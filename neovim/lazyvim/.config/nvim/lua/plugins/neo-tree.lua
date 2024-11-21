return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Esto hace que los archivos ocultos sean visibles
        hide_dotfiles = false, -- No ocultar archivos que comiencen con un punto
        hide_gitignored = true, -- Ocultar archivos ignorados por Git
      },
    },
  },
}
