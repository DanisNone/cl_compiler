from typing import Protocol
import numpy as np
from cl_compiler.src.compiler.builder import Builder
from cl_compiler.src.core import Array, ConstantArray, MemoryInfo
from cl_compiler.src.core import Operation, CompilerContext
from cl_compiler.src.device import Device, DeviceBuffer, DeviceEvent, write_buffer
from cl_compiler.src.elementwise import ElementWise


class _kernel_type(Protocol):
    def __call__(
        self,
        buffers: list[DeviceBuffer],
        mem_info: list[MemoryInfo],
        wait_for: DeviceEvent | None
    ) -> DeviceEvent: ...


def mem_info_to_strides(device: Device, mem_info: MemoryInfo) -> DeviceBuffer:
    arr = np.array([mem_info.offset, *mem_info.strides], dtype=device.size_t)
    buffer = device.allocate_buffer(arr.nbytes)
    write_buffer(buffer, arr)
    return buffer


def build_elementwise(
    device: Device,
    operation: ElementWise,
    input_arrays: list[Array],
    output_array: Array
) -> _kernel_type:
    build = Builder(operation.name)
    for i, inp in enumerate(input_arrays):
        build.add_param(inp, f"x{i}", is_input=True)

    build.add_param(output_array, "out", is_input=False)
    build.add_line("size_t id = get_global_id(0);")

    func_params = ", ".join(
        build.load_param(f"x{i}", "id")
        for i in range(len(input_arrays))
    )

    func_call = f"{operation.cl_func_name}({func_params})"
    build.store_var("result", output_array.dtype, func_call)
    build.store_param("out", "id", "result")
    kernel = build.build(device)

    def inner(
        buffers: list[DeviceBuffer],
        mem_info: list[MemoryInfo],
        wait_for: DeviceEvent | None
    ) -> DeviceEvent:
        strides = [mem_info_to_strides(device, mem) for mem in mem_info]
        return kernel(output_array.size, None, *buffers, *strides, wait_for=wait_for)
    return inner


def build_operation(
    device: Device,
    operation: Operation,
    input_arrays: list[Array],
    output_array: Array
) -> _kernel_type:
    if isinstance(operation, ElementWise):
        return build_elementwise(device, operation, input_arrays, output_array)
    raise NotImplementedError


class Compiler:
    def __init__(
        self,
        device: Device,
        context: CompilerContext,
        outputs: list[Array]
    ):
        for output in outputs:
            if output not in context.array_to_id:
                raise ValueError(f"output not found in context; {output=}")

        self.device = device
        self.context = context.copy()
        self.outputs = outputs
        self.array_to_buffer: dict[Array, DeviceBuffer] = {}
        self.kernels: list[_kernel_type] = []

        self.build_kernels()

    def build_kernels(self) -> None:
        if self.kernels:
            raise RuntimeError("kernels already builded")

        for operation, output_id, input_ids in self.context.operations:
            output_array = self.context.arrays[output_id]
            input_arrays = [
                self.context.arrays[input_id]
                for input_id in input_ids
            ]

            kernel = build_operation(
                self.device, operation,
                input_arrays, output_array
            )
            self.kernels.append(kernel)

    def __call__(self, arrays: list[ConstantArray]) -> list[ConstantArray]:
        if len(arrays) != len(self.context.inputs):
            raise ValueError

        buffers: dict[Array, DeviceBuffer] = {}
        mem_info: dict[Array, MemoryInfo] = {}
        events: dict[Array, DeviceEvent] = {}

        for array, inp in zip(arrays, self.context.inputs):
            if array.shape != inp.shape:
                raise ValueError(f"gived {array.shape=} waited array.shape={inp.shape}")
            if array.dtype != inp.dtype:
                raise ValueError(f"gived {array.dtype=} waited array.dtype={inp.dtype}")

            mem_info[inp] = MemoryInfo(array.strides, array.offset)
            buffers[inp] = array.buffer
            events[inp] = array.event

        for const in self.context.constants:
            buffers[const] = const.buffer
            mem_info[const] = MemoryInfo(const.strides, const.offset)
    
        zip_ = zip(self.kernels, self.context.operations)
        for kernel, (operation, output_id, input_ids) in zip_:
            input_arrays = [
                self.context.arrays[input_id]
                for input_id in input_ids
            ]
            output_array = self.context.arrays[output_id]

            inputs_memory_info = [
                mem_info[arr]
                for arr in input_arrays
            ]

            output_buffer_owner = operation.buffer_owner(input_arrays, inputs_memory_info)
            if output_buffer_owner is None:
                if output_array not in buffers:
                    buffers[output_array] = DeviceBuffer(self.device, output_array.nbytes)
                output_buffer_owner = output_array
            else:
                buffers[output_array] = buffers[output_buffer_owner]

            mem_info[output_array] = operation.compute_strides(
                input_arrays,
                inputs_memory_info
            )

            wait_for = DeviceEvent([events.get(inp) for inp in input_arrays])

            buffers_for_kernel = [buffers[arr] for arr in input_arrays + [output_array]]
            mem_info_for_kernel = [mem_info[arr] for arr in input_arrays + [output_array]]
            event = kernel(buffers_for_kernel, mem_info_for_kernel, wait_for)
            events[output_array] = event

        result: list[ConstantArray] = []
        for output in self.outputs:
            result.append(ConstantArray(
                output.shape, output.dtype,
                mem_info[output].strides, mem_info[output].offset,
                buffers[output], event=events[output]
            ))
        return result
