#!/usr/bin/env bash
# Re-sync the cooklang agent skills under .opencode/skills/ from upstream.
#
# Upstream: https://github.com/cooklang/cooklang-skills (canonical skills live
# in cook-md/cook-mcp; this repo carries a synced copy).
#
# The copy is adapted for a skills-only, no-MCP-server install: the tools like
# read_recipe/write_recipe/validate are not available here, so each skill's
# "Needs the Cook MCP server" preamble is replaced with a local CookCLI bridge
# (make doctor, cook recipe read, cook search, cook sl) and cross-references
# like cooklang://skills/<id> are rewritten to local sibling paths.
# Project-specific workflow content is injected into the synced skills below
# (photos pipeline, image rules): those skills are the canonical home for
# such instructions, so there are no separate overlay skills that could drift
# or contradict them. Re-run to apply after upstream changes.
#
set -euo pipefail

upstream=${1:-cooklang/cooklang-skills}
ref=${2:-main}

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d -t cooklang-skills-sync.XXXXXX)
trap 'rm -rf "$tmp"' EXIT

git clone --depth 1 -q --branch "$ref" "https://github.com/$upstream" "$tmp/repo"
sha=$(git -C "$tmp/repo" rev-parse HEAD)

mkdir -p "$root/.opencode/skills"
# Overlay: overwrite upstream-synced skills but preserve other project-local
# skills already present in .opencode/skills/.
cp -r "$tmp/repo/skills/." "$root/.opencode/skills/"

python3 - "$root" <<'EOF'
import re, pathlib, sys
root = pathlib.Path(sys.argv[1])
bridge = (' '.join(
    """**Tooling bridge (this project, skills-only install).** This copy of the
    cooklang skills runs without the Cook MCP server. Use the local CookCLI
    instead. In the repo root: `make doctor` validates the whole collection
    and fails on errors — this is the project linter; never run
    `cook doctor validate` from the repo root directly, it scans the
    gitignored `dist/` build copy and mis-resolves `./` references (false
    errors). `cook recipe read <path>` or `cook recipe read <path> -f json`
    parses and inspects a file; `cook search <term>` searches; from
    `recipes/`, `cook sl <file>` builds a shopping list and `cook doctor
    aisle` lists ingredients missing from `recipes/config/aisle.conf` and
    `config/pantry.conf`. When
    writing or editing files, save them under `recipes/` and run `make doctor`
    before claiming success. Refresh the skills with
    `scripts/sync-cooklang-skills.sh` from upstream cooklang-skills.
""".split())) + '\n'

PHOTOS_SECTION = '''## Photos of cookbook pages (this collection)

This collection imports photo sources — cookbook pages, recipe cards,
hand-written cards — locally, with the agent's own vision as the OCR. No
cloud import, no account, no auth; never suggest the paid photo-import
service for photos.

Sequence:

1. Inspect before transcribing. Read the photo once for orientation. For
   ambiguous quantity glyphs and fractions (¾ vs ¼, torn column edges),
   rotate in 90° steps and crop the ingredient region with Python +
   Pillow, upscale ~2x, and re-read the crop. Confirm every amount against
   the enlarged view; report the two or three trickiest readings you
   settled and how.
2. Check the name is free (`ls recipes/` + `cook search <subject>`), then
   choose a category folder matching the dish (Breakfast/, Salads/, Breads/,
   Shared/ today; create a folder only when the dish has no home).
3. Write the file per the cooklang-editing skill, with canonical frontmatter
   (`servings` as a bare number, `time required`, `course`, `diet`,
   `locale`), quantities inline per step (prefer the metric value when the
   book shows dual units), judging each item as ingredient (consumed) or
   cookware (used as a tool/vessel — e.g. `#baking paper{}` vs
   `@boiling water{}` for water that goes into the pan).
4. Validation ladder, in order: `cook recipe read <path> -f json` (counts:
   steps, ingredients, cookware); `make doctor` (0 new errors; the seed
   collection has 3 known warnings); from `recipes/`, `cook sl <path>` to
   sanity-check quantities survived; `cook doctor aisle` for missing
   aisle/pantry entries — offer `aisle.conf` additions when the grouping is
   obvious, and ask before touching `config/pantry.conf`.
5. Report what was saved and where, including any unresolved readings.
   Do not commit page scans into the repo (see the image rule under Rules).

## Rules

''' + '''
- Never save a page scan or source snapshot into the repo — the photo lives
  elsewhere and the book is referenced via `source:` frontmatter. The only
  images from photo sources that may ever enter the repo are actual cookbook
  illustrations (the printed food photography), and only with the owner's
  approval.
'''
for p in (root / ".opencode/skills").glob("*/SKILL.md"):
    text = p.read_text()
    text = re.sub(r"\*\*Needs the Cook MCP server\*\*.*?\n", bridge, text, flags=re.S)
    text = text.replace("cooklang://skills/", "../")
    text = re.sub(r"\.\./([\w-]+)`", r"../\1/SKILL.md`", text)
    text = text.replace("cooklang://menu-format",
                        "https://cooklang.org/docs/conventions/")
    text = text.replace("cooklang://syntax", "https://cooklang.org/docs/spec/")

    rel = str(p.relative_to(root / ".opencode/skills"))

    # recipe-import: photos are routed through the local pipeline
    if rel == "recipe-import/SKILL.md":
        text = text.replace(
            "   - `image_paths` — 1–10 photos (cookbook page, recipe card) as paths inside the collection. Photos need a cook.md account and use the import allowance of Cook Basic or Cook Pro.",
            "   - `image_paths` — NOT routed through the cloud in this collection: photo sources follow the local pipeline in \"Photos of cookbook pages (this collection)\" below; no account needed."
        )
        text = text.replace(
            "3. Decide an output path: look at the collection layout with `list_recipes`, then pick a category folder and a name in the user's naming style. Check the name isn't taken — `write_recipe` overwrites.",
            "3. Decide an output path: look at the layout with `ls recipes/` (menus stay at the `recipes/` root), then pick a category folder and a name in the user's naming style. Check the name isn't taken (`ls` + `cook search`) — versions overwrites."
        )
        text = text.replace("## Rules\n",
            PHOTOS_SECTION + "\n## Rules\n")
        text = text.replace(
            "- Never copy a recipe out of a web page by hand when `import_recipe` can take the URL — it handles the page structure and returns clean Cooklang.",
            "- Never copy a recipe out of a web page by hand when `import_recipe` can take the URL — it handles the page structure and returns clean Cooklang.\n- Recipe images must be correctly licensed and credited (Wikimedia CC0 and Pixabay are in use here), via frontmatter `image credit` or a `-- comment`. Never suggest cloud import for photos; this collection's photo pipeline is local on purpose."
        )

    # cooklang-editing: repo image policy for scans
    if rel == "cooklang-editing/SKILL.md":
        text = text.replace(
            "- Recipe images live beside the file with a matching name (`Baked Potato.jpg`), or as step images (`Baked Potato.3.jpg`); see the syntax reference under Images.",
            "- Recipe images live beside the file with a matching name (`Baked Potato.jpg`), or as step images (`Baked Potato.3.jpg`); see the syntax reference under Images.\n- Scan/photo policy: never commit page scans or source snapshots into the repo, and a page scan must never become a cover image. From photo sources only actual cookbook illustrations (the printed food photography) may be used as recipe images, and only with the owner's approval. Keep source scans elsewhere and reference them via `source:` frontmatter."
        )
    p.write_text(text)
EOF

echo "Synced from $upstream@$sha"
