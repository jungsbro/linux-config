import os
import sys
import shutil
import xml.etree.ElementTree as ET

# config_lxde ==================================================================
# python3 /core/linux/bin/wmde/lxde/config_lxde.py ${CUR_USER}
# ==============================================================================

# env ==========================================================================
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

# IS_RPI------------------------------------------------------------------------
def is_rpi():
    cmd = "uname -r"        # -r : kernel-release
    stream = os.popen(cmd)
    output = stream.read()  # 6.6.31+rpt-rpi-v8

    if "rpi" in output:
        return True
    else:
        return False
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
def get_child_elem(parent_elem, child_tag, child_attrib):

    # 1) child_tag
    child_elem_list = parent_elem.findall(child_tag)
    if not child_elem_list: return None
    if not child_attrib: return child_elem_list[0]

    # 2) child_attrib
    for child_elem in child_elem_list:
        for key in child_attrib:
            if child_elem.get(key) != child_attrib[key]: continue
            # print(child_elem)
            return child_elem
# ==============================================================================

# ==============================================================================
def get_family_elem_list(elem, family_info_list):
    # family_info_list = [(parent_tag, parent_attrib), (child_tag, child_attrib)]
    family_elem_list = []

    if not family_info_list: return family_elem_list

    for tag, attrib in family_info_list:
        # print(tag, attrib)
        elem = get_child_elem(elem, tag, attrib)
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
# ==============================================================================

# ==============================================================================
def fix_settings(old_str, new_str, dst_path):
    if not os.path.isfile(dst_path): return

    f = open(dst_path, "r")
    data = f.read()
    f.close()

    if old_str not in data: return
    data = data.replace(old_str, new_str)

    # bk_path = get_bk_path(dst_path)
    # shutil.copy2(dst_path, bk_path)

    f = open(dst_path, "w")
    f.write(data)
# ==============================================================================

