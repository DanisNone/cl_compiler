#ifndef __DTYPES_int8__
#define __DTYPES_int8__

#include "dtypes/bool.cl"

typedef char dt_int8;
typedef char dt_int8_work;

dt_int8_work dt_normalize_input_int8(dt_int8_work x) {
    return x;
}

dt_int8_work dt_normalize_output_int8(dt_int8_work x) {
    return x;
}


dt_int8_work dt_add_int8(dt_int8_work x, dt_int8_work y) {
    return x + y;
}

dt_int8_work dt_subtract_int8(dt_int8_work x, dt_int8_work y) {
    return x - y;
}

dt_int8_work dt_multiply_int8(dt_int8_work x, dt_int8_work y) {
    return x * y;
}

dt_int8_work dt_modulo_int8(dt_int8_work x, dt_int8_work y) {
    return x % y;
}

dt_int8_work dt_power_int8(dt_int8_work x, dt_int8_work y)
{
    if (y < 0)
        return x == 1;
    if (x == 0)
        return y == 0;

    dt_int8_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_int8_work dt_bitwise_and_int8(dt_int8_work x, dt_int8_work y) {
    return x & y;
}

dt_int8_work dt_bitwise_or_int8(dt_int8_work x, dt_int8_work y) {
    return x | y;
}

dt_int8_work dt_bitwise_xor_int8(dt_int8_work x, dt_int8_work y) {
    return x ^ y;
}

dt_int8_work dt_left_shift_int8(dt_int8_work x, dt_int8_work y) {
    return y >= 8 ? 0 : x << y;
}

dt_int8_work dt_right_shift_int8(dt_int8_work x, dt_int8_work y) {
    return y >= 8 ? (-(x < 0)) : x >> y;
}

dt_int8_work dt_negative_int8(dt_int8_work x) {
    return -x;
}

dt_int8_work dt_bitwise_not_int8(dt_int8_work x) {
    return ~x;
}

dt_int8_work dt_square_int8(dt_int8_work x) {
    return x * x;
}

dt_int8_work dt_abs_int8(dt_int8_work x) {
    return x < 0 ? -x : x;
}

dt_int8_work dt_sign_int8(dt_int8_work x) {
    return (x > 0) - (x < 0);
}

dt_bool_work dt_equal_int8(dt_int8_work x, dt_int8_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_int8(dt_int8_work x, dt_int8_work y) {
    return x != y;
}

dt_bool_work dt_greater_int8(dt_int8_work x, dt_int8_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_int8(dt_int8_work x, dt_int8_work y) {
    return x >= y;
}

dt_bool_work dt_less_int8(dt_int8_work x, dt_int8_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_int8(dt_int8_work x, dt_int8_work y) {
    return x <= y;
}

dt_int8_work dt_min_int8(dt_int8_work x, dt_int8_work y) {
    return x < y ? x : y;
}

dt_int8_work dt_max_int8(dt_int8_work x, dt_int8_work y) {
    return x < y ? y : x;
}

dt_int8_work dt_mad_int8(dt_int8_work x, dt_int8_work y, dt_int8_work z) {
    return x * y + z;
}

#endif