-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_palette = "original"
      vim.g.gruvbox_material_better_performance = 1
      -- vim.cmd("colorscheme gruvbox-material")
      vim.g.gruvbox_material_enable_italic = true
      -- vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  {
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("noice").setup {
          -- Aquí puedes configurar noice.nvim según tus necesidades
          presets = {
            bottom_search = true, -- Usa la barra de búsqueda en la parte inferior
            command_palette = true, -- Barra estilo palette para comandos
            long_message_to_split = true, -- Mensajes largos se dividen en buffers
            lsp_doc_border = true, -- Bordes alrededor de la ventana flotante del LSP
          },
        }
      end,
    },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- change colorscheme
      colorscheme = "gruvbox-material",
      -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
      highlights = {
        init = { -- this table overrides highlights in all themes
          -- Normal = { bg = "#000000" },
        },
        astrodark = { -- a table of overrides/changes when applying the astrotheme theme
          -- Normal = { bg = "#000000" },
        },
      },
      -- Icons can be configured throughout the interface
      icons = {
        -- configure the loading of the lsp in the status line
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
      },
    },
  },
}
