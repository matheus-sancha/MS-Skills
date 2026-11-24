# Claude Code Skills

A collection of custom skills for [Claude Code](https://claude.ai/code) and
Agent-Skills-compatible harnesses — reusable instructions that extend what an
agent can do in your projects.

## Installing

### As a Claude plugin (recommended)

The repo is a plugin marketplace containing one plugin, `ms-skills`.

**Claude Code** (terminal, desktop, or IDE):

```
/plugin marketplace add matheus-sancha/MS-Skills
/plugin install ms-skills@ms-skills
```

**Claude desktop / claude.ai (Cowork):** Customize → Plugins → Add marketplace
→ `matheus-sancha/MS-Skills`, then install `ms-skills`. Plugins installed
there sync to cloud sessions too.

Skills are namespaced by the plugin: `/ms-skills:handoff`,
`/ms-skills:wayfinder`, and so on. Update with `/plugin marketplace update
ms-skills`.

### As live symlinks (for editing skills)

Symlinking gives un-namespaced skills (`/handoff`) that reflect edits in this
checkout immediately, so it is the better setup while authoring. Use one
method or the other — with both, every skill shows up twice.

```bash
git clone https://github.com/matheus-sancha/MS-Skills
cd MS-Skills
```

**Windows** (recommended — Git Bash's `ln -s` silently copies instead of linking):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\link-skills.ps1 -DryRun   # preview
powershell -ExecutionPolicy Bypass -File scripts\link-skills.ps1           # apply
```

**macOS / Linux:**

```bash
bash scripts/link-skills.sh
```

Either script symlinks every skill into `~/.claude/skills` (Claude Code, and
any subagent that can use skills) and `~/.agents/skills` (other Agent-Skills
harnesses). Because they are symlinks, editing a file in this repo is live
immediately and `git pull` needs no re-installation.

The Windows script needs **Developer Mode** on (Settings → System → For
developers) so it can create symlinks without an elevated shell. Without it,
it falls back to directory junctions, which work the same for local paths.

## Available skills

`slash-only` skills fire only when you type `/<name>`; the rest can also be
invoked by the model when the context matches.

### Engineering

| Skill | Description |
|---|---|
| [codebase-design](./skills/engineering/codebase-design/) | Shared vocabulary for designing deep modules — use when designing or restructuring a module's interface |
| [context-map](./skills/engineering/context-map/) | Create and maintain `CONTEXT.md` and ADRs — the mental model and the record of why |
| [diagnosing-bugs](./skills/engineering/diagnosing-bugs/) | Diagnosis discipline for hard bugs — build a tight, red-capable feedback loop before hypothesising |
| [domain-modeling](./skills/engineering/domain-modeling/) | Pin down entities, relationships, and invariants; lock one ubiquitous language |
| [flutter-desktop-app](./skills/engineering/flutter-desktop-app/) | Blueprint for a local-first Flutter app shipped as a plain Windows zip |
| [flutter-ui-design](./skills/engineering/flutter-ui-design/) | Design and audit beautiful, adaptive Flutter UI — tokens, M3 anti-defaults, proportions, navigation, app flow |
| [implement](./skills/engineering/implement/) | `slash-only` — build one ticket test-first: checks run, review done, evidence shown |
| [lean-code-reviewer](./skills/engineering/lean-code-reviewer/) | Review a codebase for waste, redundancy, and AI slop |
| [prototype](./skills/engineering/prototype/) | Build a throwaway prototype to flesh out a design (logic terminal app or UI variations) |
| [resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/) | Resolve an in-progress merge or rebase by each side's intent |
| [review-changes](./skills/engineering/review-changes/) | Review a diff on two axes — repo standards, and fidelity to the originating spec |
| [test-strategy](./skills/engineering/test-strategy/) | Decide what deserves a test and which seam to write it at |
| [to-spec](./skills/engineering/to-spec/) | Turn decisions made in the conversation into a spec issue on GitHub |
| [to-tickets](./skills/engineering/to-tickets/) | `slash-only` — split a spec into vertical-slice tickets with blocking links |

### Productivity

| Skill | Description |
|---|---|
| [grilling](./skills/productivity/grilling/) | Interview the user relentlessly about a plan or design to stress-test it |
| [handoff](./skills/productivity/handoff/) | `slash-only` — compact the current conversation into a handoff document for another agent |
| [research](./skills/productivity/research/) | Investigate a question against primary sources, captured as a cited Markdown file |
| [resume](./skills/productivity/resume/) | `slash-only` — pick up from a handoff document, checking what drifted since it was written |
| [skill-creator](./skills/productivity/skill-creator/) | Reference for writing and editing skills well — vocabulary and principles for predictable skills |
| [teach](./skills/productivity/teach/) | `slash-only` — teach the user a new skill or concept across multiple sessions |
| [wayfinder](./skills/productivity/wayfinder/) | `slash-only` — plan work too big for one session as a map of tickets on GitHub Issues |
| [which-skill](./skills/productivity/which-skill/) | `slash-only` — router: which skill or flow fits what you're trying to do |

The main flow runs `grilling` → `prototype` (optional) → `to-spec` →
`to-tickets` → `implement` → `review-changes`; `which-skill` routes you onto it.

Three review skills exist and the boundary between them is **scope**:
`review-changes` reviews a diff, `lean-code-reviewer` reviews a whole codebase,
and the built-in `/code-review` hunts bugs.

Many of these are adapted from [Matt Pocock's skills](https://github.com/mattpocock/skills)
(MIT) — `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grilling`,
`handoff`, `implement`, `prototype`, `research`, `resolving-merge-conflicts`,
`review-changes`, `teach`, `to-spec`, `to-tickets`, `wayfinder`, and
`which-skill` — rewritten to depend only on skills in this repo and to target
GitHub Issues directly. A few techniques in `diagnosing-bugs`, `test-strategy`,
`review-changes`, and `skill-creator` come from
[obra/superpowers](https://github.com/obra/superpowers) (MIT).

### Vendor

Third-party skills copied in, not authored here. See
[skills/vendor/README.md](./skills/vendor/README.md) for upstreams and licensing.

| Skill | Description | Upstream |
|---|---|---|
| [building-native-ui](./skills/vendor/building-native-ui/) | Guide for building apps with Expo Router | [expo/skills](https://github.com/expo/skills) |
| [find-skills](./skills/vendor/find-skills/) | Discover and install agent skills | [vercel-labs/skills](https://github.com/vercel-labs/skills) |

## Repo structure

Everything under `skills/` is installed as a live skill. Anything that should
*not* be — templates, human-facing docs — lives outside it.

```
MS-Skills/
├── .claude-plugin/
│   ├── plugin.json           ← plugin manifest; lists every skill path
│   └── marketplace.json      ← makes the repo installable via /plugin
├── skills/
│   ├── engineering/
│   │   ├── codebase-design/
│   │   ├── context-map/
│   │   ├── diagnosing-bugs/
│   │   ├── domain-modeling/
│   │   ├── flutter-desktop-app/
│   │   ├── flutter-ui-design/
│   │   ├── implement/
│   │   ├── lean-code-reviewer/
│   │   ├── prototype/
│   │   ├── resolving-merge-conflicts/
│   │   ├── review-changes/
│   │   ├── test-strategy/
│   │   ├── to-spec/
│   │   └── to-tickets/
│   ├── productivity/
│   │   ├── grilling/
│   │   ├── handoff/
│   │   ├── research/
│   │   ├── resume/
│   │   ├── skill-creator/
│   │   ├── teach/
│   │   ├── wayfinder/
│   │   └── which-skill/
│   └── vendor/               ← third-party, minimally edited
│       ├── building-native-ui/
│       └── find-skills/
├── templates/
│   └── example-skill/        ← copy this to start a new skill; NOT installed
├── scripts/
│   ├── link-skills.ps1       ← Windows installer (use this on Windows)
│   ├── link-skills.sh        ← macOS/Linux installer
│   ├── list-skills.sh        ← list all skills in the repo
│   ├── new-skill.sh          ← scaffold a new skill interactively
│   └── validate.sh           ← validate all SKILL.md files
├── docs/
│   ├── authoring-guide.md
│   └── trigger-writing-tips.md
└── .github/workflows/
    └── validate.yml
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to add or improve skills.

## License

[MIT](./LICENSE) for the skills authored here. Skills under `skills/vendor/`
remain under their upstream licenses — see
[skills/vendor/README.md](./skills/vendor/README.md).
