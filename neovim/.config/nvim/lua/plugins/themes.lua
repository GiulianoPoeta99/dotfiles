-- setup theme
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
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
