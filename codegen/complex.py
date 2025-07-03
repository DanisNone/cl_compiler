from parser import parse, parse_result_type


def generate(complex_name: str, float_name: str) -> parse_result_type:
    kw = dict(
        name = complex_name,
        floatname = float_name,
    )
    template = open("./codegen/template/complex.src").read()
    return parse(template, **kw)
