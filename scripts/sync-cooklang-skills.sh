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
# like cooklang://skills/<id> are rewritten to local sibling paths. See
# scripts/sync-cooklang-skills.sh --help for usage; re-run after upstream
# changes.
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
for p in (root / ".opencode/skills").glob("*/SKILL.md"):
    text = p.read_text()
    text = re.sub(r"\*\*Needs the Cook MCP server\*\*.*?\n", bridge, text, flags=re.S)
    text = text.replace("cooklang://skills/", "../")
    text = re.sub(r"\.\./([\w-]+)`", r"../\1/SKILL.md`", text)
    text = text.replace("cooklang://menu-format",
                        "https://cooklang.org/docs/conventions/")
    text = text.replace("cooklang://syntax", "https://cooklang.org/docs/spec/")
    p.write_text(text)
EOF

echo "Synced from $upstream@$sha"
