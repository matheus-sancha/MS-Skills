# Skill Authoring Guide

The mechanics of a skill in this repo. The principles — what makes a skill predictable — live in the [`skill-creator`](../skills/productivity/skill-creator/SKILL.md) skill; this guide does not repeat them.

## Frontmatter reference

| Field | Required | Notes |
|---|---|---|
| `name` | Yes | Kebab-case; identical to the directory name |
| `description` | Yes | Model-invoked: the trigger the agent reads to decide when to fire the skill. Slash-only: a short human-facing summary |
| `disable-model-invocation` | No | `true` makes the skill slash-only: the agent never sees the description, so only the user can invoke it |
| `argument-hint` | No | Shown after the skill name when the user types it |

Nothing else. Skills carry no `version` or `license` field; the repo-level `LICENSE` (MIT) covers them all.

See [trigger-writing-tips.md](./trigger-writing-tips.md) for the description.

## Writing the skill body

The body is instructions to the agent. Write them imperatively:

**Do:**
> Find every `_test.dart` file under `test/`. For each, check that it calls `testWidgets` or `test`. Report any that don't.

**Avoid:**
> This skill helps with test files. It can look at Dart files and check them.

- **One skill, one job.** Split a skill that does two unrelated things.
- **End each step on a checkable "done when".** A vague finish line invites stopping early.
- **State the output's shape.** A list, a table, a file at a named path.
- **Say what to do, not what to avoid.** Naming the unwanted behaviour brings it into context.
- **Leave out what the agent can find by looking.** Scripts, config, and directory layout are already in the repo; write down only what they don't say.

## Reference files

Material only some runs need — a format, a glossary, a checklist for one case — goes in an UPPERCASE `.md` file next to `SKILL.md`, linked from the step that needs it:

```
skills/engineering/prototype/
├── SKILL.md
├── LOGIC.md
└── UI.md
```

One topic per file, named for what it holds. No `references/` subfolder.

## Testing your skill

1. Run `bash scripts/validate.sh` — checks frontmatter, name/directory match, and `.claude-plugin/plugin.json`.
2. Link the skill locally (`scripts/link-skills.ps1` on Windows, `scripts/link-skills.sh` elsewhere) and invoke it.
3. For wording meant to change behaviour, follow [`TESTING.md`](../skills/productivity/skill-creator/TESTING.md): compare against a run without the guidance.
