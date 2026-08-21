
# Python

Python is wired differently from every other language here. TypeScript, Lua, CSS, JSON and friends
get their language servers from Mason — one global copy each. Python tools instead come from the
**project's own `.venv`**, because ruff is version-coupled to the code it checks: `[tool.ruff]`
keys get added and renamed between releases and rule sets shift, so a single global ruff would
quietly disagree with any repo that pins an older one.

## One-time fallback setup

Not every project keeps these in its venv, so install a fallback pair once:

```sh
uv tool install basedpyright   # -> ~/.local/bin/basedpyright-langserver
uv tool install ruff           # -> ~/.local/bin/ruff
```

Two commands — `uv tool install` takes a single package. Later, `uv tool upgrade --all`.

Nothing is added to Mason; `:Mason` should never list `ruff` or `basedpyright`.

## How a binary gets chosen

For each Python buffer, both servers look for their executable in this order
(`lua/core/venv.lua`):

1. `<project root>/.venv/bin/<exe>`
2. `$VIRTUAL_ENV/bin/<exe>`
3. whatever is on `PATH` — i.e. the `uv tool` copies above

If it's found nowhere, the server prints one warning naming the install command and simply doesn't
attach. No per-buffer spawn errors.

The project root comes from the nearest marker file: `pyproject.toml`, `ruff.toml`, `.ruff.toml`
or `.git` for ruff; those plus `pyrightconfig.json`, `setup.py`, `setup.cfg`, `requirements.txt`
and `Pipfile` for basedpyright. A `.py` file with no markers above it still gets both servers, just
without a workspace root.

**So: to pin a project's linting, add ruff to its dev dependencies.** Everything else follows.

## What you get

**basedpyright** — types, completion, hover, go-to-definition. It resolves imports through the
project's interpreter, so packages installed only in that `.venv` are understood.

**ruff** — lint diagnostics and autofixes, using the project's own rule selection. Its hover is
switched off so basedpyright owns `K` instead of two popups stacking.

| Key | Action |
| --- | --- |
| `<leader>cf` | Format buffer (conform) |
| `<leader>co` | Ruff: organize imports |
| `<leader>cF` | Ruff: fix all — drops unused imports, applies safe rule fixes |
| `gra` | Any code action (both servers) |
| `grn` | Rename across files |
| `K` | Hover (basedpyright) |
| `<leader>th` | Toggle inlay hints |

`:LspPyrightOrganizeImports` and `:LspPyrightSetPythonPath` also exist, from nvim-lspconfig.

**On save**, ruff sorts imports and then formats. Note it does *not* remove unused imports — that
is `<leader>cF`.

## Per-project configuration

The project's own config always wins over the defaults set here.

Type-checking defaults to `standard` (upstream pyright's level) rather than basedpyright's own
much louder `recommended`, which demands annotations everywhere and reports every `Any`. To raise
or lower it for one repo, in `pyproject.toml`:

```toml
[tool.basedpyright]
typeCheckingMode = "recommended"   # or "basic" / "off"

[tool.ruff.lint]
select = ["E", "F", "I"]
```

## Troubleshooting

`:checkhealth vim.lsp` shows what attached. To see which ruff is actually running:

```vim
:lua =vim.lsp.get_clients({ name = 'ruff' })[1].server_info
```

The reported version should match the project's pin — if it shows the `~/.local/bin` version in a
repo that has ruff in its venv, the venv isn't being found (check that `.venv` sits at the project
root alongside a marker file).

Both servers must agree on position encoding, so `after/lsp/ruff.lua` pins ruff to `utf-16` to
match basedpyright. Without that, checkhealth reports mixed encodings and diagnostics land on the
wrong columns on lines containing non-ASCII text.

The Python config lives in `after/lsp/basedpyright.lua` and `after/lsp/ruff.lua` — `after/`, not
`lsp/`, because nvim merges `lsp/*.lua` in runtimepath order with later winning, and
nvim-lspconfig comes after `~/.config/nvim`. From `lsp/` the custom `cmd` would be silently
replaced by lspconfig's plain `{ 'ruff', 'server' }`.

# Resources

- <https://github.com/hendrikmi/dotfiles> and YouTube videos.
- <https://github.com/nvim-lua/kickstart.nvim> a starter setup that Hendrik customizes
- Learn Lua: <https://learnxinyminutes.com/docs/lua>
- Python: <https://docs.astral.sh/ruff/> and <https://docs.basedpyright.com/>
