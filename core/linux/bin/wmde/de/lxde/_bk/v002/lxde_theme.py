import os
import sys
import shutil

# usage ========================================================================
# python3 "${CORE_BIN_DIR}/wmde/de/lxde/lxde_theme.py" ${CUR_USER}

# import lxde_theme
# lxde_theme.set_desktop_icons(HOME_DIR)
# lxde_theme.set_theme(HOME_DIR)
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde/de/lxde/lxde_theme.py
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

def set_desktop_icons(home_dir):
    # 2) desktop icon settings
    # --------------------------------------------------------------------------
    if lxde_funcs.is_rpios():
        dst_path = f"{home_dir}/.config/pcmanfm/LXDE-pi/desktop-items-0.conf"
    else:
        dst_path = f"{home_dir}/.config/pcmanfm/LXDE/desktop-items-0.conf"
    if not os.path.isfile(dst_path): return
    # --------------------------------------------------------------------------

    # documents : on -----------------------------------------------------------
    old_str = "show_documents=0"
    new_str = "show_documents=1"
    lxde_funcs.fix_settings(old_str, new_str, dst_path)
    # --------------------------------------------------------------------------

    # mounts : on --------------------------------------------------------------
    old_str = "show_mounts=0"
    new_str = "show_mounts=1"
    lxde_funcs.fix_settings(old_str, new_str, dst_path)
    # --------------------------------------------------------------------------
# ------------------------------------------------------------------------------


def set_theme(home_dir):
    # 3) icon theme settings
    # --------------------------------------------------------------------------
    if lxde_funcs.is_rpios():
        dst_path = f"{home_dir}/.config/lxsession/LXDE-pi/desktop.conf"
    else:
        dst_path = f"{home_dir}/.config/lxsession/LXDE/desktop.conf"

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

    lxde_funcs.fix_settings(old_str, new_str, dst_path)
# ------------------------------------------------------------------------------

# ==============================================================================



# Main =========================================================================
if __name__ == "__main__":
    set_desktop_icons(HOME_DIR)
    set_theme(HOME_DIR)
# ==============================================================================
