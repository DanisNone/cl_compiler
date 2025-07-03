#include "dtypes/bool.cl"
#include "dtypes/uint2.cl"
#include "dtypes/int2.cl"
#include "dtypes/uint4.cl"
#include "dtypes/int4.cl"
#include "dtypes/uint8.cl"
#include "dtypes/int8.cl"
#include "dtypes/uint16.cl"
#include "dtypes/int16.cl"
#include "dtypes/uint32.cl"
#include "dtypes/int32.cl"
#include "dtypes/uint64.cl"
#include "dtypes/int64.cl"
#include "dtypes/float8_e3m4.cl"
#include "dtypes/bfloat16.cl"
#include "dtypes/float16.cl"
#include "dtypes/float32.cl"
#include "dtypes/float64.cl"
#include "dtypes/complex64.cl"
#include "dtypes/complex128.cl"

inline size_t flat_index(
    const size_t index,
    const size_t ndim,
    constant const size_t* shape,
    constant const size_t* strides,
    constant const size_t* factors
) {
    size_t flat_idx = strides[0]; // offset of buffers
    size_t remaining = index;

    for (size_t i = 0; i < ndim; ++i) {
        size_t coord = remaining / factors[i];
        remaining = remaining % factors[i];
        flat_idx += coord * strides[i + 1];
    }

    return flat_idx;
}