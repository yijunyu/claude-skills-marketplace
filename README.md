# Claude Skills Marketplace

A collection of skills (plugins) for Claude Code that extend its capabilities with specialized workflows and domain expertise.

## What are Skills?

Skills are reusable prompts and workflows that teach Claude Code how to perform specific tasks more effectively. They can include:

- Step-by-step workflows for complex tasks
- Domain-specific knowledge and best practices
- Integration with external tools (debuggers, REPLs, etc.)
- Code patterns and templates

## Available Skills

| Skill | Description | Status |
|-------|-------------|--------|
| [gdb-debugging](skills/gdb-debugging/) | Debug compiled programs (Rust, C, C++) using GDB instead of print statements | Stable |
| [rust-warning-reduction](skills/rust-warning-reduction/) | Identify and iteratively eliminate high-frequency Clippy warnings using the Li et al. (arXiv:2310.11738) methodology; stops at 18/KLOC and asks whether to continue | Stable |

## Installation

### Via Claude Code plugin system (recommended)

Add this marketplace, then install any skill with a single command:

```
/plugin install rust-warning-reduction@claude-skills-marketplace
/plugin install gdb-debugging@claude-skills-marketplace
```

Or browse and install interactively:

```
/plugin > Discover
```

To register this marketplace with Claude Code:

```
/plugin add-marketplace https://github.com/yijunyu/claude-skills-marketplace
```

### Manual installation

```bash
git clone https://github.com/yijunyu/claude-skills-marketplace /tmp/claude-skills-marketplace
mkdir -p ~/.claude/skills

# Install a specific skill
cp -r /tmp/claude-skills-marketplace/skills/rust-warning-reduction ~/.claude/skills/
cp -r /tmp/claude-skills-marketplace/skills/gdb-debugging ~/.claude/skills/
```

## Usage

Once installed, skills activate automatically based on your request:

| Skill | Trigger phrases |
|---|---|
| `rust-warning-reduction` | "identify high-frequency warnings", "reduce clippy warnings", "warning density", "warn-identify", "warn-reduce" |
| `gdb-debugging` | "debug", "diagnose", "find root cause", "why does this crash", "segfault", "panic" |

## Contributing

To add a new skill:

1. Create a directory under `skills/` with your skill name
2. Add a `SKILL.md` file with the skill definition (see existing skills for format)
3. Include any supporting files (examples, templates, etc.)
4. Submit a pull request

### Skill File Format

```markdown
---
name: skill-name
description: When to trigger this skill (used for automatic activation)
---

# Skill Title

## Overview
Brief description of what the skill does.

## When to Use
List of scenarios where this skill is helpful.

## Workflow
Step-by-step instructions for Claude to follow.
```

## License

MIT
