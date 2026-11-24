# Ticket format

The ticket is the contract an agent builds from with no other context than the spec it hangs off. It may sit for weeks while the code moves, so write it to survive that.

## Body

```markdown
## What to build

<the end-to-end behaviour this ticket makes work, from the user's side —
current behaviour, then desired, including error and edge cases>

**Interfaces:** Consumes <what it relies on from blocking tickets or existing code> / Produces <what later tickets or callers may rely on>

## Acceptance criteria

- [ ] <one observable, independently verifiable outcome>

## Out of scope

- <adjacent thing this ticket must not touch>
```

Parent and blockers are **not** written in the body — they are the sub-issue and blocked-by links, the single place they live.

## Rules

- **Behaviour, not procedure.** Say what the system does, not which edits to make. "`DraftStore.save` rejects an empty title with `ValidationFailure`", not "add a check in the save method".
- **Durable.** Name types, interfaces, and contracts. No file paths, no line numbers. A prototype snippet that pins a decision goes inline, trimmed, marked as from the prototype.
- **Criteria are checkable.** Each one can be shown passing or failing by a test, a command, or a demo. "Sync works correctly" is not a criterion.
- **Interfaces line.** Produces is what a neighbour's Consumes may name; a Consumes that no blocker Produces and the code doesn't already have is a missing ticket or a missing edge.
- **Scope is explicit.** Out of scope names what the agent would otherwise be tempted to gold-plate. Don't restate the spec; quote only the decision this ticket implements.

## Title

What the ticket delivers, readable alone: "Save a draft offline and see it in the list", not "Draft store" or "Ticket 3". Expand–contract tickets say their step: "Expand: add `updatedAt` beside `modified`".
