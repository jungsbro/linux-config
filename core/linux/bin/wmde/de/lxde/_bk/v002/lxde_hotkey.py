import os
import sys
import shutil
import xml.etree.ElementTree as ET

# usage ========================================================================
# python3 "${CORE_BIN_DIR}/wmde/de/lxde/lxde_hotkey.py" ${CUR_USER}

# import lxde_hotkey
# lxde_hotkey.set_shortcuts(CORE_BIN_DIR, HOME_DIR)
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde/de/lxde/lxde_hotkey.py
SCRIPT_PATH = os.path.abspath(__file__)

# os.getcwd()
# core/linux/bin/wmde/de/lxde
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
if SCRIPT_DIR not in sys.path:
    sys.path.append(SCRIPT_DIR)

# core/linux/bin/wmde/de
DE_DIR = os.path.dirname(SCRIPT_DIR)

# core/linux/bin/wmde
WMDE_DIR = os.path.dirname(DE_DIR)

# core/linux/bin
CORE_BIN_DIR = os.path.dirname(WMDE_DIR)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER = f"{sys.argv[1]}"


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
# ==============================================================================


# Funcs ========================================================================
import lxde_funcs


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
# ------------------------------------------------------------------------------


def get_family_elem_list(elem, family_info_list):
    # family_info_list = [(parent_tag, parent_attrib), (child_tag, child_attrib)]
    family_elem_list = []

    if not family_info_list: return family_elem_list

    for tag, attrib in family_info_list:
        # print(tag, attrib)
        elem = get_child_elem(elem, tag, attrib)
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


