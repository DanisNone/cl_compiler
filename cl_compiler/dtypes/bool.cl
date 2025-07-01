typedef bool dt_bool;
typedef bool dt_bool_work;

dt_bool_work dt_normalize_input_bool(dt_bool_work x) {
    return x;
}

dt_bool_work dt_normalize_output_bool(dt_bool_work x) {
    return x;
}

dt_bool_work dt_add_bool(dt_bool_work x, dt_bool_work y) {
    return x || y;
}

dt_bool_work dt_multiply_bool(dt_bool_work x, dt_bool_work y) {
    return x && y;
}

dt_bool_work dt_bitwise_and_bool(dt_bool_work x, dt_bool_work y) {
    return x && y;
}

dt_bool_work dt_bitwise_or_bool(dt_bool_work x, dt_bool_work y) {
    return x || y;
}

dt_bool_work dt_bitwise_xor_bool(dt_bool_work x, dt_bool_work y) {
    return x != y;
}

dt_bool_work dt_square_bool(dt_bool_work x) {
    return x;
}

dt_bool_work dt_abs_bool(dt_bool_work x) {
    return x;
}

dt_bool_work dt_equal_bool(dt_bool_work x, dt_bool_work y) {
    return x == y;
}

dt_bool_work dt_not_equal_bool(dt_bool_work x, dt_bool_work y) {
    return x != y;
}

dt_bool_work dt_greater_bool(dt_bool_work x, dt_bool_work y) {
    return x > y;
}

dt_bool_work dt_greater_equal_bool(dt_bool_work x, dt_bool_work y) {
    return x >= y;
}

dt_bool_work dt_less_bool(dt_bool_work x, dt_bool_work y) {
    return x < y;
}

dt_bool_work dt_less_equal_bool(dt_bool_work x, dt_bool_work y) {
    return x <= y;
}

dt_bool_work dt_logical_and_bool(dt_bool_work x, dt_bool_work y) {
    return x && y;
}

dt_bool_work dt_logical_or_bool(dt_bool_work x, dt_bool_work y) {
    return x || y;
}

dt_bool_work dt_logical_xor_bool(dt_bool_work x, dt_bool_work y) {
    return x != y;
}

dt_bool_work dt_logical_not_bool(dt_bool_work x) {
    return !x;
}

dt_bool_work dt_min_bool(dt_bool_work x, dt_bool_work y) {
    return x && y;
}

dt_bool_work dt_max_bool(dt_bool_work x, dt_bool_work y) {
    return x || y;
}

dt_bool_work dt_mad_bool(dt_bool_work x, dt_bool_work y, dt_bool_work z) {
    return (x && y) || z;
}