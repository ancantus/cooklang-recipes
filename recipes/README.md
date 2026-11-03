# recipes

Personal recipe collection in [Cooklang](https://cooklang.org) — plain-text
`.cook` files managed with [CookCLI](https://cooklang.org/cli/).

## Layout

| Path | What it is |
| --- | --- |
| `*.cook` (root + folders) | Recipes — root for main dishes, folders for categories (e.g. `Breakfast/`, `Shared/`) |
| `*.menu` | Meal plans that combine recipes |
| `config/aisle.conf` | Maps ingredients to supermarket aisles (used by shopping lists) |
| `config/pantry.conf` | What you already have — shopping lists exclude these |
| `db/` | Per-ingredient shopping extras (urgency, notes) |
| `reports/*.jinja` | Jinja templates for `cook report` (cost, ingredients, recipe cards) |

## Install CookCLI

`~/.local/bin/cook` (v0.39.0), or see the
[download page](https://cooklang.org/cli/download/) for brew/rpm/cargo options.

## Everyday commands

```sh
# Read a recipe (scale with a suffix, e.g. "Risotto.cook:2" for double)
cook recipe read "Risotto.cook"

# Combined shopping list, grouped by aisle, minus pantry items
cook sl "Weekly Plan.menu"

# Full-text search over everything
cook search tomato

# Import any recipe from a URL into a clean .cook file
cook import <url>

# Check the collection for errors / missing aisle+pantry entries
cook doctor

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

Then `cook doctor` to catch typos, and commit.
