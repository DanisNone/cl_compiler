#ifndef __DTYPES_float32__
#define __DTYPES_float32__

#include "dtypes/bool.cl"

typedef float dt_float32;
typedef float dt_float32_work;

static inline dt_float32_work dt_normalize_input_float32(dt_float32 x)  { return x; }
static inline dt_float32 dt_normalize_output_float32(dt_float32_work x) { return x; }


dt_float32_work dt_zero_float32() { return 0; }
dt_float32_work dt_one_float32() { return 1; }

__constant dt_float32_work dt_const_log2_float32 = 0.6931471805599453;
__constant dt_float32_work dt_const_log10_float32 = 2.302585092994046;
__constant dt_float32_work dt_const_pi_float32 = 3.1415926535897931;
__constant dt_float32_work dt_const_e_float32 = 2.7182818284590451;

dt_float32_work dt_add_float32(dt_float32_work x, dt_float32_work y) {
    return x + y;
}

dt_float32_work dt_subtract_float32(dt_float32_work x, dt_float32_work y) {
    return x - y;
}

dt_float32_work dt_multiply_float32(dt_float32_work x, dt_float32_work y) {
    return x * y;
}

dt_float32_work dt_divide_float32(dt_float32_work x, dt_float32_work y) {
    return x / y;
}

dt_float32_work dt_min_float32(dt_float32_work x, dt_float32_work y) {
    return x < y ? x : y;
}

dt_float32_work dt_max_float32(dt_float32_work x, dt_float32_work y) {
    return x < y ? y : x;
}

dt_float32_work dt_mad_float32(dt_float32_work x, dt_float32_work y, dt_float32_work z) {
    return x * y + z;
}

dt_float32_work dt_floor_divide_float32(dt_float32_work x, dt_float32_work y) {
    return floor(x / y);
}

dt_float32_work dt_power_float32(dt_float32_work x, dt_float32_work y) {
    return pow(x, y);
}

dt_float32_work dt_arctan2_float32(dt_float32_work x, dt_float32_work y) {
    return atan2(x, y);
}

dt_float32_work dt_square_float32(dt_float32_work x) {
    return x * x;
}

dt_float32_work dt_round_float32(dt_float32_work x) {
    dt_float32_work rounded = round(x);

    if (fabs(x - rounded) == (dt_float32_work)0.5) {
        rounded = ((dt_float32_work)2.0) * round(x * (dt_float32_work)0.5);
    }
    return rounded;
}

dt_bool_work dt_equal_float32(dt_float32_work x, dt_float32_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_float32(dt_float32_work x, dt_float32_work y) {
    return x != y;
}

dt_bool_work dt_greater_float32(dt_float32_work x, dt_float32_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_float32(dt_float32_work x, dt_float32_work y) {
    return x >= y;
}

dt_bool_work dt_less_float32(dt_float32_work x, dt_float32_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_float32(dt_float32_work x, dt_float32_work y) {
    return x <= y;
}

dt_bool_work dt_mod_float32(dt_float32_work x, dt_float32_work y) {
    return fmod(x, y);
}

dt_float32_work dt_negative_float32(dt_float32_work x) {
    return -x;
}

dt_float32_work dt_abs_float32(dt_float32_work x) {
    return fabs(x);
}

dt_float32_work dt_sqrt_float32(dt_float32_work x) {
    return sqrt(x);
}

dt_float32_work dt_exp_float32(dt_float32_work x) {
    return exp(x);
}

dt_float32_work dt_exp2_float32(dt_float32_work x) {
    return exp2(x);
}

dt_float32_work dt_exp10_float32(dt_float32_work x) {
    return exp10(x);
}

dt_float32_work dt_expm1_float32(dt_float32_work x) {
    return expm1(x);
}

dt_float32_work dt_log_float32(dt_float32_work x) {
    return log(x);
}

dt_float32_work dt_log2_float32(dt_float32_work x) {
    return log2(x);
}

dt_float32_work dt_log10_float32(dt_float32_work x) {
    return log10(x);
}

dt_float32_work dt_log1p_float32(dt_float32_work x) {
    return log1p(x);
}

dt_float32_work dt_sign_float32(dt_float32_work x) {
    return sign(x);
}

dt_float32_work dt_sin_float32(dt_float32_work x) {
    return sin(x);
}

dt_float32_work dt_cos_float32(dt_float32_work x) {
    return cos(x);
}

dt_float32_work dt_tan_float32(dt_float32_work x) {
    return tan(x);
}

dt_float32_work dt_sinh_float32(dt_float32_work x) {
    return sinh(x);
}

dt_float32_work dt_cosh_float32(dt_float32_work x) {
    return cosh(x);
}

dt_float32_work dt_tanh_float32(dt_float32_work x) {
    return tanh(x);
}

dt_float32_work dt_arcsin_float32(dt_float32_work x) {
    return asin(x);
}

dt_float32_work dt_arccos_float32(dt_float32_work x) {
    return acos(x);
}

dt_float32_work dt_arctan_float32(dt_float32_work x) {
    return atan(x);
}

dt_float32_work dt_arcsinh_float32(dt_float32_work x) {
    return asinh(x);
}

dt_float32_work dt_arccosh_float32(dt_float32_work x) {
    return acosh(x);
}

dt_float32_work dt_arctanh_float32(dt_float32_work x) {
    return atanh(x);
}

dt_float32_work dt_floor_float32(dt_float32_work x) {
    return floor(x);
}

dt_float32_work dt_ceil_float32(dt_float32_work x) {
    return ceil(x);
}

dt_float32_work dt_trunc_float32(dt_float32_work x) {
    return trunc(x);
}

#endif