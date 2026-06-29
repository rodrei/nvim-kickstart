return { -- Highlight, edit, and navigate code
	-- NOTE: `main` is a full rewrite of nvim-treesitter (requires Neovim 0.12+
	-- and the `tree-sitter` CLI: `brew install tree-sitter-cli`). Unlike the old
	-- `master` branch it does not support lazy-loading, and highlighting /
	-- indentation / on-demand install are no longer `opts` — see below.
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		-- Parsers installed up front. Anything else is installed on demand by the
		-- FileType autocommand below (mirrors the old `auto_install = true`).
		ts.install({
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"typescript",
			"javascript",
			"ruby",
			"go",
		})

		-- Per-language tweaks carried over from the old `master` config:
		local also_vim_syntax = { ruby = true } -- old `additional_vim_regex_highlighting`
		local no_ts_indent = { ruby = true } -- old `indent.disable`

		-- Cache of all installable parsers (static for the session).
		local available
		local function is_available(lang)
			if not available then
				available = ts.get_available()
			end
			return vim.list_contains(available, lang)
		end

		local function start(buf, lang)
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			if not pcall(vim.treesitter.start, buf, lang) then
				return
			end
			if not no_ts_indent[lang] then
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
			if also_vim_syntax[lang] then
				vim.bo[buf].syntax = "on"
			end
		end

		-- On `main`, features are opt-in per buffer. Enable highlighting for any
		-- buffer whose language has a parser, installing it on demand if needed.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(args)
				local buf = args.buf
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not lang then
					return
				end
				if vim.list_contains(ts.get_installed("parsers"), lang) then
					start(buf, lang)
				elseif is_available(lang) then
					ts.install(lang):await(function()
						vim.schedule(function()
							start(buf, lang)
						end)
					end)
				end
			end,
		})
	end,
}
