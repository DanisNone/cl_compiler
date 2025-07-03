#ifndef __DTYPES_float64__
#define __DTYPES_float64__

#include "dtypes/bool.cl"

#ifndef cl_khr_fp64
typedef ulong dt_float64;
typedef float dt_float64_work;

dt_float64_work dt_normalize_input_float64(dt_float64 h) {
    uint sign     = (h >> 63) & 0x1;
    int  exponent = (int)((h >> 52) & 0x7FF);
    ulong mantissa = h & (((ulong)1 << 52) - 1);

    if (exponent == 0x7FF) {
        uint f_sign = sign << 31;
        if (mantissa != 0) {
            return as_float(f_sign | 0x7FC00000);
        } else {
            return as_float(f_sign | 0x7F800000);
        }
    }

    int f_exp;
    uint f_mant;

    if (exponent == 0) {
        f_exp = 0;
        f_mant = 0;
    } else {
        exponent -= 1023;
        exponent += 127;

        if (exponent <= 0) {
            f_exp = 0;
            f_mant = 0;
        } else if (exponent >= 0xFF) {
            return as_float((sign << 31) | 0x7F800000);
        } else {
            f_exp = exponent;
            ulong full_mant = mantissa | ((ulong)1 << 52);
            f_mant = (uint)(full_mant >> (52 - 23));
        }
    }

    uint floatBits = (sign << 31) | ((f_exp & 0xFF) << 23) | (f_mant & 0x7FFFFF);
    return as_float(floatBits);
}

dt_float64 dt_normalize_output_float64(dt_float64_work f) {
    uint i = as_uint(f);
    uint sign = (i >> 31) & 0x1;
    int exp = (int)((i >> 23) & 0xFF);
    uint frac = i & 0x7FFFFF;

    ulong out_sign = ((ulong)sign) << 63;
    int out_exp;
    ulong out_frac;

    if (exp == 0) {
        if (frac == 0) {
            return out_sign;
        } else {
            int shift = 0;
            uint mant = frac;
            while ((mant & 0x400000) == 0) {
                mant <<= 1;
                shift++;
            }
            mant &= 0x3FFFFF;
            out_exp = 1023 - 127 - shift + 1;
            out_frac = ((ulong)mant) << (52 - 23);
            return out_sign | ((ulong)out_exp << 52) | out_frac;
        }
    } else if (exp == 0xFF) {
        out_exp = 0x7FF;
        out_frac = (frac != 0) ? (((ulong)frac) << (52 - 23)) | ((ulong)1 << 51) : 0;
        return out_sign | ((ulong)out_exp << 52) | out_frac;
    } else {
        out_exp = exp - 127 + 1023;
        out_frac = ((ulong)frac) << (52 - 23);
        return out_sign | ((ulong)out_exp << 52) | out_frac;
    }
}
#else
#pragma OPENCL EXTENSION cl_khr_fp64 : enable

typedef double dt_float64;
typedef double dt_float64_work;

static inline dt_float64_work dt_normalize_input_float64(dt_float64 x)  { return x; }
static inline dt_float64 dt_normalize_output_float64(dt_float64_work x) { return x; }
#endif

dt_float64_work dt_zero_float64() { return 0; }
dt_float64_work dt_one_float64() { return 1; }

__constant dt_float64_work dt_const_log2_float64 = 0.6931471805599453;
__constant dt_float64_work dt_const_log10_float64 = 2.302585092994046;
__constant dt_float64_work dt_const_pi_float64 = 3.1415926535897931;
__constant dt_float64_work dt_const_e_float64 = 2.7182818284590451;

dt_float64_work dt_add_float64(dt_float64_work x, dt_float64_work y) {
    return x + y;
}

dt_float64_work dt_subtract_float64(dt_float64_work x, dt_float64_work y) {
    return x - y;
}

dt_float64_work dt_multiply_float64(dt_float64_work x, dt_float64_work y) {
    return x * y;
}

dt_float64_work dt_divide_float64(dt_float64_work x, dt_float64_work y) {
    return x / y;
}

dt_float64_work dt_min_float64(dt_float64_work x, dt_float64_work y) {
    return x < y ? x : y;
}

