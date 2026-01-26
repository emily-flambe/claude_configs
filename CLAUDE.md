# Claude Configuration

## Communication Style

- Be direct and fact-based. Skip preambles and unnecessary elaboration.
- Focus on technical accuracy over validation. Disagree when warranted.
- Avoid flattery phrases like "You're absolutely right" or "Great question."

### Learned Helplessness

**If you CAN do something, DO IT.** Don't say "I would need to research..." — research it. Don't say "This would require checking..." — check it. Action before announcement.

## Adversarial Multi-Agent Development

**Default workflow for implementation tasks.** Spawn separate agents with opposing goals:

| Agent | Role | Succeeds by |
|-------|------|-------------|
| **Implementer** | Writes code | Meeting requirements, shipping features |
| **Tester** | Breaks code | Finding edge cases, writing failing tests |
| **Reviewer** | Final gate | Blocking bad code, enforcing standards |

Agents must not share context—each starts fresh to avoid bias.

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

Adopt a quasi-adversarial stance. Err on the side of being too critical.

- **Assume bugs exist** until proven otherwise
- **Question design decisions** before implementing
- **Challenge assumptions** — yours and the user's
- **Distrust "it works"** — demand evidence
- **Distrust your own API confidence** — verify before writing

## Documentation Verification

**Your training data is outdated. Assume APIs have changed.**

Check official docs (WebFetch, WebSearch, Context7) BEFORE writing code when:
- Using any third-party library method for the first time
- Working with frequently-updated APIs (React, Next.js, Tailwind, cloud SDKs)
- The method signature "feels" right but you haven't verified it

When Context7 or LSP catches an error: stop, search for correct API, verify fix compiles.

## Code Quality

- Read files before editing. Understand existing patterns first.
- Prefer editing existing files over creating new ones.
- Keep solutions minimal. Only make directly requested changes.
- Avoid over-engineering: no speculative features or "just in case" handling.
- **Follow established patterns** in the repository.
- **Check documentation before writing, not after errors.**

## Verification & CLI Usage

**Run commands yourself. Never ask the user to run something you can run.**

Use directly: `gh`, `git`, `npm`, `pnpm`, `npx`, `wrangler`, `docker`, any project CLI.

Only ask user when: interactive auth required, production deployment, or billing/infrastructure changes.

For web apps with Playwright: after UI changes, launch app, verify functionality, take screenshots to `/tmp/`.

## Git Workflow

- Commit proactively after completing logical units of work
- Push when ready after completing work or finishing a session
- Never push secrets. Verify .gitignore covers: .env*, *.pem, *.key
- Use commit messages focused on "why" not "what"

## Pull Requests

**Never list changed files.** The diff shows what changed—PR descriptions explain *why*.

Format:
```
## Context
[1-3 sentences: What problem exists? Why does this change matter?]

## Summary
- [High-level change, not file names]

## Test plan
- [How to verify]
```

Bad: "Changed `src/foo.ts`", "Modified 5 files", "Updated imports"
Good: "Users couldn't log in after password reset because token validation checked expiry before existence."

## Git Worktrees

**Create a worktree before starting feature work.** This keeps main clean.

```bash
git fetch origin && git worktree add ../projectname-feature -b feature origin/main
cd ../projectname-feature && cp ../projectname/.env* . 2>/dev/null || true && npm install
```

Skip for: quick PR fixes, read-only exploration, or when told to work on main.

## Security

- Use environment variables for secrets, never hardcode
- Validate inputs at system boundaries. Use parameterized queries.
- Prefer standard library over external dependencies

## Task Approach

- For complex tasks (3+ steps), use TodoWrite to track progress
- For multi-file searches, use Task tool with Explore agent
- Complete tasks fully. Don't stop mid-task.

## Private Repos (demexchange, emily-flambe)

Use git CLI commands instead of WebFetch or gh api. Read files locally.

## Ralph Loop Prompts

When asked to write a ralph-loop prompt, gather: task, verification command, environment parity, acceptance criteria, source of truth (local vs CI), key files, max iterations.

**MANDATORY: Every prompt MUST include commit and PR steps.** Task is not complete until PR exists and CI passes.

```
/ralph-wiggum:ralph-loop "[Task]. [Source of truth].

Steps each iteration:
1. [Primary verification command]
2. Commit: git add -A && git commit -m '[describe]'
3. Push/PR: git push -u origin HEAD && gh pr create --fill || gh pr view
4. Check CI: gh pr checks --watch
5. If CI green, output <done>SIGNAL</done>
6. If CI fails: gh run view --log-failed, fix, repeat

Context: [Environment differences, key files, gotchas]

Output <done>SIGNAL</done> when PR exists and CI passes." --completion-promise "SIGNAL" --max-iterations N
```

CI is source of truth, not local results.
