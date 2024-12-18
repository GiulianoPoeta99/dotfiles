return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>fgl", builtin.git_files, { desc = "Git files" })
		-- vim.keymap.set({ "n", "v" }, "<leader>fgs", builtin.grep_string, { desc = "Live grep under cursor" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old files" })
		vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
		vim.keymap.set("n", "<leader>fch", builtin.command_history, { desc = "Command history" })
		vim.keymap.set("n", "<leader>fsh", builtin.search_history, { desc = "Search history" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
	end,
}
