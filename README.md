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

To install a skill, copy it to your Claude Code skills directory:

```bash
# Create skills directory if it doesn't exist
mkdir -p ~/.claude/skills

# Copy a skill (e.g., gdb-debugging)
cp -r skills/gdb-debugging ~/.claude/skills/
```

## Usage

Once installed, skills are automatically available to Claude Code. The skill will be triggered based on its description - for example, the `gdb-debugging` skill activates when you ask Claude to "debug", "find root cause", or investigate crashes.

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
