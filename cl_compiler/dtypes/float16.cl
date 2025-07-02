#ifndef __DTYPES_float16__
#define __DTYPES_float16__

#include "dtypes/bool.cl"

#ifndef cl_khr_fp16
typedef ushort dt_float16;
typedef float dt_float16_work;

dt_float16_work dt_normalize_input_float16(dt_float16 h) {
    uint s = (h >> 15) & 0x00000001;
    uint e = (h >> 10) & 0x0000001F;
    uint f = h & 0x000003FF;

    uint out_e, out_f;

    if (e == 0) {
        if (f == 0) {
            out_e = 0;
            out_f = 0;
        } else {
            e = 1;
            while ((f & 0x00000400) == 0) {
                f <<= 1;
                e--;
            }
            f &= 0x000003FF;
            out_e = 127 - 15 - e;
            out_f = f << 13;
        }
    } else if (e == 31) {
        out_e = 255;
        out_f = f << 13;
    } else {
        out_e = e + (127 - 15);
        out_f = f << 13;
    }

    uint result = (s << 31) | (out_e << 23) | out_f;
    return as_float(result);
}

dt_float16 dt_normalize_output_float16(dt_float16_work x) {
    uint i = as_uint(x);
    uint s = (i >> 31) & 0x1;
    int e = ((i >> 23) & 0xFF) - 127 + 15;
    uint f = i & 0x007FFFFF;

    ushort h;

    if ((i & 0x7FFFFFFF) == 0) {
        h = (ushort)(s << 15);
    }
    else if (((i >> 23) & 0xFF) == 0xFF) {
        if (f == 0) {
            h = (ushort)((s << 15) | (0x1F << 10));
        } else {
            h = (ushort)((s << 15) | (0x1F << 10) | (f >> 13));
        }
    }
    else if (e <= 0) {
        if (e < -10) {
            h = (ushort)(s << 15);
        } else {
            f = (f | 0x00800000) >> (1 - e);
            h = (ushort)((s << 15) | (f >> 13));
        }
    }
    else if (e >= 31) {
        h = (ushort)((s << 15) | (0x1F << 10));
    }
    else {
        h = (ushort)((s << 15) | (e << 10) | (f >> 13));
    }

    return h;
}
#else
#pragma OPENCL EXTENSION cl_khr_fp16 : enable
typedef half dt_float16;
typedef half dt_float16_work;

static inline dt_float16_work dt_normalize_input_float16(dt_float16 x)  { return x; }
static inline dt_float16 dt_normalize_output_float16(dt_float16_work x) { return x; }
#endif


dt_float16_work dt_zero_float16() { return 0; }
dt_float16_work dt_one_float16() { return 1; }

__constant dt_float16_work dt_const_log2_float16 = 0.6931471805599453;
__constant dt_float16_work dt_const_log10_float16 = 2.302585092994046;
__constant dt_float16_work dt_const_pi_float16 = 3.1415926535897931;
__constant dt_float16_work dt_const_e_float16 = 2.7182818284590451;

dt_float16_work dt_add_float16(dt_float16_work x, dt_float16_work y) {
    return x + y;
}

dt_float16_work dt_subtract_float16(dt_float16_work x, dt_float16_work y) {
    return x - y;
}

dt_float16_work dt_multiply_float16(dt_float16_work x, dt_float16_work y) {
    return x * y;
}

dt_float16_work dt_divide_float16(dt_float16_work x, dt_float16_work y) {
    return x / y;
}

dt_float16_work dt_min_float16(dt_float16_work x, dt_float16_work y) {
    return x < y ? x : y;
}

dt_float16_work dt_max_float16(dt_float16_work x, dt_float16_work y) {
    return x < y ? y : x;
}

dt_float16_work dt_mad_float16(dt_float16_work x, dt_float16_work y, dt_float16_work z) {
    return x * y + z;
}

dt_float16_work dt_floor_divide_float16(dt_float16_work x, dt_float16_work y) {
    return floor(x / y);
}

