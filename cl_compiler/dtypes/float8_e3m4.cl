#include "dtypes/bool.h"

typedef uchar dt_float8_e3m4;
typedef float dt_float8_e3m4_work;

dt_float8_e3m4_work normalize_float8e3m4_input(dt_float8_e3m4 h) {
    uint s = (h >> 7) & 0x1;
    uint e = (h >> 4) & 0x7;
    uint f = h & 0xF;

    uint out_e, out_f;

    if (e == 0) {
        if (f == 0) {
            out_e = 0;
            out_f = 0;
        } else {
            e = 1;
            while ((f & 0x10) == 0) {
                f <<= 1;
                e--;
            }
            f &= 0xF;
            out_e = 127 - 4 - e;
            out_f = f << 19;  
        }
    } else if (e == 7) {      
        out_e = 255;          
        out_f = f << 19;
    } else {
        out_e = e + (127 - 4);
        out_f = f << 19;
    }

    uint result = (s << 31) | (out_e << 23) | out_f;
    return as_float(result);
}

dt_float8_e3m4 normalize_float8e3m4_output(dt_float8_e3m4_work x) {
    uint i = as_uint(x);
    uint s = (i >> 31) & 0x1;
    int e = ((i >> 23) & 0xFF) - 127 + 4;
    uint f = i & 0x007FFFFF;

    uchar h;

    if ((i & 0x7FFFFFFF) == 0) {
        h = (uchar)(s << 7);
    }
    else if (((i >> 23) & 0xFF) == 0xFF) {
        if (f == 0) {
            h = (uchar)((s << 7) | (0x7 << 4));
        } else {
            h = (uchar)((s << 7) | (0x7 << 4) | (f >> 19));
        }
    }
    else if (e <= 0) {
        if (e < -4) {
            h = (uchar)(s << 7);
        } else {
            f = (f | 0x00800000) >> (1 - e);
            h = (uchar)((s << 7) | (f >> 19));
        }
    }
    else if (e >= 7) {
        h = (uchar)((s << 7) | (0x7 << 4));
    }
    else {
        h = (uchar)((s << 7) | (e << 4) | (f >> 19));
    }

    return h;
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

dt_bool_work dt_logical_and_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_float8_e3m4(dt_float8_e3m4_work x, dt_float8_e3m4_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_float8_e3m4(dt_float8_e3m4_work x) {
    return !x;
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