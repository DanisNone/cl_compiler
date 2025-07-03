#ifndef __DTYPES_float8_e3m4__
#define __DTYPES_float8_e3m4__

#include "dtypes/bool.cl"

typedef uchar dt_float8_e3m4;
typedef float dt_float8_e3m4_work;


dt_float8_e3m4_work dt_normalize_input_float8_e3m4(dt_float8_e3m4 f) {
    bool is_neg = f >= 128;
    if (is_neg) f -= 128;

    float res;
    if (f < 32)
        res = f / 64.0f;
    else if (f < 48)
        res = f / 32.0f - 0.5f;
    else if (f < 64)
        res = f / 16.0f - 2.0f;
    else if (f < 80)
        res = f / 8.0f - 6.0f;
    else if (f < 96)
        res = f / 4.0f - 16.0f;
    else if (f < 112)
        res = f / 2.0f - 40.0f;
    else if (f == 112)
        res = as_float(0x7f800000); // inf
    else
        res = as_float(0x7fc00000); // nan
    return is_neg ? -res : res;
}


dt_float8_e3m4 dt_normalize_output_float8_e3m4(dt_float8_e3m4_work f) {
    float af = fabs(f);
    uchar result;

    if (af <= 0.5f)
        result = convert_uchar_rte(af * 64);
    else if (af <= 1.0f)
        result = convert_uchar_rte(af * 32) + 16;
    else if (af <= 2.0f)
        result = convert_uchar_rte(af * 16) + 32;
    else if (af <= 4.0f)
        result = convert_uchar_rte(af * 8) + 48;
    else if (af <= 8.0f)
        result = convert_uchar_rte(af * 4) + 64;
    else if (af <= 16.0f)
        result = convert_uchar_rte(af * 2) + 80;
    else if (af > 16.0f)
        result = 112; // inf
    else
        result = 113; // nan
    return result | (signbit(f) ? 0x80 : 0);
}

dt_float8_e3m4_work dt_zero_float8_e3m4() { return 0; }
dt_float8_e3m4_work dt_one_float8_e3m4() { return 1; }

__constant dt_float8_e3m4_work dt_const_log2_float8_e3m4 = 0.6931471805599453;
__constant dt_float8_e3m4_work dt_const_log10_float8_e3m4 = 2.302585092994046;
__constant dt_float8_e3m4_work dt_const_pi_float8_e3m4 = 3.1415926535897931;
__constant dt_float8_e3m4_work dt_const_e_float8_e3m4 = 2.7182818284590451;

dt_float8_e3m4_work dt_add_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x + y;
}

dt_float8_e3m4_work dt_subtract_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x - y;
}

dt_float8_e3m4_work dt_multiply_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x * y;
}

dt_float8_e3m4_work dt_divide_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x / y;
}

dt_float8_e3m4_work dt_min_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x < y ? x : y;
}

dt_float8_e3m4_work dt_max_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x < y ? y : x;
}

dt_float8_e3m4_work dt_mad_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y, dt_float8_e3m4_work z) {
    return x * y + z;
}

dt_float8_e3m4_work dt_floor_divide_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return floor(x / y);
}

dt_float8_e3m4_work dt_power_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return pow(x, y);
}

dt_float8_e3m4_work dt_arctan2_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return atan2(x, y);
}

dt_float8_e3m4_work dt_square_float8_e3m4(dt_float8_e3m4_work x) {
    return x * x;
}

dt_float8_e3m4_work dt_round_float8_e3m4(dt_float8_e3m4_work x) {
    dt_float8_e3m4_work rounded = round(x);

    if (fabs(x - rounded) == (dt_float8_e3m4_work)0.5) {
        rounded = ((dt_float8_e3m4_work)2.0) * round(x * (dt_float8_e3m4_work)0.5);
    }
    return rounded;
}

dt_bool_work dt_equal_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x != y;
}

dt_bool_work dt_greater_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x >= y;
}

dt_bool_work dt_less_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x <= y;
}

dt_bool_work dt_mod_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return fmod(x, y);
}

dt_float8_e3m4_work dt_negative_float8_e3m4(dt_float8_e3m4_work x) {
    return -x;
}

dt_float8_e3m4_work dt_abs_float8_e3m4(dt_float8_e3m4_work x) {
    return fabs(x);
}

dt_float8_e3m4_work dt_sqrt_float8_e3m4(dt_float8_e3m4_work x) {
    return sqrt(x);
}

dt_float8_e3m4_work dt_exp_float8_e3m4(dt_float8_e3m4_work x) {
    return exp(x);
}

dt_float8_e3m4_work dt_exp2_float8_e3m4(dt_float8_e3m4_work x) {
    return exp2(x);
}

dt_float8_e3m4_work dt_exp10_float8_e3m4(dt_float8_e3m4_work x) {
    return exp10(x);
}

dt_float8_e3m4_work dt_expm1_float8_e3m4(dt_float8_e3m4_work x) {
    return expm1(x);
}

dt_float8_e3m4_work dt_log_float8_e3m4(dt_float8_e3m4_work x) {
    return log(x);
}

dt_float8_e3m4_work dt_log2_float8_e3m4(dt_float8_e3m4_work x) {
    return log2(x);
}

dt_float8_e3m4_work dt_log10_float8_e3m4(dt_float8_e3m4_work x) {
    return log10(x);
}

dt_float8_e3m4_work dt_log1p_float8_e3m4(dt_float8_e3m4_work x) {
    return log1p(x);
}

dt_float8_e3m4_work dt_sign_float8_e3m4(dt_float8_e3m4_work x) {
    return sign(x);
}

dt_float8_e3m4_work dt_sin_float8_e3m4(dt_float8_e3m4_work x) {
    return sin(x);
}

dt_float8_e3m4_work dt_cos_float8_e3m4(dt_float8_e3m4_work x) {
    return cos(x);
}

dt_float8_e3m4_work dt_tan_float8_e3m4(dt_float8_e3m4_work x) {
    return tan(x);
}

dt_float8_e3m4_work dt_sinh_float8_e3m4(dt_float8_e3m4_work x) {
    return sinh(x);
}

dt_float8_e3m4_work dt_cosh_float8_e3m4(dt_float8_e3m4_work x) {
    return cosh(x);
}

dt_float8_e3m4_work dt_tanh_float8_e3m4(dt_float8_e3m4_work x) {
    return tanh(x);
}

dt_float8_e3m4_work dt_arcsin_float8_e3m4(dt_float8_e3m4_work x) {
    return asin(x);
}

dt_float8_e3m4_work dt_arccos_float8_e3m4(dt_float8_e3m4_work x) {
    return acos(x);
}

dt_float8_e3m4_work dt_arctan_float8_e3m4(dt_float8_e3m4_work x) {
    return atan(x);
}

dt_float8_e3m4_work dt_arcsinh_float8_e3m4(dt_float8_e3m4_work x) {
    return asinh(x);
}

dt_float8_e3m4_work dt_arccosh_float8_e3m4(dt_float8_e3m4_work x) {
    return acosh(x);
}

dt_float8_e3m4_work dt_arctanh_float8_e3m4(dt_float8_e3m4_work x) {
    return atanh(x);
}

dt_float8_e3m4_work dt_floor_float8_e3m4(dt_float8_e3m4_work x) {
    return floor(x);
}

dt_float8_e3m4_work dt_ceil_float8_e3m4(dt_float8_e3m4_work x) {
    return ceil(x);
}

dt_float8_e3m4_work dt_trunc_float8_e3m4(dt_float8_e3m4_work x) {
    return trunc(x);
}

#endif