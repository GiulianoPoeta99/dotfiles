-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "json",
      "yaml",
      "toml",
      "lua",
      "vim",
      "rust",
      "ron",
      "go",
      "python",
      "rst",
      "ninja",
      "cpp",
      "typescript",
      "astro",
      "svelte",
      "css",
      "php",
      "zig",
      "java",
      "kotlin",
    },
  },
}
