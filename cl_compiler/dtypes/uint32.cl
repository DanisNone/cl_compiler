#include "dtypes/bool.h"

typedef uint dt_uint32;
typedef uint dt_uint32_work;

dt_uint32_work dt_normalize_input_uint32(dt_uint32_work x) {
    return x;
}

dt_uint32_work dt_normalize_output_uint32(dt_uint32_work x) {
    return x;
}


dt_uint32_work dt_add_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x + y;
}

dt_uint32_work dt_subtract_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x - y;
}

dt_uint32_work dt_multiply_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x * y;
}

dt_uint32_work dt_modulo_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x % y;
}

dt_uint32_work dt_power_uint32(dt_uint32_work x, dt_uint32_work y)
{
    if (x == 0)
        return y == 0;

    dt_uint32_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_uint32_work dt_bitwise_and_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x & y;
}

dt_uint32_work dt_bitwise_or_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x | y;
}

dt_uint32_work dt_bitwise_xor_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x ^ y;
}

dt_uint32_work dt_left_shift_uint32(dt_uint32_work x, dt_uint32_work y) {
    return y >= 32 ? 0 : x << y;
}

dt_uint32_work dt_right_shift_uint32(dt_uint32_work x, dt_uint32_work y) {
    return y >= 32 ? 0 : x >> y;
}

dt_uint32_work dt_negative_uint32(dt_uint32_work x) {
    return -x;
}

dt_uint32_work dt_bitwise_not_uint32(dt_uint32_work x) {
    return ~x;
}

dt_uint32_work dt_square_uint32(dt_uint32_work x) {
    return x * x;
}

dt_uint32_work dt_abs_uint32(dt_uint32_work x) {
    return x;
}

dt_uint32_work dt_sign_uint32(dt_uint32_work x) {
    return x > 0;
}

dt_bool_work dt_equal_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x != y;
}

dt_bool_work dt_greater_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x >= y;
}

dt_bool_work dt_less_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_uint32(dt_uint32_work x, dt_uint32_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_uint32(dt_uint32_work x) {
    return !x;
}

dt_uint32_work dt_min_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x < y ? x : y;
}

dt_uint32_work dt_max_uint32(dt_uint32_work x, dt_uint32_work y) {
    return x < y ? y : x;
}

dt_uint32_work dt_mad_uint32(dt_uint32_work x, dt_uint32_work y, dt_uint32_work z) {
    return x * y + z;
}