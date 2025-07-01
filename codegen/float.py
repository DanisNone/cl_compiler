from parser import parse, parse_result_type


def generate(float_name: str) -> parse_result_type:
    kw = dict(
        name=float_name,
        define=open(f"./codegen/template/{float_name}.src").read()
    )
    template = open("./codegen/template/float.src").read()
    return parse(template, **kw)