dt_float16_work dt_power_float16(dt_float16_work x, dt_float16_work y) {
    return pow(x, y);
}

dt_float16_work dt_arctan2_float16(dt_float16_work x, dt_float16_work y) {
    return atan2(x, y);
}

dt_float16_work dt_square_float16(dt_float16_work x) {
    return x * x;
}

dt_float16_work dt_round_float16(dt_float16_work x) {
    dt_float16_work rounded = round(x);

    if (fabs(x - rounded) == (dt_float16_work)0.5) {
        rounded = ((dt_float16_work)2.0) * round(x * (dt_float16_work)0.5);
    }
    return rounded;
}

dt_bool_work dt_equal_float16(dt_float16_work x, dt_float16_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_float16(dt_float16_work x, dt_float16_work y) {
    return x != y;
}

dt_bool_work dt_greater_float16(dt_float16_work x, dt_float16_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_float16(dt_float16_work x, dt_float16_work y) {
    return x >= y;
}

dt_bool_work dt_less_float16(dt_float16_work x, dt_float16_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_float16(dt_float16_work x, dt_float16_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_float16(dt_float16_work x, dt_float16_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_float16(dt_float16_work x, dt_float16_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_float16(dt_float16_work x, dt_float16_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_float16(dt_float16_work x) {
    return !x;
}

dt_float16_work dt_negative_float16(dt_float16_work x) {
    return -x;
}

dt_float16_work dt_abs_float16(dt_float16_work x) {
    return fabs(x);
}

dt_float16_work dt_sqrt_float16(dt_float16_work x) {
    return sqrt(x);
}

dt_float16_work dt_exp_float16(dt_float16_work x) {
    return exp(x);
}

dt_float16_work dt_exp2_float16(dt_float16_work x) {
    return exp2(x);
}

dt_float16_work dt_exp10_float16(dt_float16_work x) {
    return exp10(x);
}

dt_float16_work dt_expm1_float16(dt_float16_work x) {
    return expm1(x);
}

dt_float16_work dt_log_float16(dt_float16_work x) {
    return log(x);
}

dt_float16_work dt_log2_float16(dt_float16_work x) {
    return log2(x);
}

dt_float16_work dt_log10_float16(dt_float16_work x) {
    return log10(x);
}

dt_float16_work dt_log1p_float16(dt_float16_work x) {
    return log1p(x);
}

dt_float16_work dt_sign_float16(dt_float16_work x) {
    return sign(x);
}

dt_float16_work dt_sin_float16(dt_float16_work x) {
    return sin(x);
}

dt_float16_work dt_cos_float16(dt_float16_work x) {
    return cos(x);
}

dt_float16_work dt_tan_float16(dt_float16_work x) {
    return tan(x);
}

dt_float16_work dt_sinh_float16(dt_float16_work x) {
    return sinh(x);
}

dt_float16_work dt_cosh_float16(dt_float16_work x) {
    return cosh(x);
}

dt_float16_work dt_tanh_float16(dt_float16_work x) {
    return tanh(x);
}

dt_float16_work dt_arcsin_float16(dt_float16_work x) {
    return asin(x);
}

dt_float16_work dt_arccos_float16(dt_float16_work x) {
    return acos(x);
}

dt_float16_work dt_arctan_float16(dt_float16_work x) {
    return atan(x);
}

dt_float16_work dt_arcsinh_float16(dt_float16_work x) {
    return asinh(x);
}

dt_float16_work dt_arccosh_float16(dt_float16_work x) {
    return acosh(x);
}

dt_float16_work dt_arctanh_float16(dt_float16_work x) {
    return atanh(x);
}

dt_float16_work dt_floor_float16(dt_float16_work x) {
    return floor(x);
}

dt_float16_work dt_ceil_float16(dt_float16_work x) {
    return ceil(x);
}

dt_float16_work dt_trunc_float16(dt_float16_work x) {
    return trunc(x);
}

#endif