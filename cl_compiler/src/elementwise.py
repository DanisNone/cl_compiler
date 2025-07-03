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


class Negative(ElementWiseUnary):
    _name = "negative"

class Add(ElementWiseBinary):
    _name = "add"

class Subtract(ElementWiseBinary):
    _name = "subtract"

class Multiply(ElementWiseBinary):
    _name = "multiply"

class Divide(ElementWiseBinary):
    _name = "divide"

class Mod(ElementWiseBinary):
    _name = "mod"

class Power(ElementWiseBinary):
    _name = "power"

class BitwiseAnd(ElementWiseBinary):
    _name = "bitwise_and"

class BitwiseOr(ElementWiseBinary):
    _name = "bitwise_or"

class BitwiseXor(ElementWiseBinary):
    _name = "bitwise_xor"

class LeftShift(ElementWiseBinary):
    _name = "left_shift"

class RightShift(ElementWiseBinary):
    _name = "right_shift"

class BitwiseNot(ElementWiseUnary):
    _name = "bitwise_not"

class Square(ElementWiseUnary):
    _name = "square"

class Abs(ElementWiseUnary):
    _name = "abs"

class Sign(ElementWiseUnary):
    _name = "sign"

class Equal(ElementWiseBinary):
    _name = "equal"

class NotEqual(ElementWiseBinary):
    _name = "not_equal"

class Greater(ElementWiseBinary):
    _name = "greater"

class GreaterEqual(ElementWiseBinary):
    _name = "greater_equal"

class Less(ElementWiseBinary):
    _name = "less"

class LessEqual(ElementWiseBinary):
    _name = "less_equal"

class LogicalAnd(ElementWiseBinary):
    _name = "logical_and"

class LogicalOr(ElementWiseBinary):
    _name = "logical_or"

class LogicalXor(ElementWiseBinary):
    _name = "logical_xor"

class LogicalNot(ElementWiseUnary):
    _name = "logical_not"

class Minimum(ElementWiseBinary):
    _name = "min"

class Maximum(ElementWiseBinary):
    _name = "max"

def negative(x: Array) -> Array:
    return get_current_context().add_operation(Negative, x)

def add(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Add, x, y)

def subtract(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Subtract, x, y)

def multiply(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Multiply, x, y)

def divide(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Divide, x, y)

def mod(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Mod, x, y)

def power(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Power, x, y)

def bitwise_and(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(BitwiseAnd, x, y)

def bitwise_or(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(BitwiseOr, x, y)

def bitwise_xor(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(BitwiseXor, x, y)

def left_shift(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(LeftShift, x, y)

def right_shift(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(RightShift, x, y)

def bitwise_not(x: Array) -> Array:
    return get_current_context().add_operation(BitwiseNot, x)

def square(x: Array) -> Array:
    return get_current_context().add_operation(Square, x)

def abs(x: Array) -> Array:
    return get_current_context().add_operation(Abs, x)

def sign(x: Array) -> Array:
    return get_current_context().add_operation(Sign, x)

def equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Equal, x, y)

def not_equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(NotEqual, x, y)

def greater(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Greater, x, y)

def greater_equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(GreaterEqual, x, y)

def less(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Less, x, y)

def less_equal(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(LessEqual, x, y)

def logical_and(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(LogicalAnd, x, y)

def logical_or(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(LogicalOr, x, y)

def logical_xor(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(LogicalXor, x, y)

def logical_not(x: Array) -> Array:
    return get_current_context().add_operation(LogicalNot, x)

def minimum(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Minimum, x, y)

def maximum(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Maximum, x, y)