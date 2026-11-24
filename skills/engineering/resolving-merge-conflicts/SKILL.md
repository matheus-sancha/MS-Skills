---
name: resolving-merge-conflicts
description: Use when a git merge or rebase is in progress with conflicts to resolve.
---

1. **See the state.** `git status`, the history of both sides, every conflicted file.
2. **Find each side's intent** from primary sources — commit messages, PRs, the issues they reference. Know why each change was made before touching a hunk.
3. **Resolve each hunk**, preserving both intents. Where they are truly incompatible, pick the one matching the merge's stated goal and note the trade-off. Invent no new behaviour.
4. **Run the project's checks** — Flutter: `dart format .`, `flutter analyze`, `flutter test`; otherwise what the repo documents. Fix what the merge broke.
5. **Finish.** Stage, commit; on a rebase, continue until every commit is replayed.

Never `--abort` without the user's say — if resolving looks wrong, stop and ask.

_Done when_: no conflict markers remain, checks are green, and `git status` shows no merge or rebase in progress.
