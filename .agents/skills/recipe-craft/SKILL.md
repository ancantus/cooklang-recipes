---
name: recipe-craft
description: Use when creating a brand-new .cook recipe from a brief ("make me a recipe for X in Y device", "come up with a recipe using what's on hand") - the multi-source research process that searches the internet for inspiration, distils from several distinct sources plus the model's own knowledge, resolves conflicts explicitly, adapts classic technique to the named equipment, and presents derived swaps for the owner to confirm. Not for transcribing one page (recipe-import) or classically editing files (cooklang-editing).
---

# Skill: recipe-craft

Create a recipe the owner asked into existence from a brief. A brief names a
dish, constraints (equipment like "Instant Pot", diet, main ingredients) and
explicit swaps ("use rump steak instead of lamb", "I'll tell you if swaps are
needed"). The owner owns the decisions: work a blend, mark what is debatable,
and stage the rest as swaps rather than deciding silently.

## Workflow

1. **Restate the brief and its open questions.** Keep requested ingredients
   and equipment in the main recipe. Use sensible defaults for servings and
   seasoning; put meaningful style choices (alcohol, richness, heat, thick
   versus brothy) in a swap note unless the brief settles them.
2. **Research for inspiration, not copying — three angles minimum when the
   web is reachable:**
   a. *Traditional / credible food source* — what the dish is commonly
      (composition, cuts, technique, what makes it authentic). Cite the name
      of the site and link it in the recipe note.
   b. *Equipment-constrained sources* — how real recipes solve the same dish
      for the named device (timings, pressure/release strategy, batch
      behaviour), including reader comments about real outcomes.
   c. *Variants* — one or two recipes of the same family that show the range
      (stout version, lamb, vegan etc.) so optional swaps are grounded.
   Search terms: the dish + the device + the swapped ingredient ("instant pot
   irish stew rump steak"), and separately dish + "recipe" for the
   traditional angle. When the web is absent or thin, do all three angles
   from model knowledge and say so.
3. **Distil, don't transcribe one source.** Reconcile disagreements by
   *choosing* and recording: quantities from the traditional composition,
   technique from the equipment sources where they conflict, optional parts
   demoted to swaps. Keep a short `> Source blend` note at the foot of the
   file naming each source, its contribution and direct URLs. Distinguish
   measured source guidance from your own estimates; flag untested timing
   and adaptations.
4. **Adapt to the equipment explicitly.** Check that the requested cut and
   method are compatible. Tender steak cuts do not become tender like
   collagen-rich shoulder just because they are pressure cooked; don't copy
   a chuck or shoulder timing onto a lean cut without explaining the
   trade-off. Use the device's names for things
   (#Instant Pot{}, Sauté, Sealing, quick-release) and timers for each
   pressure stage (~{25%minutes}). If a classic step is impossible or
   risky on the device, replace it and say why in a `-- comment`.
5. **Swaps area:** put every variant worth the owner's attention in a
   `> Swaps to consider` note at the end, using optional ingredients
   (`@?Guinness{330%ml}`, `@?lamb shoulder{800%g}`) so they can be included
   later from shopping lists without editing the file. Do not pirate a
   choice into the body the owner asked to keep open.
6. **Write and validate** exactly like `../cooklang-editing/SKILL.md` —
   quantities inline per step, one quantity per ingredient, canonical
   frontmatter — then the validation ladder: `cook recipe read -f json`,
   `make doctor`, from `recipes/`: `cook sl <file>` and `cook doctor aisle`.
   New ingredients missing from `config/aisle.conf` with obvious
   supermarket grouping may be added directly; `config/pantry.conf` is
   never touched without the owner.
7. **Report** what was blended and from where, what is staged as swaps, and
   any assumptions or untested steps that the owner may want to adjust.

## Rules

- Never present a single source's recipe as the result — at least two
  distinct sources must have influenced the draft, or the answer must say
  it is model-knowledge only.
- The dish's identity is protected: a swap the owner asked for (rump steak
  for lamb) is described as their choice in the file (source blend/comment),
  never silently reverted to the traditional cut.
- Quantity sanity: measure the draft's numbers against the collection's
  other recipes (serves-6 stew ≈ 700-900 g meat, 750 ml stock — scale
  everything by glance before validating; one off-by-2x quantity is a
  real-world disaster).
- Optional ingredients live in swaps, not in the body; the body has only
  what the brief requires and ordinary supporting ingredients.
- Do not add `difficulty`/`diet` claims the evidence doesn't support.
