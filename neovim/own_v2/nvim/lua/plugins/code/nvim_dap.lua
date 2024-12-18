return {
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = {
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("mason-nvim-dap").setup({
			automatic_setup = true, -- Configura los adaptadores automáticamente
		})

		-- Configuración personalizada de nvim-dap
		local dap, dapui = require("dap"), require("dapui")

		dapui.setup()

		-- Eventos de DAP para manejar DAP UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Keybindings personalizados
		vim.keymap.set("n", "<Leader>b", function()
			dap.toggle_breakpoint()
		end, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>dr", function()
			dap.continue()
		end, { desc = "Start/Continue Debugging" })

		-- Adaptador para Python como ejemplo
		dap.adapters.python = {
			type = "executable",
			command = "python",
			args = { "-m", "debugpy.adapter" },
		}

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Debug Python File",
				program = "${file}", -- Archivo actual
				pythonPath = function()
					return "python"
				end,
			},
		}
	end,
}
