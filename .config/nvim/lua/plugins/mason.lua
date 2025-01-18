-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "pyright",
        "clangd",
        "ts_ls",
        "astro",
        "intelephense",
        "zls",
        "jdtls",
        "kotlin_language_server",
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        "gofumpt",
        "goimports_reviser",
        "golines",
        "mypy",
        "ruff",
        "black",
        "clang-format", -- cpp/java
        "eslint_d",
        "prettier",
        "phpcs",
        "php-cs-fixer",
        "checkstyle",
        "ktfmt",
        "ktlint",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "codelldb", -- rust/cpp/zig
        "go-debug-adapter",
        "debugpy",
        "js-debug-adapter",
        "php-debug-adapter",
        "java-debug-adapter",
        "kotlin-debug-adapter",
      },
    },
  },
}
