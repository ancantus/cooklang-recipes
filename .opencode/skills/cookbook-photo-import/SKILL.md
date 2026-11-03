---
name: cookbook-photo-import
description: Use when importing a recipe from a photo of a cookbook page, recipe card, or hand-written card into THIS collection (skills-only, no Cook MCP server) — or when the user asks to re-run or tune the local photo-to-cooklang pipeline. Runs entirely locally; ignore cloud import tools. Preserves the page-inspection sequence, transcription verification, validation loop and repo image rules agreed here.
---

# Skill: cookbook-photo-import (this project only)

Import a recipe from a photo of a printed page into `recipes/` with only
local tools. This is the project-local sequence; the generic `recipe-import`
skill is superseded by this one for photo sources.

## Repo rules (also in AGENTS.md)

- **Never save scanned pages into the repo.** Only photos of actual cookbook
  illustrations — the food photography printed on the page — may be stored as
  recipe images, and even then ask the owner first; a cover image made from a
  page scan is wrong (it hangs on the recipe page). Keep source scans
  elsewhere (drive/cloud) and reference them by `source:` metadata instead.
- Never call cloud import APIs for photos — this pipeline is deliberately
  local and needs no auth or account.

## Workflow

1. **Inspect before transcribing.** Read the photo once for orientation.
   Rotate (90° steps) and crop secrets — for ambiguous quantity
   glyphs/fractions (¼ vs ¾, torn column edges) crop the list region with
   Python + Pillow, upscale ~2×, and re-read the crop. Confirm every amount
   against the enlarged view before using it. Report the two or three
   trickiest glyphs you settled and how.
2. **Check the name is free.** Look at the existing layout:
   `ls recipes/` and remember menus live at the `recipes/` root. Pick a
   category folder matching the dish (Breakfast/, Salads/, Breads/, Shared/
   are current ones; create a folder when the dish has no home) and the
   book's title. Confirm not already imported (`cook search <title-subject>`
   and `ls`).
3. **Write the file** per `../cooklang-editing/SKILL.md`:
   - Frontmatter: `title`, `description`, `source` (book title + page and
     "transcribed from a photo" when the scan isn't saved), `servings` as a
     **bare number** (string suffixes fail validation), `time required`,
     `prep time` / `cook time` when split, `difficulty`, `course`, `diet`,
     `tags`, `locale`. Prefer canonical keys (`servings`, `time required`,
     `course`) over synonyms.
   - Quantities inline per step; prefer the metric value when the book shows
     dual units and they disagree; keep mixed white spaces in `@`,
     multi-word names in braces; preparation notes in
     `(...)`; `~{N%minutes}` timers; `>` notes for serving suggestions and
     printed nutrition info.
   - Judgement call per item: consumed → ingredient (`@baking paper` is
     wrong, `#baking paper` is right); used as a vessel/tedium → cookware.
     Oven and trays are cookware; water that goes into the pan is an
     ingredient even when the book doesn't quantify it (`@boiling water{}`).
4. **Validation loop, in this order:**
   1. `cook recipe read <path> -f json | python3 -m json.tool` from repo
      root — check counts: steps, ingredients vs the source list, cookware
      exactly listing what steps name.
   2. `make doctor` (repo root). Must show 0 new errors; preexisting seed
      warnings are known.
   3. `cook sl "<path>"` from `recipes/` (single file) — sanity-check
      quantities came out of steps, and where new ingredients land in the
      aisle grouping ([other] means missing from `aisle.conf`).
   4. `cook doctor aisle` from `recipes/` — lists everything missing from
      `config/aisle.conf` / `config/pantry.conf`. Offer to append; never
      silently add to `config/pantry.conf` (pantry items get subtracted from
      shopping lists) — ask the owner. Additive tidy-ups to `aisle.conf`
      are safe when the grouping is obvious.
5. **Do not link the scan into the repo** (rule above). State what was saved
   and where, list unresolved readings, run `make doctor` one last time,
   then commit with a message naming the source.

## Tuning

This skill is project-local (survives `scripts/sync-cooklang-skills.sh`,
which overlays the 14 upstream skills). Edit this file as rules evolve, and
mirror durable, generic lessons back upstream via the sync script's bridge
rather than forking the upstream copies by hand.
