# Claude Configs

Streamlined Claude Code configuration files based on [Anthropic's best practices](https://www.anthropic.com/engineering/claude-code-best-practices).

## Design Principles

This configuration follows key recommendations from Anthropic's documentation:

- **Keep it concise**: Under 100 lines total across all files (research shows LLMs reliably follow ~150-200 instructions; Claude Code's system prompt uses ~50)
- **Universal applicability**: Only rules that apply to all sessions
- **Pointers over copies**: Reference external docs rather than embedding
- **No linter's job**: Style enforcement delegated to actual linters
- **Explanations over commands**: "Avoid X because [reason]" instead of "NEVER do X"

## Files

| File | Purpose | Lines |
|------|---------|-------|
| `CLAUDE.md` | Main configuration and workflow rules | ~60 |
| `SECURITY.md` | Security-focused rules | ~30 |
| `SNOWFLAKE.md` | Snowflake database connection patterns | ~60 |

## Installation

### Option 1: Symlink (Recommended)

Keep configs version-controlled while Claude Code uses them:

```bash
# Backup existing config
mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup

# Symlink this repo's files
ln -sf ~/Documents/Github/claude_configs/CLAUDE.md ~/.claude/CLAUDE.md
```

### Option 2: Copy

```bash
cp CLAUDE.md SECURITY.md SNOWFLAKE.md ~/.claude/
```

### Option 3: Install Script

```bash
./install.sh
```

## Customization

### Adding Project-Specific Rules

For project-specific configuration, create a `CLAUDE.md` in the project root:

```markdown
# Project: my-app

## Stack
- Framework: Next.js 14
- Database: PostgreSQL
- Testing: Jest + Playwright

## Commands
- `npm run dev`: Start development server
- `npm test`: Run tests
- `npm run lint`: Run ESLint

## Project-Specific Notes
- API routes are in `src/app/api/`
- Use server actions for mutations
```

### Extending Global Config

Add new files and reference them with `@filename.md` in CLAUDE.md:

```markdown
@SECURITY.md
@SNOWFLAKE.md
@MY_CUSTOM_RULES.md
```

## References

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Claude 4 Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
