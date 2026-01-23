# Claude Configs

Streamlined Claude Code configuration based on [Anthropic's best practices](https://www.anthropic.com/engineering/claude-code-best-practices).

## Design Principles

- **Keep it concise**: LLMs follow fewer instructions more reliably. Front-load the most important rules.
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

## Plugins

This config is designed to work with the following Claude Code plugins:

| Plugin | Source | Purpose |
|--------|--------|---------|
| [superpowers](https://github.com/obra/superpowers) | superpowers-marketplace | TDD, debugging, code review, planning workflows |
| [ralph-wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) | anthropics-claude-code | Iterative development loops with automatic retry until completion |
| context7 | claude-plugins-official | Live documentation lookup - prevents outdated API hallucinations |
| frontend-design | claude-plugins-official | Distinctive UI development, avoiding generic aesthetics |
| pr-review-toolkit | claude-plugins-official | Comprehensive PR review with specialized agents |
| playwright | claude-plugins-official | Browser automation and visual verification |
| github | claude-plugins-official | GitHub integration |
| security-guidance | claude-plugins-official | Security best practices |
| typescript-lsp | claude-plugins-official | TypeScript language server support |

Install marketplace plugins:
```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

/plugin marketplace add anthropics/claude-code
/plugin install ralph-wiggum@anthropics-claude-code
```

Install official plugins:
```bash
/plugin install frontend-design@claude-plugins-official
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install playwright@claude-plugins-official
/plugin install github@claude-plugins-official
/plugin install security-guidance@claude-plugins-official
/plugin install typescript-lsp@claude-plugins-official
```

The CLAUDE.md includes triggers for proactive subagent usage with superpowers skills.

## Custom Agents

This config includes custom agents in `.claude/agents/` that implement an adversarial development workflow and address common failure modes.

### Adversarial Workflow Agents

| Agent | Role | Succeeds By |
|-------|------|-------------|
| `implementer` | Writes code | Meeting requirements, minimal changes, following patterns |
| `tester` | Breaks code | Finding bugs, edge cases, writing failing tests |
| `reviewer` | Final gate | Blocking bad code, enforcing standards |

### Utility Agents

| Agent | Purpose |
|-------|---------|
| `explorer` | Researches codebases autonomously—counters "I would need to look at..." helplessness |
| `doc-verifier` | Verifies API documentation before implementation—prevents hallucinations |
| `test-runner` | Runs tests, analyzes failures, fixes implementations (not tests) |
| `documentation-generator` | Generates docs from actual code (uses Opus model) |
| `debugger` | Systematic debugging with evidence before fixes |
| `security-auditor` | OWASP Top 10 checks, credential scanning, injection detection |

### Installation

Copy the agents directory to your global Claude config:

```bash
cp -r .claude/agents ~/.claude/
```

Or symlink for automatic updates:

```bash
ln -sf ~/Documents/GitHub/claude-configs/.claude/agents ~/.claude/agents
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
