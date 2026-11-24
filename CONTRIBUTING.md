# Contributing

Thanks for contributing a skill! Here's everything you need to know.

## Skill location

Skills live under `skills/<category>/<skill-name>/`:

```
skills/
└── engineering/
│   └── my-skill/
│       ├── SKILL.md           # Required
│       └── FORMATS.md         # Optional: reference file, UPPERCASE, next to SKILL.md
└── productivity/
    └── my-other-skill/
        └── SKILL.md
```

Current categories: `engineering`, `productivity`. Add a new category directory if your skill doesn't fit.

Two directories are deliberately **outside** `skills/`, because everything under
`skills/` gets installed as a live skill:

- `templates/` — the worked example of a skill, not a skill to run.
- `docs/` — guidance for humans writing skills.

## Skill format

### `SKILL.md` frontmatter

```yaml
---
name: my-skill                  # Required — kebab-case, must match directory name
description: ...                # Required — triggers if model-invoked, a one-line summary if slash-only
disable-model-invocation: true  # Optional — makes the skill slash-only
argument-hint: "..."            # Optional — shown when the user types the skill name
---
```

No `version` or `license` field: the repo-level `LICENSE` (MIT) covers every skill.

The body is plain Markdown written as instructions to Claude — imperative, specific, and focused on one task. See [docs/authoring-guide.md](./docs/authoring-guide.md) for writing guidance and [docs/trigger-writing-tips.md](./docs/trigger-writing-tips.md) for description best practices.

### Model-invoked vs user-invoked

- **Model-invoked** (default): the `description:` is the trigger — Claude can fire the skill automatically based on context, and other skills can reach it by name. The description adds to context load every turn, so keep it tight.
- **User-invoked** (slash-only): set `disable-model-invocation: true` — only fires when the user types its name. Keep a short `description:` for the human's skill list; Claude never sees it, so it costs no context load, but the user must remember the skill exists.

See [skills/productivity/skill-creator/SKILL.md](./skills/productivity/skill-creator/SKILL.md) for the full reference on this decision.

## Naming conventions

- Directory name and `name:` field must be identical
- Use kebab-case (`my-skill`, not `mySkill` or `my_skill`)
- Keep names short and descriptive (2–4 words max)

## Scaffold a new skill

```bash
bash scripts/new-skill.sh
```

Prompts for a category, name, invocation mode, and description, then creates `skills/<category>/<skill-name>/SKILL.md` — a bare skeleton — and prints the registration steps.

For what a finished skill looks like, read [templates/example-skill/](./templates/example-skill/): the worked example, with a sibling reference file. Copying it into `skills/<category>/` by hand is equivalent to running the script; its own steps walk you through the rest.

Refer to another skill by name ("the `research` skill"), never as a bare slash command: the command differs between a plugin install (`/ms-skills:research`) and a symlink (`/research`).

## Scripts reference

| Script | Purpose |
|---|---|
| `scripts/link-skills.ps1` | **Windows** — symlink all skills into `~/.claude/skills` and `~/.agents/skills`. Supports `-DryRun` |
| `scripts/link-skills.sh` | **macOS/Linux** — same, via `ln -s`. On Windows it silently *copies*; use the `.ps1` instead |
| `scripts/list-skills.sh` | List all `SKILL.md` paths in the repo |
| `scripts/new-skill.sh` | Scaffold a new skill interactively |
| `scripts/validate.sh` | Validate all `SKILL.md` files for required fields |

## Validate before opening a PR

```bash
bash scripts/validate.sh
```

Checks that every `SKILL.md` has the required fields, that directory names match the `name:` field, and that `.claude-plugin/plugin.json` lists exactly the skills on disk. CI runs this automatically on all PRs.

## PR checklist

- [ ] Skill is in the right category under `skills/<category>/<skill-name>/`
- [ ] Directory name matches `name:` in frontmatter
- [ ] `description:` is present — triggers for a model-invoked skill, a one-line summary for a slash-only one
- [ ] Reference files are UPPERCASE siblings of `SKILL.md`; other skills are referenced by name
- [ ] Skill path added to `"skills"` in `.claude-plugin/plugin.json`
- [ ] `bash scripts/validate.sh` passes locally
- [ ] `README.md` skills table updated with the new entry
