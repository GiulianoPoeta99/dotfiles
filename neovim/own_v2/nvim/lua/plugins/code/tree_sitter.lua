return {
   "nvim-treesitter/nvim-treesitter",
   config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
         -- ensure_installed = {
         --    "lua",
         --    "javascript",
         -- },
         auto_install = true,
         highlight = { enable = true },
         indent = { enable = true },
      })
   end,
}
