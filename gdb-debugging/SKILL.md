---
name: gdb-debugging
description: Use when debugging compiled programs (Rust, C, C++) that crash, produce wrong output, or exhibit unexpected behavior. Triggers on "debug", "diagnose", "find root cause", "why does this crash", "segfault", "panic".
---

# GDB Debugging Skill

## Overview

Debug compiled programs using GDB instead of print statements. This approach is more efficient because:
- No code modification required for debugging
- No recompilation cycles for adding/removing debug output
- Direct access to call stack, variable inspection, and execution control

**Key Principle**: Observe first, change later. GDB lets you inspect program state without modifying code. Only edit source after you've confirmed the root cause.

## When to Use

- Program crashes (segfault, panic, abort)
- Program produces wrong output
- Program hangs or runs indefinitely
- Need to understand execution flow
- Want to trace variable/expression values without adding print statements
- User asks to "debug", "diagnose", or "find root cause"

## Prerequisites

1. **Program compiled with debug symbols** (`-g` flag)
   - For Rust: Add to Cargo.toml or use `RUSTFLAGS="-g" cargo build`
   - For C/C++: Compile with `gcc -g` or `clang -g`

2. **tmux skill available** - GDB runs via tmux for interactive control

## Debugging Workflow

### Step 1: Ensure Debug Symbols

For Rust projects, verify Cargo.toml has debug symbols:
```toml
[profile.dev]
debug = true
```

Then build:
```bash
cargo build
```

### Step 2: Start GDB Session via tmux

First, invoke the tmux skill to get the session management tools:
```
/tmux
```

The tmux skill provides these tools (paths provided when skill is invoked):
- `create-session.sh` - Create new tmux sessions
- `safe-send.sh` - Send commands and wait for output
- `kill-session.sh` - Terminate sessions

Create a GDB session:
```bash
$TMUX_TOOLS/create-session.sh -n gdb-debug --gdb
```

**Critical**: Disable pagination (GDB will pause waiting for input otherwise):
```bash
$TMUX_TOOLS/safe-send.sh -s gdb-debug -c "set pagination off" -w "(gdb)"
```

Load the binary:
```bash
$TMUX_TOOLS/safe-send.sh -s gdb-debug -c "file target/debug/program_name" -w "(gdb)"
```

> **Note**: `$TMUX_TOOLS` represents the path to tmux tools, which is provided when you invoke the `/tmux` skill. Typically: `~/.claude/plugins/cache/alberto-marketplace/tmux/VERSION/tools`

### Step 3: Debug Based on Problem Type

#### Pattern A: Crash Investigation
When program crashes (segfault, panic, etc.):

1. For Rust programs, set a panic breakpoint first:
   ```bash
   safe-send.sh -s gdb-debug -c "break rust_panic" -w "(gdb)"
   ```

2. Run the program under GDB:
   ```bash
   safe-send.sh -s gdb-debug -c "run" -w "(gdb)"
   ```

3. When it crashes/panics, get backtrace:
   ```bash
   safe-send.sh -s gdb-debug -c "bt" -w "(gdb)"
   ```

4. Inspect the crash frame:
   ```bash
   safe-send.sh -s gdb-debug -c "frame 0" -w "(gdb)"
   safe-send.sh -s gdb-debug -c "info locals" -w "(gdb)"
   ```

5. Navigate up the stack if needed:
   ```bash
   safe-send.sh -s gdb-debug -c "up" -w "(gdb)"
   safe-send.sh -s gdb-debug -c "info locals" -w "(gdb)"
   ```

#### Pattern B: Wrong Output Investigation
When program runs but produces wrong result:

1. Set breakpoint at suspicious function:
   ```bash
   safe-send.sh -s gdb-debug -c "break function_name" -w "(gdb)"
   # or at specific line:
   safe-send.sh -s gdb-debug -c "break src/main.rs:15" -w "(gdb)"
   ```

2. Run to breakpoint:
   ```bash
   safe-send.sh -s gdb-debug -c "run" -w "(gdb)"
   ```

