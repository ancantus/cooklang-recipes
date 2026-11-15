---
name: cooklang-validation
description: Use when validating or fixing Cooklang .cook recipes for syntax, metadata, quantities, recipe references, and CookCLI warnings.
---

# Skill: cooklang-validation

Use this skill whenever a recipe is added or changed. This cookbook stores
`.cook` recipes and their Git LFS images directly under `recipes/`;
organization uses frontmatter tags, not directories.

## Validation workflow

1. Run `make doctor` from the repository root. It runs
   `cook doctor validate --strict` from `recipes/` and fails on warnings or
   errors. Do not run `cook doctor validate` from the repository root because
   the generated `dist/` copy can produce false reference errors.
2. Read a single recipe with `cook recipe read <path> -f json` when its parsed
   data needs inspection.
3. Fix all reported issues in the `.cook` files, then rerun `make doctor`.
   Do not dismiss warnings as harmless without verifying the syntax or
   metadata they identify.

## Recipe rules

1. Keep ingredient quantities inline in the steps that use them; do not add a
   separate ingredient or shopping-list section.
2. Declare an ingredient quantity once. Later mentions of that ingredient
   should be bare references.
3. Brace multi-word ingredient and cookware names, for example
   `@white sandwich bread{}` and `#baking sheet{}`.
4. Put metadata in YAML frontmatter at the beginning of the file.
5. Use `{amount%unit}` quantities, such as `@milk{1/2%cup}`.
6. Use `@./Recipe Name{}` for recipe references, without a `.cook` suffix.
7. Separate steps with blank lines so each step remains distinct.
8. Keep every recipe directly in `recipes/`; use lowercase, hyphenated tags
   for course, cuisine, technique, and reusable components.
9. Format frontmatter `time:` with single, canonical Cooklang time units (such
   as `time: 40 min`, `time: 75 min`, or `time: 8 hours`). Do not use
   multi-unit expressions like `1 hr 15 min` (`hr` is unrecognized) or ranges
   like `4 to 8 hours` (`to` is parsed as an invalid unit). For descriptive
   ranges or breakdowns, use `time required: 1 hour 15 minutes` or
   `prep time:` / `cook time:`.
