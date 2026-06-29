# Repository Guidelines

This file guides agents (Claude Code, etc.) and human contributors working in this repository. `CLAUDE.md` is a symlink to this file.

This is a personal Neovim configuration derived from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Architecture

`init.lua` is the entry point. It loads three core modules in order, then bootstraps plugins:

1. `lua/base.lua` — editor options (`vim.opt`), leader keys, the yank-highlight autocommand, and the `lazy.nvim` clone/bootstrap. **The leader key is `\` (backslash), not space** — set here and must stay before plugins load.
2. `lua/keymaps.lua` — global, plugin-independent keymaps (tab navigation on `<C-l>`/`<C-h>`/`<C-t>`, terminal escape, diagnostics).
3. `lua/filetypes.lua` — `FileType` autocommands for per-language buffer-local options (e.g. 2-space indent for TS/JS).

Then `require("lazy").setup({ { import = "plugins" } }, ...)` loads **every file in `lua/plugins/` as a plugin spec**. The plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim). `lazy-lock.json` pins plugin versions for reproducible installs.

### Plugin specs (`lua/plugins/`)

One plugin (or tightly-coupled group) per file; each file `return`s a lazy.nvim spec table. To add a plugin, create a new file here — no central registry to edit. Notable specs:

- `lsp.lua` — the largest spec. `nvim-lspconfig` + `mason.nvim` (auto-installs LSP servers/tools), `fidget`, and `cmp-nvim-lsp`. The `LspAttach` autocommand defines all buffer-local LSP keymaps (`gd`, `gr`, `<leader>rn`, `<leader>ca`, etc.), many of which route through Telescope pickers. **Enable a language server by adding it to the `servers` table** (only `lua_ls` is active); Mason installs it automatically.
- `telescope.lua` — fuzzy finder and the source of most `<leader>f*` keymaps. `<leader>fh` is overridden to find hidden/non-ignored files.
- `treesitter.lua` — on nvim-treesitter's **`main` branch** (the rewrite; requires Neovim 0.12+ and the `tree-sitter` CLI, `brew install tree-sitter-cli`). A base parser set is installed via `require("nvim-treesitter").install({...})`; any other language's parser is installed **on demand** by the `FileType` autocommand (reimplementing `master`'s old `auto_install = true`), which then enables highlighting + experimental indentation via `vim.treesitter.start()`. Per-language carve-outs (`also_vim_syntax`/`no_ts_indent`, currently `ruby`) replace the old `additional_vim_regex_highlighting` / `indent.disable`. Does **not** support lazy-loading (`lazy = false`). Note: `main` has a different API than the old `master` branch — `ensure_installed`/`auto_install`/`opts` no longer apply.
- `cmp.lua` — completion engine.
- `conform.lua` — formatting, **currently disabled** (`return {}`; real config is commented out). Formatting falls back to LSP.
- `lint.lua` — `nvim-lint`, **currently inactive** (`linters_by_ft` is empty; markdownlint commented out).

## Build, Test, and Development Commands

There is no build or automated test step — this is runtime config. Validate changes by launching Neovim and exercising the affected behavior.

| Command | Purpose |
| --- | --- |
| `nvim` | Launch with this config |
| `:Lazy` | Plugin manager UI (status, `?` for help) |
| `:Lazy update` | Update plugins and refresh `lazy-lock.json` |
| `:Mason` | Manage LSP servers / tools |
| `:checkhealth` | Diagnose runtime issues |
| `:TSUpdate` | Update Treesitter parsers |

## Coding Style & Naming Conventions

- Lua is 2-space indented, soft tabs (`ts=2 sts=2 sw=2 et`).
- Keep plugin configs in `lua/plugins/<plugin>.lua` and `return` a plugin spec table.
- Keymap descriptions use bracketed mnemonics matching the keystroke, e.g. `[F]ind [F]iles`, `[C]ode [A]ction`.
- `vim.g.have_nerd_font` (set in `base.lua`) gates icon usage throughout specs.

## Testing Guidelines

- There is no automated test suite in this repository.
- Validate changes by launching `nvim`, reloading configs, and verifying the affected behavior.

## Commit & Pull Request Guidelines

- Commit messages follow a short imperative style (examples: "Add ability…", "Disable conform").
- Keep commits focused; avoid mixing refactors with behavior changes.
- PRs should describe the user-visible effect and mention any plugin additions or removals.
- Include screenshots only when visual UI changes are involved (themes, statusline, etc.).
- `lazy-lock.json` pins plugin versions — commit it alongside any plugin update so installs stay reproducible.

## Configuration Notes

- `vim.g.have_nerd_font` controls icon usage; set it to match your terminal font.
- Plugin updates should not be committed without updating `lazy-lock.json`.
