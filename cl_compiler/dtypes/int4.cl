#ifndef __DTYPES_int4__
#define __DTYPES_int4__

#include "dtypes/bool.cl"

typedef char dt_int4;
typedef char dt_int4_work;

dt_int4_work dt_normalize_input_int4(dt_int4_work x) {
    return ((x & (dt_int4_work)0b1111) ^ (dt_int4_work)0b1000) - (dt_int4_work)0b1000;
}

dt_int4_work dt_normalize_output_int4(dt_int4_work x) {
    return ((x & (dt_int4_work)0b1111) ^ (dt_int4_work)0b1000) - (dt_int4_work)0b1000;
}


dt_int4_work dt_add_int4(dt_int4_work x, dt_int4_work y) {
    return x + y;
}

dt_int4_work dt_subtract_int4(dt_int4_work x, dt_int4_work y) {
    return x - y;
}

dt_int4_work dt_multiply_int4(dt_int4_work x, dt_int4_work y) {
    return x * y;
}

dt_int4_work dt_mod_int4(dt_int4_work x, dt_int4_work y) {
    return x % y;
}

dt_int4_work dt_power_int4(dt_int4_work x, dt_int4_work y)
{
    if (y < 0)
        return x == 1;
    if (x == 0)
        return y == 0;

    dt_int4_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_int4_work dt_bitwise_and_int4(dt_int4_work x, dt_int4_work y) {
    return x & y;
}

dt_int4_work dt_bitwise_or_int4(dt_int4_work x, dt_int4_work y) {
    return x | y;
}

dt_int4_work dt_bitwise_xor_int4(dt_int4_work x, dt_int4_work y) {
    return x ^ y;
}

dt_int4_work dt_left_shift_int4(dt_int4_work x, dt_int4_work y) {
    return y >= 4 ? 0 : x << y;
}

dt_int4_work dt_right_shift_int4(dt_int4_work x, dt_int4_work y) {
    return y >= 4 ? (-(x < 0)) : x >> y;
}

dt_int4_work dt_negative_int4(dt_int4_work x) {
    return -x;
}

dt_int4_work dt_bitwise_not_int4(dt_int4_work x) {
    return ~x;
}

dt_int4_work dt_square_int4(dt_int4_work x) {
    return x * x;
}

dt_int4_work dt_abs_int4(dt_int4_work x) {
    return x < 0 ? -x : x;
}

dt_int4_work dt_sign_int4(dt_int4_work x) {
    return (x > 0) - (x < 0);
}

dt_bool_work dt_equal_int4(dt_int4_work x, dt_int4_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_int4(dt_int4_work x, dt_int4_work y) {
    return x != y;
}

dt_bool_work dt_greater_int4(dt_int4_work x, dt_int4_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_int4(dt_int4_work x, dt_int4_work y) {
    return x >= y;
}

dt_bool_work dt_less_int4(dt_int4_work x, dt_int4_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_int4(dt_int4_work x, dt_int4_work y) {
    return x <= y;
}

dt_int4_work dt_min_int4(dt_int4_work x, dt_int4_work y) {
    return x < y ? x : y;
}

dt_int4_work dt_max_int4(dt_int4_work x, dt_int4_work y) {
    return x < y ? y : x;
}

dt_int4_work dt_mad_int4(dt_int4_work x, dt_int4_work y, dt_int4_work z) {
    return x * y + z;
}

#endif