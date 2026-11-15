# cooklang-cli

Personal recipe collection in [Cooklang](https://cooklang.org), managed with
[CookCLI](https://cooklang.org/cli/). Recipe pages are published as a static
site via GitHub Pages on every push to `main`.

## Repo layout

| Path | What it is |
| --- | --- |
| `recipes/` | The cookbook: `.cook` recipes and their images, plus recipe report templates — see [`recipes/README.md`](recipes/README.md) |
| `.agents/skills/` | Shared agent tooling for Codex CLI, OpenCode CLI, and T3 |
| `Makefile` | Everyday runner targets (`serve`, `build`, `doctor`, `search`) |
| `.github/workflows/publish.yml` | On pushes to `main`: validate recipes, build the static site, deploy to GitHub Pages |

## Quick start

Requires `cook` ≥ 0.35 on `$PATH` (see the
[download page](https://cooklang.org/cli/download/)).

```sh
# Browse recipes locally
make serve               # → http://localhost:9080

# Validate / build / search
make doctor
make build               # static site in dist/ (opens from file://)
make open
make search TERM=tomato
```

## GitHub Pages

The workflow builds with `--base-url /<repo-name>/`, which is right for a
project site at `https://<owner>.github.io/<repo-name>/`. Options:

- **Custom domain:** set `BASE_URL` in `.github/workflows/publish.yml`
  (e.g. `BASE_URL: /` if served at a domain root), or pin the cook version
  via the same file's `COOK_VERSION` env.
- **First time:** enable *Settings → Pages → Build and deployment → Source:
  GitHub Actions*. Deploys then happen automatically on push.

## Editing

`.vscode/settings.json` wires the official Cooklang extension to `cook lsp`
(syntax checking, completion, hover docs). Run `make doctor` before
committing. The cooklang.org docs cover the
[Cooklang syntax](https://cooklang.org/docs/spec/) and the
[CLI commands](https://cooklang.org/cli/).
