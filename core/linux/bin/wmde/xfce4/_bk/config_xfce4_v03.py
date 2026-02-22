import os
import sys
import shutil
import xml.etree.ElementTree as ET


# config_xfce4 =================================================================
# python3 f"{BIN_DIR}/wmde/xfce4/config_xfce4.py" ${CUR_USER}
# ==============================================================================

# env ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde/xfce4/config_xfce4.py
SCRIPT_PATH = os.path.abspath(__file__)

# os.getcwd()
# core/linux/bin/wmde/xfce4
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)

# core/linux/bin/wmde
WMDE_DIR = os.path.dirname(SCRIPT_DIR)

# core/linux/bin
BIN_DIR = os.path.dirname(WMDE_DIR)
# ------------------------------------------------------------------------------

# CUR_USER ---------------------------------------------------------------------
# CUR_USER = "{}".format(sys.argv[1])
CUR_USER = f"{sys.argv[1]}"
# ------------------------------------------------------------------------------

# HOME_DIR ---------------------------------------------------------------------
def set_home_dir():
    home_dir = ""

    if len(sys.argv) != 2:
        print("Please input username!")
    else:
        # ~jungs
        cmd = f"~{CUR_USER}"

        # /home/jungs
        home_dir = os.path.expanduser(cmd)

    return home_dir

HOME_DIR = set_home_dir()
# ------------------------------------------------------------------------------

# IS_MXLINUX -------------------------------------------------------------------
cmd = "cat /etc/*-release"
result = os.popen(cmd).read()

if "ID=MX" in result:   # for mxlinux
    IS_MXLINUX = True
else:
    IS_MXLINUX = False
# ------------------------------------------------------------------------------
# ==============================================================================


def get_child_elem(parent_elem, child_attrib_name):
    for child_elem in parent_elem:
        # print(child_elem.get("name"))
        if child_elem.get("name") != child_attrib_name: continue

        return child_elem
# ------------------------------------------------------------------------------

def get_family_elem_list(elem, name_path):
    family_elem_list = []

    name_list = name_path.split("/")
    if not name_list: return family_elem_list

    for cur_name in name_list:
        # print("=" * 40)
        elem = get_child_elem(elem, cur_name)
        family_elem_list.append(elem)

    return family_elem_list
# ------------------------------------------------------------------------------

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
# ------------------------------------------------------------------------------

def get_bk_dir(dst_dir):
    ''' ~/.config/temp/test  >>  ~/.config/_backup/temp/test_0001 '''

    # 1) bk_parent_dir, dir_basename -------------------------------------------
    parent_dir = os.path.dirname(dst_dir)

    if ".config" in parent_dir:                 #  ~/.config/temp  >>  ~/.config/_backup/temp
        prefix = parent_dir.split(".config")[0]
        suffix = parent_dir.split(".config")[1]
        bk_parent_dir = f"{prefix}.config/_bakcup{suffix}"
    else:                                       # ~/temp  >>  ~/temp/_backup
        bk_parent_dir = f"{parent_dir}/_bakcup"

    if not os.path.isdir(bk_parent_dir):
        os.makedirs(bk_parent_dir)

    dir_basename = os.path.basename(dst_dir)

    # 2) bk_dir ----------------------------------------------------------------
    num = 1

    while True:
        padding = f"{num:04d}"
        bk_dir = f"{bk_parent_dir}/{dir_basename}_{padding}"

        if os.path.isdir(bk_dir):
            num += 1
        else:
            return bk_dir
# ------------------------------------------------------------------------------

