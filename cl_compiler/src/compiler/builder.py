from collections import OrderedDict
from pathlib import Path

from cl_compiler.src.core import Array, Shape
from cl_compiler.src.device import Device, DeviceProgram, DeviceKernel
from cl_compiler.src.dtypes import DType


class Builder:
    def __init__(self, kernel_name: str):
        self.kernel_name = "_".join(["kernel", kernel_name])
        self.params: OrderedDict[str, tuple[Array, bool]] = OrderedDict()
        self.lines: list[str] = []

    def add_param(self, array: Array, name: str, *, is_input: bool) -> None:
        if name in self.params:
            raise ValueError(f"Parameter name '{name}' is already used")
        self.params[name] = (array, is_input)

    def add_line(self, line: str) -> None:
        self.lines.append(line)

    def decode_index(self, name: str, index: str) -> str:
        self.lines.append(
            f"size_t {name}_index = flat_index("
            f"{index}, "
            f"{name}_ndim, "
            f"{name}_shape, "
            f"{name}_strides, "
            f"{name}_factors);"
        )

        return f"{name}_index"

    def load_param(
        self,
        param_name: str,
        index: str,
        save_name: str | None = None
    ) -> str:
        if save_name is None:
            save_name = f"{param_name}_value"
        self.decode_index(param_name, index)
        dtype = self.params[param_name][0].dtype
        self.lines.append(
            f"dt_{dtype}_work {save_name} = "
            f"dt_normalize_input_{dtype}({param_name}[{param_name}_index]);"
        )

        return f"{param_name}_value"

    def store_param(self, param_name: str, index: str, var_name: str) -> None:
        self.decode_index(param_name, index)
        dtype = self.params[param_name][0].dtype
        self.lines.append(
            f"{param_name}[{param_name}_index] = dt_normalize_output_{dtype}({var_name});"
        )

    def array_constants(self, shape: Shape, name: str) -> list[str]:
        factors: list[int] = []
        s = 1
        for dim in shape[::-1]:
            factors.append(s)
            s *= dim
        factors.reverse()

        return [
            f"constant size_t {name}_ndim = {len(shape)};",
            tuple_to_constant(f"{name}_shape", shape),
            tuple_to_constant(f"{name}_factors", tuple(factors))
        ]

    def store_var(
        self,
        name: str, dtype: DType,
        value: str, *,
        is_work_dtype: bool = True
    ) -> None:
        work = "_work" if is_work_dtype else ""
        self.lines.append(
            f"dt_{dtype}{work} {name} = {value};"
        )

    def build_source(self) -> str:
        result: list[str] = []
        result.append("#include \"dtypes/core.cl\"")

        for name, (array, _) in self.params.items():
            result.extend(self.array_constants(array.shape, name))

        result.append(f"kernel void {self.kernel_name} (")
        for name, (array, is_input) in self.params.items():
            const = " const " if is_input else " "
            result.append(f"    global{const}dt_{array.dtype}* {name},")

        for name, (array, is_input) in self.params.items():
            result.append(f"    constant const size_t* {name}_strides,")

        result[-1] = result[-1].strip(",")
        result.append(")")
        result.append("{")
        result.extend("    " + line for line in self.lines)
        result.append("}")

        return "\n".join(result)

    def build(self, device: Device) -> DeviceKernel:
        source = self.build_source()
        program = DeviceProgram(device, source)

        headers_path = Path(__file__).parent.parent.parent
        program.build([f"-I {headers_path}"])
        kernel = getattr(program, self.kernel_name)
        assert isinstance(kernel, DeviceKernel)
        return kernel


def tuple_to_constant(name: str, data: tuple[int, ...]) -> str:
    res = f"constant size_t {name}[] = {{"
    if len(data) == 0:
        res += "0"
    else:
        res += ", ".join(map(str, data))
    return res + "};"
