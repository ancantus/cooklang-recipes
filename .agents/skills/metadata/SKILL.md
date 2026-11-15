---
name: metadata
description: Use when adding, normalizing, or fixing YAML frontmatter in Cooklang .cook recipes (title, tags, source, servings/yield, times, diet, locale, images), including converting old >> metadata lines and bulk metadata changes across a library.
---

# Skill: metadata

**Project workflow.** Keep `.cook` files directly under `recipes/`. Use lowercase, hyphenated tags for organization. Run `make doctor` from the repository root after metadata edits; it uses strict validation.

Use when adding, normalizing, or fixing recipe metadata (YAML frontmatter): titles, tags, source/author, servings/yield, times, diet, locale, images, or bulk metadata changes across a library.

This skill owns all metadata guidance. The cooklang-editing skill defers metadata/frontmatter work to here.

## Hard rule

Metadata is YAML frontmatter between `---` markers at the very start of the file. NEVER use the old `>>` metadata lines — reason: they are removed from the language; only frontmatter is supported, and `write_recipe` refuses them. If a file still has them, convert them to frontmatter keys as part of the edit.

## Workflow

Changing metadata — tags, cuisine, source, any frontmatter key — on one file or many:

1. Pick the target recipes. This collection is flat, so select files by their frontmatter tags or recipe names rather than directories.
2. For each file: `read_recipe`, change only the frontmatter, and keep the recipe body byte-for-byte. Match the file's existing key names, casing, order and tag style; add a frontmatter block if the file has none; never duplicate a tag.
3. Save each recipe as a `.cook` file directly under `recipes/`.
4. More than about 10 files → tell the user how many files you will touch and get a yes first; every write replaces a real file.
5. Tell the user what you changed, in which files, and name any files you skipped and why.

For a brand-new file, the frontmatter is part of the content you save with `write_recipe`.

## Canonical metadata fields

| Key (and synonyms) | Purpose | Example |
| --- | --- | --- |
| `title` | Recipe title. | `Uzbek Manti` |
| `source`, `source.name` | Where it came from (URL or text). | `https://example.org/recipe`, `mums` |
| `source.url` | URL when the nested form is used. | `https://example.org/recipe` |
| `author`, `source.author` | Recipe author. | `John Doe` |
| `servings`, `serves` | Number of portions; drives scaling. | `2` |
| `yield` | Numeric output amount when applicable. Put units or explanatory wording in `description`. | `6` |
| `course`, `category` | Meal category or course. | `dinner` |
| `locale` | ISO 639 language, optional `_` then ISO 3166 country. Used for spelling and pluralisation. | `en_GB`, `fr` |
| `time`, `time required`, `duration` | Total prep + cook time. Prefer `HhMm`. | `1h30m` |
| `prep time`, `time.prep` | Prep only. | `2 hour 30 min` |
| `cook time`, `time.cook` | Cooking only. | `10 minutes` |
| `difficulty` | Difficulty level. | `easy` |
| `cuisine` | Cuisine. | `French` |
| `diet` | Dietary suitability; string or array. | `gluten-free`, `[vegan, halal]` |
| `tags` | Descriptive, lowercase, hyphenated tags. | `baking, summer, side-dish` |
| `image`, `images`, `picture`, `pictures` | Image URL, or array of URLs. | `https://example.org/img.jpg` |
| `description`, `introduction` | Notes about the recipe. | `Traditional Uzbek dish…` |

## Rules

- Frontmatter goes at the very top of the file, before any step or section.
- Match the file's existing conventions (key spelling, casing) — reason: a file that mixes `serves` and `servings` is harder to maintain.
- Keep `servings`/`yield` accurate — they drive recipe scaling.
- `search_recipes` with `tag` matches the frontmatter `tags` list, so consistent tags make the library searchable.
- Touch only the files the task names.

## Do not skip the care

| Excuse | Rebuttal |
|--------|----------|
| "It's only metadata, I'll rewrite the body from memory." | `write_recipe` saves exactly what you send. Copy the body from `read_recipe`'s `source` unchanged. |
| "The metadata edit is tiny, I'll say it's done." | Say it's done after `write_recipe` succeeds, and name the file. |