def get_bk_path(dst_path):
    ''' ~/.config/temp/dst.txt  >>  ~/.config/_backup/temp/dst_0001.txt '''

    # 1) bk_parent_dir ---------------------------------------------------------
    dst_dir = os.path.dirname(dst_path)
    if ".config" in dst_dir:                    #  ~/.config/temp  >>  ~/.config/_backup/temp
        prefix = dst_dir.split(".config")[0]
        suffix = dst_dir.split(".config")[1]
        bk_parent_dir = f"{prefix}.config/_bakcup{suffix}"
    else:                                       # ~/temp  >>  ~/temp/_backup
        bk_parent_dir = f"{dst_dir}/_bakcup"

    if not os.path.isdir(bk_parent_dir):
        os.makedirs(bk_parent_dir)

    # 2) dst_basename, dst_fname, dst_ext --------------------------------------
    dst_basename = os.path.basename(dst_path)
    if "." in dst_basename:
        dst_fname = dst_basename.split(".")[0]
        dst_ext = dst_basename.split(".")[-1]
    else:
        dst_fname = dst_basename
        dst_ext = ""

    # 3) bk_path ---------------------------------------------------------------
    num = 1

    while True:
        padding = f"{num:04d}"
        bk_path = f"{bk_parent_dir}/{dst_fname}_{padding}.{dst_ext}"

        if os.path.isfile(bk_path):
            num += 1
        else:
            return bk_path
# ------------------------------------------------------------------------------

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
        # ----------------------------------------------------------------------

        # 2) append elements / delete elements / fix elements ------------------
        # {"name":"<Super>Down", "type":"string", "value":"tile_down_key"}
        cur_dict = prop_dict[name_path]

        if son_elem == None:            # append son elem (new elem)
            if cur_dict["name"] == "": continue

            son_elem = ET.SubElement(parent_elem, "property")
            son_elem.attrib = cur_dict
            # print("append", cur_dict)

        elif cur_dict["name"] == "":    # delete son elem
            parent_elem.remove(son_elem)
            # print("delete", cur_dict)

        else:                           # fix son elem attrib
            son_elem.attrib = cur_dict
            # print("fix", cur_dict)
        # ----------------------------------------------------------------------

    # 3) check results ---------------------------------------------------------
    indent(root_elem)
    # ET.dump(root_elem)
    # --------------------------------------------------------------------------

    # 4) backup dst-file -------------------------------------------------------
    bk_path = get_bk_path(dst_path)
    shutil.copy2(dst_path, bk_path)
    # --------------------------------------------------------------------------

    # 5) apply results ---------------------------------------------------------
    elem_tree.write(dst_path, encoding="utf-8", xml_declaration=True)
    # --------------------------------------------------------------------------
# ------------------------------------------------------------------------------

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
# ------------------------------------------------------------------------------