# ==============================================================================
def config_hotkey(ns, dst_path):
    if not os.path.isfile(dst_path): return

    elem_tree = ET.parse(dst_path)
    root_elem = elem_tree.getroot()
    # for sub_elem in root_elem:
    #     print(sub_elem.tag, sub_elem.attrib, sub_elem.text)

    # --------------------------------------------------------------------------
    def remove_hotkey(hotkey):
        family_info_list = [
            # tag             attrib
            (f"{ns}keyboard", {}),
            (f"{ns}keybind", {"key":hotkey}),
        ]

        family_elem_list = get_family_elem_list(root_elem, family_info_list)
        # print(family_elem_list)

        keyboard_elem = family_elem_list[-2]
        keybind_elem = family_elem_list[-1]

        if not keybind_elem: return
        keyboard_elem.remove(keybind_elem)
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    def add_hotkey(hotkey, cmd):

        family_info_list = [
            # tag             attrib
            (f"{ns}keyboard", {}),
            (f"{ns}keybind", {"key":hotkey}),
        ]

        family_elem_list = get_family_elem_list(root_elem, family_info_list)
        # print(family_elem_list)

        keyboard_elem = family_elem_list[-2]
        keybind_elem = family_elem_list[-1]
        if keybind_elem: return

        """ 1) keybind element """
        keybind_elem = ET.Element(f"{ns}keybind")
        keybind_elem.attrib={"key": hotkey}
        keyboard_elem.append(keybind_elem)

        """ 2) action element """
        axn_elem = ET.Element(f"{ns}action")
        if "/usr/bin" in cmd:
            axn_elem.attrib={"name": "Execute"}
            ET.SubElement(axn_elem, f"{ns}command").text=cmd
        else:
            axn_elem.attrib={"name": cmd}
        keybind_elem.append(axn_elem)
    # --------------------------------------------------------------------------

    # W-d / C-A-d 추가 : show desktop ------------------------------------------
    # add_hotkey("W-d", "ToggleShowDesktop")
    # add_hotkey("C-A-d", "ToggleShowDesktop")
    # --------------------------------------------------------------------------

    # C-A-t 추가 : terminal ----------------------------------------------------
    add_hotkey("C-A-t", "/usr/bin/lxterminal")
    # --------------------------------------------------------------------------

    # W-Tab 추가 : expose ------------------------------------------------------
    add_hotkey("W-Tab", "/usr/bin/skippy-xd")
    # --------------------------------------------------------------------------

    # A-Tab 추가 : next windows ------------------------------------------------
    # add_hotkey("A-Tab", "NextWindow")
    # --------------------------------------------------------------------------

    # W-f 추가 : find files ----------------------------------------------------
    # add_hotkey("W-f", "/usr/bin/pcmanfm --find-files")
    # --------------------------------------------------------------------------

    # W-r / A-F2 추가 : spotlight ----------------------------------------------
    # add_hotkey("W-r", "/usr/bin/lxpanelctl run")
    # add_hotkey("A-F2", "/usr/bin/lxpanelctl run")
    # --------------------------------------------------------------------------

    # C-Escape / A-F1 추가 : lx menu -------------------------------------------
    # add_hotkey("C-Escape", "/usr/bin/lxpanelctl menu")
    # add_hotkey("A-F1", "/usr/bin/lxpanelctl menu")
    # --------------------------------------------------------------------------

    # W-i 추가 lx settings -----------------------------------------------------
    add_hotkey("W-i", "/usr/bin/lxpanelctl menu")
    # --------------------------------------------------------------------------

    # A-F11 추가 : toggle fullscreen -------------------------------------------
    # add_hotkey("A-F11", "ToggleFullscreen")
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # S-C-Escape 추가 : lx task (밑에 logout보다 먼저실행해야 한다.)
    remove_hotkey("A-C-Delete")
    add_hotkey("S-C-Escape", "/usr/bin/lxtask")

    # A-C-Delete 추가 : logout
    add_hotkey("A-C-Delete", "/usr/bin/lxde-logout")
    # --------------------------------------------------------------------------

    # W-l 추가 : lock screen ---------------------------------------------------
    add_hotkey("W-l", "/usr/bin/lxlock")
    # --------------------------------------------------------------------------

    # W-x 추가 : xkill (추가 해야하는데 일단 보류) -----------------------------
    # add_hotkey("W-x", "/usr/bin/xkill")
    # --------------------------------------------------------------------------

    # W-Up 추가 ----------------------------------------------------------------
    add_hotkey("W-Up", "Maximize")
    # --------------------------------------------------------------------------

    # W-Down 추가 --------------------------------------------------------------
    add_hotkey("W-Down", "Unmaximize")
    # --------------------------------------------------------------------------

    # W-Left 추가 --------------------------------------------------------------
    family_info_list = [
        # tag             attrib
        (f"{ns}keyboard", {}),
        (f"{ns}keybind", {"key":"W-Left"}),
    ]

    family_elem_list = get_family_elem_list(root_elem, family_info_list)
    # print(family_elem_list)

    keyboard_elem = family_elem_list[-2]
    keybind_elem = family_elem_list[-1]

    if not keybind_elem:
        keybind_elem = ET.Element(f"{ns}keybind")
        keybind_elem.attrib={"key": "W-Left"}
        keyboard_elem.append(keybind_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "UnmaximizeFull"}
        keybind_elem.append(axn_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "MaximizeVert"}
        keybind_elem.append(axn_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "MoveResizeTo"}
        ET.SubElement(axn_elem, f"{ns}width").text="50%"
        keybind_elem.append(axn_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "MoveToEdge"}
        ET.SubElement(axn_elem, f"{ns}direction").text="west"
        keybind_elem.append(axn_elem)
    # --------------------------------------------------------------------------

    # W-Right 추가 -------------------------------------------------------------
    family_info_list = [
        # tag             attrib
        (f"{ns}keyboard", {}),
        (f"{ns}keybind", {"key":"W-Right"}),
    ]

    family_elem_list = get_family_elem_list(root_elem, family_info_list)
    # print(family_elem_list)

    keyboard_elem = family_elem_list[-2]
    keybind_elem = family_elem_list[-1]

    if not keybind_elem:
        keybind_elem = ET.Element(f"{ns}keybind")
        keybind_elem.attrib={"key": "W-Right"}
        keyboard_elem.append(keybind_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "UnmaximizeFull"}
        keybind_elem.append(axn_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "MaximizeVert"}
        keybind_elem.append(axn_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "MoveResizeTo"}
        ET.SubElement(axn_elem, f"{ns}width").text="50%"
        keybind_elem.append(axn_elem)

        axn_elem = ET.Element(f"{ns}action")
        axn_elem.attrib={"name": "MoveToEdge"}
        ET.SubElement(axn_elem, f"{ns}direction").text="east"
        keybind_elem.append(axn_elem)
    # --------------------------------------------------------------------------

    # A-space 추가 : show menu -------------------------------------------------
    # family_info_list = [
    #     (f"{ns}keyboard", {}),
    #     (f"{ns}keybind", {"key":"A-space"}),
    # ]

    # family_elem_list = get_family_elem_list(root_elem, family_info_list)

    # keyboard_elem = family_elem_list[-2]
    # keybind_elem = family_elem_list[-1]

    # if not keybind_elem:
    #     keybind_elem = ET.Element(f"{ns}keybind")
    #     keybind_elem.attrib={"key": "A-space"}
    #     keyboard_elem.append(keybind_elem)

    #     axn_elem = ET.Element(f"{ns}action")
    #     axn_elem.attrib={"name": "ShowMenu"}
    #     ET.SubElement(axn_elem, f"{ns}menu").text="client-menu"
    #     keybind_elem.append(axn_elem)
    # --------------------------------------------------------------------------

    # W-e 추가 : home folder ---------------------------------------------------
    # family_info_list = [
    #     (f"{ns}keyboard", {}),
    #     (f"{ns}keybind", {"key":"W-e"}),
    # ]

    # family_elem_list = get_family_elem_list(root_elem, family_info_list)

    # keyboard_elem = family_elem_list[-2]
    # keybind_elem = family_elem_list[-1]

    # if not keybind_elem:
    #     keybind_elem = ET.Element(f"{ns}keybind")
    #     keybind_elem.attrib={"key": "W-e"}
    #     keyboard_elem.append(keybind_elem)

    #     axn_elem = ET.Element(f"{ns}action")
    #     axn_elem.attrib={"name": "Execute"}
    #     noti_elem = ET.SubElement(axn_elem, f"{ns}startupnotify")
    #     ET.SubElement(noti_elem, f"{ns}enabled").text="true"
    #     ET.SubElement(noti_elem, f"{ns}name").text="PCManFM"
    #     keybind_elem.append(axn_elem)
    # --------------------------------------------------------------------------

    # check results ------------------------------------------------------------
    indent(root_elem)
    # ET.dump(root_elem)
    # --------------------------------------------------------------------------

    # backup dst-file ----------------------------------------------------------
    bk_path = get_bk_path(dst_path)
    shutil.copy2(dst_path, bk_path)
    # --------------------------------------------------------------------------

    # apply results ------------------------------------------------------------
    elem_tree.write(dst_path, encoding="utf-8", xml_declaration=True)
    # --------------------------------------------------------------------------
