---
name: organize-collection
description: Use when organizing or auditing this Cooklang recipe collection, especially tag consistency and flat file layout.
---

# Skill: organize-collection

This repository is a flat recipe collection. Keep every `.cook` file and its
Git LFS images directly in `recipes/`. Do not create category folders, `.menu` files,
pantry data, aisle configuration, or shopping-list data. Use tags for
organization.

## Tag conventions

- Use lowercase, hyphenated tags: `breakfast`, `side-dish`, `instant-pot`.
- Use tags for course, cuisine, dietary properties, technique, ingredients,
  and reusable components where useful.
- Preserve meaningful existing tags; normalize spelling and casing rather
  than adding near-duplicates such as `Italian`, `italian`, and
  `italian-food` for the same concept.
- Keep tags in each recipe's YAML frontmatter.

## Workflow

1. Survey recipes with `find recipes -maxdepth 1 -name '*.cook'` and inspect
   frontmatter with `cook recipe read <path> -f json` as needed.
2. Identify missing or inconsistent tags and confirm any uncertain category
   with the owner.
3. Keep recipe bodies unchanged when only adding or normalizing tags.
4. Run `make doctor` from the repository root after edits. This runs strict
   CookCLI validation and must pass with no warnings or errors.

## Rules

- Do not reorganize recipes into folders; tags are the collection's
  organization system.
- Do not add pantry, aisle, shopping-list, or `.menu` features or files.
- Preserve recipe text unless the user asked for recipe edits or validation
  finds an issue that requires correction.
