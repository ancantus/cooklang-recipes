---
name: recipe-search
description: Use when the user wants to find recipes in their Cooklang collection by ingredient, tag, cuisine, course, title or a half-remembered phrase - "what recipes use chickpeas?", "find my Italian dinners", "where's that lemon cake?".
---

# Skill: recipe-search

Use when the user wants to find recipes in their collection.

**Project workflow.** Recipes are flat in `recipes/` and organized with lowercase, hyphenated frontmatter tags. Search tags and recipe text; do not infer categories from folders.

## The tools

- `search_recipes` — `query` and/or `tag`. Returns `hits` (`path`, `name`): best match first when there is a `query`; a `tag`-only search is sorted by path.
  - **Every word in `query` must match** (AND), case-insensitively, as a substring of the file name or the file's text (frontmatter, ingredients, steps, notes). `chicken rice` finds recipes with both; `tomato` also matches `tomatoes`.
  - `tag` keeps only files whose frontmatter `tags` list contains that tag (case-insensitive, whole tag). `query` may be empty when `tag` is set.
- `list_recipes` — browse the flat recipe collection when a listing is more useful than a text search.
- `read_recipe` — a hit's metadata (servings, time, tags) and steps, when you need them.

## Workflow

1. Turn the request into the narrowest cheap search:
   - an ingredient or dish → `query` with one or two distinctive words (`chickpea`, `lemon cake`);
   - a tag the collection uses (`vegetarian`, `quick`) → `tag`;
   - a course, cuisine, or technique → search for the matching frontmatter tag;
   - a cuisine or diet → try `tag` first, then `query` (it also matches frontmatter like `cuisine: Italian`).
2. Too many hits: add a word or a `tag`. None: drop a word, try a shorter stem (`aubergin` for aubergine/aubergines), or a synonym (`courgette`/`zucchini`). For "X or Y", run one search per word and merge the results.
3. Present hits as a short list of names with their paths. Read only the few you need to say more about (servings, time) — not every hit.
4. Offer the obvious next step: open one, scale it (scale-recipe), or edit it (cooklang-editing).

## Rules

- Only name recipes the tools returned, with their paths exactly as returned. If nothing matches, say so and offer to import one (recipe-import).
- This repository does not track pantry inventory or shopping lists.
- Nutrition criteria ("over 30 g protein") are a screen, not a search: narrow here first, then follow nutrition-reports ("Screening a shortlist").
- If searches keep missing because tags are inconsistent (`Italian` vs `italian` vs `italian-food`), mention it and offer the organize-collection audit.
