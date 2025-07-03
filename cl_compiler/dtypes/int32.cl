#ifndef __DTYPES_int32__
#define __DTYPES_int32__

#include "dtypes/bool.cl"

typedef int dt_int32;
typedef int dt_int32_work;

dt_int32_work dt_normalize_input_int32(dt_int32_work x) {
    return x;
}

dt_int32_work dt_normalize_output_int32(dt_int32_work x) {
    return x;
}


dt_int32_work dt_add_int32(dt_int32_work x, dt_int32_work y) {
    return x + y;
}

dt_int32_work dt_subtract_int32(dt_int32_work x, dt_int32_work y) {
    return x - y;
}

dt_int32_work dt_multiply_int32(dt_int32_work x, dt_int32_work y) {
    return x * y;
}

dt_int32_work dt_mod_int32(dt_int32_work x, dt_int32_work y) {
    return x % y;
}

dt_int32_work dt_power_int32(dt_int32_work x, dt_int32_work y)
{
    if (y < 0)
        return x == 1;
    if (x == 0)
        return y == 0;

    dt_int32_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_int32_work dt_bitwise_and_int32(dt_int32_work x, dt_int32_work y) {
    return x & y;
}

dt_int32_work dt_bitwise_or_int32(dt_int32_work x, dt_int32_work y) {
    return x | y;
}

dt_int32_work dt_bitwise_xor_int32(dt_int32_work x, dt_int32_work y) {
    return x ^ y;
}

dt_int32_work dt_left_shift_int32(dt_int32_work x, dt_int32_work y) {
    return y >= 32 ? 0 : x << y;
}

dt_int32_work dt_right_shift_int32(dt_int32_work x, dt_int32_work y) {
    return y >= 32 ? (-(x < 0)) : x >> y;
}

dt_int32_work dt_negative_int32(dt_int32_work x) {
    return -x;
}

dt_int32_work dt_bitwise_not_int32(dt_int32_work x) {
    return ~x;
}

dt_int32_work dt_square_int32(dt_int32_work x) {
    return x * x;
}

dt_int32_work dt_abs_int32(dt_int32_work x) {
    return x < 0 ? -x : x;
}

dt_int32_work dt_sign_int32(dt_int32_work x) {
    return (x > 0) - (x < 0);
}

dt_bool_work dt_equal_int32(dt_int32_work x, dt_int32_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_int32(dt_int32_work x, dt_int32_work y) {
    return x != y;
}

dt_bool_work dt_greater_int32(dt_int32_work x, dt_int32_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_int32(dt_int32_work x, dt_int32_work y) {
    return x >= y;
}

dt_bool_work dt_less_int32(dt_int32_work x, dt_int32_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_int32(dt_int32_work x, dt_int32_work y) {
    return x <= y;
}

dt_int32_work dt_min_int32(dt_int32_work x, dt_int32_work y) {
    return x < y ? x : y;
}

dt_int32_work dt_max_int32(dt_int32_work x, dt_int32_work y) {
    return x < y ? y : x;
}

dt_int32_work dt_mad_int32(dt_int32_work x, dt_int32_work y, dt_int32_work z) {
    return x * y + z;
}

#endif