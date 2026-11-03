# Recipes managed with CookCLI (https://cooklang.org/cli/)

COOK      ?= cook
RECIPES    := recipes
DIST_DIR   := dist
PORT       ?= 9080

.PHONY: help serve build clean doctor open search

help: ## Show available targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F'##' '{printf "  %-14s %s\n", $$1$$2, $$3}' | sed -e 's/: /:/'

## Launch interactive browsing UI (http://localhost:$(PORT))
serve:
	$(COOK) server $(RECIPES) --port $(PORT)

## Render the static website into dist/ (works from file:// too)
build:
	$(COOK) build web $(DIST_DIR) --base-path $(RECIPES)

## Open the built static site in a browser
open: build
	xdg-open '$(DIST_DIR)/index.html' 2>/dev/null || open '$(DIST_DIR)/index.html'

## Validate all recipes; fails on syntax errors
doctor:
	cd $(RECIPES) && $(COOK) doctor validate

## Full-text search: make search TERM=tomato
search:
ifeq ($(TERM),)
	$(error usage: make search TERM=<word>)
endif
	$(COOK) search $(TERM) --base-path $(RECIPES)

clean:
	rm -rf $(DIST_DIR)
