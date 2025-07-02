#ifndef __DTYPES_bfloat16__
#define __DTYPES_bfloat16__

#include "dtypes/bool.cl"

typedef ushort dt_bfloat16;
typedef float dt_bfloat16_work;

dt_bfloat16_work dt_normalize_input_bfloat16(dt_bfloat16 h) {
    return as_float(((uint)h) << 16);
}

dt_bfloat16 dt_normalize_output_bfloat16(dt_bfloat16_work x) {
    uint bits = *(uint*)(&x);
    uint exp = (bits >> 23) & 0xFF;

    if (exp == 0xFF) {
        return (ushort)(bits >> 16);
    }

    uint round_bit = (bits >> 15) & 1;
    uint lsb = (bits >> 16) & 1;
    uint lower_bits = bits & 0xFFFF;

    if (lower_bits > 0x8000 || (lower_bits == 0x8000 && lsb == 1)) {
        bits += 0x10000;
    }

    return (ushort)(bits >> 16);
}


dt_bfloat16_work dt_zero_bfloat16() { return 0; }
dt_bfloat16_work dt_one_bfloat16() { return 1; }

__constant dt_bfloat16_work dt_const_log2_bfloat16 = 0.6931471805599453;
__constant dt_bfloat16_work dt_const_log10_bfloat16 = 2.302585092994046;
__constant dt_bfloat16_work dt_const_pi_bfloat16 = 3.1415926535897931;
__constant dt_bfloat16_work dt_const_e_bfloat16 = 2.7182818284590451;

dt_bfloat16_work dt_add_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x + y;
}

dt_bfloat16_work dt_subtract_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x - y;
}

dt_bfloat16_work dt_multiply_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x * y;
}

dt_bfloat16_work dt_divide_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x / y;
}

dt_bfloat16_work dt_min_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x < y ? x : y;
}

dt_bfloat16_work dt_max_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x < y ? y : x;
}

dt_bfloat16_work dt_mad_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y, dt_bfloat16_work z) {
    return x * y + z;
}

dt_bfloat16_work dt_floor_divide_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return floor(x / y);
}

dt_bfloat16_work dt_power_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return pow(x, y);
}

dt_bfloat16_work dt_arctan2_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return atan2(x, y);
}

dt_bfloat16_work dt_square_bfloat16(dt_bfloat16_work x) {
    return x * x;
}

dt_bfloat16_work dt_round_bfloat16(dt_bfloat16_work x) {
    dt_bfloat16_work rounded = round(x);

    if (fabs(x - rounded) == (dt_bfloat16_work)0.5) {
        rounded = ((dt_bfloat16_work)2.0) * round(x * (dt_bfloat16_work)0.5);
    }
    return rounded;
}

dt_bool_work dt_equal_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x != y;
}

dt_bool_work dt_greater_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x >= y;
}

dt_bool_work dt_less_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_bfloat16(dt_bfloat16_work x, dt_bfloat16_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_bfloat16(dt_bfloat16_work x) {
    return !x;
}

dt_bfloat16_work dt_negative_bfloat16(dt_bfloat16_work x) {
    return -x;
}

dt_bfloat16_work dt_abs_bfloat16(dt_bfloat16_work x) {
    return fabs(x);
}

dt_bfloat16_work dt_sqrt_bfloat16(dt_bfloat16_work x) {
    return sqrt(x);
}

dt_bfloat16_work dt_exp_bfloat16(dt_bfloat16_work x) {
    return exp(x);
}

dt_bfloat16_work dt_exp2_bfloat16(dt_bfloat16_work x) {
    return exp2(x);
}

dt_bfloat16_work dt_exp10_bfloat16(dt_bfloat16_work x) {
    return exp10(x);
}

dt_bfloat16_work dt_expm1_bfloat16(dt_bfloat16_work x) {
    return expm1(x);
}

dt_bfloat16_work dt_log_bfloat16(dt_bfloat16_work x) {
    return log(x);
}

dt_bfloat16_work dt_log2_bfloat16(dt_bfloat16_work x) {
    return log2(x);
}

dt_bfloat16_work dt_log10_bfloat16(dt_bfloat16_work x) {
    return log10(x);
}

dt_bfloat16_work dt_log1p_bfloat16(dt_bfloat16_work x) {
    return log1p(x);
}

dt_bfloat16_work dt_sign_bfloat16(dt_bfloat16_work x) {
    return sign(x);
}

dt_bfloat16_work dt_sin_bfloat16(dt_bfloat16_work x) {
    return sin(x);
}

dt_bfloat16_work dt_cos_bfloat16(dt_bfloat16_work x) {
    return cos(x);
}

dt_bfloat16_work dt_tan_bfloat16(dt_bfloat16_work x) {
    return tan(x);
}

dt_bfloat16_work dt_sinh_bfloat16(dt_bfloat16_work x) {
    return sinh(x);
}

dt_bfloat16_work dt_cosh_bfloat16(dt_bfloat16_work x) {
    return cosh(x);
}

dt_bfloat16_work dt_tanh_bfloat16(dt_bfloat16_work x) {
    return tanh(x);
}

dt_bfloat16_work dt_arcsin_bfloat16(dt_bfloat16_work x) {
    return asin(x);
}

dt_bfloat16_work dt_arccos_bfloat16(dt_bfloat16_work x) {
    return acos(x);
}

dt_bfloat16_work dt_arctan_bfloat16(dt_bfloat16_work x) {
    return atan(x);
}

dt_bfloat16_work dt_arcsinh_bfloat16(dt_bfloat16_work x) {
    return asinh(x);
}

dt_bfloat16_work dt_arccosh_bfloat16(dt_bfloat16_work x) {
    return acosh(x);
}

dt_bfloat16_work dt_arctanh_bfloat16(dt_bfloat16_work x) {
    return atanh(x);
}

dt_bfloat16_work dt_floor_bfloat16(dt_bfloat16_work x) {
    return floor(x);
}

dt_bfloat16_work dt_ceil_bfloat16(dt_bfloat16_work x) {
    return ceil(x);
}

dt_bfloat16_work dt_trunc_bfloat16(dt_bfloat16_work x) {
    return trunc(x);
}

#endif