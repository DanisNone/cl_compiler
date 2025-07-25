#ifndef __DTYPES_complex128__
#define __DTYPES_complex128__

#include "dtypes/bool.cl"
#include "dtypes/float64.cl"

typedef struct {
    dt_float64 real, imag;
} dt_complex128;

typedef struct {
    dt_float64_work real, imag;
} dt_complex128_work;

dt_complex128 dt_make_complex128(dt_float64 real, dt_float64 imag) {
    dt_complex128 res;
    res.real = real;
    res.imag = imag;
    return res;
}

dt_complex128_work dt_make_complex128_work(dt_float64_work real, dt_float64_work imag) {
    dt_complex128_work res;
    res.real = real;
    res.imag = imag;
    return res;
}

dt_complex128_work dt_rot90_complex128(dt_complex128_work x) {
    dt_complex128_work res;
    res.real = -x.imag;
    res.imag = x.real;
    return res;
}

dt_complex128_work dt_rot270_complex128(dt_complex128_work x) {
    dt_complex128_work res;
    res.real = x.imag;
    res.imag = -x.real;
    return res;
}

dt_complex128_work dt_normalize_input_complex128(dt_complex128 x) {
    return dt_make_complex128_work(
        dt_normalize_input_float64(x.real),
        dt_normalize_input_float64(x.imag)
    );
}

dt_complex128 dt_normalize_output_complex128(dt_complex128_work x) {
    return dt_make_complex128(
        dt_normalize_output_float64(x.real),
        dt_normalize_output_float64(x.imag)
    );
}


dt_complex128_work dt_zero_complex128() { return dt_make_complex128_work(0, 0); }
dt_complex128_work dt_one_complex128() { return dt_make_complex128_work(1, 0); }
dt_complex128_work dt_two_complex128() { return dt_make_complex128_work(2, 0); }

dt_complex128_work dt_add_complex128(dt_complex128_work x, dt_complex128_work y) {
    return dt_make_complex128_work(
        x.real + y.real,
        x.imag + y.imag
    );
}


dt_complex128_work dt_subtract_complex128(dt_complex128_work x, dt_complex128_work y) {
    return dt_make_complex128_work(
        x.real - y.real,
        x.imag - y.imag
    );
}

dt_complex128_work dt_multiply_complex128(dt_complex128_work x, dt_complex128_work y) {
    return dt_make_complex128_work(
        x.real * y.real - x.imag * y.imag,
        x.real * y.imag + x.imag * y.real
    );
}

dt_complex128_work dt_divide_complex128(dt_complex128_work x, dt_complex128_work y) {
    dt_float64 denominator = y.real * y.real + y.imag * y.imag;
    return dt_make_complex128_work(
        (x.real * y.real + x.imag * y.imag) / denominator,
        (x.imag * y.real - x.real * y.imag) / denominator
    );
}

dt_complex128_work dt_square_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        (x.real - x.imag) * (x.real + x.imag),
        2 * x.real * x.imag
    );
}

dt_complex128_work dt_log_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        log(hypot(x.real, x.imag)),
        atan2(x.imag, x.real)
    );
}

dt_complex128_work dt_log2_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        log2(hypot(x.real, x.imag)),
        atan2(x.imag, x.real) / dt_const_log2_float64
    );
}

dt_complex128_work dt_log10_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        log10(hypot(x.real, x.imag)),
        atan2(x.imag, x.real) / dt_const_log10_float64
    );
}

dt_complex128_work dt_exp_complex128(dt_complex128_work x) {
    dt_float64_work exp_ = exp(x.real);
    return dt_make_complex128_work(
        exp_ * cos(x.imag),
        exp_ * sin(x.imag)
    );
}


dt_complex128_work dt_exp2_complex128(dt_complex128_work x) {
    dt_float64_work exp_ = exp2(x.real);
    dt_float64_work angle = x.imag * dt_const_log2_float64;
    
    return dt_make_complex128_work(
        exp_ * cos(angle),
        exp_ * sin(angle)
    );
}

dt_complex128_work dt_exp10_complex128(dt_complex128_work x) {
    dt_float64_work exp_ = exp10(x.real);
    dt_float64_work angle = x.imag * dt_const_log10_float64;
    
    return dt_make_complex128_work(
        exp_ * cos(angle),
        exp_ * sin(angle)
    );
}

