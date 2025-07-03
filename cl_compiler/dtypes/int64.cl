#ifndef __DTYPES_int64__
#define __DTYPES_int64__

#include "dtypes/bool.cl"

typedef long dt_int64;
typedef long dt_int64_work;

dt_int64_work dt_normalize_input_int64(dt_int64_work x) {
    return x;
}

dt_int64_work dt_normalize_output_int64(dt_int64_work x) {
    return x;
}


dt_int64_work dt_add_int64(dt_int64_work x, dt_int64_work y) {
    return x + y;
}

dt_int64_work dt_subtract_int64(dt_int64_work x, dt_int64_work y) {
    return x - y;
}

dt_int64_work dt_multiply_int64(dt_int64_work x, dt_int64_work y) {
    return x * y;
}

dt_int64_work dt_mod_int64(dt_int64_work x, dt_int64_work y) {
    return x % y;
}

dt_int64_work dt_power_int64(dt_int64_work x, dt_int64_work y)
{
    if (y < 0)
        return x == 1;
    if (x == 0)
        return y == 0;

    dt_int64_work res = 1;
    while (y != 0)
    {
        if (y & 1)
            res *= x;
        x *= x;
        y >>= 1;
    }
    return res;
}

dt_int64_work dt_bitwise_and_int64(dt_int64_work x, dt_int64_work y) {
    return x & y;
}

dt_int64_work dt_bitwise_or_int64(dt_int64_work x, dt_int64_work y) {
    return x | y;
}

dt_int64_work dt_bitwise_xor_int64(dt_int64_work x, dt_int64_work y) {
    return x ^ y;
}

dt_int64_work dt_left_shift_int64(dt_int64_work x, dt_int64_work y) {
    return y >= 64 ? 0 : x << y;
}

dt_int64_work dt_right_shift_int64(dt_int64_work x, dt_int64_work y) {
    return y >= 64 ? (-(x < 0)) : x >> y;
}

dt_int64_work dt_negative_int64(dt_int64_work x) {
    return -x;
}

dt_int64_work dt_bitwise_not_int64(dt_int64_work x) {
    return ~x;
}

dt_int64_work dt_square_int64(dt_int64_work x) {
    return x * x;
}

dt_int64_work dt_abs_int64(dt_int64_work x) {
    return x < 0 ? -x : x;
}

dt_int64_work dt_sign_int64(dt_int64_work x) {
    return (x > 0) - (x < 0);
}

dt_bool_work dt_equal_int64(dt_int64_work x, dt_int64_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_int64(dt_int64_work x, dt_int64_work y) {
    return x != y;
}

dt_bool_work dt_greater_int64(dt_int64_work x, dt_int64_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_int64(dt_int64_work x, dt_int64_work y) {
    return x >= y;
}

dt_bool_work dt_less_int64(dt_int64_work x, dt_int64_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_int64(dt_int64_work x, dt_int64_work y) {
    return x <= y;
}

dt_int64_work dt_min_int64(dt_int64_work x, dt_int64_work y) {
    return x < y ? x : y;
}

dt_int64_work dt_max_int64(dt_int64_work x, dt_int64_work y) {
    return x < y ? y : x;
}

dt_int64_work dt_mad_int64(dt_int64_work x, dt_int64_work y, dt_int64_work z) {
    return x * y + z;
}

#endif