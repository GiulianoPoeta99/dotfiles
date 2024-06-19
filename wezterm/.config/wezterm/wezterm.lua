local wezterm = require("wezterm")

return {
	-- Deshabilitar la tab bar y el multiplexado
	enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,

	--?=====================================================================================================================
	-- Tema Catppuccin Mocha
	color_scheme = "Catppuccin Mocha",

	-- Ejemplo de transparencia
	-- window_background_opacity = 0.85,

	--?=====================================================================================================================
	-- Fuente FiraCode Nerd Font con ligaduras y emojis
	font = wezterm.font("FiraCode Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	font_size = 12.0,
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
	adjust_window_size_when_changing_font_size = false,

	--?=====================================================================================================================
	-- Scrollbar presente pero invisible
	enable_scroll_bar = true,
	-- Scrollback
	scrollback_lines = 5000,

	--?=====================================================================================================================
	-- Ejemplo de keybind
	keys = {
		-- Copiar y pegar
		-- Copiar al portapapeles
		{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
		-- Pegar desde el portapapeles
		{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },

		-- Copiar al portapapeles primario (en sistemas X11/Linux)
		{ key = "C", mods = "CTRL|ALT", action = wezterm.action({ CopyTo = "PrimarySelection" }) },
		-- Pegar desde el portapapeles primario (en sistemas X11/Linux)
		{ key = "V", mods = "CTRL|ALT", action = wezterm.action({ PasteFrom = "PrimarySelection" }) },

		-- Copiar al portapapeles y al portapapeles primario
		{ key = "C", mods = "CTRL|SHIFT|ALT", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },
		-- Pegar desde el portapapeles o portapapeles primario
		{ key = "V", mods = "CTRL|SHIFT|ALT", action = wezterm.action({ PasteFrom = "Clipboard" }) },

		-- Abrir nueva pestaña
		-- { key = "T", mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "T", mods = "CTRL|SHIFT", action = wezterm.action({ ShowLauncherArgs = { flags = "COMMANDS" } }) },

		-- Cerrar pestaña
		-- { key = "W", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "W", mods = "CTRL|SHIFT", action = wezterm.action({ ShowLauncherArgs = { flags = "COMMANDS" } }) },

		-- Navegar entre pestañas
		{ key = "PageUp", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "PageDown", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },

		-- Dividir paneles
		-- { key = "D", mods = "CTRL|SHIFT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "D", mods = "CTRL|SHIFT", action = wezterm.action({ ShowLauncherArgs = { flags = "COMMANDS" } }) },

		-- { key = "|", mods = "CTRL|SHIFT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action({ ShowLauncherArgs = { flags = "COMMANDS" } }) },
		
		-- Navegar entre paneles
		-- { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		-- { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		-- { key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		-- { key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },

		-- Mover paneles
		-- { key = "LeftArrow", mods = "CTRL|ALT", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
		-- { key = "RightArrow", mods = "CTRL|ALT", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },
		-- { key = "UpArrow", mods = "CTRL|ALT", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
		-- { key = "DownArrow", mods = "CTRL|ALT", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },

		-- Búsqueda
		{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action({ Search = { CaseSensitiveString = "" } }) },


		-- Scrollback
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action({ ScrollByPage = -1 }) },
		{ key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action({ ScrollByPage = 1 }) },
		{ key = "U", mods = "CTRL|SHIFT", action = wezterm.action({ ScrollByLine = -3 }) },
		{ key = "D", mods = "CTRL|SHIFT", action = wezterm.action({ ScrollByLine = 3 }) },

		-- Zoom del terminal
		{ key = "+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL|SHIFT", action = "DecreaseFontSize" },
		{ key = "0", mods = "CTRL|SHIFT", action = "ResetFontSize" },

		-- Mostrar comandos
		-- { key = "I", mods = "CTRL|SHIFT", action = wezterm.action({ ShowLauncherArgs = { flags = "COMMANDS" } }) },

		-- Lanzador de pestañas
		-- { key = "L", mods = "CTRL|SHIFT", action = wezterm.action({ ShowLauncherArgs = { flags = "TABS" } }) },
	},

	--?=====================================================================================================================
	-- Ejemplo de mouse binds
	mouse_bindings = {
		-- Selección de texto
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ SelectTextAtMouseCursor = "Cell" }),
		},
		{
			event = { Down = { streak = 2, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ SelectTextAtMouseCursor = "Word" }),
		},
		{
			event = { Down = { streak = 3, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ SelectTextAtMouseCursor = "Line" }),
		},

		-- -- Selección de texto y copia al portapapeles
		-- {
		--   event = {Up = {streak = 1, button = "Left"}},
		--   mods = "NONE",
		--   action = wezterm.action{CompleteSelection = "Clipboard"},
		-- },
		-- -- Selección de texto y copia al portapapeles primario (X11/Linux)
		-- {
		--   event = {Up = {streak = 1, button = "Right"}},
		--   mods = "NONE",
		--   action = wezterm.action{CompleteSelection = "PrimarySelection"},
		-- },
		-- -- Selección de texto y copia al portapapeles y al portapapeles primario
		-- {
		--   event = {Up = {streak = 1, button = "Middle"}},
		--   mods = "NONE",
		--   action = wezterm.action{CompleteSelection = "ClipboardAndPrimarySelection"},
		-- },
		-- -- Pegar desde el portapapeles
		-- {
		--   event = {Down = {streak = 1, button = "Middle"}},
		--   mods = "NONE",
		--   action = wezterm.action{PasteFrom = "Clipboard"},
		-- },

		-- -- Pegar desde el portapapeles
		-- {
		-- 	event = { Down = { streak = 1, button = "Middle" } },
		-- 	mods = "NONE",
		-- 	action = wezterm.action({ PasteFrom = "Clipboard" }),
		-- },

		-- Mover el cursor del mouse
		{
			event = { Drag = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ ExtendSelectionToMouseCursor = "Cell" }),
		},

		-- Dividir paneles (similar a key bindings)
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "CTRL|SHIFT",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "CTRL|ALT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
	},

	--?=====================================================================================================================
	-- Configuración de WSL y SSH
	default_prog = (wezterm.target_triple == "x86_64-pc-windows-msvc" and { "wsl.exe" } or nil),

	--   * si algun dia hago lo del server remoto de desarrollo con esta config puedo hacer un quickaccess
	--   ssh_domains = {
	--     {
	--       name = "myserver",
	--       remote_address = "my.server.com",
	--       username = "myuser",
	--     },
	--   },

	--?=====================================================================================================================
	-- Ejemplo de eventos y notificaciones

	-- wezterm.on("bell", function(window, pane)
	-- 	window:toast_notification("WezTerm", "Bell triggered", nil, 4000)
	-- end),

	-- wezterm.on("window-config-reloaded", function(window, pane)
	-- 	wezterm.log_info("Window configuration reloaded!")
	-- 	window:toast_notification("WezTerm", "Window configuration reloaded!", nil, 4000)
	-- end),

	-- wezterm.on("config-reloaded", function()
	-- 	wezterm.log_info("Configuration reloaded")
	-- 	window:toast_notification("WezTerm", "Configuration reloaded!", nil, 4000)
	-- end),

	-- wezterm.on("clipboard", function(window, pane, data)
	-- 	wezterm.log_info("Clipboard event: ", data)
	-- end),

	--?=====================================================================================================================
	-- Clipboard
	selection_word_boundary = " \t\n{}[]()\"'`,;:!?.",

	-- --?=====================================================================================================================
	--   -- Configuración de búsqueda
	--   search = {

	--     case_sensitive = "Smart",
	--     incremental = true,
	-- 	selection_word_boundary = " \t\n{}[]()\"'`,;:!?.",
	-- 	-- Palabras completas
	-- 	whole_word = false,
	-- 	-- Usar expresiones regulares
	-- 	regex = true,
	-- 	-- Resaltar resultados de búsqueda
	-- 	highlight_results = true,
	-- 	-- Resaltar el resultado actual
	-- 	highlight_current_result = true,
	-- 	-- Colores de resalte
	-- 	highlights = {
	-- 	  result = { fg = "#ffffff", bg = "#0000ff" }, -- Resultado de búsqueda
	-- 	  current = { fg = "#ffffff", bg = "#ff0000" }, -- Resultado actual
	-- 	},
	--   },
}