# ==============================================================================



# 1) panel-height / panel-style / panel-clock settings =========================
def set_panel():
    # data ---------------------------------------------------------------------
    data='''# lxpanel <profile> config file. Manually editing is not recommended.
# Use preference dialog in lxpanel to adjust config when you can.

Global {
  edge=bottom
  align=left
  margin=0
  widthtype=percent
  width=100
  height=26
  transparent=0
  tintcolor=#000000
  alpha=0
  setdocktype=1
  setpartialstrut=1
  autohide=0
  heightwhenhidden=0
  usefontcolor=1
  fontcolor=#ffffff
  background=1
  backgroundfile=/usr/share/lxpanel/images/background.png
}
Plugin {
  type=space
  Config {
    Size=2
  }
}
Plugin {
  type=menu
  Config {
    image=/usr/share/lxde/images/lxde-icon.png
    system {
    }
    separator {
    }
    item {
      command=run
    }
    separator {
    }
    item {
      image=gnome-logout
      command=logout
    }
  }
}
Plugin {
  type=launchbar
  Config {
    Button {
      id=pcmanfm.desktop
    }
    Button {
      id=lxde-x-www-browser.desktop
    }
  }
}
Plugin {
  type=space
  Config {
    Size=4
  }
}
Plugin {
  type=wincmd
  Config {
    Button1=iconify
    Button2=shade
  }
}
Plugin {
  type=space
  Config {
    Size=4
  }
}
Plugin {
  type=pager
  Config {
  }
}
Plugin {
  type=space
  Config {
    Size=4
  }
}
Plugin {
  type=taskbar
  expand=1
  Config {
    tooltips=1
    IconsOnly=0
    AcceptSkipPager=1
    ShowIconified=1
    ShowMapped=1
    ShowAllDesks=0
    UseMouseWheel=1
    UseUrgencyHint=1
    FlatButton=0
    MaxTaskWidth=150
    spacing=1
  }
}
Plugin {
  type=cpu
  Config {
  }
}
Plugin {
  type=volume
  Config {
    VolumeMuteKey=XF86AudioMute
    VolumeDownKey=XF86AudioLowerVolume
    VolumeUpKey=XF86AudioRaiseVolume
  }
}
Plugin {
  type=tray
  Config {
  }
}
Plugin {
  type=dclock
  Config {
    ClockFmt=%R
    TooltipFmt=%A %x
    BoldFont=0
    IconOnly=0
    CenterText=0
  }
}
Plugin {
  type=launchbar
  Config {
    Button {
      id=lxde-screenlock.desktop
    }
    Button {
      id=lxde-logout.desktop
    }
  }
}
'''
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if is_rpi():
        panel_path = "/core/linux/bin/wmde/lxde/panel-pi";
        dst_path = f"{HOME_DIR}/.config/lxpanel/LXDE-pi/panels/panel"
    else:
        panel_path = "/core/linux/bin/wmde/lxde/panel";
        dst_path = f"{HOME_DIR}/.config/lxpanel/LXDE/panels/panel"

    if not os.path.isfile(dst_path):
        f = open(dst_path, "w")
        f.write(data)
        f.close()
    # --------------------------------------------------------------------------

    if os.path.isfile(panel_path):
        # backup dst-file ------------------------------------------------------
        if os.path.isfile(dst_path):
            bk_path = get_bk_path(dst_path)
            shutil.copy2(dst_path, bk_path)
        # ----------------------------------------------------------------------

        shutil.copy2(panel_path, dst_path)
    else:
        # panel-height ---------------------------------------------------------
        old_str = "height=26"
        new_str = "height=40"
        fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------

        # panel-style ----------------------------------------------------------
        old_str = "background=1"
        new_str = "background=0"
        fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------

        # panel-fontcolor ------------------------------------------------------
        # old_str = "fontcolor=#000000"
        # new_str = "fontcolor=#ffffff"
        old_str = "usefontcolor=1"
        new_str = "usefontcolor=0"
        fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------

        # panel-clock ----------------------------------------------------------
        old_str = "ClockFmt=%R"
        new_str = "ClockFmt=     %p %I:%M\\n%y-%m-%d (%a)"
        fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------
