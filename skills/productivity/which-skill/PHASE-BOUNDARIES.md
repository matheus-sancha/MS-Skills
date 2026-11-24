# Phase boundaries

A **phase** ends when you think "ok, we're done with that". The **boundary** between two phases is the only place this decision belongs. Mid-phase there is nothing to decide: continue, or split what's left into subagents. Compacting mid-phase loses the thread.

Harness commands differ; the five moves don't.

| Move | What it does |
|---|---|
| **Continue** | Stay in the session. No context switch. |
| **Clear** | Empty the window, start from nothing. |
| **Hand off** | Write a portable document (the `handoff` skill) and seed a session anywhere with it (the `resume` skill). |
| **Subagent** | Send a task to its own window; get a report back. |
| **Compact** | Compress this context and carry on from the summary. |

## The tree

Top to bottom, at the boundary. The first **yes** wins.

**1. Can you continue?** Yes if the next phase needs this one as a **primary source**, or enough of the **smart zone** — the stretch of window in which the model still reasons sharply, roughly the first 150k tokens — is left for it to fit. Grilling → spec → tickets is the standard yes: each wants the reasoning verbatim. Continue costs nothing and loses nothing, so rule it out first.

**2. Is this context irrelevant to what's next?** Exploration, decisions, dead ends — all disposable? **Clear.** Cheapest move there is. Between two tickets is the standard case: the ticket carries everything. The mistake is one-way — clear a relevant context and the *why* behind what you built is gone; the diff won't give it back.

**3. Is the work travelling?** **Hand off** only when moving to:

- a different harness,
- a different directory or repo,
- another person,
- a side task found mid-phase, forked without derailing this one.

That is the whole list. Hand-off buys portability; if nothing travels, skip it.

**4. Can it run unattended?** Scoped tightly enough to need no steering? **Subagent**, and this session stays untouched. Review of a diff is the standard case.

**5. Otherwise, compact.** Relevant context, same place, you still in the loop. Give it an instruction naming what the next phase needs ("we're about to QA the sync path") so the summary keeps it.

Compact is the default, not the first reach: the four questions above are cheaper or more precise. Starting here is how a fresh session ends up confidently wrong about a decision the summary flattened.

## Why the order

Every move except Continue swaps a primary source — the session as it happened — for a secondary one, a summary of it.

| Source | Information | Noise | Room |
|---|---|---|---|
| Primary (continue) | full | lots | little |
| Secondary (compact, hand off) | lossy | less | lots |

Pay the lossiness only when staying costs more than it saves.

These are judgement calls; the same boundary can go two ways on two days. The value is in asking the questions in order, at the boundary.
