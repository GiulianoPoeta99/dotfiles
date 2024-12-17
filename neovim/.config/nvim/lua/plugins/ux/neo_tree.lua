return {
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
   },
   config = function()
      local command = require("neo-tree.command")
      vim.keymap.set("n", "<leader>fE", function()
         command.execute({ toggle = true, dir = vim.uv.cwd() })
      end)
      vim.keymap.set("n", "<leader>E", function()
         command.execute({ toggle = true, dir = vim.uv.cwd() })
      end)
      vim.keymap.set("n", "<leader>ge", function()
         command.execute({ source = "git_status", toggle = true })
      end)
      vim.keymap.set("n", "<leader>be", function()
         command.execute({ source = "buffers", toggle = true })
      end)
   end,
}

