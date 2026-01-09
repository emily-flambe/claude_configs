# Claude Configuration

## Communication Style

- Be direct and fact-based. Skip preambles and unnecessary elaboration.
- Focus on technical accuracy over validation. Disagree when warranted.
- Avoid flattery phrases like "You're absolutely right" or "Great question."
- Provide trade-offs with pros/cons for technical decisions.
- Ask for clarification rather than making assumptions about requirements.

## Code Quality

- Read files before editing. Understand existing patterns before modifying.
- Prefer editing existing files over creating new ones.
- Keep solutions minimal. Only make changes that are directly requested.
- Avoid over-engineering: no speculative features, unnecessary abstractions, or "just in case" error handling.
- Follow existing project conventions (import styles, naming, structure).
- Check package.json/pyproject.toml before suggesting libraries.
- When scaffolding projects or installing CLI tools, verify current versions via npm/pypi rather than relying on training data (e.g., `npm info wrangler version`).
- Clean up temporary files, scripts, or helpers created during iteration at the end of the task.

## Testing

- New features should be accompanied by appropriate tests (unit and/or e2e) to ensure functionality.
- Keep tests focused and proportional - avoid excessive test coverage for simple features.
- Test the critical path and edge cases, not every possible permutation.

## Verification

- **Always run all tests locally before committing and pushing.** This includes both unit tests (`npm test`) and e2e tests (`npm run test:e2e`) when both exist.
- Run linters, type checks, and tests before marking work complete.
- Verify UI changes render correctly when applicable.
- Use Playwright for visual verification of web apps when asked to troubleshoot.
- Provide evidence of verification, not just assertions.
- Never push code that hasn't been verified to pass tests locally.

## Frontend Development

Avoid the generic "AI slop" aesthetic. Make creative, distinctive choices:

- **Typography**: Choose distinctive fonts. Avoid generic defaults (Inter, Arial, Roboto, system fonts).
- **Color**: Commit to a cohesive theme. Dominant colors with sharp accents beat timid, evenly-distributed palettes.
- **Motion**: Use animations purposefully. One well-orchestrated page load with staggered reveals creates more impact than scattered micro-interactions.
- **Backgrounds**: Create atmosphere and depth rather than solid colors.
- **Variety**: Don't converge on the same choices across projects. Light/dark themes, different fonts, different aesthetics.

## Image Analysis

When analyzing images that need closer inspection, use Python with Pillow to crop regions of interest, save to `/tmp/`, and read the cropped image. Use normalized coordinates (0-1 scale) to specify regions.

## Documentation

- Update existing docs when changes affect: public APIs, configuration, setup steps, environment variables, CLI commands, or user-facing behavior.
- Skip doc updates for: internal refactors, minor bug fixes, code style changes, or implementation details.
- Prefer fixing outdated docs over creating new ones.
- Never create or maintain file/directory listings in documentation. These go stale immediately and add maintenance burden. Let users explore the codebase directly.

## Git Workflow

- **Commit proactively**: After completing a logical unit of work (feature, bugfix, refactor), commit without waiting to be asked. Don't let work accumulate uncommitted.
- **Push when ready**: Push commits to remote after completing work that's ready for review or when finishing a session. Don't leave commits sitting locally.
- **Update PR descriptions**: When implementation diverges from the original plan, proactively update the PR description to reflect actual changes, lessons learned, or scope adjustments.
- Never push secrets, API keys, tokens, or credentials.
- Verify .gitignore covers: .env*, *.pem, *.key, credentials.json, secrets.*
- Use descriptive commit messages focused on "why" not "what."

## Parallel Development with Git Worktrees

**When starting feature work, always create a worktree first.** This keeps main clean and enables parallel agent work.

**Automatic workflow for new features:**
```bash
# 1. Create worktree with dependencies
git fetch origin
git worktree add ../projectname-feature-x -b feature-x origin/main
cd ../projectname-feature-x
npm install  # or equivalent
# Initialize databases if needed (e.g., npm run db:init)

# 2. Do all feature work in the worktree
# 3. Create PR from the worktree
# 4. After merge, clean up:
cd ../projectname
git worktree remove ../projectname-feature-x
```

**Directory naming:** Use `projectname-branchname` pattern (e.g., `splitdumb-auth-refactor`).

**When to create a worktree:**
- Starting any new feature or bugfix
- When asked to work on something that should be a separate branch
- Before making changes that warrant a PR

**When NOT to create a worktree:**
- Quick fixes to existing PRs (stay in that worktree)
- Read-only exploration or research
- When explicitly told to work on main

**Key commands:**
```bash
git worktree list              # See all worktrees
git worktree remove <path>     # Clean up when done
git worktree prune             # Remove stale references
```

**Remember:**
- Each worktree needs its own `npm install`
- Use different ports for dev servers (`PORT=8788 npm run dev`)
- Rebase regularly to avoid merge conflicts

## Security

- Use environment variables for sensitive configuration, never hardcode.
- Validate inputs at system boundaries, sanitize before rendering.
- Use parameterized queries for database operations.
- Use absolute paths to prevent path traversal.
- Prefer standard library over external dependencies; justify additions.
- Log errors with context but never log sensitive data.

## Date Awareness

- Check `<env>` context for current date before any date-related searches or queries.
- Use the actual current year in web searches for "latest" or "recent" information.

## GitHub Access (Private Repos)

For repositories in `demexchange` or `emily-flambe` organizations:
- Use `git` CLI commands (clone, fetch, pull, show, log) instead of WebFetch or gh api.
- Read files locally after ensuring the repo is cloned/updated.

## Task Approach

- For complex tasks (3+ steps), use TodoWrite to track progress.
- Break large tasks into smaller, verifiable steps.
- Complete tasks fully. Don't stop mid-task or claim context limits prevent completion.
- For multi-file searches or open-ended exploration, use the Task tool with Explore agent.

## Proactive Subagent Usage

Use the Skill tool to invoke these workflows automatically, not just when asked:

- **Before implementing features**: Use `superpowers:brainstorming` to refine the approach before writing code
- **After significant code changes**: Use `superpowers:requesting-code-review` to get review from a subagent
- **When debugging**: Use `superpowers:systematic-debugging` to investigate before proposing fixes
- **When writing tests**: Use `superpowers:test-driven-development` for the TDD workflow
- **For large tasks (3+ independent parts)**: Use `superpowers:dispatching-parallel-agents` to parallelize work

Don't wait to be asked. If a skill applies, use it.