def config_hotkey(ns, dst_path):
    if not os.path.isfile(dst_path): return

    # --------------------------------------------------------------------------
    elem_tree = ET.parse(dst_path)
    root_elem = elem_tree.getroot()
    # for sub_elem in root_elem:
    #     print(sub_elem.tag, sub_elem.attrib, sub_elem.text)
    # --------------------------------------------------------------------------

    def remove_hotkey(hotkey):
        # ----------------------------------------------------------------------
        family_info_list = [
            # tag             attrib
            (f"{ns}keyboard", {}),
            (f"{ns}keybind", {"key":hotkey}),
        ]

        family_elem_list = get_family_elem_list(root_elem, family_info_list)
        # print(family_elem_list)

        keyboard_elem = family_elem_list[-2]
        keybind_elem = family_elem_list[-1]
        # ----------------------------------------------------------------------

        # 1) remove hotkey -----------------------------------------------------
        if keybind_elem is None: return
        keyboard_elem.remove(keybind_elem)
        # ----------------------------------------------------------------------
    # --------------------------------------------------------------------------


    def add_hotkey(hotkey, cmd):
        # ----------------------------------------------------------------------
        family_info_list = [
            # tag             attrib
            (f"{ns}keyboard", {}),
            (f"{ns}keybind", {"key":hotkey}),
        ]

        family_elem_list = get_family_elem_list(root_elem, family_info_list)
        # print(family_elem_list)

        keyboard_elem = family_elem_list[-2]
        keybind_elem = family_elem_list[-1]
        # ----------------------------------------------------------------------

        # 1) remove hotkey -----------------------------------------------------
        if keybind_elem is not None:
            keyboard_elem.remove(keybind_elem)
        # ----------------------------------------------------------------------

        # 2) keybind element ---------------------------------------------------
        keybind_elem = ET.Element(f"{ns}keybind")
        keybind_elem.attrib={"key": hotkey}
        keyboard_elem.append(keybind_elem)
        # ----------------------------------------------------------------------

        # 3) action element ----------------------------------------------------
        axn_elem = ET.Element(f"{ns}action")
        if "/bin" in cmd:
            axn_elem.attrib={"name": "Execute"}
            ET.SubElement(axn_elem, f"{ns}command").text=cmd
        else:
            axn_elem.attrib={"name": cmd}
        keybind_elem.append(axn_elem)
        # ----------------------------------------------------------------------
    # --------------------------------------------------------------------------


    # W-d / C-A-d 추가 : show desktop -------------------------------------------
    add_hotkey("W-d", "ToggleShowDesktop")      # alreay exists in lxde-rc.xml

    add_hotkey("C-A-d", "ToggleShowDesktop")    # alreay exists in lxde-rc.xml
    # --------------------------------------------------------------------------

    # W-P : Display Settings ---------------------------------------------------
    add_hotkey("W-P", "/usr/bin/lxrandr")
    # --------------------------------------------------------------------------

    # C-A-t 추가 : terminal -----------------------------------------------------
    add_hotkey("C-A-t", "/usr/bin/lxterminal")
    # --------------------------------------------------------------------------

    # W-Tab 추가 : expose -------------------------------------------------------
    # expose_cmd = "/usr/bin/rofi -show window -show-icons"
    expose_cmd = """/usr/bin/rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'
"""

    add_hotkey("W-Tab", expose_cmd)
    # --------------------------------------------------------------------------

    # A-Tab 추가 : next windows -------------------------------------------------
    add_hotkey("A-Tab", "NextWindow")       # alreay exists in lxde-rc.xml
    # --------------------------------------------------------------------------

    # W-f 추가 : find files -----------------------------------------------------
    add_hotkey("W-f", "/usr/bin/pcmanfm --find-files")    # alreay exists in lxde-rc.xml
    # --------------------------------------------------------------------------

    # W-r / A-F2 추가 : spotlight ----------------------------------------------
    add_hotkey("W-r", "/usr/bin/lxpanelctl run")    # alreay exists in lxde-rc.xml

    add_hotkey("A-F2", "/usr/bin/rofi -show drun -show-icons")
    # --------------------------------------------------------------------------

    # C-Escape / A-F1 추가 : lx menu --------------------------------------------
    add_hotkey("C-Escape", "/usr/bin/lxpanelctl menu")  # alreay exists in lxde-rc.xml

    add_hotkey("A-F1", "/usr/bin/lxpanelctl menu")      # alreay exists in lxde-rc.xml
    # --------------------------------------------------------------------------

    # W-i 추가 lx settings ------------------------------------------------------
    lxcc_path = f"{HOME_DIR}/.local/bin/lxcc.py"
    add_hotkey("W-i", f"/usr/bin/python3 {lxcc_path}")
    # --------------------------------------------------------------------------

    # A-F11 추가 : toggle fullscreen -------------------------------------------
    add_hotkey("A-F11", "ToggleFullscreen")     # alreay exists in lxde-rc.xml
    # --------------------------------------------------------------------------

    # A-C-Delete 추가 : logout --------------------------------------------------
    add_hotkey("A-C-Delete", "/usr/bin/lxde-logout")
    # --------------------------------------------------------------------------

    # W-S-r 추가 : settings restart ---------------------------------------------
    add_hotkey("W-S-r", "/usr/bin/openbox --reconfigure")
    # --------------------------------------------------------------------------

    # W-l 추가 : lock screen ----------------------------------------------------
    add_hotkey("W-l", "/usr/bin/lxlock")
    # --------------------------------------------------------------------------

    # S-C-Escape 추가 : lx task (A-C-Delete >> S-C-Escape) ----------------------
    add_hotkey("S-C-Escape", "/usr/bin/lxtask")
    # --------------------------------------------------------------------------

    # W-x 추가 : xkill (추가 해야하는데 일단 보류) -----------------------------------
    add_hotkey("W-x", "/usr/bin/xkill")
    # --------------------------------------------------------------------------

    # W-Up 추가 ----------------------------------------------------------------
    add_hotkey("W-Up", "Maximize")
    # --------------------------------------------------------------------------

    # W-Down 추가 ---------------------------------------------------------------
    add_hotkey("W-Down", "Unmaximize")
    # --------------------------------------------------------------------------

    # W-Left 추가 ---------------------------------------------------------------
    remove_hotkey("W-Left")

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

    # W-Right 추가 --------------------------------------------------------------
    remove_hotkey("W-Right")

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

    # A-space 추가 : show menu --------------------------------------------------
    # # alreay exists in lxde-rc.xml
    # remove_hotkey("A-space")

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

    # W-e 추가 : home folder ----------------------------------------------------
    # # alreay exists in lxde-rc.xml
    # remove_hotkey("W-e")

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
    bk_path = lxde_funcs.get_bk_path(dst_path)
    shutil.copy2(dst_path, bk_path)
    # --------------------------------------------------------------------------

    # apply results ------------------------------------------------------------
    elem_tree.write(dst_path, encoding="utf-8", xml_declaration=True)
    # --------------------------------------------------------------------------
# ------------------------------------------------------------------------------


def set_shortcuts(core_bin_dir, home_dir):
    # 5) lxde-rc settings
    # --------------------------------------------------------------------------
    src_path = f"{core_bin_dir}/wmde/lxde/lxde-rc.xml";

    if lxde_funcs.is_rpios():
        dst_path = f"{home_dir}/.config/openbox/lxde-pi-rc.xml"
    else:
        dst_path = f"{home_dir}/.config/openbox/lxde-rc.xml"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if os.path.isfile(src_path):
        # backup dst-file ------------------------------------------------------
        if os.path.isfile(dst_path):
            bk_path = lxde_funcs.get_bk_path(dst_path)
            shutil.copy2(dst_path, bk_path)
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        dst_dir = os.path.dirname(dst_path)
        if not os.path.isdir(dst_dir):
            os.makedirs(dst_dir)

        shutil.copy2(src_path, dst_path)
        # ----------------------------------------------------------------------
    else:
        ns = "{http://openbox.org/3.4/rc}"

        config_hotkey(ns, dst_path)
    # --------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
if __name__ == "__main__":
    set_shortcuts(CORE_BIN_DIR, HOME_DIR)
# ==============================================================================
