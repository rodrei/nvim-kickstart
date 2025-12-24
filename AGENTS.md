# Repository Guidelines

## Project Structure & Module Organization
- `init.lua` bootstraps core settings and plugin loading via `lazy.nvim`.
- `lua/base.lua` contains editor options and runtime setup (leader keys, UI, lazy.nvim bootstrap).
- `lua/keymaps.lua` defines custom mappings.
- `lua/plugins/` holds individual plugin specs and configuration (one plugin per file).
- `lazy-lock.json` pins plugin versions for reproducible installs.

## Build, Test, and Development Commands
- `nvim` launches the config locally.
- Inside Neovim:
  - `:Lazy` shows plugin status and available actions.
  - `:Lazy update` updates plugins and refreshes `lazy-lock.json`.
  - `:checkhealth` helps diagnose runtime issues.
- No standalone build step is required.

## Coding Style & Naming Conventions
- Lua uses 2-space indentation and soft tabs (`ts=2 sts=2 sw=2 et`).
- Keep plugin configs in `lua/plugins/<plugin>.lua` and return a plugin spec table.
- Prefer clear, imperative names for keymap descriptions (e.g., `[F]ormat buffer`).
- Linting: `nvim-lint` runs `markdownlint` for Markdown buffers on common editor events.

## Testing Guidelines
- There is no automated test suite in this repository.
- Validate changes by launching `nvim`, reloading configs, and verifying the affected behavior.

## Commit & Pull Request Guidelines
- Commit messages follow a short imperative style (examples: “Add ability…”, “Disable conform”).
- Keep commits focused; avoid mixing refactors with behavior changes.
- PRs should describe the user-visible effect and mention any plugin additions or removals.
- Include screenshots only when visual UI changes are involved (themes, statusline, etc.).

## Configuration Notes
- `vim.g.have_nerd_font` controls icon usage; set it to match your terminal font.
- Plugin updates should not be committed without updating `lazy-lock.json`.
