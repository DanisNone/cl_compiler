import abc
from typing import Any, ClassVar, Self

import numpy as np
from cl_compiler.src import device as cl_device
from cl_compiler.src.device import Device, DeviceBuffer, DeviceEvent
from cl_compiler.src.dtypes import DType


Shape = tuple[int, ...]


class Array:
    def __init__(self, shape: Shape, dtype: DType):
        if min(shape, default=0) < 0:
            raise ValueError(f"All dims must be non-negative; {shape=}")

        self.shape = shape
        self.dtype = dtype

    def __repr__(self) -> str:
        return f"Array(shape={self.shape}, dtype={self.dtype})"

    @property
    def size(self) -> int:
        res = 1
        for s in self.shape:
            res *= s
        return res

    @property
    def nbytes(self) -> int:
        return self.size * self.dtype.itemsize


class MemoryInfo:
    def __init__(self, strides: Shape, offset: int):
        self.strides = strides
        self.offset = offset

    @classmethod
    def default(cls, shape: Shape) -> Self:
        strides: list[int] = []
        s = 1
        for dim in shape[::-1]:
            strides.append(s)
            s *= dim
        return cls(tuple(strides[::-1]), 0)


class ConstantArray(Array):
    def __init__(
        self,
        shape: Shape, dtype: DType,
        strides: Shape, offset: int,
        buffer: DeviceBuffer,
        event: DeviceEvent | None = None
    ):
        super().__init__(shape, dtype)
        self.strides = strides
        self.offset = offset
        self.buffer = buffer
        if event is None:
            event = cl_device.empty_event()
        self.event = event

    @classmethod
    def from_numpy(cls, device: Device, array: np.ndarray) -> Self:
        array = array.copy()
        dtype = DType.from_numpy(array.dtype)
        strides: list[int] = []
        s = 1
        for dim in array.shape[::-1]:
            strides.append(s)
            s *= dim
        strides.reverse()

        buffer = DeviceBuffer(device, s * dtype.itemsize)
        cl_device.write_buffer(buffer, array)
        return cls(
            array.shape, DType.from_numpy(array.dtype),
            tuple(strides),
            offset=0,
            buffer=buffer,
            event=None
        )

    def to_numpy(self) -> np.ndarray:
        result = np.empty(self.buffer.nbytes, dtype=np.int8)
        cl_device.read_buffer(self.buffer, result)
        result = result.view(dtype=self.dtype.to_numpy())
        result = result[self.offset:]
        strides = [s * self.dtype.itemsize for s in self.strides]
        return np.lib.stride_tricks.as_strided(
            result,
            self.shape,
            strides
        ).copy()


class Operation(abc.ABC):
    output_shape: Shape
    output_dtype: DType

    @abc.abstractmethod
    def buffer_owner(
        self,
        inputs: list[Array],
        mem_info: list[MemoryInfo]
    ) -> Array | None: ...

    @abc.abstractmethod
    def compute_strides(
        self,
        inputs: list[Array],
        mem_info: list[MemoryInfo]
    ) -> MemoryInfo: ...


class CompilerContext:
    _run_context: ClassVar[Self | None] = None

    def __init__(self) -> None:
        self.inputs: list[Array] = []
        self.constants: list[ConstantArray] = []
        self.arrays: list[Array] = []

        self.array_to_id: dict[Array, int] = {}
        self.operations: list[tuple[
            Operation,
            int,
            tuple[int, ...]
        ]] = []

        self._used = False

    def copy(self) -> Self:
        new = type(self)()
        new.inputs = self.inputs.copy()
        new.constants = self.constants.copy()
        new.arrays = self.arrays.copy()
        new.array_to_id = self.array_to_id.copy()
        new.operations = self.operations.copy()
        new._used = self._used
        return new

    def __enter__(self) -> Self:
        if self._run_context:
            raise RuntimeError(
                "Cannot enter context: another context is already active"
            )
        if self._used:
            raise RuntimeError("Cannot reuse a compiler context")
        type(self)._run_context = self
        self._used = True
        return self

    def __exit__(self, *args: Any) -> None:
        type(self)._run_context = None

    def _add_array(self, array: Array) -> int:
        id = len(self.arrays)
        self.arrays.append(array)
        self.array_to_id[array] = id
        return id

    def add_operation(
        self,
        operation:
        type[Operation],
        *inputs: Array,
        **kwargs: Any
    ) -> Array:
        for inp in inputs:
            if inp not in self.array_to_id:
                raise ValueError(f"Input array {inp} not found in context")
        op = operation(*inputs, **kwargs)
        result = Array(op.output_shape, op.output_dtype)
        id = self._add_array(result)
        self.operations.append(
            (op, id, tuple(self.array_to_id[inp] for inp in inputs))
        )
        return result

    def add_input(self, shape: Shape, dtype: DType) -> Array:
        array = Array(shape, dtype)
        self.inputs.append(array)
        self._add_array(array)
        return array

    def add_constant(self, array: ConstantArray) -> Array:
        self.constants.append(array)
        self._add_array(array)
        return array

    @classmethod
    def get_current_context(cls) -> Self:
        if cls._run_context is None:
            raise RuntimeError("No active compiler context found")
        return cls._run_context


get_current_context = CompilerContext.get_current_context
