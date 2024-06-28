from libqtile import widget
from libqtile.config import Key, Group
from libqtile.lazy import lazy

# Botones
MOD = "mod4" # this is everything
ALT = "mod1" # special
CONTROL = "control" # control
SHIFT = "shift" # alt

# Combinaciones
LEADER = [MOD] # acciones principales
ALT_LEADER = [MOD, ALT] # acciones principales inversas
ORDER = [MOD, CONTROL] # ordenar tiles 
SIZE = [MOD, SHIFT] # modificar tiles
ALT_SIZE = [MOD, ALT, SHIFT] # modificar tiles inversas

keys = []

NUM_SCREENS = 2
NUM_GROUPS = 9
GROUP_MAP = {}
GROUP_LIST = []

# Here we create two objects:
# 1) A dict, "GROUP_MAP", which has a key relating to the screen index. The value is another dict
#    where groups are numbered from 1 to NUM_GROUPS. The value is a unique group name.
# 2) A list of all groups. Each group has a unique name but the label is between 1 and NUM_GROUPS

for screen in range(NUM_SCREENS):
    screen_dict = {}
    for group in range(NUM_GROUPS):
        name = f"{screen * NUM_GROUPS + group}"
        group_num = group + 1
        screen_dict[group_num] = name
        GROUP_LIST.append(Group(name, label=str(group_num)))
    GROUP_MAP[screen] = screen_dict

GROUP_LIST = [
    Group(0, label=str(1)),
    Group(1, label=str(2)),
    Group(2, label=str(3)),
    Group(3, label=str(4)),
    Group(4, label=str(5)),
    Group(5, label=str(6)),
    Group(6, label=str(7)),
    Group(7, label=str(8)),
    Group(8, label=str(9)),
    Group(9, label=str(10)),
    Group(10, label=str(1)),
    Group(11, label=str(2)),
    Group(12, label=str(3)),
    Group(13, label=str(4)),
    Group(14, label=str(5)),
    Group(15, label=str(6)),
    Group(16, label=str(7)),
    Group(17, label=str(8)),
    Group(18, label=str(9)),
    Group(19, label=str(10)),
]

GROUP_MAP[0] = {
    '1': 0,
    '2': 1,
    '3': 2,
    '4': 3,
    '5': 4,
    '6': 5,
    '7': 6,
    '8': 7,
    '9': 8,
    '10': 9,
}

GROUP_MAP[1] = {
    '1': 10,
    '2': 11,
    '3': 12,
    '4': 13,
    '5': 14,
    '6': 15,
    '7': 16,
    '8': 17,
    '9': 18,
    '10': 19,
}



@lazy.function
def switch_group(qtile, group_num):
    """
    This function looks up the unique group name for group number on the current screen
    and then displays that group.
    """
    group_name = GROUP_MAP[qtile.current_screen.index][group_num]
    qtile.groups_map[group_name].toscreen()


@lazy.window.function
def move_window_to_group(window, group_num, switch_group=False, toggle=False):
    """
    This function looks up the unique group name for group number on the current screen
    and then moves the window to that group.
    """   
    group_name = GROUP_MAP[window.qtile.current_screen.index][group_num]
    window.togroup(group_name, switch_group, toggle)

# Groups should be set to our group list
groups = GROUP_LIST

# We bind keys mod + 1-8 to call our function to display a group depending on the focused screen
# mod + shift + 1-8 moves window to that group on the active screen
for i in range(NUM_GROUPS):
    keys.append(Key(LEADER, str(i+1), switch_group(i+1)))
    keys.append(Key(SIZE, str(i+1), move_window_to_group(i+1, switch_group=True)))

# mod + control + 1-3 moves window to current group on that screen
for i in range(NUM_SCREENS):
    keys.append(Key(ORDER, str(i+1), lazy.window.toscreen(i)))


#! For the GroupBox widget, you'll need to set visible_groups to GROUP_MAP[screen_index].values() for each screen where screen_index starts at 0.