3. Step through and inspect:
   ```bash
   safe-send.sh -s gdb-debug -c "next" -w "(gdb)"      # step over
   safe-send.sh -s gdb-debug -c "print var_name" -w "(gdb)"  # inspect
   safe-send.sh -s gdb-debug -c "step" -w "(gdb)"      # step into
   ```

4. Continue to next breakpoint:
   ```bash
   safe-send.sh -s gdb-debug -c "continue" -w "(gdb)"
   ```

#### Pattern C: Binary Search Narrowing
When unsure where the bug is:

1. Start broad:
   ```bash
   safe-send.sh -s gdb-debug -c "break main" -w "(gdb)"
   safe-send.sh -s gdb-debug -c "run" -w "(gdb)"
   ```

2. Verify program starts correctly, then narrow:
   ```bash
   safe-send.sh -s gdb-debug -c "delete breakpoints" -w "(gdb)"
   safe-send.sh -s gdb-debug -c "break suspected_function" -w "(gdb)"
   safe-send.sh -s gdb-debug -c "run" -w "(gdb)"
   ```

3. Repeat until root cause found

#### Pattern D: Value Tracing Without Code Changes
When you need to observe how values change during execution—without inserting debug print statements and recompiling:

This is useful when:
- You want to understand how a variable evolves through a loop or algorithm
- You need to trace an expression's value at specific points
- You want to log values without modifying source code
- You're exploring unfamiliar code to understand its behavior

1. Set a breakpoint where you want to observe values:
   ```bash
   safe-send.sh -s gdb-debug -c "break process_data" -w "(gdb)"
   # or at a specific line inside a loop:
   safe-send.sh -s gdb-debug -c "break src/algorithm.rs:42" -w "(gdb)"
   ```

2. Add commands to automatically print values when the breakpoint hits:
   ```bash
   # Print a variable each time breakpoint is hit
   safe-send.sh -s gdb-debug -c "commands" -w ">"
   safe-send.sh -s gdb-debug -c "silent" -w ">"
   safe-send.sh -s gdb-debug -c "print iteration" -w ">"
   safe-send.sh -s gdb-debug -c "print current_sum" -w ">"
   safe-send.sh -s gdb-debug -c "print buffer[i]" -w ">"
   safe-send.sh -s gdb-debug -c "continue" -w ">"
   safe-send.sh -s gdb-debug -c "end" -w "(gdb)"
   ```

3. Run the program—values are printed automatically:
   ```bash
   safe-send.sh -s gdb-debug -c "run" -w "(gdb)"
   # Output shows traced values at each breakpoint hit:
   # $1 = 0
   # $2 = 0
   # $3 = 10
   # $4 = 1
   # $5 = 10
   # $6 = 25
   # ... continues for each iteration
   ```

4. For conditional tracing (only print when condition is met):
   ```bash
   safe-send.sh -s gdb-debug -c "break src/main.rs:50 if count > 100" -w "(gdb)"
   safe-send.sh -s gdb-debug -c "commands" -w ">"
   safe-send.sh -s gdb-debug -c "print count" -w ">"
   safe-send.sh -s gdb-debug -c "print state" -w ">"
   safe-send.sh -s gdb-debug -c "continue" -w ">"
   safe-send.sh -s gdb-debug -c "end" -w "(gdb)"
   ```

5. To trace expressions (not just variables):
   ```bash
   safe-send.sh -s gdb-debug -c "commands" -w ">"
   safe-send.sh -s gdb-debug -c "print left + right" -w ">"
   safe-send.sh -s gdb-debug -c "print arr[i] * factor" -w ">"
   safe-send.sh -s gdb-debug -c "print node->next != NULL" -w ">"
   safe-send.sh -s gdb-debug -c "continue" -w ">"
   safe-send.sh -s gdb-debug -c "end" -w "(gdb)"
   ```

**Key advantage**: No source code changes, no recompilation. Just set breakpoints, attach print commands, and run. When done, simply delete the breakpoints—no cleanup of debug statements needed.

### Step 4: Verify Fix

After identifying and fixing the bug:

1. Rebuild:
   ```bash
   cargo build
   ```

