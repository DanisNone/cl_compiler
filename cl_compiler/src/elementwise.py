from pathlib import Path
from typing import ClassVar, TypeAlias
from cl_compiler.src.core import Array, Operation, get_current_context
from cl_compiler.src.dtypes import DType

_cl_funcs_type: TypeAlias = dict[str, dict[tuple[DType, ...], tuple[str, DType]]]
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
                raise ValueError(f"Duplicate input dtypes found; {name=}; {input_dtypes};")
            result[name][input_dtypes] = (cl_name, output_dtype)
    return result


class ElementWise(Operation):
    _cl_func_name: str
    _name: ClassVar[str]

    def __init__(self, *inputs: Array):
        if not inputs:
            raise ValueError(f"ElementWise operation require inputs; {inputs=}")
        shapes = tuple(inp.shape for inp in inputs)
        if any(shapes[0] != shape for shape in shapes):
            raise ValueError(
                f"All input shapes of ElementWise operations must be equal; {shapes=}"
            )
    
        cl_funcs = load_cl_funcs_info()
        if self._name not in cl_funcs:
            raise ValueError(f"unknown cl_func; cl_func={self._name}")
        dtypes = tuple(inp.dtype for inp in inputs)
        if dtypes not in cl_funcs[self._name]:
            raise ValueError(f"not support input dtypes; cl_func={self._name}; {dtypes=}")
        
        self.output_shape = inputs[0].shape
        self._cl_func_name,self.output_dtype = cl_funcs[self._name][dtypes]

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

class Multiply(ElementWiseBinary):
    _name = "multiply"


def negative(x: Array) -> Array:
    return get_current_context().add_operation(Negative, x)

def add(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Add, x, y)

def multiply(x: Array, y: Array) -> Array:
    return get_current_context().add_operation(Multiply, x, y)
