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
		local function get_project_root()
			local current_dir = vim.uv.cwd()

			while current_dir ~= "/" do
				local git_dir = current_dir .. "/.git"
				if vim.fn.isdirectory(git_dir) == 1 then
					return current_dir
				end

				current_dir = vim.fn.fnamemodify(current_dir, ":h")
			end
			return vim.uv.cwd()
		end

		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		local command = require("neo-tree.command")
		vim.keymap.set("n", "<leader>fe", function()
			local root_dir = get_project_root()
			command.execute({ toggle = true, dir = root_dir })
		end)
		vim.keymap.set("n", "<leader>e", function()
			local root_dir = get_project_root()
			command.execute({ toggle = true, dir = root_dir })
		end)
		-- vim.keymap.set("n", "<leader>fE", function()
		-- 	command.execute({ toggle = true, dir = vim.uv.cwd() })
		-- end)
		-- vim.keymap.set("n", "<leader>E", function()
		-- 	command.execute({ toggle = true, dir = vim.uv.cwd() })
		-- end)
		vim.keymap.set("n", "<leader>ge", function()
			command.execute({ source = "git_status", toggle = true })
		end)
		vim.keymap.set("n", "<leader>be", function()
			command.execute({ source = "buffers", toggle = true })
		end)

		require("neo-tree").setup({
			close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
			sort_case_insensitive = false, -- used when sorting files and directories in the tree
			sort_function = nil, -- use a custom function for sorting files and directories in the tree

			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},
		})
	end,
}
