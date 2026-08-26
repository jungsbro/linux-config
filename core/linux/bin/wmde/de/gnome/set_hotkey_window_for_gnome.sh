#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_hotkey_window_for_gnome.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/gnome
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
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

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navitation >> Hide all normal windows

    # /org/gnome/desktop/wm/keybindings/show-desktop
    # ['<Super>d']

    gsettings set "org.gnome.desktop.wm.keybindings" "show-desktop" "['<Super>d']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-switching()
{
    # --------------------------------------------------------------------------
    # window-switching
    # alt+tab

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navitation >> Switch applications
    # /org/gnome/desktop/wm/keybindings/switch-applications
    #   ['<Alt>Tab']
    # /org/gnome/desktop/wm/keybindings/switch-applications-backward
    #   ['<Shift><Alt>Tab']

    gsettings set "org.gnome.desktop.wm.keybindings" "switch-applications" "['<Alt>Tab']";
    gsettings set "org.gnome.desktop.wm.keybindings" "switch-applications-backward" "['<Shift><Alt>Tab']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_expose()    # not used
{
    # --------------------------------------------------------------------------
    # expose
    # win+tab

    # expose 초기화했다.
    echo ""
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

    # 이미 있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Windows >> Maximize window

    # /org/gnome/desktop/wm/keybindings/maximize
    #   ['<Super>Up']

    gsettings set "org.gnome.desktop.wm.keybindings" "maximize" "['<Super>Up']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-bottom()
{
    # --------------------------------------------------------------------------
    # window tile (down)
    # win+keypad_down >> win+down

    # 이미있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Windows >> Restore window
    # /org/gnome/desktop/wm/keybindings/unmaximize
    # ['<Super>Down']

    gsettings set "org.gnome.desktop.wm.keybindings" "unmaximize" "['<Super>Down']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-left()
{
    # --------------------------------------------------------------------------
    # window tile (left)
    # win+keypad_left >> win+left

    # 이미있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Windows >> View split on left
    # /org/gnome/mutter/keybindings/toggle-tiled-left
    # ['<Super>Left']

    gsettings set "org.gnome.mutter.keybindings" "toggle-tiled-left" "['<Super>Left']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-right()
{
    # --------------------------------------------------------------------------
    # window tile (right)
    # win+keypad_right >> win+right

    # 이미있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Windows >> View split on right

    # /org/gnome/mutter/keybindings/toggle-tiled-right
    #   ['<Super>Right']

    gsettings set "org.gnome.mutter.keybindings" "toggle-tiled-right" "['<Super>Right']";
    # --------------------------------------------------------------------------
}

function set_hotkey_for_left-screen()
{
    # --------------------------------------------------------------------------
    # shift+win+left

    # 이미있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navigation >> Move window one monitor to the left
    # /org/gnome/desktop/wm/keybindings/move-to-monitor-left
    # ['<Shift><Super>Left']

    gsettings set "org.gnome.desktop.wm.keybindings" "move-to-monitor-left" "['<Shift><Super>Left']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-screen()
{
    # --------------------------------------------------------------------------
    # shift+win+right

    # 이미있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navigation >> Move window one monitor to the right
    # /org/gnome/desktop/wm/keybindings/move-to-monitor-right
    #   ['<Shift><Super>Right']

    gsettings set "org.gnome.desktop.wm.keybindings" "move-to-monitor-right" "['<Shift><Super>Right']";
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
        [[ -n $(pacman -Q | grep -i ^gnome) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^gnome) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome) ]] && set_all_hotkey_for_window;
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