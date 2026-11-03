# Project instructions

Cooklang recipe collection in `recipes/`, managed with CookCLI (`cook`,
installed at `~/.local/bin/cook`). Root holds tooling only: Makefile, CI,
editor config. **14 cooklang skills live in `.opencode/skills` — prefer them
over guessing when the task touches recipes.**

## Everyday commands

- `make serve` — local web UI at http://localhost:9080 (reads live, no restart)
- `make build` — static site into `dist/` (gitignored)
- `make search TERM=<word>` — full-text search
- `cook import <url>` — one-off URL import

## Linter / validation

- **`make doctor` is the linter.** Run it before claiming any `.cook` or
  `.menu` change is done; it fails on syntax errors and broken references.
- Inspect a single file with `cook recipe read <path> -f json`.
- Run `cook doctor aisle` from `recipes/` to find ingredients missing from
  `config/aisle.conf` / `config/pantry.conf`. Never add pantry entries
  silently — pantry items are subtracted from shopping lists, so a wrong
  entry hides real purchases. Ask first; obvious `aisle.conf` groupings may
  be added directly.
- Do **not** run `cook doctor validate` from the repo root: it scans the
  gitignored `dist/` raw copy and resolves `./` references against the scan
  root, producing phantom errors. Use `make doctor` (which `cd`s into
  `recipes/`) — CI does the same.

## Files and layout

- Recipes in `recipes/`, categories as folders (Breakfast/, Salads/, Breads/,
  Shared/). New `.menu` files stay at the `recipes/` root (references
  resolve relative to the menu's own directory).
- Recipe images sit next to the `.cook` file: `Name.jpg` = cover,
  `Name.N.jpg` = photo for step N (1-based across the whole file, even
  though per-section numbering restarts in UI displays).
- Try to match an existing recipe's frontmatter style (canonical keys:
  `title`, `servings` (bare number), `time required`, `course`, `diet`,
  `tags`, `source`, `locale`).

## Images and photos

- Images must be correctly licensed/credited (Wikimedia CC0 and Pixabay are
  in use; credit in frontmatter `image credit` or a `-- comment` beside the
  step).
- **From scans of books/photos of pages, only actual cookbook illustrations
  (the printed food photography) may be used as recipe images** — and only
  with the owner's approval. Never commit page scans or source snapshots
  into the repo; reference them by `source:` metadata instead. A page scan
  should never become a cover image.

## Importing from a photo

Use the `recipe-import` skill (the synced one — it contains the whole local
photo pipeline: crop/rotate inspection, transcription verification,
validation ladder). This collection imports photos locally with no cloud
service and no account; never route photos through the cook.md paid import.

## Skills

The skills in `.opencode/skills/` are our fork: they began as a snapshot of
upstream `cooklang/cooklang-skills` (14 skills @ `7d96745`, with the local
CLI bridge applied in place of MCP-server instructions) and are now edited
directly as repo content. Feel free to change them whenever a rule needs
tuning; upstream is just where they came from, not something we track.
The Cook MCP server is intentionally not installed; every recipe write path
is skills + local CLI commands.
