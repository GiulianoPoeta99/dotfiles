import os
import subprocess
from libqtile import layout, hook, bar, widget, layout
from libqtile.config import Match, Key, Group, Click, Drag, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from modules.themes.bluloco import bluloco
from modules.subprocess import count_screens

#! Constantes ==========================================================================================================
COLORS = bluloco()
FONT="FiraCode Nerd Font Mono"
FONT_SIZE=13

# lazy objects
LAZY = lazy
LAYOUT = lazy.layout
WINDOW = lazy.window
GROUP = lazy.group
SCREEN = lazy.screen

# Botones
MOD = "mod4" # this is everything
ALT = "mod1" # special
CONTROL = "control" # control
SHIFT = "shift" # alt

# Combinaciones
LEADER = [MOD] # acciones principales

ALT_PRIMARY = [MOD, ALT]
ORDER       = [MOD, CONTROL]             # ordenar tiles 
ALT_ORDER   = [MOD, ALT, CONTROL]        # ordenar tiles alternativo
MODIFY      = [MOD, SHIFT]               # modificar tiles
ALT_MODIFY  = [MOD, ALT, SHIFT] 
SYSTEM      = [MOD, CONTROL, SHIFT] 
ALT_SYSTEM  = [MOD, ALT, CONTROL, SHIFT] # acciones del sistema alternativo (sensibles)

LEFT = "Left"
RIGHT = "Right"
DOWN = "Down"
UP = "Up"

TERMINAL = guess_terminal()
BROWSER = "brave"
EXPLORER = "nautilus"
STORE = "gnome-software"
EDITOR = "code"
DB = "dbeaver"

#! con esto se definen todos los binds de qtile ========================================================================
#TODO: esto falta
# [
#     LAYOUT.flip_down(),
#     LAYOUT.flip_up(),
#     LAYOUT.flip_left(),
#     LAYOUT.flip_right(),
#     LAYOUT.swap_column_left(),
#     LAYOUT.swap_column_right(),
#     LAYOUT.swap_left(),
#     LAYOUT.swap_right(),
#     LAYOUT.grow(),
#     LAYOUT.shrink(),
#     LAYOUT.maximize(),
#     LAYOUT.flip(),
# ]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
# for vt in range(1, 8):
#     keys.append(
#         Key(
#             ["control", "mod1"],
#             f"f{vt}",
#             lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
#             desc=f"Switch to VT{vt}",
#         )
#     )

