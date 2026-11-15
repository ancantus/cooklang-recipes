---
name: cooklang-editing
description: Use when writing a new Cooklang recipe or editing or fixing a .cook file - ingredients, cookware, timers, steps, sections, or resizing a recipe for good. For metadata/frontmatter changes use the metadata skill; to just show scaled amounts use scale-recipe. Not for importing from a URL/text.
---

# Skill: cooklang-editing

**Project workflow.** Keep every `.cook` file and its images directly in `recipes/`; use lowercase, hyphenated tags instead of category folders. Images use Git LFS. Run `make doctor` from the repository root for strict validation.

Use when creating, editing, scaling, or fixing .cook recipe files.

This skill is for `.cook` recipes only. For metadata/frontmatter changes (title, tags, source, servings, etc.), follow the metadata skill (`../metadata/SKILL.md`).

## Workflow

1. If editing an existing file, read it with `read_recipe` first (use the path exactly as `list_recipes` / `search_recipes` returned it); understand its style and structure.
2. If creating a file, save it directly under `recipes/` and use tags for its course, cuisine, and other useful categories.
3. Make the change using Cooklang syntax. For scaling, fixed quantities (`@salt{=1%tsp}`), or recipe references (`@./Recipe Name`), consult the `https://cooklang.org/docs/spec/` resource.
4. Self-check the content against the cooklang-validation rules — no separate ingredient section, each quantity declared once inline, multi-word names braced — then run `make doctor` from the repository root. Fix every warning and error before saving.
5. Save with `write_recipe`, always sending the full file content (there is no partial edit). It validates again and refuses to save content with errors.
6. Tell the user what you saved and where.

## Writing a new recipe

From a description, a family recipe from memory, or a dish the user names:

- Ask for what you can't know (how many it serves, the user's quantities) instead of inventing it; a sensible default is fine for things like oven temperature if you say so.
- Frontmatter with at least `title` and `servings`; add `time` (or `prep time` / `cook time`) and `tags` when known. Leave `source` out unless there is one.
- One paragraph per step, separated by a blank line: lines with no blank line between them join into one step.
- Mark everything inline where the step uses it: `@onion{1}(finely diced)` (preparation in parentheses), `#large pot{}`, `~{15%minutes}`. `= Sauce` starts a section in a multi-part recipe; a line starting with `>` is a note; `--` starts a comment.
- Show the draft, adjust, then validate and save as in the workflow above.

## Rules

- Metadata is YAML frontmatter, never the deprecated `>>` lines — for metadata-focused work, follow the metadata skill.
- Store cover and step images beside their recipe files; `.gitattributes` tracks supported image formats with Git LFS.
- Scan/photo policy: never commit page scans or source snapshots into the repo, and a page scan must never become a cover image. From photo sources only actual cookbook illustrations (the printed food photography) may be used as recipe images, and only with the owner's approval. Keep source scans elsewhere and reference them via `source:` frontmatter.
- Match the surrounding file's conventions (units, casing, section style) — reason: a recipe that mixes styles is harder for the user to maintain.
- Touch only the file the task names. If a change demonstrably needs another file (e.g. a referenced sub-recipe), name that file and explain why before editing it.
- Do not set `force: true` to `write_recipe` to get past validation errors; fix them. Use it only when the user explicitly wants a file saved as-is.

## Do not skip the checks

| Excuse | Rebuttal |
|--------|----------|
| "The edit is tiny, I'll skip validation." | `write_recipe` overwrites the user's file for real. Run `validate` on the new content first; a broken recipe breaks every app that reads it. |
| "I'll send just the changed lines." | `write_recipe` replaces the whole file. Send the complete recipe, or you delete the rest of it. |
| "I described the change, that's enough." | If the user asked for the change, save it with `write_recipe` and say what you saved. |
