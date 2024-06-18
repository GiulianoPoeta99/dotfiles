-- setup theme
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		"uloco/bluloco.nvim",
		lazy = false,
		priority = 1000,
		dependencies = { "rktjmp/lush.nvim" },
		-- config = function()
		-- 	vim.cmd.colorscheme("bluloco-dark")
		-- end,
	},
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 1000,
		-- config = function()
		-- 	vim.cmd.colorscheme("dracula")
		-- end,
	},
	{
		"zaldih/themery.nvim",
		config = function()
			require("themery").setup({
				themes = {
					{
						name = "Catppuccin latte",
						colorscheme = "catppuccin-latte",
					},
					{
						name = "Catppuccin frappe",
						colorscheme = "catppuccin-frappe",
					},
					{
						name = "Catppuccin macchiato",
						colorscheme = "catppuccin-macchiato",
					},
					{
						name = "Catppuccin mocha",
						colorscheme = "catppuccin-mocha",
					},
					{
						name = "Bluloco dark",
						colorscheme = "bluloco-dark",
					},
					{
						name = "Bluloco light",
						colorscheme = "bluloco-light",
					},
					{
						name = "Dracula",
						colorscheme = "dracula",
					},
					{
						name = "Dracula Soft",
						colorscheme = "dracula-soft",
					},
				},
			})
		end,
	},
}