keys = [ 
    # esto se puede mejorar con keychords, modes y chains
    # https://docs.qtile.org/en/stable/manual/config/keys.html
    #* Aplicaciones 
    Key(LEADER,"Return", LAZY.spawn(TERMINAL), desc="Launch terminal"), # TODO: cambiar a t
    Key(LEADER,"b", LAZY.spawn(BROWSER), desc="Launch browser"),
    Key(LEADER,"f", LAZY.spawn(EXPLORER), desc="Launch File explorer"),
    Key(LEADER,"s", LAZY.spawn(STORE), desc="Launch App store"),
    Key(LEADER,"t", LAZY.spawn(EDITOR), desc="Launch Text editor"), # TODO: cambiar a c
    Key(LEADER,"d", LAZY.spawn(DB), desc="Launch Database manager"),
    Key(LEADER,"r", LAZY.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(LEADER,"q", WINDOW.kill(), desc="Kill focused window"), 
    #* Movilidad 
    Key(LEADER, LEFT, LAYOUT.left(), desc="Move focus to left"), 
    Key(LEADER, RIGHT, LAYOUT.right(), desc="Move focus to right"),
    Key(LEADER, DOWN, LAYOUT.down(), desc="Move focus down"),
    Key(LEADER, UP, LAYOUT.up(), desc="Move focus up"),    
    # Key(LEADER, "space", LAYOUT.next(), desc="Move window focus to other window"),
    #* pantallas
    Key(LEADER,     "space",   LAZY.next_screen(),         desc="Move window focus to the next screen"),
    Key(ALT_PRIMARY, "space",  LAZY.prev_screen(),         desc="Move window focus to the previus screen"),
    #* grupos 
    Key(ALT_PRIMARY, LEFT,     SCREEN.prev_group(),        desc="Move focus to left group"), 
    Key(ALT_PRIMARY, RIGHT,    SCREEN.next_group(),        desc="Move focus to right group"),
    Key(ALT_PRIMARY, DOWN,     GROUP.prev_window(),        desc="Switch focus to previous window in group"),
    Key(ALT_PRIMARY, UP,       GROUP.next_window(),        desc="Switch focus to next window in group"),
    #* Redimensionar 
    Key(MODIFY,      LEFT,     LAYOUT.grow_left(),         desc="Grow window to the left"), 
    Key(MODIFY,      RIGHT,    LAYOUT.grow_right(),        desc="Grow window to the right"),
    Key(MODIFY,      DOWN,     LAYOUT.grow_down(),         desc="Grow window down"),
    Key(MODIFY,      UP,       LAYOUT.grow_up(),           desc="Grow window up"),
    Key(MODIFY,      "space",  LAYOUT.increase_ratio(),    desc="Increase the space for master window"),
    Key(ALT_MODIFY,  "space",  LAYOUT.decrease_ratio(),    desc="Decrease the space for master window"),
    Key(MODIFY,      "r",      LAYOUT.normalize(),         desc="Reset all window sizes"),
    #* Acomodar 
    Key(ORDER, LEFT, LAYOUT.shuffle_left(), desc="Move window to the left"), 
    Key(ORDER, RIGHT, LAYOUT.shuffle_right(), desc="Move window to the right"),
    Key(ORDER, DOWN, LAYOUT.shuffle_down(), desc="Move window down"),
    Key(ORDER, UP, LAYOUT.shuffle_up(), desc="Move window up"),
    Key(ORDER, "f", WINDOW.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key(ORDER, "t", WINDOW.toggle_floating(), desc="Toggle floating on the focused window"),
    Key(ALT_ORDER, UP, WINDOW.move_up(), desc="Move the window above the next window"),
    Key(ALT_ORDER, DOWN, WINDOW.move_down(), desc="Move the window below the previous window"),
    Key(ALT_ORDER, "space", WINDOW.move_to_top(), desc="Move the window above all"),
    Key(ALT_ORDER, "space", WINDOW.move_to_bottom(), desc="Move the window below all"),
    Key(ORDER, "x", WINDOW.keep_above(), desc="Keep window above other windows"),
    Key(ALT_ORDER, "x", WINDOW.keep_below(), desc="Keep window below other windows"),
    Key(ALT_ORDER, "f", WINDOW.bring_to_front(), desc="Toggle fullscreen on the focused window"), #* faltan los dropdown
    #* Layout 
    Key(ORDER, "Tab", LAZY.next_layout(), desc="Move next layouts"), 
    Key(ALT_ORDER, "Tab", LAZY.prev_layout(), desc="Move previus layouts"),
    Key(ORDER, "Return", LAYOUT.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    #* Control de sistema 
    Key(SYSTEM, "r", LAZY.reload_config(), desc="Reload the config"), 
    Key(SYSTEM, "q", LAZY.shutdown(), desc="Shutdown Qtile"),
]

#* aca se definen los usos del mouse
mouse = [
    Drag( LEADER, "Button1", WINDOW.set_position_floating(), start=WINDOW.get_position()),
    Drag( LEADER, "Button3", WINDOW.set_size_floating(), start=WINDOW.get_size()),
    Click(LEADER, "Button2", WINDOW.bring_to_front()),
]

#! aca se definen los grupos y sus binds ===============================================================================
group_data = {
    '1': {'layout': 'treetab', 'label': ''},
    '2': {'layout': 'monadtall', 'label': '󰙯'},
    '3': {'layout': 'monadtall', 'label': ''},
    '4': {'layout': 'monadtall', 'label': '󰆼'},
    '5': {'layout': 'monadtall', 'label': ''},
    '6': {'layout': 'monadtall', 'label': '1'},
    '7': {'layout': 'monadtall', 'label': '2'},
    '8': {'layout': 'monadtall', 'label': '3'},
    '9': {'layout': 'monadtall', 'label': '4'},
    '0': {'layout': 'max', 'label': ''}
}
groups = []
for name, data in group_data.items():
    groups.append(Group(name=name, layout=data['layout'], label=name))
    keys.extend([
        Key(LEADER, name, GROUP[name].toscreen(), desc=f"Switch to group {name}"),
        Key(ORDER, name, WINDOW.togroup(name, switch_group=False), desc=f"Switch to & move focused window to group {name}"),
    ])

#! aca se definen los layouts y sus configs ============================================================================

global_config = {
    'border_focus': '#D84610', # Border colour(s) for the focused window.
    'border_normal': '#000000', # Border colour(s) for un-focused windows.
    'border_width': 2, # Border width.
    'margin': 8, # Margin of the layout
}

layouts = [
    layout.MonadTall( # sirve buena mov 
        single_border_width = 2, # Border width for single window
        single_margin = 8, # Margin size for single window
        **global_config #* si paso esto como kwargs me ahorro espacio
    ),
    layout.TreeTab( # SUPER GOD
        active_bg = '#000080', # Background color of active tab
        active_fg = '#ffffff', # Foreground color of active tab
        inactive_bg = '#606060', # Background color of inactive tab
        inactive_fg = '#ffffff', # Foreground color of inactive tab
        urgent_bg = '#ff0000', # Background color of urgent tab
        urgent_fg = '#ffffff', # Foreground color of urgent tab
        bg_color = '#000000', # Background color of tabs
        section_fg = 'ffffff', # Color of section label
        border_width = 2, # Width of the border
        font = FONT, # Font
        fontsize = FONT_SIZE, # Font pixel size.
        padding_left = 8, # Left padding for tabs
        padding_x = 8, # Left padding for tab label
        padding_y = 6, # Top padding for tab label
        vspace = 1, # Space between tabs
        level_shift = 8, # Shift for children tabs
        sections = ["Tabs"], # Titles of section instances
        section_fontsize = 10, # Font pixel size of section label
        section_top = 8, # Top margin of section label
        section_bottom = 8, # Bottom margin of section
        previous_on_rm = True, # Focus previous window on close instead of first.
        panel_width = 190, # Width of the left panel
    ),
    layout.Bsp(),
    layout.Columns(),
    layout.Matrix(),
    layout.Max(),
    layout.MonadThreeCol(),
    layout.MonadWide(),
    layout.RatioTile()
]

#! definimos un estandar para los widgets ==============================================================================
widget_defaults = dict(
    font=FONT,
    fontsize=FONT_SIZE,
    padding=3,
)
extension_defaults = widget_defaults.copy()

def def_widgets(i):
    return [
        widget.TextBox(str(i)),
        widget.Sep(),
        widget.GroupBox(),
        widget.Sep(),
        widget.WindowName(),
        widget.Prompt(),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        widget.Sep(),
        widget.CurrentLayout(),
        widget.Sep(),    
        # widget.StatusNotifier(),
        # widget.Systray(), #! no funciona en ambos (solo muestra el idioma, es raro)
        widget.Clock(format="%d/%m/%Y %H:%M:%S"), # DD/MM/YYYY hh:mm:ss
        widget.Sep(),
        # widget.Backlight(), #TODO: hay que hacerlo andar
        # widget.Sep(),
        widget.QuickExit(
            default_text='[]', 
            countdown_format='[{}]',
            countdown_start=7,
            foreground='#FF004A'
        ),
    ]

#! definimos las pantallas y sus caracteristicas =======================================================================

def default_screen(monitor: str) -> Screen:
    return Screen(
        wallpaper='~/.config/qtile/modules/wallpapers/wallpaper.jpg',
        wallpaper_mode='fill',
        top=bar.Bar(
            def_widgets(monitor),
            26,
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    )

num_screens = count_screens()
if (num_screens > 0):
    screens_list = []
    for i in range(num_screens):
        screens_list.append(default_screen(str(i+1)))
else :
    screens_list = [default_screen('ERROR')]

screens = screens_list


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"), # gitk
        Match(wm_class="makebranch"), # gitk
        Match(wm_class="maketag"), # gitk
        Match(wm_class="ssh-askpass"), # ssh-askpass
        Match(title="branchdialog"), # gitk
        Match(title="pinentry"), # GPG key password entry
    ],
    border_focus = '#D84610', # Border colour(s) for the focused window.
    border_normal = '#000000', # Border colour(s) for un-focused windows.
    border_width = 1, # Border width.
    fullscreen_border_width = 0, # Border width for fullscreen.
    max_border_width = 0 # Border width for maximize.
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

#* este hook ejecuta una unica vez el script de inicio de sistema
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])
