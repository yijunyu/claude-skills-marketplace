# GDB Debugging Skill

Debug compiled programs (Rust, C, C++) using GDB instead of inserting print statements.

## Why Use GDB Instead of Print Statements?

- **No code modification required** - Inspect state without changing source
- **No recompilation cycles** - Add/remove debug output instantly
- **Direct access to runtime state** - Call stack, variables, memory, registers
- **Breakpoints and watchpoints** - Stop at specific locations or when values change

## Prerequisites

1. **GDB installed** (`apt install gdb` or `brew install gdb`)
2. **Program compiled with debug symbols** (`-g` flag)
3. **tmux skill installed** (for interactive GDB sessions)

## Installation

```bash
cp -r . ~/.claude/skills/gdb-debugging/
```

## Triggers

This skill activates when you mention:
- "debug", "diagnose", "find root cause"
- "why does this crash", "segfault", "panic"
- Any debugging-related request for compiled programs

## Example Usage

```
User: Debug this Rust program that panics with "index out of bounds"

Claude: [Invokes gdb-debugging skill]
1. Creates GDB session via tmux
2. Sets breakpoint at rust_panic
3. Runs program and catches the panic
4. Shows backtrace pointing to exact line
5. Inspects variables to identify the bug
```

## Test Examples

Three example Rust programs with intentional bugs are included:

- `examples/off_by_one/` - Array index out of bounds
- `examples/logic_error/` - Wrong comparison operator
- `examples/option_unwrap/` - Unwrap on None

Each has a regression test script (`test_regression.sh`) to verify the bug detection.

## Dependencies

- [tmux skill](https://github.com/anthropics/claude-code-plugins) - Required for interactive GDB sessions