dt_complex128_work dt_sqrt_complex128(dt_complex128_work x) {
    dt_float64_work mag = hypot(x.real, x.imag);
    dt_float64_work re = dt_sqrt_float64((mag + x.real) * 0.5);
    dt_float64_work im = dt_sqrt_float64((mag - x.real) * 0.5);
    if (x.imag < 0) im = -im;
    return dt_make_complex128_work(re, im);
}

dt_complex128_work dt_power_complex128(dt_complex128_work x, dt_complex128_work y) {
    return dt_exp_complex128(dt_multiply_complex128(dt_log_complex128(x), y));
}

dt_complex128_work dt_sin_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        sin(x.real) * cosh(x.imag),
        cos(x.real) * sinh(x.imag)
    );
}

dt_complex128_work dt_cos_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        cos(x.real) * cosh(x.imag),
        -sin(x.real) * sinh(x.imag)
    );
}

dt_complex128_work dt_tan_complex128(dt_complex128_work x) {
    dt_float64_work denom = cos(2 * x.real) + cosh(2 * x.imag);
    return dt_make_complex128_work(
        sin(2 * x.real) / denom,
        sinh(2 * x.imag) / denom
    );
}

dt_complex128_work dt_sinh_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        sinh(x.real) * cos(x.imag),
        cosh(x.real) * sin(x.imag)
    );
}

dt_complex128_work dt_cosh_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(
        cosh(x.real) * cos(x.imag),
        sinh(x.real) * sin(x.imag)
    );
}

dt_complex128_work dt_tanh_complex128(dt_complex128_work x) {
    dt_float64_work denom = cosh(2 * x.real) + cos(2 * x.imag);
    return dt_make_complex128_work(
        sinh(2 * x.real) / denom,
        sin(2 * x.imag) / denom
    );
}

dt_complex128_work dt_arcsin_complex128(dt_complex128_work x) {
    return dt_rot270_complex128(
        dt_log_complex128(
            dt_add_complex128(
                dt_rot90_complex128(x),
                dt_sqrt_complex128(
                    dt_subtract_complex128(
                        dt_one_complex128(),
                        dt_square_complex128(x)
                    )
                )
            )
        )
    );
}


dt_complex128_work dt_arccos_complex128(dt_complex128_work x) {
    return dt_rot270_complex128(
        dt_log_complex128(
            dt_add_complex128(
                x,
                dt_rot90_complex128(
                    dt_sqrt_complex128(
                        dt_subtract_complex128(
                            dt_one_complex128(),
                            dt_square_complex128(x)
                        )
                    )
                )
            )
        )
    );
}

dt_complex128_work dt_arctan_complex128(dt_complex128_work x) {
    return dt_rot90_complex128(
        dt_divide_complex128(
            dt_log_complex128(
                dt_divide_complex128(
                    dt_add_complex128(
                        dt_rot90_complex128(dt_one_complex128()),
                        x
                    ),
                    dt_subtract_complex128(
                        dt_rot90_complex128(dt_one_complex128()),
                        x
                    )
                )
            ),
            dt_two_complex128()
        )
    );
}

dt_complex128_work dt_arcsinh_complex128(dt_complex128_work x) {
    return dt_log_complex128(
        dt_add_complex128(
            x,
            dt_sqrt_complex128(
                dt_add_complex128(
                    dt_square_complex128(x),
                    dt_one_complex128()
                )
            )
        )
    );
}

dt_complex128_work dt_arccosh_complex128(dt_complex128_work x) {
    return dt_log_complex128(
        dt_add_complex128(
            x,
            dt_sqrt_complex128(
                dt_subtract_complex128(
                    dt_square_complex128(x),
                    dt_one_complex128()
                )
            )
        )
    );
}

dt_complex128_work dt_arctanh_complex128(dt_complex128_work x) {
    return dt_divide_complex128(
        dt_log_complex128(
            dt_divide_complex128(
                dt_add_complex128(
                    dt_one_complex128(),
                    x
                ),
                dt_subtract_complex128(
                    dt_one_complex128(),
                    x
                )
            )
        ),
        dt_two_complex128()
    );
}

dt_bool_work dt_equal_complex128(dt_complex128_work x, dt_complex128_work y) {
    return x.real == y.real && x.imag == y.imag;
}

dt_bool_work dt_not_equal_complex128(dt_complex128_work x, dt_complex128_work y) {
    return x.real != y.real || x.imag != y.imag;
}

dt_complex128_work dt_negative_complex128(dt_complex128_work x) {
    return dt_make_complex128_work(-x.real, -x.imag);
}

dt_float64_work dt_abs_complex128(dt_complex128_work x) {
    return hypot(x.real, x.imag);
}

#endif