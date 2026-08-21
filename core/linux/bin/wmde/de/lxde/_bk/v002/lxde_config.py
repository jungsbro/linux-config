import os
import sys
import shutil

# usage ========================================================================
# python3 "${CORE_BIN_DIR}/wmde/de/lxde/lxde_config.py" "${CUR_USER}"

# dbus-run-session python3 ${CORE_BIN_DIR}/wmde/de/lxde/lxde_config.py "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde/de/lxde/lxde_config.py
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


# Main =========================================================================
if __name__ == "__main__":
    import lxde_panel
    lxde_panel.set_panel(CORE_BIN_DIR, HOME_DIR)

    import lxde_theme
    lxde_theme.set_desktop_icons(HOME_DIR)
    lxde_theme.set_theme(HOME_DIR)

    import lxde_system
    lxde_system.set_text_editor(HOME_DIR)
    lxde_system.set_mouse_double_click(HOME_DIR)

    import lxde_hotkey
    lxde_hotkey.set_shortcuts(CORE_BIN_DIR, HOME_DIR)
# ==============================================================================
