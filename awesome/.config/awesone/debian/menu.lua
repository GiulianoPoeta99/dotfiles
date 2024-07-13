-- automatically generated file. Do not edit (see /usr/share/doc/menu/html)

local awesome = awesome

Debian_menu = {}

Debian_menu["Debian_Applications_Science_Mathematics"] = {
	{ "Bc", "x-terminal-emulator -e " .. "/usr/bin/bc" },
	{ "Dc", "x-terminal-emulator -e " .. "/usr/bin/dc" },
}
Debian_menu["Debian_Applications_Science"] = {
	{ "Mathematics", Debian_menu["Debian_Applications_Science_Mathematics"] },
}
Debian_menu["Debian_Applications_Shells"] = {
	{ "Bash", "x-terminal-emulator -e " .. "/bin/bash --login" },
	{ "Dash", "x-terminal-emulator -e " .. "/bin/dash -i" },
	{ "Sh", "x-terminal-emulator -e " .. "/bin/sh --login" },
	{ "Zsh", "x-terminal-emulator -e " .. "/bin/zsh" },
}
Debian_menu["Debian_Applications_System_Administration"] = {
	{ "Editres", "editres" },
	{ "Xfontsel", "xfontsel" },
	{ "Xkill", "xkill" },
}
Debian_menu["Debian_Applications_System_Monitoring"] = {
	{ "Xev", "x-terminal-emulator -e xev" },
}
Debian_menu["Debian_Applications_System"] = {
	{ "Administration", Debian_menu["Debian_Applications_System_Administration"] },
	{ "Monitoring", Debian_menu["Debian_Applications_System_Monitoring"] },
}
Debian_menu["Debian_Applications"] = {
	{ "Science", Debian_menu["Debian_Applications_Science"] },
	{ "Shells", Debian_menu["Debian_Applications_Shells"] },
	{ "System", Debian_menu["Debian_Applications_System"] },
}
Debian_menu["Debian_Window_Managers"] = {
	{
		"awesome",
		function()
			awesome.exec("/usr/bin/awesome")
		end,
		"/usr/share/pixmaps/awesome.xpm",
	},
}
Debian_menu["Debian"] = {
	{ "Applications", Debian_menu["Debian_Applications"] },
	{ "Window Managers", Debian_menu["Debian_Window_Managers"] },
}

debian = { menu = { Debian_menu = Debian_menu } }
return debian

