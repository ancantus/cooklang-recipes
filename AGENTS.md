# Project instructions

Cooklang recipe collection in `recipes/`, managed with CookCLI (`cook`,
installed at `~/.local/bin/cook`). Root holds tooling only: Makefile, CI,
editor config, and shared agent skills. **Project skills live in
`.agents/skills` — prefer them over guessing when the task touches recipes.**

## Everyday commands

- `make serve` — local web UI at http://localhost:9080 (reads live, no restart)
- `make build` — static site into `dist/` (gitignored)
- `make search TERM=<word>` — full-text search
- `cook import <url>` — one-off URL import

## Linter / validation

- **`make doctor` is the linter.** It runs `cook doctor validate --strict`.
  Fix every reported error and warning before claiming a recipe change is done.
- Inspect a single file with `cook recipe read <path> -f json`.
- The collection is recipe content only: do not add pantry inventory,
  shopping-list data, aisle configuration, or shopping-list features.
- Do **not** run `cook doctor validate` from the repo root: it scans the
  gitignored `dist/` raw copy and resolves `./` references against the scan
  root, producing phantom errors. Use `make doctor` (which `cd`s into
  `recipes/`) — CI does the same.

## Files and layout

- Keep all `.cook` files directly in `recipes/`; use frontmatter tags to
  organize by course, cuisine, technique, ingredients, and reusable components.
  Tags use lowercase, hyphenated values. Do not create category folders or
  `.menu` files.
- Store images beside their `.cook` file under Git LFS. CookCLI discovers
  cover and step images by filename next to the recipe: `Name.jpg` = cover,
  `Name.N.jpg` = step N (1-based across the whole file, even though section
  numbering restarts in UI displays). `.gitattributes` tracks the supported
  image formats.
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

Skills in `.agents/skills/` are project tooling in the portable Agent Skills
format. This location is shared by Codex CLI, OpenCode CLI, and T3. Edit the
checked-in skills directly when project workflows need tuning. The Cook MCP
server is not installed; recipe edits use these skills and the local CookCLI.
