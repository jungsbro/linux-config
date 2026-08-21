import os
import sys
import shutil

# usage ========================================================================
# python3 "${CORE_BIN_DIR}/wmde/de/lxde/lxde_system.py" "${CUR_USER}"

# import lxde_system
# lxde_system.set_text_editor(HOME_DIR)
# lxde_system.set_mouse_double_click(HOME_DIR)
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde/de/lxde/lxde_system.py
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

def set_text_editor(home_dir):
    # 4) defualt textEditor(mousepad) settings
    dst_path = f"{home_dir}/.config/mimeapps.list"

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
# ------------------------------------------------------------------------------


def set_mouse_double_click(home_dir):
    # 5) lxde-rc settings
    if lxde_funcs.is_rpios():
        dst_path = f"{home_dir}/.config/lxsession/LXDE-pi/desktop.conf"
        if not os.path.isfile(dst_path): return

        old_str = "iNet/DoubleClickTime=200"
        new_str = "iNet/DoubleClickTime=750"
    else:
        dst_path = f"{home_dir}/.config/openbox/lxde-rc.xml"
        if not os.path.isfile(dst_path): return

        old_str = "<doubleClickTime>200</doubleClickTime>"
        new_str = "<doubleClickTime>750</doubleClickTime>"

    lxde_funcs.fix_settings(old_str, new_str, dst_path)
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
if __name__ == "__main__":
    set_text_editor(HOME_DIR)
    set_mouse_double_click(HOME_DIR)
# ==============================================================================
