import os
import sys
import shutil
import xml.etree.ElementTree as ET

"""
# usage ========================================================================
python3 ./config_xfce4.py username
# ==============================================================================
"""

# ==============================================================================
def set_home_dir():
    home_dir = ""

    if len(sys.argv) != 2:
        print("Please input username!")
    else:
        # ~jungs
        cmd = "~{}".format(sys.argv[1])
        # /home/jungs
        home_dir = os.path.expanduser(cmd)

    return home_dir
# ==============================================================================

# ==============================================================================
def get_child_elem(parent_elem, child_attrib_name):
    for child_elem in parent_elem:
        # print(child_elem.get("name"))
        if child_elem.get("name") != child_attrib_name: continue

        return child_elem
# ==============================================================================

# ==============================================================================
def get_family_elem_list(elem, name_path):
    family_elem_list = []

    name_list = name_path.split("/")
    if not name_list: return family_elem_list

    for cur_name in name_list:
        # print("=" * 40)
        elem = get_child_elem(elem, cur_name)
        family_elem_list.append(elem)

    return family_elem_list
# ==============================================================================

# ==============================================================================
def indent(elem, level=0):
    i = "\n" + level * "  "

    if len(elem):
        if (not elem.text) or (not elem.text.strip()):
            elem.text = i + "  "
        if (not elem.tail) or (not elem.tail.strip()):
            elem.tail = i
        for elem in elem:
            indent(elem, level+1)
        if (not elem.tail) or (not elem.tail.strip()):
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i
# ==============================================================================

# ==============================================================================
def get_bk_dir(dst_dir):
    ''' ~/temp/dst >> ~/temp/_backup/dst_0001 '''

    # 1) bk_parent_dir, dir_basename -------------------------------------------
    parent_dir = os.path.dirname(dst_dir)
    bk_parent_dir = f"{parent_dir}/_bakcup"

    if not os.path.isdir(bk_parent_dir):
        os.makedirs(bk_parent_dir)
        
    dir_basename = os.path.basename(dst_dir)

    # 2) bk_dir ----------------------------------------------------------------
    num = 1

    while True:
        suffix = f"{num:04d}"
        bk_dir = f"{bk_parent_dir}/{dir_basename}_{suffix}"

        if os.path.isdir(bk_dir):
            num += 1
        else:
            return bk_dir
# ==============================================================================

# ==============================================================================
def get_bk_path(dst_path):
    ''' ~/temp/dst.txt >> ~/temp/_backup/dst0001.txt '''
    
    # 1) bk_parent_dir ---------------------------------------------------------
    dst_dir = os.path.dirname(dst_path)
    bk_parent_dir = f"{dst_dir}/_bakcup"

    if not os.path.isdir(bk_parent_dir):
        os.makedirs(bk_parent_dir)
    
    # 2) dst_basename, dst_fname, dst_ext --------------------------------------
    dst_basename = os.path.basename(dst_path)
    dst_fname = dst_basename.split(".")[0]
    dst_ext = dst_basename.split(".")[-1]

    # 3) bk_path ---------------------------------------------------------------
    num = 1

    while True:
        suffix = f"{num:04d}"
        bk_path = f"{bk_parent_dir}/{dst_fname}_{suffix}.{dst_ext}"

        if os.path.isfile(bk_path):
            num += 1
        else:
            return bk_path
# ==============================================================================