dt_float64_work dt_max_float64(dt_float64_work x, dt_float64_work y) {
    return x < y ? y : x;
}

dt_float64_work dt_mad_float64(dt_float64_work x, dt_float64_work y, dt_float64_work z) {
    return x * y + z;
}

dt_float64_work dt_floor_divide_float64(dt_float64_work x, dt_float64_work y) {
    return floor(x / y);
}

dt_float64_work dt_power_float64(dt_float64_work x, dt_float64_work y) {
    return pow(x, y);
}

dt_float64_work dt_arctan2_float64(dt_float64_work x, dt_float64_work y) {
    return atan2(x, y);
}

dt_float64_work dt_square_float64(dt_float64_work x) {
    return x * x;
}

dt_float64_work dt_round_float64(dt_float64_work x) {
    dt_float64_work rounded = round(x);

    if (fabs(x - rounded) == (dt_float64_work)0.5) {
        rounded = ((dt_float64_work)2.0) * round(x * (dt_float64_work)0.5);
    }
    return rounded;
}

dt_bool_work dt_equal_float64(dt_float64_work x, dt_float64_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_float64(dt_float64_work x, dt_float64_work y) {
    return x != y;
}

dt_bool_work dt_greater_float64(dt_float64_work x, dt_float64_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_float64(dt_float64_work x, dt_float64_work y) {
    return x >= y;
}

dt_bool_work dt_less_float64(dt_float64_work x, dt_float64_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_float64(dt_float64_work x, dt_float64_work y) {
    return x <= y;
}

dt_bool_work dt_mod_float64(dt_float64_work x, dt_float64_work y) {
    return fmod(x, y);
}

dt_float64_work dt_negative_float64(dt_float64_work x) {
    return -x;
}

dt_float64_work dt_abs_float64(dt_float64_work x) {
    return fabs(x);
}

dt_float64_work dt_sqrt_float64(dt_float64_work x) {
    return sqrt(x);
}

dt_float64_work dt_exp_float64(dt_float64_work x) {
    return exp(x);
}

dt_float64_work dt_exp2_float64(dt_float64_work x) {
    return exp2(x);
}

dt_float64_work dt_exp10_float64(dt_float64_work x) {
    return exp10(x);
}

dt_float64_work dt_expm1_float64(dt_float64_work x) {
    return expm1(x);
}

dt_float64_work dt_log_float64(dt_float64_work x) {
    return log(x);
}

dt_float64_work dt_log2_float64(dt_float64_work x) {
    return log2(x);
}

dt_float64_work dt_log10_float64(dt_float64_work x) {
    return log10(x);
}

dt_float64_work dt_log1p_float64(dt_float64_work x) {
    return log1p(x);
}

dt_float64_work dt_sign_float64(dt_float64_work x) {
    return sign(x);
}

dt_float64_work dt_sin_float64(dt_float64_work x) {
    return sin(x);
}

dt_float64_work dt_cos_float64(dt_float64_work x) {
    return cos(x);
}

dt_float64_work dt_tan_float64(dt_float64_work x) {
    return tan(x);
}

dt_float64_work dt_sinh_float64(dt_float64_work x) {
    return sinh(x);
}

dt_float64_work dt_cosh_float64(dt_float64_work x) {
    return cosh(x);
}

dt_float64_work dt_tanh_float64(dt_float64_work x) {
    return tanh(x);
}

dt_float64_work dt_arcsin_float64(dt_float64_work x) {
    return asin(x);
}

dt_float64_work dt_arccos_float64(dt_float64_work x) {
    return acos(x);
}

dt_float64_work dt_arctan_float64(dt_float64_work x) {
    return atan(x);
}

dt_float64_work dt_arcsinh_float64(dt_float64_work x) {
    return asinh(x);
}

dt_float64_work dt_arccosh_float64(dt_float64_work x) {
    return acosh(x);
}

dt_float64_work dt_arctanh_float64(dt_float64_work x) {
    return atanh(x);
}

dt_float64_work dt_floor_float64(dt_float64_work x) {
    return floor(x);
}

dt_float64_work dt_ceil_float64(dt_float64_work x) {
    return ceil(x);
}

dt_float64_work dt_trunc_float64(dt_float64_work x) {
    return trunc(x);
}

#endif