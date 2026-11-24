# Testing a Skill's Wording

Disclosed reference for [`skill-creator`](SKILL.md). The **No-Op** verdict — does this line change behaviour versus the default? — is settled by running the skill, not by debate. This is how to run it. **Bold terms** are defined in [`GLOSSARY.md`](GLOSSARY.md).

Test guidance meant to change behaviour. Pure **reference** (a format, a lookup table) has no default to beat; skip it.

## Micro-test

A micro-test checks one piece of wording cheaply, before any full run of the skill.

1. **One fresh context per sample.** Dispatch a single-shot subagent. Give it the realistic context the guidance will live in — the whole skill, not the sentence alone — and a task that tempts the failure.
2. **Run a no-guidance control.** Same task, guidance removed. If the control never shows the failure, the line is a **no-op**: stop, and delete it rather than tune it.
3. **Five or more reps per variant.** One sample is an anecdote.
4. **Read every hit yourself.** A count over grep matches overstates both failure and success: quoted counter-examples and echoed templates pass as hits.
5. **Score variance, not only the hit rate.** **Predictability** is the same process every run, so reps that converge on one shape mean the wording binds. Five reps with five readings mean it does not: change the form before adding words.

_Done when_: the control shows the failure, the variant removes it, and the variant's reps converge.

## Match the form to the failure

Classify what the control did wrong, then pick the form. A form that cures one failure worsens another.

| Control failure | Form that binds |
|---|---|
| Skips a step it knows it should do | A **step** with a checkable **completion criterion** |
| Output has the wrong shape | A positive recipe: state the shape, show one example |
| Leaves out a required element | A named slot in a template |
| Behaviour should depend on a condition | A conditional keyed to something observable ("if `pubspec.yaml` exists, …") |
| Effort too thin | A stronger **leading word**, or a more demanding criterion |

Two rules whichever form you pick:

- **One rule, zero riders.** "Do X unless it matters" hands the agent a negotiation, and a single rider turns a converging recipe noisy. Write a real exception as its own conditional on an observable predicate.
- **Exemptions leak.** "This limit skips code blocks" still shrinks code blocks. Restructure so the rule cannot reach the exempt part: a separate section, a separate step.

A prohibition is rarely the binding form (see **Negation**): under a competing incentive it can score worse than the control. Measure it against the positive recipe before keeping it.

## Discipline skills: baseline under pressure

A discipline skill asks the agent to hold a line when cutting it is easier: test first, reproduce before fixing, verify before claiming done. Micro-tests check its wording; they do not show whether the line holds. For these skills only:

1. **Write one scenario combining three or more pressures** — time, sunk cost, authority, exhaustion, a visible shortcut. An agent holds against one pressure and folds under three. Make it concrete: real paths, a forced choice, act now.
2. **Run it without the skill.** Record what the agent chose and its justification, verbatim. Those sentences are the spec: the skill answers them and nothing hypothetical.
3. **Run it with the skill.** If the agent still folds, record the new justification verbatim and close that gap alone.

_Done when_: the agent holds the line under the combined scenario, and each sentence added to the skill traces to a recorded justification.
