#ifndef __DTYPES_uint4__
#define __DTYPES_uint4__

#include "dtypes/bool.cl"

typedef uchar dt_uint4;
typedef uchar dt_uint4_work;

dt_uint4_work dt_normalize_input_uint4(dt_uint4_work x) {
    return x & (dt_uint4_work)0b1111;
}

dt_uint4_work dt_normalize_output_uint4(dt_uint4_work x) {
    return x & (dt_uint4_work)0b1111;
}


dt_uint4_work dt_add_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x + y;
}

dt_uint4_work dt_subtract_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x - y;
}

dt_uint4_work dt_multiply_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x * y;
}

dt_uint4_work dt_mod_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x % y;
}

dt_uint4_work dt_power_uint4(dt_uint4_work x, dt_uint4_work y)
{
    if (x == 0)
        return y == 0;

    dt_uint4_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_uint4_work dt_bitwise_and_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x & y;
}

dt_uint4_work dt_bitwise_or_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x | y;
}

dt_uint4_work dt_bitwise_xor_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x ^ y;
}

dt_uint4_work dt_left_shift_uint4(dt_uint4_work x, dt_uint4_work y) {
    return y >= 4 ? 0 : x << y;
}

dt_uint4_work dt_right_shift_uint4(dt_uint4_work x, dt_uint4_work y) {
    return y >= 4 ? 0 : x >> y;
}

dt_uint4_work dt_negative_uint4(dt_uint4_work x) {
    return -x;
}

dt_uint4_work dt_bitwise_not_uint4(dt_uint4_work x) {
    return ~x;
}

dt_uint4_work dt_square_uint4(dt_uint4_work x) {
    return x * x;
}

dt_uint4_work dt_abs_uint4(dt_uint4_work x) {
    return x;
}

dt_uint4_work dt_sign_uint4(dt_uint4_work x) {
    return x > 0;
}

dt_bool_work dt_equal_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x != y;
}

dt_bool_work dt_greater_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x >= y;
}

dt_bool_work dt_less_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x <= y;
}

dt_uint4_work dt_min_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x < y ? x : y;
}

dt_uint4_work dt_max_uint4(dt_uint4_work x, dt_uint4_work y) {
    return x < y ? y : x;
}

#endif