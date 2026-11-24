---
name: review-changes
description: Review the diff since a fixed point along two axes — does it follow the repo's documented standards, and does it match what the originating issue or spec asked for? Use when reviewing a branch, a PR, or work in progress; for whole-codebase waste use the `lean-code-reviewer` skill instead.
---

# Review Changes

Two-axis review of the diff between `HEAD` and a fixed point:

- **Standards** — does the code conform to this repo's documented conventions?
- **Spec** — does it faithfully implement the originating issue or spec?

Both axes run as **parallel sub-agents** so they don't pollute each other's context; this skill then aggregates.

**Scope is the trigger boundary.** This skill reviews a *diff*. For waste and redundancy across the *whole codebase*, use the `lean-code-reviewer` skill. For bug-hunting, use the built-in `/code-review`.

## Process

### 1. Pin the fixed point

Whatever the user named — a SHA, branch, tag, `main`, `HEAD~5`. If they didn't name one, ask.

Confirm it resolves and the diff is non-empty **before** spawning anything, so a bad ref fails here rather than inside two sub-agents:

```bash
git rev-parse <fixed-point>
git diff --stat <fixed-point>...HEAD
git log <fixed-point>..HEAD --oneline
```

Three-dot, so the comparison is against the merge-base.

_Done when_: the ref resolves and the diff has at least one changed file.

### 2. Identify the spec source

In order:

1. Issue references in the commit messages or PR body — `#123`, `Closes #45` — normally the issue the `to-spec` or `to-tickets` skill wrote. Fetch with `gh issue view <n>` (on Windows Git Bash, write `gh api` paths without a leading slash); where `gh` is unavailable, as in cloud sessions, use the GitHub MCP tools.
2. A path the user passed as an argument.
3. Ask the user. If they say there isn't one, the Spec axis is skipped and reported as such.

### 3. Identify the standards sources

Anything in the repo documenting how code should be written — `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `CONTEXT.md`, ADRs, lint configs that encode judgement rather than mechanics.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** in [SMELLS.md](SMELLS.md) — Fowler's code smells, which apply even when a repo documents nothing. The two rules that bind it sit at the top of that file, where the sub-agent reads them.

### 4. Spawn both sub-agents in parallel

One message, two `Agent` calls, `general-purpose` for both. Both briefs open: _read-only — do not mutate the working tree, the index, or `HEAD`; inspect with `git diff`, `git show`, `git log`._

**Standards sub-agent** — give it the diff and log commands, the standards-source paths from step 3, and the **absolute path to `SMELLS.md`** with an instruction to read it first. Brief:

> Report, per file or hunk: (a) every place the diff violates a documented standard — cite the standard file and the rule; (b) any baseline smell you spot, under the two rules at the top of `SMELLS.md` — name it and quote the hunk. Skip anything tooling enforces. Under 400 words.

**Spec sub-agent** — give it the diff and log commands and the spec path or contents. Brief:

> Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. A spec's silence is not permission: where it says nothing, judge by what a reasonable user of the software would expect. Close with every behaviour you considered and set aside as outside the spec, one line each with the reason — an empty list means nothing was set aside. Under 400 words.

Passing `SMELLS.md` by path rather than pasting its contents keeps the baseline out of this session's context entirely — only the sub-agent that needs it loads it.

### 5. Aggregate

Present both reports under `## Standards` and `## Spec`, verbatim or lightly cleaned. Do **not** merge or rerank across axes — that's the reranking the separation exists to prevent. The Spec axis's set-aside list goes through untouched: the user rules on each line.

End with one line: findings per axis, and the worst issue *within each axis*. Don't pick a winner across axes.

## Why two axes

A change can pass one and fail the other:

- Follows every standard, implements the wrong thing → **Standards pass, Spec fail.**
- Does exactly what the issue asked, breaks every convention → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.

## Acting on findings

When asked to fix what a review found — this one or anyone's:

- **Clarify first.** One unclear finding blocks all of them: ask before implementing any, because findings are often related and a half-understood set gets built wrong.
- **Verify against the code.** A finding is a claim. Confirm it holds in this codebase before acting on it.
- **Push back with evidence** when it doesn't — the line, test, or ADR that contradicts it.
- **YAGNI check.** Before "implementing properly" something a finding calls half-done, grep for real usage. Unused → propose deleting it instead.
