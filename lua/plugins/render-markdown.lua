return { -- In-buffer markdown rendering (headings, code blocks, tables, etc.)
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	opts = {},
	keys = {
		{ "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "[M]arkdown [R]ender toggle (in-buffer)" },
	},
}
