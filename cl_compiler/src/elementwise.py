from pathlib import Path
from typing import ClassVar, TypeAlias
from cl_compiler.src.core import Array, MemoryInfo, Operation
from cl_compiler.src.core import get_current_context
from cl_compiler.src.dtypes import DType


_cl_funcs_type: TypeAlias = dict[
    str,
    dict[tuple[DType, ...], tuple[str, DType]]
]


def load_cl_funcs_info() -> _cl_funcs_type:
    result: _cl_funcs_type = {}

    path = Path(__file__).parent.parent / "dtypes" / "cl_funcs.info"
    with open(path, encoding="utf8") as file:
        for line in file:
            name, cl_name, output, *inputs = line.split()
            output_dtype = DType.from_name(output)
            input_dtypes = tuple(DType.from_name(inp) for inp in inputs)

            if name not in result:
                result[name] = {}

            if input_dtypes in result[name]:
                raise ValueError(
                    f"Duplicate input dtypes found; {name=}; {input_dtypes};"
                )
            result[name][input_dtypes] = (cl_name, output_dtype)
    return result


class ElementWise(Operation):
    _cl_func_name: str
    _name: ClassVar[str]

    def __init__(self, *inputs: Array):
        if not inputs:
            raise ValueError(
                f"ElementWise operation require inputs; {inputs=}"
            )

        shapes = tuple(inp.shape for inp in inputs)
        if any(shapes[0] != shape for shape in shapes):
            raise ValueError(
                "All input shapes of ElementWise operations "
                f"must be equal; {shapes=}"
            )

        cl_funcs = load_cl_funcs_info()
        if self._name not in cl_funcs:
            raise ValueError(f"unknown cl_func; cl_func={self._name}")
        dtypes = tuple(inp.dtype for inp in inputs)
        if dtypes not in cl_funcs[self._name]:
            raise ValueError(
                f"not support input dtypes; cl_func={self._name}; {dtypes=}"
            )

        self.output_shape = inputs[0].shape
        self._cl_func_name, self.output_dtype = cl_funcs[self._name][dtypes]

    @property
    def name(self) -> str:
        return self._name

    @property
    def cl_func_name(self) -> str:
        return self._cl_func_name

    def buffer_owner(
        self,
        inputs: list[Array],
        mem_info: list[MemoryInfo]
    ) -> None:
        return None

    def compute_strides(
        self,
        inputs: list[Array],
        mem_info: list[MemoryInfo]
    ) -> MemoryInfo:
        return MemoryInfo.default(self.output_shape)


class ElementWiseUnary(ElementWise):
    def __init__(self, x: Array):
        super().__init__(x)


class ElementWiseBinary(ElementWise):
    def __init__(self, x: Array, y: Array):
        super().__init__(x, y)


class Abs(ElementWiseUnary):
    _name = "abs"

class Add(ElementWiseBinary):
    _name = "add"

class Arccos(ElementWiseUnary):
    _name = "arccos"

class Arccosh(ElementWiseUnary):
    _name = "arccosh"

class Arcsin(ElementWiseUnary):
    _name = "arcsin"

class Arcsinh(ElementWiseUnary):
    _name = "arcsinh"

class Arctan(ElementWiseUnary):
    _name = "arctan"

class Arctan2(ElementWiseBinary):
    _name = "arctan2"

class Arctanh(ElementWiseUnary):
    _name = "arctanh"

class Bitwise_and(ElementWiseBinary):
    _name = "bitwise_and"

class Bitwise_not(ElementWiseUnary):
    _name = "bitwise_not"

class Bitwise_or(ElementWiseBinary):
    _name = "bitwise_or"

class Bitwise_xor(ElementWiseBinary):
    _name = "bitwise_xor"

class Ceil(ElementWiseUnary):
    _name = "ceil"

class Cos(ElementWiseUnary):
    _name = "cos"

class Cosh(ElementWiseUnary):
    _name = "cosh"

class Divide(ElementWiseBinary):
    _name = "divide"

class Equal(ElementWiseBinary):
    _name = "equal"

class Exp(ElementWiseUnary):
    _name = "exp"

class Exp10(ElementWiseUnary):
    _name = "exp10"

class Exp2(ElementWiseUnary):
    _name = "exp2"

class Expm1(ElementWiseUnary):
    _name = "expm1"

class Floor(ElementWiseUnary):
    _name = "floor"

class Floor_divide(ElementWiseBinary):
    _name = "floor_divide"

class Greater(ElementWiseBinary):
    _name = "greater"

class Greater_equal(ElementWiseBinary):
    _name = "greater_equal"

class Left_shift(ElementWiseBinary):
    _name = "left_shift"

class Less(ElementWiseBinary):
    _name = "less"

class Less_equal(ElementWiseBinary):
    _name = "less_equal"

class Log(ElementWiseUnary):
    _name = "log"

class Log10(ElementWiseUnary):
    _name = "log10"

class Log1p(ElementWiseUnary):
    _name = "log1p"

class Log2(ElementWiseUnary):
    _name = "log2"

class Logical_and(ElementWiseBinary):
    _name = "logical_and"

class Logical_not(ElementWiseUnary):
    _name = "logical_not"

