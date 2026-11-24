#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ERRORS=0
CHECKED=0
NAMES=()

# ── Helpers ────────────────────────────────────────────────────────────────────

error() {
  echo "  ERROR: $*" >&2
  ERRORS=$((ERRORS + 1))
}

extract_field() {
  local file="$1" field="$2"
  # Reads the value of a frontmatter field (between the first pair of ---)
  awk -v field="$field" '
    /^---$/ { if (in_fm) exit; in_fm=1; next }
    in_fm && $0 ~ "^" field ": " { sub("^" field ": *", ""); print; exit }
  ' "$file"
}

# ── Scan skills ────────────────────────────────────────────────────────────────

while IFS= read -r skill_file; do
  dir_name="$(basename "$(dirname "$skill_file")")"
  CHECKED=$((CHECKED + 1))
  echo "Checking: $dir_name/SKILL.md"

  # name field
  name_val="$(extract_field "$skill_file" "name")"
  if [[ -z "$name_val" ]]; then
    error "missing or empty 'name:' field"
  elif [[ "$name_val" != "$dir_name" ]]; then
    error "name '$name_val' does not match directory '$dir_name'"
  fi

  # description field — required for every skill. Slash-only skills keep a
  # short human-facing one; it is what the user sees in the command list.
  desc_val="$(extract_field "$skill_file" "description")"
  if [[ -z "$desc_val" ]]; then
    error "missing or empty 'description:' field"
  fi

  NAMES+=("$dir_name")

done < <(find "$REPO_ROOT/skills" -name "SKILL.md" | sort)

# ── Cross-skill checks ─────────────────────────────────────────────────────────

# Harness skill directories are flat, so two skills in different categories
# that share a name would collide on install — the second link silently wins.
if [[ ${#NAMES[@]} -gt 0 ]]; then
  while IFS= read -r dupe; do
    [[ -z "$dupe" ]] && continue
    echo "Checking: duplicate names"
    error "skill name '$dupe' is used by more than one directory; names must be unique across categories"
  done < <(printf '%s\n' "${NAMES[@]}" | sort | uniq -d)
fi

# The plugin manifest lists every skill explicitly (categories are nested, so
# the default one-level discovery would find none). A skill missing from the
# list is silently not installed; a stale entry breaks the plugin.
MANIFEST="$REPO_ROOT/.claude-plugin/plugin.json"
echo "Checking: .claude-plugin/plugin.json"
if [[ ! -f "$MANIFEST" ]]; then
  error "missing .claude-plugin/plugin.json"
else
  on_disk="$(cd "$REPO_ROOT" && find skills -name SKILL.md | sed 's|/SKILL.md$||; s|^|./|' | sort)"
  listed="$(grep -o '"\./skills/[^"]*"' "$MANIFEST" | tr -d '"' | sort)"
  while IFS= read -r missing; do
    [[ -z "$missing" ]] && continue
    error "$missing is not listed under \"skills\" in plugin.json"
  done < <(comm -23 <(echo "$on_disk") <(echo "$listed"))
  while IFS= read -r stale; do
    [[ -z "$stale" ]] && continue
    error "plugin.json lists $stale but it has no SKILL.md"
  done < <(comm -13 <(echo "$on_disk") <(echo "$listed"))
fi

# ── Result ─────────────────────────────────────────────────────────────────────

echo ""
if [[ $ERRORS -eq 0 ]]; then
  echo "All $CHECKED skill(s) valid."
else
  echo "$ERRORS error(s) found across $CHECKED skill(s)." >&2
  exit 1
fi
