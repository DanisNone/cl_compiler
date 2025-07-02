#ifndef __DTYPES_uint16__
#define __DTYPES_uint16__

#include "dtypes/bool.cl"

typedef ushort dt_uint16;
typedef ushort dt_uint16_work;

dt_uint16_work dt_normalize_input_uint16(dt_uint16_work x) {
    return x;
}

dt_uint16_work dt_normalize_output_uint16(dt_uint16_work x) {
    return x;
}


dt_uint16_work dt_add_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x + y;
}

dt_uint16_work dt_subtract_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x - y;
}

dt_uint16_work dt_multiply_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x * y;
}

dt_uint16_work dt_modulo_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x % y;
}

dt_uint16_work dt_power_uint16(dt_uint16_work x, dt_uint16_work y)
{
    if (x == 0)
        return y == 0;

    dt_uint16_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_uint16_work dt_bitwise_and_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x & y;
}

dt_uint16_work dt_bitwise_or_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x | y;
}

dt_uint16_work dt_bitwise_xor_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x ^ y;
}

dt_uint16_work dt_left_shift_uint16(dt_uint16_work x, dt_uint16_work y) {
    return y >= 16 ? 0 : x << y;
}

dt_uint16_work dt_right_shift_uint16(dt_uint16_work x, dt_uint16_work y) {
    return y >= 16 ? 0 : x >> y;
}

dt_uint16_work dt_negative_uint16(dt_uint16_work x) {
    return -x;
}

dt_uint16_work dt_bitwise_not_uint16(dt_uint16_work x) {
    return ~x;
}

dt_uint16_work dt_square_uint16(dt_uint16_work x) {
    return x * x;
}

dt_uint16_work dt_abs_uint16(dt_uint16_work x) {
    return x;
}

dt_uint16_work dt_sign_uint16(dt_uint16_work x) {
    return x > 0;
}

dt_bool_work dt_equal_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x != y;
}

dt_bool_work dt_greater_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x >= y;
}

dt_bool_work dt_less_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_uint16(dt_uint16_work x, dt_uint16_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_uint16(dt_uint16_work x) {
    return !x;
}

dt_uint16_work dt_min_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x < y ? x : y;
}

dt_uint16_work dt_max_uint16(dt_uint16_work x, dt_uint16_work y) {
    return x < y ? y : x;
}

dt_uint16_work dt_mad_uint16(dt_uint16_work x, dt_uint16_work y, dt_uint16_work z) {
    return x * y + z;
}

#endif