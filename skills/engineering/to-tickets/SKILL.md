---
name: to-tickets
description: Split a spec issue into tracer-bullet implementation tickets on GitHub, wired as sub-issues with blocked-by edges.
argument-hint: "Spec issue number or URL"
disable-model-invocation: true
---

# To Tickets

Cut a spec into **tickets**: **tracer-bullet** vertical slices, each a sub-issue of the spec, each declaring the tickets that **block** it. One ticket is one fresh agent session of work.

## Process

### 1. Load the spec

Fetch the spec issue — body and comments. No spec issue? If the conversation holds the decisions, run the `to-spec` skill first; tickets hang off a spec.

Explore the code if you haven't. Look for **prefactors**: make the change easy, then make the easy change.

### 2. Draft the slices

- **Vertical** — each slice cuts a narrow, complete path through every layer it needs (data, logic, UI, tests). Never one layer across the whole feature.
- **Demoable** — a finished slice can be shown or verified on its own.
- **Sized** to one fresh context window.
- **Prefactors first**, as their own tickets, blocking what they enable.

**Where to cut**: split only where a reviewer could reject one ticket while approving its neighbour. If two slices would always pass or fail together, they are one ticket.

Give each ticket its **blocking edges** — only tickets that genuinely gate it. No blockers means it can start now.

**Wide refactors don't slice vertically.** One mechanical change (rename a column, retype a shared symbol) whose blast radius fans across the codebase can't land green as a tracer bullet. Sequence it **expand–contract**:

1. **Expand** — add the new form beside the old; nothing breaks.
2. **Migrate** — move call sites over in batches sized by blast radius (per package, per directory). One ticket per batch, each blocked by the expand, each green because the old form still exists.
3. **Contract** — delete the old form; blocked by every migrate batch.

If batches can't stay green alone, they share an integration branch and all block a final integrate-and-verify ticket — green is promised only there.

_Done when_: every user story and implementation decision in the spec is covered by at least one slice, and nothing in a slice falls outside the spec.

### 3. Get the list approved

Show a numbered list — per ticket: **title**, **blocked by**, **what it delivers** end to end. Ask whether the granularity is right, whether each edge is real, and what to merge or split. Iterate.

_Done when_: the user has approved the list. Create nothing before that.

### 4. Publish

Write each body per [TICKET-FORMAT.md](TICKET-FORMAT.md). Then, with the commands in [GITHUB.md](../../productivity/wayfinder/GITHUB.md) (read it first — the relationship endpoints want the database id), using the spec where it says map:

1. Create every ticket, blockers first.
2. Second pass: make each a sub-issue of the spec, then wire each blocked-by edge.

Leave the spec issue's body and state alone.

_Done when_: every approved ticket exists as a sub-issue of the spec, every edge is wired, and the frontier query from GITHUB.md, run against the spec, returns the tickets with no blockers. Report them by title — that is where the `implement` skill starts.
