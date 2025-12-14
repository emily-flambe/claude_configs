# Claude Configuration

@SECURITY.md

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
- Clean up temporary files, scripts, or helpers created during iteration at the end of the task.

## Verification

- Run linters, type checks, and tests before marking work complete.
- Verify UI changes render correctly when applicable.
- Use Playwright for visual verification of web apps when asked to troubleshoot.
- Provide evidence of verification, not just assertions.

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

## Git Workflow

- Never commit automatically unless explicitly requested.
- Never push secrets, API keys, tokens, or credentials.
- Verify .gitignore covers env files and secret stores.
- Use descriptive commit messages focused on "why" not "what."

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
