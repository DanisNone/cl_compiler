#ifndef __DTYPES_complex64__
#define __DTYPES_complex64__

#include "dtypes/bool.cl"
#include "dtypes/float32.cl"

typedef struct {
    dt_float32 real, imag;
} dt_complex64;

typedef struct {
    dt_float32_work real, imag;
} dt_complex64_work;

dt_complex64 dt_make_complex64(dt_float32 real, dt_float32 imag) {
    dt_complex64 res;
    res.real = real;
    res.imag = imag;
    return res;
}

dt_complex64_work dt_make_complex64_work(dt_float32_work real, dt_float32_work imag) {
    dt_complex64_work res;
    res.real = real;
    res.imag = imag;
    return res;
}


dt_complex64_work dt_normalize_input_complex64(dt_complex64 x) {
    return dt_make_complex64_work(
        dt_normalize_input_float32(x.real),
        dt_normalize_input_float32(x.imag)
    );
}

dt_complex64 dt_normalize_output_complex64(dt_complex64_work x) {
    return dt_make_complex64(
        dt_normalize_output_float32(x.real),
        dt_normalize_output_float32(x.imag)
    );
}

dt_complex64_work dt_zero_complex64() { return dt_make_complex64_work(0, 0); }
dt_complex64_work dt_one_complex64() { return dt_make_complex64_work(1, 0); }

dt_complex64_work dt_add_complex64(dt_complex64_work x, dt_complex64_work y) {
    return dt_make_complex64_work(
        x.real + y.real,
        x.imag + y.imag
    );
}


dt_complex64_work dt_subtract_complex64(dt_complex64_work x, dt_complex64_work y) {
    return dt_make_complex64_work(
        x.real - y.real,
        x.imag - y.imag
    );
}

dt_complex64_work dt_multiply_complex64(dt_complex64_work x, dt_complex64_work y) {
    return dt_make_complex64_work(
        x.real * y.real - x.imag * y.imag,
        x.real * y.imag + x.imag * y.real
    );
}

dt_complex64_work dt_divide_complex64(dt_complex64_work x, dt_complex64_work y) {
    double denominator = y.real * y.real + y.imag * y.imag;
    return dt_make_complex64_work(
        (x.real * y.real + x.imag * y.imag) / denominator,
        (x.imag * y.real - x.real * y.imag) / denominator
    );
}

dt_complex64_work dt_square_complex64(dt_complex64_work x) {
    return dt_make_complex64_work(
        (x.real - x.imag) * (x.real + x.imag),
        2 * x.real * x.imag
    );
}

dt_complex64_work dt_log_complex64(dt_complex64_work x) {
    return dt_make_complex64_work(
        log(hypot(x.real, x.imag)),
        atan2(x.imag, x.real)
    );
}

dt_complex64_work dt_exp_complex64(dt_complex64_work x) {
    dt_float32_work exp_ = exp(x.real);
    return dt_make_complex64_work(
        exp_ * cos(x.imag),
        exp_ * sin(x.imag)
    );
}

dt_complex64_work dt_power_complex64(dt_complex64_work x, dt_complex64_work y) {
    return dt_exp_complex64(dt_multiply_complex64(dt_log_complex64(x), y));
}

dt_bool_work dt_equal_complex64(dt_complex64_work x, dt_complex64_work y) {
    return x.real == y.real && x.imag == y.imag;
}

dt_bool_work dt_not_equal_complex64(dt_complex64_work x, dt_complex64_work y) {
    return x.real != y.real || x.imag != y.imag;
}

dt_complex64_work dt_negative_complex64(dt_complex64_work x) {
    return dt_make_complex64_work(-x.real, -x.imag);
}

dt_float32_work dt_abs_complex64(dt_complex64_work x) {
    return hypot(x.real, x.imag);
}

#endif