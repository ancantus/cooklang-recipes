# recipes

Personal recipe collection in [Cooklang](https://cooklang.org) — plain-text
`.cook` files managed with [CookCLI](https://cooklang.org/cli/).

## Layout

| Path | What it is |
| --- | --- |
| `*.cook` | All recipes live directly in this directory; use tags for organization |
| `Name.jpg` | Cover image, stored beside its recipe and tracked by Git LFS |
| `Name.N.jpg` | Photo for step `N` (1-based across the whole file), stored beside its recipe and tracked by Git LFS |

## Install CookCLI

`~/.local/bin/cook` (v0.39.0), or see the
[download page](https://cooklang.org/cli/download/) for brew/rpm/cargo options.

## Everyday commands

This directory contains recipes and their images only. Pantry inventory,
shopping lists, and meal-plan `.menu` files are outside this cookbook's scope.
Use lowercase, hyphenated frontmatter tags such as `breakfast`, `side-dish`,
`instant-pot`, and `component` instead of creating category directories.

```sh
# Read a recipe (scale with a suffix, e.g. "Risotto.cook:2" for double)
cook recipe read "Risotto.cook"

# Full-text search over recipes
cook search tomato

# Import any recipe from a URL into a clean .cook file
cook import <url>

# Strictly validate all recipes
make doctor

# Browse locally in a browser
cook server
# → http://127.0.0.1:9080
```

## Adding a recipe

Create `My Dish.cook` and write it in Cooklang — see the
[spec](https://cooklang.org/docs/spec/) or `cook seed`'s examples:

```cooklang
---
title: Pesto Pasta
servings: 2
tags: pasta, quick
---

Boil @water{1%L} with @salt{1%tbsp}, cook @spaghetti{200%g} for ~{8%min}.

Toss with @pesto{3%tbsp} and top with @parmesan{grated} and @black pepper{}.
```

Then `make doctor` to validate strictly, and commit.
