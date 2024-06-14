-- setup theme
return {
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'catppuccin'
                }
            })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    },
    {
        'uloco/bluloco.nvim',
        lazy = false,
        priority = 1000,
        dependencies = { 'rktjmp/lush.nvim' },
    },
    {
        'zaldih/themery.nvim',
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
                    }
                }
            })
        end
    }
}