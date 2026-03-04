# rust-warning-reduction

A Claude Code skill that implements the Li et al. ([arxiv:2310.11738](https://arxiv.org/abs/2310.11738)) methodology for iteratively reducing Clippy warning density in Rust projects.

## Overview

Warnings in Rust projects follow a Pareto distribution: the top-5 lint types typically account for >80% of all warnings. This skill targets high-frequency lints first, using the paper's three fix strategies, until warning density falls below 18/KLOC (the crates-io average is 21/KLOC).

## Two Phases

### `warn-identify`
Runs `rust-diagnostics --count` and `--warning-per-KLOC` to produce a ranked table:
```
Rank  Count  Cumul%  Type                      Fixable?
   1    NNN    56%   default_numeric_fallback    [auto]
   2    NNN    76%   arithmetic_side_effects
   ...
Density: X.XX/KLOC  [TARGET: ≤18/KLOC]
```

### `warn-reduce`
Iteratively eliminates the top warning type per pass using the paper's strategies:

| Warning Type | Strategy | Paper Result |
|---|---|---|
| `default_numeric_fallback` | `cargo clippy --fix` / type suffixes | 3,842 → 0 |
| `arithmetic_side_effects` | `wrapping_add/sub/div` rewrites | 1,919 → 682 |
| `undocumented_unsafe_blocks` | Insert `// SAFETY:` comments | 806 → 5 |
| `missing_debug_implementations` | Add `#[derive(Debug)]` | 160 → 8 |
| Others | `--fix`, suggestion application, or targeted `#[allow]` | varies |

At 18/KLOC the skill pauses and asks whether to continue with long-tail removals.

## Prerequisites

- [`rust-diagnostics`](https://github.com/yijunyu/rust-diagnostics) installed and on `PATH`
- A Rust project with `Cargo.toml`

## Installation

```bash
cp -r skills/rust-warning-reduction ~/.claude/skills/
```

## Trigger Phrases

The skill activates automatically when you say things like:
- "identify high-frequency warnings"
- "reduce clippy warnings"
- "what is the warning density?"
- "run warn-identify / warn-reduce"
- "apply Li et al. 2310.11738 methodology"

## Reference

Li, C. et al. "Unleashing the Power of Clippy in Real-World Rust Projects." arXiv:2310.11738, 2023.
