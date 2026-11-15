---
name: recipe-import
description: Use when bringing a recipe into the Cooklang collection from a URL, photos, or pasted text and saving it as a .cook file. Triggers - "import", "convert this to Cooklang", a pasted recipe, a link, a photo of a cookbook page. Not for editing an existing local recipe.
---

# Skill: recipe-import

**Project workflow.** Save every `.cook` file and its images directly under `recipes/` and use lowercase, hyphenated tags instead of folders. Images are tracked by Git LFS. Run `make doctor` from the repository root; it uses strict validation.

Use when bringing a recipe in from a URL, photos, or pasted text.

## Workflow

1. Call `import_recipe` with exactly one source:
   - `url` — a recipe web page. Works without a login; social-media links (videos, posts) need a cook.md account and use the import allowance of Cook Basic or Cook Pro.
   - `text` — recipe text the user pasted. Works without a login.
   - `image_paths` — NOT routed through the cloud in this collection: photo sources follow the local pipeline in "Photos of cookbook pages (this collection)" below; no account needed.
   It returns Cooklang text (plus metadata) and does NOT save anything.
2. On `login_required`, call `login` and show the user the code and link. On `plan_required`, show the user the `checkout_url`. If they don't want to upgrade, follow the returned `next_step`: read the source yourself and write the Cooklang by hand (cooklang-editing skill).
3. Save directly under `recipes/` using a clear recipe name. Check the name isn't taken before writing.
4. Merge the returned metadata into YAML frontmatter (`title`, `source` with the URL, `servings`, times, `tags`). Keep `source` — the user will want to find the original.
5. Self-check against the cooklang-validation rules — no separate ingredient section, each quantity declared once inline, multi-word names braced — then run `make doctor`. Fix every warning and error.
6. Save with `write_recipe` and tell the user what you saved and where.

## Photos of cookbook pages (this collection)

This collection imports photo sources — cookbook pages, recipe cards,
hand-written cards — locally, with the agent's own vision or local OCR. When
system OCR packages (`tesseract`) are unavailable or non-root, use
`pip install rapidocr-onnxruntime` (a self-contained ONNX wheel that installs
cleanly without system dependencies). No cloud import, no account, no auth;
never suggest the paid photo-import service for photos.

Sequence:

1. Inspect before transcribing. Read the photo once for orientation. For
   handwritten cards, recipe cards, or dense book scans, slice into
   horizontal bands, rotate in 90° steps, enhance contrast, and crop tricky
   regions with Python + Pillow. Upscale ~2x and re-read the crop. Confirm
   every amount against the enlarged view; report the two or three trickiest
   readings you settled and how.
2. Check the name is free under `recipes/`. Save the recipe directly in that
   directory and apply useful course, cuisine, and technique tags.
3. Write the file per the cooklang-editing skill, with canonical frontmatter
   (`servings` as a bare number, `time required`, `course`, `diet`,
   `locale`), quantities inline per step (prefer the metric value when the
   book shows dual units), judging each item as ingredient (consumed) or
   cookware (used as a tool/vessel — e.g. `#baking paper{}` vs
   `@boiling water{}` for water that goes into the pan).
4. Validation ladder: inspect the recipe with `cook recipe read <path> -f json`
   and run `make doctor`. Strict validation must report no warnings or errors.
5. Report what was saved and where, including any unresolved readings.
   Do not commit page scans into the repo (see the image rule under Rules).

## Rules


- Never save a page scan or source snapshot into the repo — the photo lives
  elsewhere and the book is referenced via `source:` frontmatter. The only
  images from photo sources that may ever enter `recipes/` are actual
  cookbook illustrations (the printed food photography), and only with the
  owner's approval. Track them with Git LFS and name them to match the recipe.

## Rules

- Never copy a recipe out of a web page by hand when `import_recipe` can take the URL — it handles the page structure and returns clean Cooklang.
- Recipe images must be correctly licensed and credited (Wikimedia CC0 and Pixabay are in use here), via frontmatter `image credit` or a `-- comment`. Never suggest cloud import for photos; this collection's photo pipeline is local on purpose.
- See the `https://cooklang.org/docs/spec/` resource and the metadata skill for field names if you adjust the converted output.
- Touch only the file you are importing into. Ask before overwriting an existing recipe of the same name.
- The import is a starting point: check that quantities and steps survived (especially from photos), and say if anything was unreadable.
- If the source doesn't give servings or times, ask the user or leave the key out; don't invent them.
- Writing it by hand (no `import_recipe`, or its `next_step` says so): put each quantity in the step that uses it — "1 cup flour" → `@flour{1%cup}`, "1/2 tsp vanilla" → `@vanilla{1/2%tsp}`, "3 large eggs" → `@eggs{3}(large)`, "salt to taste" → `@salt`; "bake for 30 minutes" → `~{30%minutes}`; "in a large bowl" → `#large bowl{}`.

## Do not skip the save

| Excuse | Rebuttal |
|--------|----------|
| "`import_recipe` ran, so the recipe is imported." | It only RETURNS Cooklang. Nothing is in the collection until you `validate` it and save it with `write_recipe`. |
| "I'll report success now and save in a moment." | Save first, then report the path you saved to. |
