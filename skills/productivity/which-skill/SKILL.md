---
name: which-skill
description: Ask which skill or flow fits what you're trying to do. A router over the skills in this repo.
argument-hint: "What are you trying to do?"
disable-model-invocation: true
---

# Which Skill

Match what the user is trying to do to a skill below, name it, and say where on the flow they are. Most work travels one **main flow**; **on-ramps** start elsewhere and merge onto it; the rest is standalone or vocabulary underneath.

## Main flow: idea → shipped

1. **`grilling`** — sharpen the idea by interview until no decision is left open. It pulls in **`domain-modeling`** to keep the terms, `CONTEXT.md`, and ADRs straight.
2. **`prototype`** (optional) — when a question needs a runnable answer: a state model to feel, a UI to see. Throwaway code; the answer returns to the thread.
3. **`to-spec`** — write the settled decisions down as a spec issue. No interview.
4. **`to-tickets`** — cut the spec into tracer-bullet tickets with blocked-by edges.
5. **`implement`** — build one ticket per fresh session, test-first.
6. **`review-changes`** — two-axis review of the diff: Standards and Spec. `implement` runs it; run it alone on any branch or PR.
7. **`update-docs`** — fix exactly the README and docs the diff made untrue, on the same branch.
8. **`open-pr`** — open the pull request with evidence in the body.

**`ship`** runs 5–8 for one ticket in one session, with a gate between each.

**Small enough for one session?** Skip 3–4: `grilling`, then `implement` or `ship` in the same window.

**Context**: keep steps 1–4 in one unbroken session so spec and tickets build on the grilling itself, not a summary. Each `implement` starts fresh from its ticket. See [Phase boundaries](#phase-boundaries).

## On-ramps

| Situation | Skill | Then |
|---|---|---|
| Something is broken, failing, or slow | `diagnosing-bugs` | fixes with a regression test; no seam to test at → `codebase-design` |
| Work too big or foggy for one session | `wayfinder` | charts decisions, doesn't build; when the map clears, merge at `to-spec` |
| A question needs reading — docs, APIs, sources | `research` | take the findings into `grilling` |
| The whole codebase carries waste or redundancy | `lean-code-reviewer` | each finding worth acting on enters at `grilling` or `implement` |
| Onboarding to a codebase, or recording a decision | `context-map` | — |
| Session ending, or work moving elsewhere | `handoff`, then `resume` in the new session | — |
| Mid-merge or mid-rebase with conflicts | `resolving-merge-conflicts` | — |

## Vocabulary underneath

Reach for these directly when the words or the shape, not the process, are the problem.

- **`domain-modeling`** — a fuzzy or overloaded domain term; an ADR to record.
- **`codebase-design`** — a module's interface, depth, and seams.
- **`test-strategy`** — what deserves a test and at which seam.

## Standalone

- **`flutter-desktop-app`** — scaffolding, structuring, or packaging a local-first Flutter app for Windows.
- **`flutter-ui-design`** — theming, laying out, or auditing Flutter UI.
- **`teach`** — learn a concept over several sessions.
- **`skill-creator`** — write or edit a skill.

## Phase boundaries

A **phase** is a chunk of work in a session — the grilling, the build, the QA. At the boundary between two, choose in this order; first yes wins:

1. **Continue** — the next phase needs this one verbatim, or there is room left.
2. **Clear** — nothing here matters to what's next.
3. **Hand off** (`handoff`) — the work is travelling: new harness, new directory, another person, or a side task forked mid-phase.
4. **Subagent** — the task is tight enough to run unattended.
5. **Compact** — otherwise.

Read [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) when the choice isn't obvious.
