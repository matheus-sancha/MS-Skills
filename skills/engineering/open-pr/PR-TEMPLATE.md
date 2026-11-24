# PR template

Fallback for repos without their own template. Skip preambles; keep prose brief.

```markdown
## Summary

<the smallest view that makes the change clear — see below>

Closes #<ticket>

## Evidence

- **Before:** <screenshot / output / failing test run>
- **After:** <screenshot / output / passing test run>

Checks: <each command run and its final line of output>

## Merge danger

**Door:** <one-way | two-way> — <why, if one-way>
**Blast radius:** <what else could break>

## Docs

<docs updated in this PR, or "none needed">
```

## Summary

Pick one view; several only when each earns its place.

- **Behaviour change** — pseudocode of the logic, or a `diff` of it when the surrounding shape already exists.
- **Control flow** — a call tree.
- **UI** — the widget tree, with the state and module boundaries that matter.
- **Refactor or new module** — a shallow file tree, one comment per entry on what it owns.

Then one or two sentences on _why_. The diff already says what.

## Evidence

Proof the change works, as before and after.

- **Visual change** — screenshots.
- **Anything else** — execution output: the test that failed and now passes, the command and what it printed.

"Tests pass" without output is a claim, not evidence. Never paste secrets: write `<REDACTED>`.

## Merge danger

- **Door** — two-way if a revert fully undoes it. One-way if it deletes data, migrates a schema, changes a file format users already hold, or publishes something that cannot be recalled.
- **Blast radius** — who is affected if it is wrong: one screen, one feature, every install, stored user data.

## Docs

List what the `update-docs` skill changed, so the reviewer knows the docs were checked rather than forgotten.
