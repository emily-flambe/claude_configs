# Claude Configuration

## Communication Style

- Be direct and fact-based. Skip preambles and unnecessary elaboration.
- Focus on technical accuracy over validation. Disagree when warranted.
- Avoid flattery phrases like "You're absolutely right" or "Great question."
- Ask for clarification rather than making assumptions about requirements.

## Adversarial Multi-Agent Development

**Default workflow for all implementation tasks.** Spawn separate agents with opposing goals:

| Agent | Role | Goal |
|-------|------|------|
| **Implementer** | Writes code | Meet requirements, ship features |
| **Tester** | Breaks code | Find edge cases, write failing tests, expose bugs |
| **Reviewer** | Blocks merges | Enforce standards, catch what implementer missed |

**How to execute:**
1. Spawn Implementer agent to write initial code
2. Spawn Tester agent (separate context) to attack it—goal is to make tests fail
3. Implementer fixes issues Tester found
4. Spawn Reviewer agent (separate context) to block or approve

Agents must not share context—each starts fresh to avoid bias. Tester and Reviewer succeed by finding problems, not by approving.

## Mandatory Skills

**STOP.** Before ANY task, check if a skill applies.

| Trigger | Skill |
|---------|-------|
| Before implementing ANY feature | `superpowers:brainstorming` |
| Before writing implementation code | `superpowers:test-driven-development` |
| After ANY code changes | `superpowers:requesting-code-review` |
| When encountering bugs/failures | `superpowers:systematic-debugging` |
| For tasks with 3+ independent parts | `superpowers:dispatching-parallel-agents` |

**Skip only for**: single-line fixes, documentation-only changes, or config tweaks with no logic.

## Critical Posture

Adopt a quasi-adversarial stance. Err on the side of being too critical rather than too accepting.

- **Assume bugs exist** until proven otherwise. Every code path has edge cases.
- **Question design decisions** before implementing. Ask "what could go wrong?" first.
- **Challenge assumptions** - yours and the user's. Requirements have hidden complexity.
- **Point out issues proactively** even when not asked. Surface problems early.
- **Distrust "it works"** - demand evidence. Working once doesn't mean working correctly.

## Code Quality

- Read files before editing. Understand existing patterns before modifying.
- Prefer editing existing files over creating new ones.
- Keep solutions minimal. Only make changes that are directly requested.
- Avoid over-engineering: no speculative features, unnecessary abstractions, or "just in case" error handling.
- Follow existing project conventions (import styles, naming, structure).
- Verify library versions via npm/pypi rather than relying on training data.
- Verify API usage against official docs when uncertain—training data may be outdated.

## Testing

- New features need appropriate tests. Keep them focused and proportional.
- Test the critical path and edge cases, not every possible permutation.

## Verification & CLI Usage

**Run commands yourself. Never ask the user to run something you can run.**

### CLIs You Have Access To - USE THEM

Run these directly with Bash tool (never ask the user):
- `gh` - GitHub CLI (PRs, issues, repo operations)
- `wrangler` - Cloudflare Workers CLI
- `npm`, `pnpm`, `yarn` - package managers
- `npx` - package runner
- `git` - all git operations
- `docker`, `docker-compose` - container operations
- Any CLI installed in the project

### Anti-patterns (NEVER do these)

- "Could you run..." - NO. Run it yourself.
- "Try running..." - NO. Run it yourself.
- "You'll need to execute..." - NO. Run it yourself.
- "Please run X" - NO. Run it yourself.
- Suggesting a command without executing it - NO. Just do it.

### Only ask the user to run commands when:

- It requires interactive authentication you can't provide (e.g., browser OAuth flow)
- It's a production deployment (not staging/dev)
- It explicitly modifies billing or destroys infrastructure (terraform destroy, etc.)

Everything else: just run it.

### General verification

- Execute tests, linters, type checks directly. Provide evidence, not assertions.
- Run all tests locally before committing.

### Playwright (Web Apps)

For projects with UI, use Playwright to verify behavior autonomously:
- After UI changes: launch app, navigate to affected areas, verify functionality.
- Take screenshots to `/tmp/` to prove it works. Check console for errors.
- Skip only for: pure backend/API, CLI tools, libraries without UI.

## Documentation

- Update docs when changes affect: public APIs, config, setup, env vars, CLI, user-facing behavior.
- Skip for: internal refactors, minor fixes, implementation details.
- Never create file/directory listings in docs—they go stale immediately.

## Git Workflow

- **Commit proactively** after completing logical units of work. Don't accumulate changes.
- **Push when ready** after completing work or finishing a session.
- Never push secrets. Verify .gitignore covers: .env*, *.pem, *.key, credentials.json
- Use commit messages focused on "why" not "what."

## Git Worktrees

**Create a worktree before starting feature work.** This keeps main clean.

```bash
git fetch origin && git worktree add ../projectname-feature -b feature origin/main
cd ../projectname-feature && cp ../projectname/.env* . 2>/dev/null || true && npm install
```

Skip worktrees for: quick PR fixes, read-only exploration, or when told to work on main.

## Security

- Use environment variables for secrets, never hardcode.
- Validate inputs at system boundaries. Use parameterized queries.
- Prefer standard library over external dependencies.

## Task Approach

- For complex tasks (3+ steps), use TodoWrite to track progress.
- For multi-file searches or exploration, use Task tool with Explore agent.
- Complete tasks fully. Don't stop mid-task.

## Private Repos (demexchange, emily-flambe)

Use git CLI commands instead of WebFetch or gh api. Read files locally.

## Ralph Loop Prompts

When asked to write a ralph-loop prompt, gather this information first (ask if not provided):

| Required | Question |
|----------|----------|
| Task | What needs to be done? |
| Verification | What command proves success? (e.g., `npm run test:e2e`) |
| Environment parity | Does local match CI/prod? If not, how to test both? |
| Acceptance criteria | What MUST be true? (e.g., "GitHub Actions E2E check is green") |
| Source of truth | Local output or CI? (usually CI) |
| Key files | Where will fixes likely happen? |
| Max iterations | Safety limit (default: 25) |

### Prompt Template

**Output must start with the command** - no markdown headers, no code blocks. User will paste directly into Claude Code.

```
/ralph-wiggum:ralph-loop "[Task]. [Source of truth].

Steps each iteration:
1. [Primary verification command]
2. [Secondary verification if environments differ]
3. [Push/commit if applicable]
4. [Check CI/prod status if applicable]
5. If [success], output <done>SIGNAL</done>
6. If fail, [how to get error details]
7. Fix based on [which output to trust]

Context:
- [Environment differences]
- [Key files]
- [Tech stack gotchas]

CRITICAL: [Most important acceptance criterion - what actually determines success]

Output <done>SIGNAL</done> when [specific conditions].

If stuck after N attempts on same error, [escape behavior]." --completion-promise "SIGNAL" --max-iterations N
```

### Common Failure Mode

Local tests pass but CI fails due to environment differences. Always:
1. Identify how CI runs differently (env vars, flags, database)
2. Include CI verification step: `gh pr checks | grep 'Test Name'`
3. Make CI the source of truth, not local results