# ==============================================================================


# 2) desktop icon settings =====================================================
def set_desktop_icons():
    # --------------------------------------------------------------------------
    if is_rpi():
        dst_path = f"{HOME_DIR}/.config/pcmanfm/LXDE-pi/desktop-items-0.conf"
    else:
        dst_path = f"{HOME_DIR}/.config/pcmanfm/LXDE/desktop-items-0.conf"
    if not os.path.isfile(dst_path): return
    # --------------------------------------------------------------------------

    # documents : on -----------------------------------------------------------
    old_str = "show_documents=0"
    new_str = "show_documents=1"
    fix_settings(old_str, new_str, dst_path)
    # --------------------------------------------------------------------------

    # mounts : on --------------------------------------------------------------
    old_str = "show_mounts=0"
    new_str = "show_mounts=1"
    fix_settings(old_str, new_str, dst_path)
    # --------------------------------------------------------------------------
# ==============================================================================


# 3) icon theme settings =======================================================
def set_theme():
    # --------------------------------------------------------------------------
    if is_rpi():
        dst_path = f"{HOME_DIR}/.config/lxsession/LXDE-pi/desktop.conf"
    else:
        dst_path = f"{HOME_DIR}/.config/lxsession/LXDE/desktop.conf"
    if not os.path.isfile(dst_path): return
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    old_str = "sNet/IconThemeName=nuoveXT2"

    if os.path.isdir("/usr/share/icons/Papirus"):
        new_str = "sNet/IconThemeName=Papirus"
    elif os.path.isdir("/usr/share/icons/Adwaita"):
        new_str = "sNet/IconThemeName=Adwaita"
    else:
        new_str = old_str
    # --------------------------------------------------------------------------

    fix_settings(old_str, new_str, dst_path)
