#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_window_for_xfce4.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/xfce4
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# set_prop_value ${ch} ${prop} ${typ} ${val};
source ${CORE_BIN_DIR}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_showdesktop()
{
    # show desktop -------------------------------------------------------------
    # ctrl+alt+d >> win+d

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>d" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>d" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>d" -t "string" -s "show_desktop_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>d" "string" "show_desktop_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-switching()
{
    # widow-switching ----------------------------------------------------------
    # alt+tab

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>Tab" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Alt>Tab" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>Tab" -t "string" -s "cycle_windows_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Alt>Tab" "string" "cycle_windows_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_expose()
{
    # expose -------------------------------------------------------------------
    # win+tab

    # expose를 위해 초기화했다. ("xfce4-keyboard-shortcuts" or "sxhkd" 에서 사용)
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Tab" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Tab" "string" "";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_maximizing-window()
{
    # maximize window ----------------------------------------------------------
    # alt+f10 (for mxlinux)

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>F10 -t string" -s "maximize_window_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Alt>F10" "string" "maximize_window_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filling-window()
{
    # window tile (not used) ---------------------------------------------------
    # local tog_fs_path="${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"

    # win+keypad_up >> win+up
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Up" -t "string" -s ""
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s ""
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "";

    # if [[ -f ${tog_fs_path} ]]; then
    #     xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Up" "string" ${tog_fs_path};
    # else
    #     xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "fill_window_key"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "fill_window_key";
    # fi
    # --------------------------------------------------------------------------

    # window tile (fill up) ----------------------------------------------------
    # win+keypad_up >> win+up

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Up" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "fill_window_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "fill_window_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_restoring-window()
{
    echo ""
}


function set_hotkey_for_tile-window-to-top()
{
    # window tile (up) ---------------------------------------------------------
    # shift+win+up

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "tile_up_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "tile_up_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-bottom()
{
    # window tile (down) -------------------------------------------------------
    # win+keypad_down >> win+down

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Down" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Down" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Down" -t "string" -s "tile_down_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Down" "string" "tile_down_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-left()
{
    # window tile (left) -------------------------------------------------------
    # win+keypad_left >> win+left

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Left" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Left" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Left" -t "string" -s "tile_left_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Left" "string" "tile_left_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-right()
{
    # window tile (right) ------------------------------------------------------
    # win+keypad_right >> win+right

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Right" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Right" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Right" -t "string" -s "tile_right_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Right" "string" "tile_right_key";
    # --------------------------------------------------------------------------
}

function set_hotkey_for_left-screen()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # shift+win+left

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Left" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Left" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Left" -t "string" -s "move_window_to_monitor_left_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "move_window_to_monitor_left_key";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Left" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-screen()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # shift+win+right
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Right" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Right" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Right" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Right" -t "string" -s "move_window_to_monitor_right_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "move_window_to_monitor_right_key";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Right" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_r_screen.sh"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Right" "string" "bash ${CORE_BIN_DIR}/tiling/move_r_screen.sh";
    # --------------------------------------------------------------------------
}



function set_all_hotkey_for_window()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_showdesktop;
    set_hotkey_for_window-switching;
    set_hotkey_for_expose;

    set_hotkey_for_maximizing-window;
    set_hotkey_for_filling-window;
    # set_hotkey_for_restoring-window;

    set_hotkey_for_tile-window-to-top;
    set_hotkey_for_tile-window-to-bottom;
    set_hotkey_for_tile-window-to-left;
    set_hotkey_for_tile-window-to-right;

    set_hotkey_for_left-screen;
    set_hotkey_for_right-screen;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^xfwm4) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xfwm4) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xfwm4) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================
