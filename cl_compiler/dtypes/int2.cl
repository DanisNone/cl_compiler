#include "dtypes/bool.h"

typedef char dt_int2;
typedef char dt_int2_work;

dt_int2_work dt_normalize_input_int2(dt_int2_work x) {
    return ((x & (dt_int2_work)0b11) ^ (dt_int2_work)0b10) - (dt_int2_work)0b10;
}

dt_int2_work dt_normalize_output_int2(dt_int2_work x) {
    return ((x & (dt_int2_work)0b11) ^ (dt_int2_work)0b10) - (dt_int2_work)0b10;
}


dt_int2_work dt_add_int2(dt_int2_work x, dt_int2_work y) {
    return x + y;
}

dt_int2_work dt_subtract_int2(dt_int2_work x, dt_int2_work y) {
    return x - y;
}

dt_int2_work dt_multiply_int2(dt_int2_work x, dt_int2_work y) {
    return x * y;
}

dt_int2_work dt_modulo_int2(dt_int2_work x, dt_int2_work y) {
    return x % y;
}

dt_int2_work dt_power_int2(dt_int2_work x, dt_int2_work y)
{
    if (y < 0)
        return x == 1;
    if (x == 0)
        return y == 0;

    dt_int2_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_int2_work dt_bitwise_and_int2(dt_int2_work x, dt_int2_work y) {
    return x & y;
}

dt_int2_work dt_bitwise_or_int2(dt_int2_work x, dt_int2_work y) {
    return x | y;
}

dt_int2_work dt_bitwise_xor_int2(dt_int2_work x, dt_int2_work y) {
    return x ^ y;
}

dt_int2_work dt_left_shift_int2(dt_int2_work x, dt_int2_work y) {
    return y >= 2 ? 0 : x << y;
}

dt_int2_work dt_right_shift_int2(dt_int2_work x, dt_int2_work y) {
    return y >= 2 ? (-(x < 0)) : x >> y;
}

dt_int2_work dt_negative_int2(dt_int2_work x) {
    return -x;
}

dt_int2_work dt_bitwise_not_int2(dt_int2_work x) {
    return ~x;
}

dt_int2_work dt_square_int2(dt_int2_work x) {
    return x * x;
}

dt_int2_work dt_abs_int2(dt_int2_work x) {
    return x < 0 ? -x : x;
}

dt_int2_work dt_sign_int2(dt_int2_work x) {
    return (x > 0) - (x < 0);
}

dt_bool_work dt_equal_int2(dt_int2_work x, dt_int2_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_int2(dt_int2_work x, dt_int2_work y) {
    return x != y;
}

dt_bool_work dt_greater_int2(dt_int2_work x, dt_int2_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_int2(dt_int2_work x, dt_int2_work y) {
    return x >= y;
}

dt_bool_work dt_less_int2(dt_int2_work x, dt_int2_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_int2(dt_int2_work x, dt_int2_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_int2(dt_int2_work x, dt_int2_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_int2(dt_int2_work x, dt_int2_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_int2(dt_int2_work x, dt_int2_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_int2(dt_int2_work x) {
    return !x;
}

dt_int2_work dt_min_int2(dt_int2_work x, dt_int2_work y) {
    return x < y ? x : y;
}

dt_int2_work dt_max_int2(dt_int2_work x, dt_int2_work y) {
    return x < y ? y : x;
}

dt_int2_work dt_mad_int2(dt_int2_work x, dt_int2_work y, dt_int2_work z) {
    return x * y + z;
}