# 1) xfce4-shortcuts settings ==================================================
def set_shortcuts():
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
    if not os.path.isfile(dst_path): return

    prop_dict = {}

    # window tile --------------------------------------------------------------
    tog_fs_path = f"{BIN_DIR}/system/install_wmctrl/toggle_fullscreen.sh"

    # win+keypad_up >> win+up
    prop_dict["xfwm4/custom/<Super>KP_Up"] = {"name":"", "type":"string", "value":"tile_up_key"}
    prop_dict["xfwm4/custom/<Super>Up"] = {"name":"", "type":"string", "value":"tile_up_key"}

    if os.path.isfile(tog_fs_path):
        prop_dict["commands/custom/<Super>KP_Up"] = {"name":"<Super>Up", "type":"string", "value":f"{tog_fs_path}"}
    else:
        prop_dict["xfwm4/custom/<Super>Up"] = {"name":"<Super>Up", "type":"string", "value":"tile_up_key"}
    # --------------------------------------------------------------------------

    # window tile --------------------------------------------------------------
    # win+keypad_down >> win+down
    prop_dict["xfwm4/custom/<Super>KP_Down"] = {"name":"", "type":"string", "value":"tile_down_key"}
    prop_dict["xfwm4/custom/<Super>Down"] = {"name":"", "type":"string", "value":"tile_down_key"}
    prop_dict["xfwm4/custom/<Super>Down"] = {"name":"<Super>Down", "type":"string", "value":"tile_down_key"}

    # win+keypad_left >> win+left
    prop_dict["xfwm4/custom/<Super>KP_Left"] = {"name":"", "type":"string", "value":"tile_left_key"}
    prop_dict["xfwm4/custom/<Super>Left"] = {"name":"", "type":"string", "value":"tile_left_key"}
    prop_dict["xfwm4/custom/<Super>Left"] = {"name":"<Super>Left", "type":"string", "value":"tile_left_key"}

    # win+keypad_right >> win+right
    prop_dict["xfwm4/custom/<Super>KP_Right"] = {"name":"", "type":"string", "value":"tile_right_key"}
    prop_dict["xfwm4/custom/<Super>Right"] = {"name":"", "type":"string", "value":"tile_right_key"}
    prop_dict["xfwm4/custom/<Super>Right"] = {"name":"<Super>Right", "type":"string", "value":"tile_right_key"}
    # --------------------------------------------------------------------------

    # fill window --------------------------------------------------------------
    # shift+win+up
    prop_dict["xfwm4/custom/<Shift><Super>Up"] = {"name":"", "type":"string", "value":"fill_window_key"}
    prop_dict["xfwm4/custom/<Shift><Super>Up"] = {"name":"<Shift><Super>Up", "type":"string", "value":"fill_window_key"}
    # --------------------------------------------------------------------------

    # maximize window ----------------------------------------------------------
    # alt+f10 (for mxlinux)
    prop_dict["xfwm4/custom/<Alt>F10"] = {"name":"", "type":"string", "value":"maximize_window_key"}
    prop_dict["xfwm4/custom/<Alt>F10"] = {"name":"<Alt>F10", "type":"string", "value":"maximize_window_key"}
    # --------------------------------------------------------------------------

    # show desktop -------------------------------------------------------------
    # ctrl+alt+d >> win+d
    prop_dict["xfwm4/custom/<Primary><Alt>d"] = {"name":"", "type":"string", "value":"show_desktop_key"}
    prop_dict["xfwm4/custom/<Super>d"] = {"name":"", "type":"string", "value":"show_desktop_key"}
    prop_dict["xfwm4/custom/<Super>d"] = {"name":"<Super>d", "type":"string", "value":"show_desktop_key"}
    # --------------------------------------------------------------------------

    # expose -------------------------------------------------------------------
    # win+tab
    prop_dict["xfwm4/custom/<Super>Tab"] = {"name":"", "type":"string", "value":"switch_window_key"}
    prop_dict["commands/custom/<Super>Tab"] = {"name":"<Super>Tab", "type":"string", "value":"skippy-xd"}
    # --------------------------------------------------------------------------

    # settings -----------------------------------------------------------------
    # win+i
    prop_dict["commands/custom/<Super>i"] = {"name":"", "type":"string", "value":"xfce4-settings-manager"}
    prop_dict["commands/custom/<Super>i"] = {"name":"<Super>i", "type":"string", "value":"xfce4-settings-manager"}
    # --------------------------------------------------------------------------

    # spotlight ----------------------------------------------------------------
    # alt+f2 >> ctrl+space
    prop_dict["commands/custom/<Alt>F2"] = {"name":"", "type":"string", "value":"xfce4-appfinder"}
    prop_dict["commands/custom/<Primary>space"] = {"name":"", "type":"string", "value":"xfce4-appfinder"}
    prop_dict["commands/custom/<Primary>space"] = {"name":"<Primary>space", "type":"string", "value":"xfce4-appfinder"}
    # prop_dict["commands/custom/<Alt>F2"] = {"name":"<Primary>space", "type":"string", "value":"xfce4-appfinder --collapsed"}

    # alt+f3 >> alt+f2
    prop_dict["commands/custom/<Alt>F3"] = {"name":"", "type":"string", "value":"xfce4-appfinder"}
    prop_dict["commands/custom/<Alt>F2"] = {"name":"", "type":"string", "value":"xfce4-appfinder"}
    prop_dict["commands/custom/<Alt>F2"] = {"name":"<Alt>F2", "type":"string", "value":"xfce4-appfinder"}
    # --------------------------------------------------------------------------

    # appmenu ------------------------------------------------------------------
    # alt+f1 >> ctrl+esc
    prop_dict["commands/custom/<Alt>F1"] = {"name":"", "type":"string", "value":"xfce4-popup-applicationsmenu"}
    prop_dict["commands/custom/<Primary>Escape"] = {"name":"", "type":"string", "value":"xfdesktop --menu"}
    prop_dict["commands/custom/<Primary>Escape"] = {"name":"<Primary>Escape", "type":"string", "value":"xfce4-popup-applicationsmenu"}
    # --------------------------------------------------------------------------

    # taskmanager --------------------------------------------------------------
    # ctrl+shift+esc (for mxlinux)
    prop_dict["commands/custom/<Primary><Shift>Escape"] = {"name":"", "type":"string", "value":"xfce4-taskmanager"}
    prop_dict["commands/custom/<Primary><Shift>Escape"] = {"name":"<Primary><Shift>Escape", "type":"string", "value":"xfce4-taskmanager"}
    # --------------------------------------------------------------------------

    # screensaver --------------------------------------------------------------
    # ctrl+alt+l >> win+l
    prop_dict["commands/custom/<Primary><Alt>l"] = {"name":"", "type":"string", "value":"xflock4"}
    prop_dict["commands/custom/<Super>l"] = {"name":"", "type":"string", "value":""}

    if IS_MXLINUX:
        prop_dict["commands/custom/<Super>l"] = {"name":"<Super>l", "type":"string", "value":"/usr/bin/xfce4-screensaver-command --activate"}
        # prop_dict["commands/custom/<Super>l"] = {"name":"<Super>l", "type":"string", "value":"/usr/bin/xfce4-screensaver-command --lock"}
    else:
        prop_dict["commands/custom/<Super>l"] = {"name":"<Super>l", "type":"string", "value":"/usr/bin/xscreensaver-command -lock"}
    # --------------------------------------------------------------------------

    # terminal dropdown --------------------------------------------------------
    # f4 >> removed
    if IS_MXLINUX:
        #       <property name="F4" type="string" value="xfce4-terminal --drop-down"/>
        prop_dict["commands/custom/F4"] = {"name":"", "type":"string", "value":"xfce4-terminal --drop-down"}
    # --------------------------------------------------------------------------

    config_settings(prop_dict, dst_path)
