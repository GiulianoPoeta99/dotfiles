-- setup treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"heex",
				"html",
				"css",
				"javascript",
				"typescript",
				"json",
				"query",
				"sql",
				"java",
				"kotlin",
				"xml",
				"yaml",
				"python",
				"php",
				"c",
				"elixir",
				"rust",
				"toml",
				"go",
			},
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
