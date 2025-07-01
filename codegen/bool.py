from parser import parse, parse_result_type


def generate() -> parse_result_type:
    return parse(open("./codegen/template/bool.src").read())