# ==============================================================================


# 4) defualt textEditor(mousepad) settings =====================================
def set_text_editor():
    dst_path = f"{HOME_DIR}/.config/mimeapps.list"

    # --------------------------------------------------------------------------
    if not os.path.isfile(dst_path):
        data = '''[Default Applications]
text/plain=org.xfce.mousepad.desktop

[Added Associations]
text/plain=org.xfce.mousepad.desktop;
'''
        f = open(dst_path, "w")
        f.write(data)
        f.close()
    # else:
    #     bk_path = get_bk_path(dst_path)
    #     shutil.copy2(dst_path, bk_path
    # --------------------------------------------------------------------------
# ==============================================================================


# 5) lxde-rc settings ==========================================================
def set_mouse_double_click():
    if is_rpi():
        dst_path = f"{HOME_DIR}/.config/lxsession/LXDE-pi/desktop.conf"
        if not os.path.isfile(dst_path): return

        old_str = "iNet/DoubleClickTime=200"
        new_str = "iNet/DoubleClickTime=750"

    else:
        dst_path = f"{HOME_DIR}/.config/openbox/lxde-rc.xml"
        if not os.path.isfile(dst_path): return

        old_str = "<doubleClickTime>200</doubleClickTime>"
        new_str = "<doubleClickTime>750</doubleClickTime>"

    fix_settings(old_str, new_str, dst_path)
# ------------------------------------------------------------------------------

def set_shortcuts():
    # --------------------------------------------------------------------------
    lxde_rc_path = "/core/linux/bin/wmde/lxde/lxde-rc.xml";

    if is_rpi():
        dst_path = f"{HOME_DIR}/.config/openbox/lxde-pi-rc.xml"
    else:
        dst_path = f"{HOME_DIR}/.config/openbox/lxde-rc.xml"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if os.path.isfile(lxde_rc_path):
        # backup dst-file ------------------------------------------------------
        if os.path.isfile(dst_path):
            bk_path = get_bk_path(dst_path)
            shutil.copy2(dst_path, bk_path)
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        dst_dir = os.path.dirname(dst_path)
        if not os.path.isdir(dst_dir):
            os.makedirs(dst_dir)

        shutil.copy2(lxde_rc_path, dst_path)
        # ----------------------------------------------------------------------
    else:
        ns = "{http://openbox.org/3.4/rc}"

        config_hotkey(ns, dst_path)
    # --------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ==============================================================================


if __name__ == "__main__":
    set_panel()
    set_desktop_icons()
    set_theme()
    set_text_editor()
    set_mouse_double_click()
    set_shortcuts()