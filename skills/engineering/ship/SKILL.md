---
name: ship
description: Take one ticket from build to open pull request — implement, review, docs, PR.
argument-hint: "Ticket (or small spec) issue number or URL"
disable-model-invocation: true
---

# Ship

One ticket, one session, one pull request. Each step is its own skill; this one only sets the order and the gates between them. Read each skill as you reach it.

1. **Branch.** On the default branch → create one named for the ticket. Note the starting commit.
2. **`implement`** — build test-first, run the checks, fix, run the `review-changes` skill, fix its findings, commit.
   _Gate_: every acceptance criterion ticked against shown evidence; checks green in pasted output. A failure you cannot fix in three attempts → stop and report; switch to the `diagnosing-bugs` skill only if the user says so.
3. **`update-docs`** — against the starting commit.
   _Gate_: docs commit on the branch, or "no docs needed" with the search named.
4. **Re-run the checks** if step 3 changed anything a check reads.
5. **`open-pr`** — body carries the evidence from step 2 and the docs list from step 3.

Stop at any gate that does not pass and say which one; an open PR over a failed gate is worse than no PR. Never merge — the PR is the hand-back to the user.

_Done when_: the PR is open and its URL reported, with the ticket's acceptance criteria, the check output, and the docs list in its body.
