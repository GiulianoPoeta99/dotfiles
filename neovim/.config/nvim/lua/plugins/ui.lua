return {
  {
    -- THEME
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
