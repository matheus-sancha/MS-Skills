---
name: open-pr
description: Use when opening a pull request or writing a PR body.
---

# Open PR

A pull request is a claim that the change works and is safe to merge. The body carries the proof, so the reviewer never has to rebuild it.

1. **Check the branch is ready.** Work committed, checks green on the latest commit, branch pushed. Not on the default branch — branch first if so. Checks not run since the last commit: run them now.
2. **Find the base and the spec.** Base is the default branch unless the user names another. The spec source is the ticket or spec issue this branch builds; no issue is fine, say so.
3. **Read the whole diff** against the merge-base (`git diff <base>...HEAD`) — every commit, not just the last.
4. **Write the body.** Use the repo's own template (`.github/pull_request_template.md`, or a file under `.github/PULL_REQUEST_TEMPLATE/`) when one exists, filling every heading. Otherwise use [PR-TEMPLATE.md](PR-TEMPLATE.md). Use the domain terms from `CONTEXT.md`.
5. **Title**: imperative, under 70 characters, what the change does — not the ticket number alone.
6. **Open it** — `gh pr create --base <base> --title … --body-file …`; without `gh` (cloud sessions), the GitHub MCP tools. One PR per branch: if one is already open, update its body instead.

_Done when_: the PR is open, its body shows evidence for every claim, and its URL is reported to the user.
