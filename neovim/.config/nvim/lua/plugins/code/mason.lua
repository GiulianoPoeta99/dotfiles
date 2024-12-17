return {
   {
      "williamboman/mason.nvim",
      config = function()
         require("mason").setup({
            ensure_installed = {
               "lua_ls",
               "stylua",
            },
         })
      end,
   },
   {
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup()
      end,
   },
}

