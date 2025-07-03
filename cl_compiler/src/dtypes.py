from __future__ import annotations
from typing import Any

import ml_dtypes
import numpy as np


class DType:
    _instances: dict[np.dtype, DType] = {}
    _named_instances: dict[str, DType] = {}

    def __init__(
        self,
        dtype: np.dtype
    ):
        self._np_dtype = dtype
        if dtype in self._instances:
            # TODO: add message
            raise ValueError
        self._instances[dtype] = self
        self._named_instances[np.dtype(dtype).name] = self

    @classmethod
    def from_name(cls, name: str) -> DType:
        return cls._named_instances[name]

    @classmethod
    def from_numpy(cls, dtype: np.dtype) -> DType:
        return cls._instances[dtype]

    def to_numpy(self) -> np.dtype:
        return self._np_dtype

    def __eq__(self, other: Any) -> bool:
        if not isinstance(other, DType):
            return False
        return self._np_dtype == other._np_dtype

    def __hash__(self) -> int:
        return hash(self._np_dtype)

    def __repr__(self) -> str:
        return np.dtype(self._np_dtype).name

    @property
    def name(self) -> str:
        return np.dtype(self._np_dtype).name

    @property
    def itemsize(self) -> int:
        return np.dtype(self._np_dtype).itemsize


bool_ = DType(np.dtype(np.bool_))

uint2 = DType(np.dtype(ml_dtypes.uint2))
uint4 = DType(np.dtype(ml_dtypes.uint4))
uint8 = DType(np.dtype(np.uint8))
uint16 = DType(np.dtype(np.uint16))
uint32 = DType(np.dtype(np.uint32))
uint64 = DType(np.dtype(np.uint64))


int2 = DType(np.dtype(ml_dtypes.int2))
int4 = DType(np.dtype(ml_dtypes.int4))
int8 = DType(np.dtype(np.int8))
int16 = DType(np.dtype(np.int16))
int32 = DType(np.dtype(np.int32))
int64 = DType(np.dtype(np.int64))


float8_e3m4 = DType(np.dtype(ml_dtypes.float8_e3m4))
bfloat16 = DType(np.dtype(ml_dtypes.bfloat16))
float16 = DType(np.dtype(np.float16))
float32 = DType(np.dtype(np.float32))
float64 = DType(np.dtype(np.float64))


complex64 = DType(np.dtype(np.complex64))
complex128 = DType(np.dtype(np.complex128))

boolean = [bool_]
unsigned = [uint2, uint4, uint8, uint16, uint32, uint64]
signed = [int2, int4, int8, int16, int32, int64]

floating = [float8_e3m4, bfloat16, float16, float32, float64]
complexfloating = [complex64, complex128]
inexact = floating + complexfloating

all_dtypes = boolean + unsigned + signed + inexact
