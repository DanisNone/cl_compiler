from typing import Callable, Iterator, TypeAlias

_c1: TypeAlias = Callable[[bool], bool]
_c2: TypeAlias = Callable[[bool, bool], bool]


def parse_if(line: str) -> int:
    ops = line.strip().split()
    skeep_count = int(ops[0])
    ops = ops[1:]
    functions: dict[str, tuple[_c1 | _c2, int]] = {
        "NOT": (lambda x: not x, 1),
        "AND": (lambda x, y: x and y, 2),
        "OR": (lambda x, y: x or y, 2)
    }

    unk = set(ops) - {"True", "False"} - set(functions.keys())
    assert len(unk) == 0, unk
    instructions: list[tuple[_c1 | _c2, int]] = []
    data: list[bool] = []
    for op in ops:
        if op in functions:
            if data:
                raise ValueError(f"Invalid line; {line=}")
            instructions.append(functions[op])
        else:
            data.append({"True": True, "False": False}[op])

    stack = data[::-1]
    while instructions:
        inst, nin = instructions.pop()
        if len(stack) < nin:
            raise ValueError(f"invalid line; {line=}")
        input = [stack.pop() for _ in range(nin)]
        stack.append(inst(*input))
    if len(stack) != 1:
        raise ValueError(f"invalid line; {line=}")
    if stack[0]:
        return 0
    return skeep_count


def parse_line(data: Iterator[str]) -> tuple[str | None, str | None] | None:
    line = next(data, None)
    if line is None:
        return None
    if line.startswith("!IF"):
        skeep = parse_if(line[3:])
        for _ in range(skeep):
            next(data, None)
        return (None, None)
    if line.startswith("!ADDFUNC"):
        func_name = line.lstrip("!ADDFUNC").strip()
        line = next(data, None)
        if line is None:
            raise ValueError("fail function add: EOF")
        return (line, func_name)
    return (line, None)


parse_result_type: TypeAlias = tuple[str, dict[str, list[str]]]


def parse(source: str, **kw: str) -> parse_result_type:
    for s1, s2 in kw.items():
        source = source.replace(
            f"${s1}$",
            s2
        )
    funcs: dict[str, list[str]] = {}
    lines: list[str] = []

    source_iter = iter(source.splitlines())
    while True:
        res = parse_line(source_iter)
        if res is None:
            break
        line, func_name = res
        if line is None:
            continue
        if func_name is not None:
            if func_name not in funcs:
                funcs[func_name] = []
            funcs[func_name].append(line.rstrip("{ "))
        lines.append(line)
    return ("\n".join(lines), funcs)
