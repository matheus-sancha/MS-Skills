# Writing Skill Descriptions That Trigger Reliably

The `description:` of a model-invoked skill is loaded into the agent's context on every turn. It is the only part of the skill the agent sees before deciding to open it, so it does all the triggering work and costs tokens whether the skill fires or not.

The rules are those of the [`skill-creator`](../skills/productivity/skill-creator/SKILL.md) skill ("Writing the description"); this page shows them applied.

## The shape

What the skill is, then one "Use when…" clause per distinct case:

```yaml
description: Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check a state model, or explore what a screen should look like.
```

## Rules

**One trigger per case.** A case is a distinct way the skill gets used. Synonyms for the same case are the same trigger written twice:

```yaml
# One case, three times
description: Diagnose bugs. Use when the user says "debug this", "fix this bug", or "why is this broken".

# One trigger per case
description: Diagnosis loop for hard bugs. Use when a bug has survived an obvious fix, reproduces only intermittently, or something has become measurably slower.
```

**Lead with the word you actually type.** If you say "grill me on this plan", the description starts with _grill_. The agent links the word in your prompt to the word in the description.

**Say when, never how.** A description that summarises the steps gets followed in place of the skill: the agent reads the summary and never opens the body.

```yaml
# Summarises the workflow
description: Reviews a diff by pinning a fixed point, spawning two sub-agents, and merging their reports.

# States the trigger
description: Two-axis review of the diff since a fixed point. Use when the user wants a branch or PR reviewed against the repo's standards and the originating spec.
```

**Name the neighbour when two skills overlap.** Refer to it by name, not as a slash command — the command differs between a plugin install and a symlink:

```yaml
description: Review a diff against standards and spec. For waste across the whole codebase, use the `lean-code-reviewer` skill.
```

**Cut what the body already says.** Identity, rationale, and detail belong in `SKILL.md`.

## Slash-only skills

With `disable-model-invocation: true` the agent never sees the description. It becomes a one-line summary for the human reading their skill list — no trigger clauses:

```yaml
description: Compact the current conversation into a handoff document for another agent to pick up.
disable-model-invocation: true
```

## Testing your description

1. In a fresh session, type a prompt for each case in the description. The skill fires each time.
2. Type an adjacent prompt that belongs to a neighbouring skill. This skill stays quiet.
3. If it misfires, change the wording of the case that misfired; adding synonyms only costs tokens.
