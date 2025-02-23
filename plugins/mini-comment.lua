return {
	"echasnovski/mini.comment",
	opts = {
		mappings = {
			-- Toggle comment (like `gcip` - comment inner paragraph) for both
			-- Normal and Visual modes
			comment = "<leader>c",
			--
			-- Toggle comment on current line
			comment_line = "<leader>cc",

			-- Toggle comment on visual selection
			comment_visual = "<leader>c",

			-- Define 'comment' textobject (like `dgc` - delete whole comment block)
			-- Works also in Visual mode if mapping differs from `comment_visual`
			textobject = "<leader>c",
		},
	},
}
