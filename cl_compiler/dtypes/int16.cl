#ifndef __DTYPES_int16__
#define __DTYPES_int16__

#include "dtypes/bool.cl"

typedef short dt_int16;
typedef short dt_int16_work;

dt_int16_work dt_normalize_input_int16(dt_int16_work x) {
    return x;
}

dt_int16_work dt_normalize_output_int16(dt_int16_work x) {
    return x;
}


dt_int16_work dt_add_int16(dt_int16_work x, dt_int16_work y) {
    return x + y;
}

dt_int16_work dt_subtract_int16(dt_int16_work x, dt_int16_work y) {
    return x - y;
}

dt_int16_work dt_multiply_int16(dt_int16_work x, dt_int16_work y) {
    return x * y;
}

dt_int16_work dt_mod_int16(dt_int16_work x, dt_int16_work y) {
    return x % y;
}

dt_int16_work dt_power_int16(dt_int16_work x, dt_int16_work y)
{
    if (y < 0)
        return x == 1;
    if (x == 0)
        return y == 0;

    dt_int16_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_int16_work dt_bitwise_and_int16(dt_int16_work x, dt_int16_work y) {
    return x & y;
}

dt_int16_work dt_bitwise_or_int16(dt_int16_work x, dt_int16_work y) {
    return x | y;
}

dt_int16_work dt_bitwise_xor_int16(dt_int16_work x, dt_int16_work y) {
    return x ^ y;
}

dt_int16_work dt_left_shift_int16(dt_int16_work x, dt_int16_work y) {
    return y >= 16 ? 0 : x << y;
}

dt_int16_work dt_right_shift_int16(dt_int16_work x, dt_int16_work y) {
    return y >= 16 ? (-(x < 0)) : x >> y;
}

dt_int16_work dt_negative_int16(dt_int16_work x) {
    return -x;
}

dt_int16_work dt_bitwise_not_int16(dt_int16_work x) {
    return ~x;
}

dt_int16_work dt_square_int16(dt_int16_work x) {
    return x * x;
}

dt_int16_work dt_abs_int16(dt_int16_work x) {
    return x < 0 ? -x : x;
}

dt_int16_work dt_sign_int16(dt_int16_work x) {
    return (x > 0) - (x < 0);
}

dt_bool_work dt_equal_int16(dt_int16_work x, dt_int16_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_int16(dt_int16_work x, dt_int16_work y) {
    return x != y;
}

dt_bool_work dt_greater_int16(dt_int16_work x, dt_int16_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_int16(dt_int16_work x, dt_int16_work y) {
    return x >= y;
}

dt_bool_work dt_less_int16(dt_int16_work x, dt_int16_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_int16(dt_int16_work x, dt_int16_work y) {
    return x <= y;
}

dt_int16_work dt_min_int16(dt_int16_work x, dt_int16_work y) {
    return x < y ? x : y;
}

dt_int16_work dt_max_int16(dt_int16_work x, dt_int16_work y) {
    return x < y ? y : x;
}

#endif