2. Reload in GDB:
   ```bash
   safe-send.sh -s gdb-debug -c "file target/debug/program_name" -w "(gdb)"
   ```

3. Run again to verify:
   ```bash
   safe-send.sh -s gdb-debug -c "run" -w "(gdb)"
   ```

### Step 5: Cleanup

End the GDB session:
```bash
$TMUX_TOOLS/safe-send.sh -s gdb-debug -c "quit" -w ""
$TMUX_TOOLS/safe-send.sh -s gdb-debug -c "y" -w ""
$TMUX_TOOLS/kill-session.sh -s gdb-debug
```

## GDB Command Quick Reference

| Task | GDB Command |
|------|-------------|
| **Breakpoints** | |
| Set at function | `break function_name` |
| Set at line | `break file.rs:42` |
| Set conditional | `break func if x > 10` |
| List breakpoints | `info breakpoints` |
| Delete all | `delete breakpoints` |
| Delete specific | `delete 1` |
| **Execution** | |
| Run program | `run [args]` |
| Continue | `continue` or `c` |
| Step over | `next` or `n` |
| Step into | `step` or `s` |
| Step out | `finish` |
| **Inspection** | |
| Print variable | `print var` or `p var` |
| Print expression | `print a + b` |
| Print array | `print *arr@len` |
| Show locals | `info locals` |
| Show arguments | `info args` |
| Show registers | `info registers` |
| **Stack** | |
| Backtrace | `bt` or `backtrace` |
| Go up | `up` |
| Go down | `down` |
| Select frame | `frame N` |
| **Source** | |
| List source | `list` |
| List function | `list function_name` |
| **Tracing** | |
| Attach commands to breakpoint | `commands` then enter commands, then `end` |
| Silent breakpoint (no stop msg) | `silent` (inside commands block) |
| Auto-continue after print | `continue` (inside commands block) |
| **Session** | |
| Quit | `quit` then `y` |

## Rust-Specific Tips

### Catching Rust Panics
Rust panics exit gracefully, so GDB won't stop at the crash by default. Set a breakpoint at the panic handler:
```bash
$TMUX_TOOLS/safe-send.sh -s gdb-debug -c "break rust_panic" -w "(gdb)"
```

This will stop execution at the panic, allowing you to examine the backtrace.

### Printing Rust Types
- Rust strings: `print str_var` (GDB understands Rust types)
- Vec contents: `print vec.buf.ptr.pointer.pointer[0]@vec.len`
- Option: Check discriminant to see if Some or None

### Common Rust Panics to Debug
- `index out of bounds` - Use backtrace to find array access
- `called Option::unwrap() on None` - Inspect Option value before unwrap
- `assertion failed` - Check values involved in assertion

### Debugging Release Builds
For release builds, add debug info:
```toml
[profile.release]
debug = true
```

## Example Debug Session

Debugging an off-by-one error:

```bash
# First invoke /tmux to get $TMUX_TOOLS path

# Start session
$TMUX_TOOLS/create-session.sh -n debug --gdb
$TMUX_TOOLS/safe-send.sh -s debug -c "set pagination off" -w "(gdb)"
$TMUX_TOOLS/safe-send.sh -s debug -c "file target/debug/off_by_one" -w "(gdb)"

# Run and see it crash
$TMUX_TOOLS/safe-send.sh -s debug -c "run" -w "(gdb)"
# Output shows panic at index out of bounds

# Get backtrace
$TMUX_TOOLS/safe-send.sh -s debug -c "bt" -w "(gdb)"
# Shows crash in sum_array at line 5

# Set breakpoint before crash
$TMUX_TOOLS/safe-send.sh -s debug -c "break src/main.rs:4" -w "(gdb)"
$TMUX_TOOLS/safe-send.sh -s debug -c "run" -w "(gdb)"

# Step through loop iterations
$TMUX_TOOLS/safe-send.sh -s debug -c "print i" -w "(gdb)"      # i = 0
$TMUX_TOOLS/safe-send.sh -s debug -c "print arr.length" -w "(gdb)"  # length = 5
$TMUX_TOOLS/safe-send.sh -s debug -c "continue" -w "(gdb)"
# ... continue until i = 5, realize 0..=5 includes 5 (out of bounds)
```

