---
name: implement
description: Build one ticket, or one small spec, test-first — checks run, review done, evidence shown.
argument-hint: "Ticket (or small spec) issue number or URL"
disable-model-invocation: true
---

Build **one ticket** per session. A spec small enough for one session counts as one ticket.

1. **Read the ticket and its parent spec** — bodies and comments. Check every ticket blocking it is closed. If the ticket is ambiguous, contradicts the spec, or needs a decision nobody made, **stop and ask** — never guess. Note the starting commit (`git rev-parse HEAD`): it is the review's fixed point.
2. **Build test-first, in vertical slices.** One failing test at the seam the spec agreed, make it pass, repeat — per the `test-strategy` skill. Stay inside the ticket's acceptance criteria and its Out of scope.
3. **Run the checks.** Flutter/Dart: `dart format .`, `flutter analyze`, `flutter test`. Anything else: the checks the repo documents (README, CONTRIBUTING, CI config). Run single test files while building, the full set once at the end.
4. **Commit** to the current branch, referencing the issue (`Closes #<ticket>` on the final commit).
5. **Review.** Run the `review-changes` skill from the fixed point, with the ticket and its spec as the spec source. Fix what it finds, rerun step 3, commit.
6. **Report with evidence.** Paste the final output of each check and tick each acceptance criterion against the test or command that proves it. No output, no claim: "should pass" is not done.

_Done when_: every acceptance criterion is ticked against shown evidence, all checks are green in pasted output, review findings are fixed or listed as open, and the work is committed. Then stop — the next ticket gets a fresh session.
