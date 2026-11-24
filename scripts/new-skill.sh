#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/skills"

# ── Prompt helpers ─────────────────────────────────────────────────────────────

prompt() {
  local var_name="$1" prompt_text="$2"
  read -r -p "$prompt_text" "$var_name"
}

# ── Validate kebab-case ────────────────────────────────────────────────────────

is_kebab_case() {
  [[ "$1" =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]
}

# ── Main ───────────────────────────────────────────────────────────────────────

echo "Claude Code Skill Scaffolder"
echo "────────────────────────────"

# List existing categories
existing_categories=()
while IFS= read -r -d '' d; do
  existing_categories+=("$(basename "$d")")
done < <(find "$SKILLS_ROOT" -maxdepth 1 -mindepth 1 -type d -print0 2>/dev/null | sort -z)

if [[ ${#existing_categories[@]} -gt 0 ]]; then
  echo "Existing categories: ${existing_categories[*]}"
fi

# Category
while true; do
  prompt CATEGORY "Category (kebab-case, e.g. engineering): "
  if [[ -z "$CATEGORY" ]]; then
    echo "Error: category cannot be empty." >&2
  elif ! is_kebab_case "$CATEGORY"; then
    echo "Error: category must be kebab-case." >&2
  else
    break
  fi
done

# Skill name
while true; do
  prompt SKILL_NAME "Skill name (kebab-case, e.g. my-skill): "
  if [[ -z "$SKILL_NAME" ]]; then
    echo "Error: name cannot be empty." >&2
  elif ! is_kebab_case "$SKILL_NAME"; then
    echo "Error: name must be kebab-case (lowercase letters, numbers, hyphens — no spaces or capitals)." >&2
  elif [[ -d "$SKILLS_ROOT/$CATEGORY/$SKILL_NAME" ]]; then
    echo "Error: 'skills/$CATEGORY/$SKILL_NAME' already exists." >&2
  else
    break
  fi
done

# User-invoked (slash-only)?
prompt SLASH_ONLY "Slash-only — invoked by the user, never by the model? [y/N] "
SLASH_ONLY="${SLASH_ONLY,,}"  # lowercase

DISABLE_MODEL=""
DESC_PROMPT="Description (what it is, then 'Use when…' — one trigger per case): "
if [[ "$SLASH_ONLY" == "y" ]]; then
  DISABLE_MODEL="disable-model-invocation: true"$'\n'
  DESC_PROMPT="Description (one line, for the human's skill list): "
fi

# Description — required either way
while true; do
  prompt SKILL_DESC "$DESC_PROMPT"
  if [[ -z "$SKILL_DESC" ]]; then
    echo "Error: description cannot be empty." >&2
  else
    break
  fi
done

# Sibling reference file
while true; do
  prompt REF_NAME "Reference file next to SKILL.md (UPPERCASE name, e.g. FORMATS; blank for none): "
  REF_NAME="${REF_NAME%.md}"
  if [[ -z "$REF_NAME" || "$REF_NAME" =~ ^[A-Z][A-Z0-9]*(-[A-Z0-9]+)*$ ]]; then
    break
  fi
  echo "Error: use UPPERCASE letters, numbers and hyphens (e.g. MAP-FORMAT)." >&2
done

# ── Create files ───────────────────────────────────────────────────────────────

SKILL_DIR="$SKILLS_ROOT/$CATEGORY/$SKILL_NAME"
mkdir -p "$SKILL_DIR"

TITLE="$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')"

# Quote the description so a colon or other YAML syntax in it stays a string.
DESC_YAML="${SKILL_DESC//\\/\\\\}"
DESC_YAML="\"${DESC_YAML//\"/\\\"}\""

cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description: $DESC_YAML
${DISABLE_MODEL}---

# $TITLE

TODO: Write your skill instructions here.
EOF

if [[ -n "$REF_NAME" ]]; then
  cat > "$SKILL_DIR/$REF_NAME.md" <<EOF
# $TITLE — $REF_NAME

TODO: Reference material for the $SKILL_NAME skill. Link this file from the step in SKILL.md that needs it.
EOF
  echo "Created: skills/$CATEGORY/$SKILL_NAME/$REF_NAME.md"
fi

echo ""
echo "Created: skills/$CATEGORY/$SKILL_NAME/SKILL.md"
echo ""
echo "Next steps:"
echo "  1. Edit skills/$CATEGORY/$SKILL_NAME/SKILL.md — fill in your skill instructions"
echo "  2. Add \"./skills/$CATEGORY/$SKILL_NAME\" to the \"skills\" list in .claude-plugin/plugin.json"
echo "  3. Add an entry to the README.md skills table under '$CATEGORY'"
echo "  4. Run: bash scripts/validate.sh"