class Logical_or(ElementWiseBinary):
    _name = "logical_or"

class Logical_xor(ElementWiseBinary):
    _name = "logical_xor"

class Max(ElementWiseBinary):
    _name = "max"

class Min(ElementWiseBinary):
    _name = "min"

class Mod(ElementWiseBinary):
    _name = "mod"

class Multiply(ElementWiseBinary):
    _name = "multiply"

class Negative(ElementWiseUnary):
    _name = "negative"

class Not_equal(ElementWiseBinary):
    _name = "not_equal"

class Power(ElementWiseBinary):
    _name = "power"

class Right_shift(ElementWiseBinary):
    _name = "right_shift"

class Round(ElementWiseUnary):
    _name = "round"

class Sign(ElementWiseUnary):
    _name = "sign"

class Sin(ElementWiseUnary):
    _name = "sin"

class Sinh(ElementWiseUnary):
    _name = "sinh"

class Sqrt(ElementWiseUnary):
    _name = "sqrt"

class Square(ElementWiseUnary):
    _name = "square"

class Subtract(ElementWiseBinary):
    _name = "subtract"

class Tan(ElementWiseUnary):
    _name = "tan"

class Tanh(ElementWiseUnary):
    _name = "tanh"

class Trunc(ElementWiseUnary):
    _name = "trunc"

def abs(x: Array) -> Array:
    return get_current_context().add_operation(Abs, x)

def add(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Add, x, y)

def arccos(x: Array) -> Array:
    return get_current_context().add_operation(Arccos, x)

def arccosh(x: Array) -> Array:
    return get_current_context().add_operation(Arccosh, x)

def arcsin(x: Array) -> Array:
    return get_current_context().add_operation(Arcsin, x)

def arcsinh(x: Array) -> Array:
    return get_current_context().add_operation(Arcsinh, x)

def arctan(x: Array) -> Array:
    return get_current_context().add_operation(Arctan, x)

def arctan2(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Arctan2, x, y)

def arctanh(x: Array) -> Array:
    return get_current_context().add_operation(Arctanh, x)

def bitwise_and(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Bitwise_and, x, y)

def bitwise_not(x: Array) -> Array:
    return get_current_context().add_operation(Bitwise_not, x)

def bitwise_or(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Bitwise_or, x, y)

def bitwise_xor(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Bitwise_xor, x, y)

def ceil(x: Array) -> Array:
    return get_current_context().add_operation(Ceil, x)

def cos(x: Array) -> Array:
    return get_current_context().add_operation(Cos, x)

def cosh(x: Array) -> Array:
    return get_current_context().add_operation(Cosh, x)

def divide(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Divide, x, y)

def equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Equal, x, y)

def exp(x: Array) -> Array:
    return get_current_context().add_operation(Exp, x)

def exp10(x: Array) -> Array:
    return get_current_context().add_operation(Exp10, x)

def exp2(x: Array) -> Array:
    return get_current_context().add_operation(Exp2, x)

def expm1(x: Array) -> Array:
    return get_current_context().add_operation(Expm1, x)

def floor(x: Array) -> Array:
    return get_current_context().add_operation(Floor, x)

def floor_divide(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Floor_divide, x, y)

def greater(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Greater, x, y)

def greater_equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Greater_equal, x, y)

def left_shift(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Left_shift, x, y)

def less(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Less, x, y)

def less_equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Less_equal, x, y)

def log(x: Array) -> Array:
    return get_current_context().add_operation(Log, x)

def log10(x: Array) -> Array:
    return get_current_context().add_operation(Log10, x)

def log1p(x: Array) -> Array:
    return get_current_context().add_operation(Log1p, x)

def log2(x: Array) -> Array:
    return get_current_context().add_operation(Log2, x)

def logical_and(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Logical_and, x, y)

def logical_not(x: Array) -> Array:
    return get_current_context().add_operation(Logical_not, x)

def logical_or(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Logical_or, x, y)

def logical_xor(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Logical_xor, x, y)

def max(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Max, x, y)

def min(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Min, x, y)

def mod(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Mod, x, y)

def multiply(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Multiply, x, y)

def negative(x: Array) -> Array:
    return get_current_context().add_operation(Negative, x)

def not_equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Not_equal, x, y)

def power(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Power, x, y)

def right_shift(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Right_shift, x, y)

def round(x: Array) -> Array:
    return get_current_context().add_operation(Round, x)

def sign(x: Array) -> Array:
    return get_current_context().add_operation(Sign, x)

def sin(x: Array) -> Array:
    return get_current_context().add_operation(Sin, x)

def sinh(x: Array) -> Array:
    return get_current_context().add_operation(Sinh, x)

def sqrt(x: Array) -> Array:
    return get_current_context().add_operation(Sqrt, x)

def square(x: Array) -> Array:
    return get_current_context().add_operation(Square, x)

def subtract(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Subtract, x, y)

def tan(x: Array) -> Array:
    return get_current_context().add_operation(Tan, x)

def tanh(x: Array) -> Array:
    return get_current_context().add_operation(Tanh, x)

def trunc(x: Array) -> Array:
    return get_current_context().add_operation(Trunc, x)