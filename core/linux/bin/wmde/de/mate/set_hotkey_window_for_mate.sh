#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/mate/set_hotkey_window_for_mate.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/mate
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
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

    # ctl+alt+d 에서 win+d로 수정해야한다.
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Hide all normal windows and set focus to the desktop
    # /org/mate/marco/global-keybindings/show-desktop
    #   '<Mod4>d'

    gsettings set "org.mate.Marco.global-keybindings" "show-desktop" '<Mod4>d';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-switching()
{
    # --------------------------------------------------------------------------
    # window-switching
    # alt+tab

    # 이미있음
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Move between windows, using a popup window
    # /org/mate/marco/global-keybindings/switch-windows
    # '<Alt>Tab'

    gsettings set "org.mate.Marco.global-keybindings" "switch-windows" '<Alt>Tab';
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
    # win+up

    # 이미있음
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement
    # /org/mate/marco/window-keybindings/maximize
    #   '<Mod4>Up'
    gsettings set "org.mate.Marco.window-keybindings" "maximize" '<Mod4>Up';
    # --------------------------------------------------------------------------
}



function set_hotkey_for_tile-window-to-bottom()
{
    # --------------------------------------------------------------------------
    # window tile (down)
    # win+keypad_down >> win+down

    # 이미있음
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Restore window
    # /org/mate/marco/window-keybindings/unmaximize
    # '<Mod4>Down'
    gsettings set "org.mate.Marco.window-keybindings" "unmaximize" '<Mod4>Down';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-left()
{
    # --------------------------------------------------------------------------
    # window tile (left)
    # win+keypad_left >> win+left

    # 이미있음
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Tile window to west(left) side of screen
    # /org/mate/marco/window-keybindings/tile-to-side-w
    # '<Mod4>Left'
    gsettings set "org.mate.Marco.window-keybindings" "tile-to-side-w" '<Mod4>Left';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-right()
{
    # --------------------------------------------------------------------------
    # window tile (right)
    # win+keypad_right >> win+right

    # 이미있음
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Tile window to east(right) side of screen
    # /org/mate/marco/window-keybindings/tile-to-side-e
    # '<Mod4>Right'
    gsettings set "org.mate.Marco.window-keybindings" "tile-to-side-e" '<Mod4>Right';
    # --------------------------------------------------------------------------
}

function set_hotkey_for_left-screen()
{
    # --------------------------------------------------------------------------
    # shift+win+left

    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Move winodow to west (left) monitor
    # /org/mate/marco/window-keybindings/move-to-monitor-w
    # '<Shift><Mod4>Left'
    gsettings set "org.mate.Marco.window-keybindings" "move-to-monitor-w" '<Shift><Mod4>Left';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-screen()
{
    # --------------------------------------------------------------------------
    # shift+win+right

    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Move winodow to east (right) monitor
    # /org/mate/marco/window-keybindings/move-to-monitor-e
    # '<Shift><Mod4>Right'
    gsettings set "org.mate.Marco.window-keybindings" "move-to-monitor-e" '<Shift><Mod4>Right';
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
        [[ -n $(pacman -Q | grep -i ^mate) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^mate) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^mate) ]] && set_all_hotkey_for_window;
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