# ==============================================================================
def config_settings(prop_dict, dst_path):
    if not os.path.isfile(dst_path): return

    elem_tree = ET.parse(dst_path)
    root_elem = elem_tree.getroot()

    for name_path in prop_dict:
        # 1) get elements ------------------------------------------------------
        elem_list = get_family_elem_list(root_elem, name_path)
        # print(elem_list)
        if len(elem_list) == 1:
            parent_elem = root_elem
        else:
            parent_elem = elem_list[-2]
        son_elem = elem_list[-1]

        # 2) fix elements-------------------------------------------------------
        cur_dict = prop_dict[name_path]
        # print(cur_dict)

        if son_elem == None:            # elem 추가
            son_elem = ET.SubElement(parent_elem, "property")
            son_elem.attrib = cur_dict
        elif cur_dict["name"] == "":    # elem 삭제
            parent_elem.remove(son_elem)
        else:                           # elem attrib 수정
            son_elem.attrib = cur_dict

    # 3) check results ---------------------------------------------------------
    indent(root_elem)
    # ET.dump(root_elem)

    # 4) backup dst-file -------------------------------------------------------
    bk_path = get_bk_path(dst_path)
    shutil.copy2(dst_path, bk_path)

    # 5) apply results ---------------------------------------------------------
    elem_tree.write(dst_path, encoding="utf-8", xml_declaration=True)
# ==============================================================================

# ==============================================================================
def check_xsettings(dst_path):
    if os.path.isfile(dst_path): return

    xsettings_cmd='''<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="empty"/>
    <property name="IconThemeName" type="string" value="Tango"/>
    <property name="DoubleClickTime" type="empty"/>
    <property name="DoubleClickDistance" type="empty"/>
    <property name="DndDragThreshold" type="empty"/>
    <property name="CursorBlink" type="empty"/>
    <property name="CursorBlinkTime" type="empty"/>
    <property name="SoundThemeName" type="empty"/>
    <property name="EnableEventSounds" type="empty"/>
    <property name="EnableInputFeedbackSounds" type="empty"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="empty"/>
    <property name="Antialias" type="empty"/>
    <property name="Hinting" type="empty"/>
    <property name="HintStyle" type="empty"/>
    <property name="RGBA" type="empty"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="empty"/>
    <property name="ColorPalette" type="empty"/>
    <property name="FontName" type="empty"/>
    <property name="MonospaceFontName" type="empty"/>
    <property name="IconSizes" type="empty"/>
    <property name="KeyThemeName" type="empty"/>
    <property name="ToolbarStyle" type="empty"/>
    <property name="ToolbarIconSize" type="empty"/>
    <property name="MenuImages" type="empty"/>
    <property name="ButtonImages" type="empty"/>
    <property name="MenuBarAccel" type="empty"/>
    <property name="CursorThemeName" type="empty"/>
    <property name="CursorThemeSize" type="empty"/>
    <property name="DecorationLayout" type="empty"/>
    <property name="DialogsUseHeader" type="empty"/>
    <property name="TitlebarMiddleClick" type="empty"/>
  </property>
  <property name="Gdk" type="empty">
    <property name="WindowScalingFactor" type="empty"/>
  </property>
</channel>
'''

    f = open(dst_path, "w")
    f.write(xsettings_cmd)
    f.close()
# ==============================================================================


# xfce4-shortcuts 수정 =========================================================
home_dir = set_home_dir()
dst_path = f"{home_dir}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"

prop_dict = \
{
    # --------------------------------------------------------------------------
    "xfwm4/custom/<Super>KP_Up" : {"name":"<Super>Up", "type":"string", "value":"tile_up_key"},
    "xfwm4/custom/<Super>KP_Down" : {"name":"<Super>Down", "type":"string", "value":"tile_down_key"},
    "xfwm4/custom/<Super>KP_Left" : {"name":"<Super>Left", "type":"string", "value":"tile_left_key"},
    "xfwm4/custom/<Super>KP_Right" : {"name":"<Super>Right", "type":"string", "value":"tile_right_key"},
    # --------------------------------------------------------------------------
    "xfwm4/custom/<Primary><Alt>d" : {"name":"<Super>d", "type":"string", "value":"show_desktop_key"},
    # --------------------------------------------------------------------------
    "xfwm4/custom/<Super>Tab" : {"name":"", "type":"string", "value":"switch_window_key"},
    "commands/custom/<Super>Tab" : {"name":"<Super>Tab", "type":"string", "value":"/usr/bin/skippy-xd"},
    # --------------------------------------------------------------------------
    "commands/custom/<Super>i" : {"name":"<Super>i", "type":"string", "value":"xfce4-settings-manager"},
    "commands/custom/<Alt>F2" : {"name":"<Primary>space", "type":"string", "value":"xfce4-appfinder --collapsed"},
    "commands/custom/<Alt>F3" : {"name":"<Alt>F2", "type":"string", "value":"xfce4-appfinder"},
    # --------------------------------------------------------------------------
    "commands/custom/<Primary>Escape" : {"name":"", "type":"string", "value":"xfdesktop --menu"},
    "commands/custom/<Alt>F1" : {"name":"<Primary>Escape", "type":"string", "value":"xfce4-popup-applicationsmenu"},
    # --------------------------------------------------------------------------
    "commands/custom/<Primary><Alt>l" : {"name":"<Super>l", "type":"string", "value":"xscreensaver"},
    # --------------------------------------------------------------------------
}

