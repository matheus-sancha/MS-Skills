---
name: example-skill
description: Worked example of this repo's skill layout. Use when scaffolding a new skill by hand.
---

# Example Skill

Turn this copy into a real skill. Work from the repo root.

1. **Place it.** Copy this directory to `skills/<category>/<skill-name>/` (kebab-case; categories are the folders under `skills/`).
   _Done when_: the directory name is the skill's name.

2. **Set the frontmatter.** Make `name:` identical to the directory name. Write the `description:` as triggers: what the skill is, then one "Use when…" clause per distinct case. For a slash-only skill, add `disable-model-invocation: true` and cut the description to a one-line summary for the human.
   _Done when_: `name:` matches the directory and the description says when, never how.

3. **Write the body.** Replace these steps with instructions to the agent: imperative, in order, each step ending on a checkable _Done when_. Follow the `skill-creator` skill for the principles.

4. **Disclose reference.** Move lookup material only some runs need into an UPPERCASE sibling file and point at it where it is needed, as [`REFERENCE.md`](REFERENCE.md) shows. Delete that file if the skill has none.

5. **Register it.** Add `"./skills/<category>/<skill-name>"` to `"skills"` in `.claude-plugin/plugin.json`, and a row to the skills table in `README.md`.

6. **Validate.** Run `bash scripts/validate.sh`.
   _Done when_: it reports every skill valid.
