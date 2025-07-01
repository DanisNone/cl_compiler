from cl_compiler.src.core import Array, CompilerContext
from cl_compiler.src.device import Device


def compile(device: Device, context: CompilerContext, outputs: list[Array]):
    for output in outputs:
        if output not in context.array_to_id:
            raise ValueError(f"output not found in context; {output=}")