# ==============================================================================


# 2) wockspace-scroll / workspace-count settings ===============================
def set_workspace():
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
    if not os.path.isfile(dst_path): return

    prop_dict = {}

    # scroll workspace : off ---------------------------------------------------
    prop_dict["general/scroll_workspaces"] = {"name":"scroll_workspaces", "type":"bool", "value":"false"}
    # --------------------------------------------------------------------------

    # workspace count : 2 ------------------------------------------------------
    prop_dict["general/workspace_count"] = {"name":"workspace_count", "type":"int", "value":"2"}
    # --------------------------------------------------------------------------

    config_settings(prop_dict, dst_path)
# ==============================================================================


# 3) panel settings ============================================================
def set_panel_clock():
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    if not os.path.isfile(dst_path): return

    prop_dict = {}

    if IS_MXLINUX:
        sel_plugin = "plugin-1"
    else:
        sel_plugin = "plugin-12"

    # digital layout -----------------------------------------------------------
    prop_dict[f"plugins/{sel_plugin}/digital-layout"] = {"name":"digital-layout", "type":"uint", "value":"1"}
    # --------------------------------------------------------------------------

    # date : 25-12-12 ----------------------------------------------------------
    prop_dict[f"plugins/{sel_plugin}/digital-date-format"] = {"name":"digital-date-format", "type":"string", "value":"%y-%m-%d (%a)"}
    # --------------------------------------------------------------------------

    # time : 12:00:AM ----------------------------------------------------------
    prop_dict[f"plugins/{sel_plugin}/digital-time-format"] = {"name":"digital-time-format", "type":"string", "value":"%I:%M %p"}
    # --------------------------------------------------------------------------

    config_settings(prop_dict, dst_path)
# ------------------------------------------------------------------------------

