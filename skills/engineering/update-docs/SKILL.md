---
name: update-docs
description: Bring the README and docs back in line with what a branch or PR changed. Use when a change is about to be opened as a pull request, when a PR altered behaviour, commands, structure or configuration, or when the user asks to update the docs for a change.
argument-hint: "Branch, PR number, or fixed point to diff from (default: the default branch)"
---

# Update Docs

Docs are a **cache** of the code. A change invalidates some of it; find exactly that and fix it. This is not a rewrite and not the moment to add docs that never existed.

1. **Read the diff** against the merge-base (`git diff <base>...HEAD`; for a PR, its diff), and its spec or ticket if it has one.
2. **List what the change made untrue.** For each of these the diff touched, write the old fact and the new one:
   - commands, flags, scripts, environment variables, config keys
   - install, build, run, or release steps
   - file and module layout; names of things a reader types or looks up
   - behaviour a user or caller can observe
   - domain terms and decisions
3. **Find every place that states the old fact.** Search for the old names and commands — don't trust memory of where docs live: `README.md`, `docs/`, `CONTRIBUTING.md`, `CHANGELOG.md`, `CONTEXT.md`, ADRs, doc comments on public APIs, in-app help text.
4. **Edit only those places**, in the file's existing voice and structure.
   - `CHANGELOG.md` exists → add an entry in its format.
   - A domain term or module map changed → the `context-map` skill owns `CONTEXT.md`.
   - The change embodies a decision worth remembering → an ADR, per `context-map`.
5. **Verify.** Run every command you documented; confirm every path and link you wrote exists.
6. **Commit** the docs on the same branch as the change, so code and docs merge together.

Nothing made untrue → change nothing and say "no docs needed", naming what you searched.

_Done when_: no doc still states a fact the diff falsified, each documented command has been run, and the docs commit is on the branch — or "no docs needed" is reported with the search behind it.
