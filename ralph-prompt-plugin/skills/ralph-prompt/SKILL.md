---
name: ralph-prompt
description: Generate a ralph-wiggum loop prompt for iterative development tasks. Use when asked to create a ralph-loop prompt, or when a task needs iterative execution until CI/tests pass.
---

# Ralph Prompt Generator

Generate well-structured `/ralph-wiggum:ralph-loop` prompts for iterative development tasks.

## When to Use

- User asks to "write a ralph-loop prompt"
- User wants to iterate until tests/CI pass
- User needs automated retry loops for development tasks

## Required Information

Gather this before generating (ask if not provided):

| Field | Question |
|-------|----------|
| Task | What needs to be done? |
| Verification | What command proves success? (e.g., `npm run test:e2e`) |
| Environment parity | Does local match CI/prod? If not, how to run both? |
| Acceptance criteria | What MUST be true? (e.g., "GitHub Actions check is green") |
| Source of truth | Local output or CI? (usually CI) |
| Key files | Where will fixes likely happen? |
| Max iterations | Safety limit (default: 25) |

## Output Format

**CRITICAL: Output must start directly with the command.** No markdown headers, no code blocks, no explanation before the command. User will paste directly into Claude Code.

Example output format:
```
/ralph-wiggum:ralph-loop "Fix all failing tests. GitHub CI is the source of truth.

Steps each iteration:
1. Run: npm test
2. If tests pass, push and check CI: gh pr checks
3. If CI green, output <done>COMPLETE</done>
4. If fail, analyze errors and fix

CRITICAL: Branch is only fixed when GitHub Actions shows green.

Output <done>COMPLETE</done> when CI passes." --completion-promise "COMPLETE" --max-iterations 25
```

## Prompt Structure

```
/ralph-wiggum:ralph-loop "[Task summary]. [Source of truth statement].

Steps each iteration:
1. [Primary verification command]
2. [Secondary verification if environments differ]
3. [Push/commit if applicable]
4. [Check CI/prod status]
5. If [success condition], output <done>SIGNAL</done>
6. If fail, [how to get error details]
7. Fix based on [which output to trust]

Context:
- [Environment differences]
- [Key files]
- [Tech stack notes]

CRITICAL: [Most important acceptance criterion]

Output <done>SIGNAL</done> when [specific conditions].

If stuck after N attempts on same error, [escape behavior]." --completion-promise "SIGNAL" --max-iterations N
```

## Common Failure Mode

Local tests pass but CI fails. Always:
1. Identify how CI runs differently (env vars, flags, database)
2. Include CI verification: `gh pr checks | grep 'Test Name'`
3. Make CI the source of truth
4. Include `gh run view --log-failed` for debugging CI failures

## Process

1. Read user's task description
2. Check if all required fields are provided
3. If missing info, ask specific clarifying questions
4. Once complete, output the prompt starting with `/ralph-wiggum:ralph-loop`
5. Do NOT wrap in code blocks or add markdown - raw command only