## Example Value Tracing Session

Tracing a running sum computation to understand how values evolve—without adding print statements to the code:

```rust
// src/main.rs - we want to trace this without modifying it
fn compute_weighted_sum(values: &[i32], weights: &[i32]) -> i32 {
    let mut sum = 0;
    for i in 0..values.len() {
        let term = values[i] * weights[i];  // line 5
        sum += term;                         // line 6
    }
    sum
}

fn main() {
    let values = vec![10, 20, 30, 40, 50];
    let weights = vec![1, 2, 3, 4, 5];
    let result = compute_weighted_sum(&values, &weights);
    println!("Result: {}", result);
}
```

Instead of adding `println!("i={}, term={}, sum={}", i, term, sum);` and recompiling, use GDB tracing:

```bash
# First invoke /tmux to get $TMUX_TOOLS path

# Start session
$TMUX_TOOLS/create-session.sh -n trace --gdb
$TMUX_TOOLS/safe-send.sh -s trace -c "set pagination off" -w "(gdb)"
$TMUX_TOOLS/safe-send.sh -s trace -c "file target/debug/weighted_sum" -w "(gdb)"

# Set breakpoint inside the loop (after term is computed)
$TMUX_TOOLS/safe-send.sh -s trace -c "break src/main.rs:6" -w "(gdb)"

# Attach tracing commands to the breakpoint
$TMUX_TOOLS/safe-send.sh -s trace -c "commands" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "silent" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "printf \"iteration %d: values[i]=%d, weights[i]=%d, term=%d, sum=%d\\n\", i, values[i], weights[i], term, sum" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "continue" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "end" -w "(gdb)"

# Run - values are traced automatically
$TMUX_TOOLS/safe-send.sh -s trace -c "run" -w "(gdb)"
# Output:
# iteration 0: values[i]=10, weights[i]=1, term=10, sum=0
# iteration 1: values[i]=20, weights[i]=2, term=40, sum=10
# iteration 2: values[i]=30, weights[i]=3, term=90, sum=50
# iteration 3: values[i]=40, weights[i]=4, term=160, sum=140
# iteration 4: values[i]=50, weights[i]=5, term=250, sum=300
# Result: 550

# Now trace only when sum exceeds a threshold
$TMUX_TOOLS/safe-send.sh -s trace -c "delete breakpoints" -w "(gdb)"
$TMUX_TOOLS/safe-send.sh -s trace -c "break src/main.rs:6 if sum > 100" -w "(gdb)"
$TMUX_TOOLS/safe-send.sh -s trace -c "commands" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "silent" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "printf \"sum exceeded 100: i=%d, sum=%d, adding term=%d\\n\", i, sum, term" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "continue" -w ">"
$TMUX_TOOLS/safe-send.sh -s trace -c "end" -w "(gdb)"

$TMUX_TOOLS/safe-send.sh -s trace -c "run" -w "(gdb)"
# Output (only iterations where sum > 100):
# sum exceeded 100: i=3, sum=140, adding term=160
# sum exceeded 100: i=4, sum=300, adding term=250
# Result: 550

# Cleanup
$TMUX_TOOLS/safe-send.sh -s trace -c "quit" -w ""
$TMUX_TOOLS/safe-send.sh -s trace -c "y" -w ""
$TMUX_TOOLS/kill-session.sh -s trace
```

**Key benefits demonstrated**:
- No `println!` added to source code
- No recompilation needed
- Conditional tracing filters output to relevant iterations
- Easy to adjust what's traced by just changing breakpoint commands
- Clean removal—just delete breakpoints, no code cleanup

## Test Examples

Example buggy programs are provided in:
- `~/.claude/skills/gdb-debugging/examples/off_by_one/` - Array bounds error
- `~/.claude/skills/gdb-debugging/examples/logic_error/` - Wrong comparison
- `~/.claude/skills/gdb-debugging/examples/option_unwrap/` - None unwrap panic

Each has a `test_regression.sh` to verify the bug and fix.
