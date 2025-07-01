from pathlib import Path
import re
import bool as gen_bool
import int as gen_int
import float as gen_float


def get_dtype(line: str) -> str:
    assert line.startswith("dt_")
    assert line.endswith("_work")
    return line.lstrip("dt_").strip("_work")


def update_funcs(all_funcs: dict[str, list[str]], new_funcs: dict[str, list[str]]):
    for name, funcs in new_funcs.items():
        if name not in all_funcs:
            all_funcs[name] = []
        all_funcs[name].extend(funcs)
    
dtypes: list[str] = []
path = Path("./cl_compiler/dtypes")
all_funcs: dict[str, list[str]] = {}

dtypes.append("bool")
with open(path / "bool.cl", "w") as out:
    source, funcs = gen_bool.generate()
    out.write(source)
    update_funcs(all_funcs, funcs)

for bits in (2, 4, 8, 16, 32, 64):
    for signed in (False, True):
        name = ("" if signed else "u") + f"int{bits}"
        dtypes.append(name)
        name += ".cl"
        save_path = path / name

        source, funcs = gen_int.generate(bits, signed)
        with open(save_path, "w") as out:
            out.write(source)
        update_funcs(all_funcs, funcs)

for float_name in ("float8_e3m4", "bfloat16", "float16", "float32", "float64"):
    dtypes.append(float_name)
    save_path = path / (float_name + ".cl")

    source, funcs = gen_float.generate(float_name)
    with open(save_path, "w") as out:
        out.write(source)
    update_funcs(all_funcs, funcs)

funcs_signature: list[tuple[str, str, str, tuple[str, ...]]] = []
for op_name in all_funcs:
    for func_line in all_funcs[op_name]:
        func_match = re.match(r'^\s*(\w+)\s+(\w+)\s*\((.*?)\)\s*$', func_line)
        assert func_match is not None, repr(func_line)

        ret_type = func_match.group(1)
        func_name = func_match.group(2)
        inputs = func_match.group(3).split(",")
        inputs = [inp.strip() for inp in inputs]

        res = re.fullmatch(r'^dt_[a-zA-Z0-9_]+_work$', ret_type)
        assert res, (func_line, ret_type)

        for i, input in enumerate(inputs):
            assert len(input.split(" ")) == 2
            inputs[i] = get_dtype(input.split(" ")[0])

        funcs_signature.append((op_name, func_name, get_dtype(ret_type), tuple(inputs)))

with open(path / "cl_funcs.info", "w") as file:
    for func in funcs_signature:
        print(*func[:3], *func[3], file=file)
