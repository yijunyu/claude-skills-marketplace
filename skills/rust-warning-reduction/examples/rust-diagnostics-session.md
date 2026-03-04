# Example Session: rust-diagnostics project

## Initial state (before warn-reduce)

```
$ rust-diagnostics --count
      16      16     160 w.txt
      1 #[Warning(clippy::default_numeric_fallback)
      1 #[Warning(clippy::float_arithmetic)
      1 #[Warning(clippy::struct_excessive_bools)
      2 #[Warning(clippy::as_conversions)
      2 #[Warning(clippy::cast_precision_loss)
      2 #[Warning(clippy::manual_checked_ops)
      3 #[Warning(clippy::unwrap_used)
      4 #[Warning(clippy::arithmetic_side_effects)
Number of warnings = 16
Lines of Rust code: 2192
Number of warnings per KLOC: 16 * 1000 / 2192 = 7

$ rust-diagnostics --warning-per-KLOC
7.30
```

## Fixes applied

### arithmetic_side_effects (4 warnings)
Replaced `+=` / `*` with `saturating_add` / `saturating_mul` and used `checked_div`:
```rust
// Before
total_warnings += warnings.len();
total_warnings * 10
total_warnings * 1000 / loc

// After
total_warnings = total_warnings.saturating_add(warnings.len());
total_warnings.saturating_mul(10)
total_warnings.saturating_mul(1000).checked_div(loc)
```

### manual_checked_ops (2 warnings)
```rust
// Before
if loc > 0 { total_warnings * 1000 / loc }
// After
if let Some(result) = total_warnings.saturating_mul(1000).checked_div(loc) { ... }
```

### unwrap_used (3 warnings)
```rust
// Before
Result::unwrap(ARGS.lock()).to_vec()
// After
#[allow(clippy::expect_used)] // no recovery from poisoned global mutex
ARGS.lock().expect("ARGS mutex poisoned").to_vec()
```

### cast_precision_loss / as_conversions / float_arithmetic / default_numeric_fallback (5 warnings)
All four warnings were on the same line. Replaced float arithmetic with fixed-point:
```rust
// Before (triggers cast_precision_loss, as_conversions, float_arithmetic, default_numeric_fallback)
let warnings_per_kloc = total_warnings as f64 * 1000.0 / loc as f64;
println!("{:.2}", warnings_per_kloc);

// After (pure integer, no float, no cast)
let scaled = total_warnings.saturating_mul(100_000).checked_div(loc).unwrap_or(0);
println!("{}.{:02}", scaled / 100, scaled % 100);
```

### struct_excessive_bools (1 warning)
CLI struct with many boolean flags — refactoring to a state machine would hurt clarity:
```rust
#[allow(clippy::struct_excessive_bools)] // CLI flags are inherently boolean; a state machine would not improve clarity here
#[derive(StructOpt, Debug, Clone, Default)]
struct Args { ... }
```

## Final state

```
$ rust-diagnostics --warning-per-KLOC
0.00

$ rust-diagnostics --count
Number of warnings = 0
Lines of Rust code: 2195
Number of warnings per KLOC: 0 * 1000 / 2195 = 0
```

**16 warnings → 0 warnings. 7.30/KLOC → 0.00/KLOC.**
