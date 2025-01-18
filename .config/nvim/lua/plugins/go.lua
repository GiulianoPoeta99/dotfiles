return {
  "olexsmir/gopher.nvim",
  ft = "go",
  config = function(_, opts)
    require("gopher").setup(opts)
    require("core.utils").load_mappings "gopher"
  end,
  build = function() vim.cmd [[silent! GoInstallDeps]] end,
}
