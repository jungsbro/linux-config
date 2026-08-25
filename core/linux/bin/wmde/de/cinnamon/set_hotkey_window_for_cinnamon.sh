#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_hotkey_window_for_cinnamon.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/cinnamon
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# set_attrib_value "${cat}" "${attr}" "${val}";
source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_showdesktop()
{
    # --------------------------------------------------------------------------
    # show desktop
    # ctrl+alt+d >> win+d

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Show desktop
    # gsettings set org.cinnamon.desktop.keybindings.wm show-desktop "['<Super>d']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="show-desktop";
    local val="['<Super>d']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-switching()
{
    # --------------------------------------------------------------------------
    # window-switching
    # alt+tab

    # 이미  있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Cycle through open windows
    # gsettings set org.cinnamon.desktop.keybindings.wm switch-windows "['<Alt>Tab']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="switch-windows";
    local val="['<Alt>Tab']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # --------------------------------------------------------------------------
}


function set_hotkey_for_expose()    # not used
{
    # --------------------------------------------------------------------------
    # expose
    # win+tab

    # expose 초기화했다.
    echo ""
    # gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-up "['<Control><Alt>Up', '<Alt>F1', '<Shift><Super>Tab']"
    # gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-down "['<Control><Alt>Down', '<Super>Tab']"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_maximizing-window()    # not used
{
    # --------------------------------------------------------------------------
    # maximize window
    # alt+f10

    echo ""
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filling-window()    # not used
{

    # --------------------------------------------------------------------------
    # window tile (fill up)
    # win+up

    echo ""
    # --------------------------------------------------------------------------
}


function set_hotkey_for_restoring-window()    # not used
{
    echo ""
}


function set_hotkey_for_tile-window-to-top()
{
    # --------------------------------------------------------------------------
    # window tile (up)
    # shift+win+up

    # 이미 있음 >> window랑 같은 방식이라 수정(Super+Shift+Up)할필요 없다.
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Tiling and Snapping >> Push tile up
    # gsettings set org.cinnamon.desktop.keybindings.wm push-tile-up "['<Super>Up']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="push-tile-up";
    local val="['<Super>Up']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-bottom()
{
    # --------------------------------------------------------------------------
    # window tile (down)
    # win+keypad_down >> win+down

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Tiling and Snapping >> Push tile down
    # gsettings set org.cinnamon.desktop.keybindings.wm push-tile-down "['<Super>Down']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="push-tile-down";
    local val="['<Super>Down']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-left()
{
    # --------------------------------------------------------------------------
    # window tile (left)
    # win+keypad_left >> win+left

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Tiling and Snapping >> Push tile left
    # gsettings set org.cinnamon.desktop.keybindings.wm push-tile-left "['<Super>Left']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="push-tile-left";
    local val="['<Super>Left']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-right()
{
    # --------------------------------------------------------------------------
    # window tile (right)
    # win+keypad_right >> win+right

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Tiling and Snapping >> Push tile right
    # gsettings set org.cinnamon.desktop.keybindings.wm push-tile-right "['<Super>Right']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="push-tile-right";
    local val="['<Super>Right']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}

function set_hotkey_for_left-screen()
{
    # --------------------------------------------------------------------------
    # shift+win+left

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Positioning >> Move window to upper-left
    # gsettings set org.cinnamon.desktop.keybindings.wm move-to-monitor-left "['<Shift><Super>Left']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="move-to-monitor-left";
    local val="['<Shift><Super>Left']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-screen()
{
    # --------------------------------------------------------------------------
    # shift+win+right

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Positioning >> Move window to upper-right
    # gsettings set org.cinnamon.desktop.keybindings.wm move-to-monitor-right "['<Shift><Super>Right']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="move-to-monitor-right";
    local val="['<Shift><Super>Right']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}



function set_all_hotkey_for_window()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_showdesktop;
    set_hotkey_for_window-switching;
    # set_hotkey_for_expose;

    # set_hotkey_for_maximizing-window;
    # set_hotkey_for_filling-window;
    # set_hotkey_for_restoring-window;

    set_hotkey_for_tile-window-to-top;
    set_hotkey_for_tile-window-to-bottom;
    set_hotkey_for_tile-window-to-left;
    set_hotkey_for_tile-window-to-right;

    set_hotkey_for_left-screen;
    set_hotkey_for_right-screen;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^cinnamon) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^cinnamon) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^cinnamon) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================