# Claude Configs

Streamlined Claude Code configuration based on [Anthropic's best practices](https://www.anthropic.com/engineering/claude-code-best-practices).

## Design Principles

- **Keep it concise**: ~90 lines (research shows LLMs reliably follow ~150-200 instructions; Claude Code's system prompt uses ~50)
- **Universal applicability**: Only rules that apply to all sessions
- **Single file**: No unnecessary indirection or modularization
- **Explanations over commands**: Context for why, not just what

## Installation

```bash
./install.sh
```

Or manually:

```bash
ln -sf ~/Documents/Github/claude_configs/CLAUDE.md ~/.claude/CLAUDE.md
```

## Project-Specific Rules

For project-specific configuration, create a `CLAUDE.md` in the project root:

```markdown
# Project: my-app

## Stack
- Framework: Next.js 14
- Database: PostgreSQL

## Commands
- `npm run dev`: Start development server
- `npm test`: Run tests
```

## References

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Claude 4 Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
