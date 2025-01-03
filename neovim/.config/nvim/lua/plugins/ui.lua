return {
  -- {
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
  -- },
  {
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
  },
  -- {
  --   "sainnhe/everforest",
  --   lazy = false,
  --   priority = 1000, -- Asegura que se cargue antes que otros plugins
  --   config = function()
  --     vim.g.everforest_background = "hard" -- Opciones: 'soft', 'medium', 'hard'
  --     vim.g.everforest_enable_italic = 1 -- Habilita las cursivas
  --     vim.g.everforest_disable_italic_comment = 0 -- Deshabilita cursivas en comentarios
  --     vim.cmd("colorscheme everforest")
  --   end,
  -- },
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
				]],
				-- stylua: ignore
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = "󰆼 ", key = "d", desc = "DB Manager", action = ":Dbee open" },
				  { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				  { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				  { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				  { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				  { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
				  { icon = " ", key = "s", desc = "Restore Session", section = "session" },
				  { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
				  { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
				  { icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
        },
      },
    },
  },
}
