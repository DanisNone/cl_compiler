from __future__ import annotations
from typing import Any


class DType:
    _instances: dict[str, DType] = {}

    def __init__(
        self,
        name: str,
        itemsize: int
    ):
        self._name = name
        self._itemsize = itemsize
        if self._name in self._instances:
            # TODO: add message
            raise ValueError
        self._instances[self._name] = self

    @classmethod
    def from_name(cls, name: str) -> DType:
        return cls._instances[name]

    def __eq__(self, other: Any) -> bool:
        if not isinstance(other, DType):
            return False
        return (
            self._name == other._name and
            self._itemsize == other._itemsize
        )

    def __hash__(self) -> int:
        return hash((self._name, self._itemsize))

    def __repr__(self) -> str:
        return self._name


bool_ = DType("bool", 1)

uint2 = DType("uint2", 1)
uint4 = DType("uint4", 1)
uint8 = DType("uint8", 1)
uint16 = DType("uint16", 2)
uint32 = DType("uint32", 4)
uint64 = DType("uint64", 8)


int2 = DType("int2", 1)
int4 = DType("int4", 1)
int8 = DType("int8", 1)
int16 = DType("int16", 2)
int32 = DType("int32", 4)
int64 = DType("int64", 8)


float8_e3m4 = DType("float8_e3m4", 1)
bfloat16 = DType("bfloat16", 2)
float16 = DType("float16", 2)
float32 = DType("float32", 4)
float64 = DType("float64", 8)

boolean = [bool_]
unsigned = [uint2, uint4, uint8, uint16, uint32, uint64]
signed = [int2, int4, int8, int16, int32, int64]

floating = [float8_e3m4, bfloat16, float16, float32, float64]

all_dtypes = boolean + unsigned + signed + floating
