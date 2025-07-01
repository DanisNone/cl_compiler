import abc
from typing import Any, Callable, ClassVar, Self
from cl_compiler.src.device import Device, DeviceBuffer
from cl_compiler.src.dtypes import DType


Shape = tuple[int, ...]

class Array:
    def __init__(self, shape: Shape, dtype: DType):
        if min(shape, default=0) < 0:
            raise ValueError(f"All dims must be non-negative; {shape=}")
        
        self.shape = shape
        self.dtype = dtype

    def __repr__(self):
        return f"Array(shape={self.shape}, dtype={self.dtype})"


class ConstantArray(Array):
    def __init__(self, shape: Shape, dtype: DType, strides: Shape, offset: int, buffer: DeviceBuffer):
        super().__init__(shape, dtype)
        self.strides = strides
        self.offset = offset
        self.buffer = buffer

class Operation(abc.ABC):
    output_shape: Shape
    output_dtype: DType

    update_strides: Callable[..., tuple[Shape, int]] | None


class CompilerContext:
    _run_context: ClassVar[Self | None] = None

    def __init__(self, device: Device):
        self.device = device
        
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

    def __enter__(self) -> Self:
        if self._run_context:
            raise RuntimeError("Cannot enter context: another context is already active")
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
        
    def add_operation(self, operation: type[Operation], *inputs: Array, **kwargs: Any) -> Array:
        for inp in inputs:
            if inp not in self.array_to_id:
                raise ValueError(f"Input array {inp} not found in context")
        op = operation(*inputs, **kwargs)
        result = Array(op.output_shape, op.output_dtype)
        id = self._add_array(result)
        self.operations.append((op, id, tuple(self.array_to_id[inp] for inp in inputs)))
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