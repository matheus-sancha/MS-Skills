---
name: to-spec
description: Turn decisions already made in the conversation into a spec issue on GitHub. Use when the user asks for a spec or PRD of what was discussed, or when grilling, a prototype, or a cleared wayfinder map has settled a design that needs writing down before it is built.
---

# To Spec

A **spec** is the record of decisions already made, published as one GitHub issue. It is what tickets are cut from and what the `review-changes` skill's Spec axis later checks the diff against — so every decision in it must be **checkable**.

**Synthesise, don't interview.** This skill writes down what the conversation settled. It decides nothing.

## Process

### 1. Gather the sources

The conversation, plus whatever it points at: a wayfinder map's **Decisions so far** (zoom into each linked ticket — the map only gists), prototype findings, research notes, `CONTEXT.md`, ADRs in the area. Explore the code enough to know the current state. Write in the project's glossary vocabulary throughout.

_Done when_: every decision you intend to write traces to something the user said or agreed to.

### 2. Sort the open ends

Anything the spec needs but nobody decided is **undecided**. Never fill it in yourself.

- **Load-bearing** — the answer changes what gets built: stop, name the questions, send the user back to the `grilling` skill.
- **Minor** — the build can start without it: record it under **Open questions**.

_Done when_: every undecided item is in one of those two piles.

### 3. Agree the test seams

Pick the seams the behaviour will be tested at, per the `test-strategy` skill: existing seams over new ones, as high as possible, as few as possible. Show them to the user — the one confirmation this skill asks for.

### 4. Write and publish

Fill the template; publish it as an issue labelled `spec`, titled for what it delivers ("Offline sync for drafts"). Label- and issue-creation commands, including the REST forms for cloud sessions, are in [GITHUB.md](../../productivity/wayfinder/GITHUB.md); without `gh`, use the GitHub MCP tools.

_Done when_: the issue URL is reported, every user story is covered by a decision, and every undecided item appears under Open questions.

## Checkable

A decision is checkable when a reviewer holding only the diff can answer yes or no.

- Checkable: "Draft state lives in `DraftStore`; widgets never hold it." "Sync retries three times, then surfaces an error banner."
- Not: "Handle drafts cleanly." "Sync should be robust."

Rewrite or move to Open questions anything that fails. Name modules, interfaces, and types; leave out file paths and line numbers — they go stale. A prototype snippet that pins a decision more exactly than prose (a state machine, a schema) goes inline, trimmed, marked as from the prototype.

## Template

```markdown
## Problem

<what is wrong or missing, from the user's side>

## Solution

<what they will be able to do once this ships>

## User stories

1. As a <actor>, I want <capability>, so that <benefit>.
<!-- exhaustive: one per distinct behaviour, including error and empty cases -->

## Implementation decisions

- <module, interface, schema, or contract decision — checkable>

## Testing decisions

- <seam, what is asserted there, prior art in the codebase>

## Out of scope

- <what this spec consciously does not deliver>

## Open questions

- <minor undecided item — omit the heading if none>
```
