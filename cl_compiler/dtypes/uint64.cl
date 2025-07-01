#include "dtypes/bool.h"

typedef ulong dt_uint64;
typedef ulong dt_uint64_work;

dt_uint64_work dt_normalize_input_uint64(dt_uint64_work x) {
    return x;
}

dt_uint64_work dt_normalize_output_uint64(dt_uint64_work x) {
    return x;
}


dt_uint64_work dt_add_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x + y;
}

dt_uint64_work dt_subtract_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x - y;
}

dt_uint64_work dt_multiply_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x * y;
}

dt_uint64_work dt_modulo_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x % y;
}

dt_uint64_work dt_power_uint64(dt_uint64_work x, dt_uint64_work y)
{
    if (x == 0)
        return y == 0;

    dt_uint64_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_uint64_work dt_bitwise_and_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x & y;
}

dt_uint64_work dt_bitwise_or_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x | y;
}

dt_uint64_work dt_bitwise_xor_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x ^ y;
}

dt_uint64_work dt_left_shift_uint64(dt_uint64_work x, dt_uint64_work y) {
    return y >= 64 ? 0 : x << y;
}

dt_uint64_work dt_right_shift_uint64(dt_uint64_work x, dt_uint64_work y) {
    return y >= 64 ? 0 : x >> y;
}

dt_uint64_work dt_negative_uint64(dt_uint64_work x) {
    return -x;
}

dt_uint64_work dt_bitwise_not_uint64(dt_uint64_work x) {
    return ~x;
}

dt_uint64_work dt_square_uint64(dt_uint64_work x) {
    return x * x;
}

dt_uint64_work dt_abs_uint64(dt_uint64_work x) {
    return x;
}

dt_uint64_work dt_sign_uint64(dt_uint64_work x) {
    return x > 0;
}

dt_bool_work dt_equal_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x != y;
}

dt_bool_work dt_greater_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x >= y;
}

dt_bool_work dt_less_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_uint64(dt_uint64_work x, dt_uint64_work y) {
    return (!!x) ^ (!!y);
}

dt_bool_work dt_logical_not_uint64(dt_uint64_work x) {
    return !x;
}

dt_uint64_work dt_min_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x < y ? x : y;
}

dt_uint64_work dt_max_uint64(dt_uint64_work x, dt_uint64_work y) {
    return x < y ? y : x;
}

dt_uint64_work dt_mad_uint64(dt_uint64_work x, dt_uint64_work y, dt_uint64_work z) {
    return x * y + z;
}