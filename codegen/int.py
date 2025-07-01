from parser import parse, parse_result_type


def generate(bits: int, signed: bool) -> parse_result_type:
    if bits <= 0:
        raise ValueError(f"bits must be positive; {bits=}")
    if bits & (bits - 1):
        raise ValueError(f"bits must be power of two; {bits=}")
    if bits > 64:
        raise ValueError(f"bits must be not greater of 64; {bits=}")

    sign_prefix = "" if signed else "u"
    name = f"{sign_prefix}int{bits}"
    cl_type = (
        sign_prefix +
        {8: "char", 16: "short", 32: "int", 64: "long"}[max(bits, 8)]
    )

    max_int = "0b" + "1" * bits
    max_neg = "0b" + "1" + "0" * (bits - 1)
    kw = dict(
        name=name,
        cl_type=cl_type,
        max_int=max_int,
        max_neg=max_neg,
        signed=str(signed),
        is_subint=str(bits < 8),
        bits=str(bits)
    )
    template = open("./codegen/template/int.src").read()
    return parse(template, **kw)