config_settings(prop_dict, dst_path)
# ==============================================================================


# wockspace-scroll / workspace-count 수정 ======================================
home_dir = set_home_dir()
dst_path = f"{home_dir}/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"

prop_dict = \
{
    "general/scroll_workspaces" : {"name":"scroll_workspaces", "type":"bool", "value":"false"},
    "general/workspace_count" : {"name":"workspace_count", "type":"int", "value":"2"},
}

config_settings(prop_dict, dst_path)
# ==============================================================================


# panel 설정 ===================================================================
xfce4_panel_dir = "/core/linux/bin/de/xfce4/panel";
xfce4_panel_path = "/core/linux/bin/de/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml";

home_dir = set_home_dir()
dst_dir = f"{home_dir}/.config/xfce4/panel"
dst_path = f"{home_dir}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"

if os.path.isdir(xfce4_panel_dir) and os.path.isfile(xfce4_panel_path):
    # xfce4_panel_dir ----------------------------------------------------------
    if os.path.isdir(dst_dir):
        bk_dir = get_bk_dir(dst_dir)
        shutil.copytree(dst_dir, bk_dir)

    shutil.rmtree(dst_dir)
    shutil.copytree(xfce4_panel_dir, dst_dir)
    # --------------------------------------------------------------------------

    # xfce4_panel_path ---------------------------------------------------------
    if os.path.isfile(dst_path):
        bk_path = get_bk_path(dst_path)
        shutil.copy2(dst_path, bk_path)

    shutil.copy2(xfce4_panel_path, dst_path)
    # --------------------------------------------------------------------------
else:
    # clock --------------------------------------------------------------------
    prop_dict = \
    {
        "plugins/plugin-12/digital-layout" : {"name":"digital-layout", "type":"uint", "value":"1"},
        "plugins/plugin-12/digital-date-format" : {"name":"digital-date-format", "type":"string", "value":"%y-%m-%d (%a)"},
        "plugins/plugin-12/digital-time-format" : {"name":"digital-time-format", "type":"string", "value":"%I:%M %p"},
    }
    config_settings(prop_dict, dst_path)
    # --------------------------------------------------------------------------
# ==============================================================================


# theme 수정 ===================================================================
home_dir = set_home_dir()
dst_path = f"{home_dir}/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"

check_xsettings(dst_path);

if os.path.isdir("/usr/share/icons/Papirus"):
    prop_dict = {"Net/IconThemeName" : {"name":"IconThemeName", "type":"string", "value":"Papirus"}}
elif os.path.isdir("/usr/share/icons/Adwaita"):
    prop_dict = {"Net/IconThemeName" : {"name":"IconThemeName", "type":"string", "value":"Adwaita"}}
else:
    prop_dict = {"Net/IconThemeName" : {"name":"IconThemeName", "type":"string", "value":"Tango"}}

config_settings(prop_dict, dst_path);
# ==============================================================================


# default applications 설정 ====================================================
home_dir = set_home_dir()
dst_path = f"{home_dir}/.config/xfce4/helpers.rc"

if not os.path.isfile(dst_path):
    data = "TerminalEmulator=xfce4-terminal"
    f = open(dst_path, "w")
    f.write(data)
    f.close()
# ==============================================================================