def set_panel(): # not used
    xfce4_panel_dir = f"{BIN_DIR}/wmde/xfce4/panel"
    xfce4_panel_path = f"{BIN_DIR}/wmde/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"

    dst_dir = f"{HOME_DIR}/.config/xfce4/panel"
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    if not os.path.isfile(dst_path): return

    if os.path.isdir(xfce4_panel_dir) and os.path.isfile(xfce4_panel_path):
        # xfce4_panel_dir ------------------------------------------------------
        if os.path.isdir(dst_dir):
            bk_dir = get_bk_dir(dst_dir)
            shutil.copytree(dst_dir, bk_dir)

        shutil.rmtree(dst_dir)
        shutil.copytree(xfce4_panel_dir, dst_dir)
        # ----------------------------------------------------------------------

        # xfce4_panel_path -----------------------------------------------------
        if os.path.isfile(dst_path):
            bk_path = get_bk_path(dst_path)
            shutil.copy2(dst_path, bk_path)

        shutil.copy2(xfce4_panel_path, dst_path)
        # ----------------------------------------------------------------------
    else:
        set_panel_clock()
# ------------------------------------------------------------------------------
# ==============================================================================


# 4) theme settings ============================================================
def set_theme():
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
    if not os.path.isfile(dst_path): return

    check_xsettings(dst_path)

    prop_dict = {}

    if os.path.isdir("/usr/share/icons/Papirus"):
        prop_dict["Net/IconThemeName"] = {"name":"IconThemeName", "type":"string", "value":"Papirus"}
    elif os.path.isdir("/usr/share/icons/Adwaita"):
        prop_dict["Net/IconThemeName"] = {"name":"IconThemeName", "type":"string", "value":"Adwaita"}
    else:
        prop_dict["Net/IconThemeName"] = {"name":"IconThemeName", "type":"string", "value":"Tango"}

    config_settings(prop_dict, dst_path)
# ==============================================================================


# 5) default applications settings =============================================
def set_default_app():
    dst_path = f"{HOME_DIR}/.config/xfce4/helpers.rc"

    if not os.path.isfile(dst_path):
        data = "TerminalEmulator=xfce4-terminal"
        f = open(dst_path, "w")
        f.write(data)
        f.close()
# ==============================================================================


# ==============================================================================
def set_desktop():
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
    if not os.path.isfile(dst_path): return

    prop_dict = {}

    # desktop icon size:32 -----------------------------------------------------
    prop_dict["desktop-icons/icon-size"] = {"name":"icon-size", "type":"unit", "value":"32"}
    # --------------------------------------------------------------------------

    # show home in desktop:on --------------------------------------------------
    prop_dict["desktop-icons/show-home"] = {"name":"show-home", "type":"bool", "value":"true"}
    # --------------------------------------------------------------------------

    # show filesystem in desktop:on --------------------------------------------
    prop_dict["desktop-icons/show-filesystem"] = {"name":"show-filesystem", "type":"bool", "value":"true"}
    # --------------------------------------------------------------------------

    # show trash in desktop:on -------------------------------------------------
    prop_dict["desktop-icons/show-trash"] = {"name":"show-trash", "type":"bool", "value":"true"}
    # --------------------------------------------------------------------------

    # show removable in desktop:on ---------------------------------------------
    prop_dict["desktop-icons/show-removable"] = {"name":"show-removable", "type":"bool", "value":"true"}
    # --------------------------------------------------------------------------

    # single_click:off (double_click:on) ---------------------------------------
    prop_dict["desktop-icons/single-click"] = {"name":"single-click", "type":"bool", "value":"false"}
    # --------------------------------------------------------------------------

    config_settings(prop_dict, dst_path)
# ==============================================================================


# ==============================================================================
def set_thunar():
    dst_path = f"{HOME_DIR}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
    if not os.path.isfile(dst_path): return

    prop_dict = {}

    # single_click:off (double_click:on) ---------------------------------------
    prop_dict["misc-single-click"] = {"name":"misc-single-click", "type":"bool", "value":"false"}
    # --------------------------------------------------------------------------

    config_settings(prop_dict, dst_path)
# ==============================================================================

if __name__ == "__main__":
    set_shortcuts()
    set_workspace()
    set_panel_clock()

    if IS_MXLINUX:
        set_desktop()
        set_thunar()
    else:
        set_theme()
        set_default_app()