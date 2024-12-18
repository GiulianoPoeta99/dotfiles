-- return {
--   "ellisonleao/gruvbox.nvim",
--   lazy = false, -- O podés usar 'true' si querés que se cargue bajo demanda
--   priority = 1000, -- Asegurarnos que se cargue primero
--   config = function()
--     -- Activar el esquema de colores Gruvbox en modo oscuro
--     vim.o.background = "dark" -- for dark mode
--     require("gruvbox").setup({
--       contrast = "medium", -- opciones: "soft", "medium", "hard"
--     })
--     vim.cmd("colorscheme gruvbox")
--   end,
-- }

return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_background = "medium"
		vim.g.gruvbox_material_palette = "original"
		vim.g.gruvbox_material_better_performance = 1
		vim.cmd("colorscheme gruvbox-material")
		vim.g.gruvbox_material_enable_italic = true
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
