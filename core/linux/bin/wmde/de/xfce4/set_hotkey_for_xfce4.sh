#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_for_xfce4.sh;
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
# ==============================================================================


# Func =========================================================================
# ------------------------------------------------------------------------------
# set_prop_value ${ch} ${prop} ${typ} ${val};
source ${CORE_BIN_DIR}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------

function set_focus_hotkey()
{
    # expose -------------------------------------------------------------------
    # win+tab
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Tab" "string" "";

    if [[ -f "/usr/bin/skippy-xd" ]]; then
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/usr/bin/skippy-xd"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "/usr/bin/skippy-xd";
    elif [[ -f "/usr/local/bin/skippy-xd" ]]; then
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/usr/local/bin/skippy-xd"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "/usr/local/bin/skippy-xd";
    else
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/home/jungs/.nix-profile/bin/skippy-xd"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "${HOME}/.nix-profile/bin/skippy-xd";
    fi
    # --------------------------------------------------------------------------

    # show desktop -------------------------------------------------------------
    # ctrl+alt+d >> win+d
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>d" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>d" -t "string" -s "show_desktop_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>d" "string" "show_desktop_key";
    # --------------------------------------------------------------------------
}


function set_lock_hotkey()
{
    # screensaver --------------------------------------------------------------
    # ctrl+alt+l >> win+l
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>l" "string" "";

    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "/usr/bin/xfce4-screensaver-command --activate"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "/usr/bin/xfce4-screensaver-command --activate";
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "/usr/bin/xfce4-screensaver-command --lock";
    else
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "/usr/bin/xscreensaver-command -lock"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "/usr/bin/xscreensaver-command -lock";
    fi
    # --------------------------------------------------------------------------
}


function set_system_hotkey()
{
    # whiskermenu --------------------------------------------------------------
    if [[ *"${CUR_VER}"* != *"ID=MX"* ]]; then  # not mxlinux
        # ctrl+esc
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>Escape" "string" "";
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>Escape"" -t "string" -s "/usr/bin/xfce4-popup-whiskermenu"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>Escape" "string" "/usr/bin/xfce4-popup-whiskermenu";
    fi
    # --------------------------------------------------------------------------

    # appmenu ------------------------------------------------------------------
    # alt+f1 >> win+esc
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F1" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Escape" -t "string" -s "xfce4-popup-applicationsmenu"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Escape" "string" "xfce4-popup-applicationsmenu";
    # --------------------------------------------------------------------------

    # taskmanager --------------------------------------------------------------
    # ctrl+shift+esc (for mxlinux)
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Shift>Escape" -t "string" -s "xfce4-taskmanager"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Shift>Escape" "string" "xfce4-taskmanager";
    # --------------------------------------------------------------------------

    # settings -----------------------------------------------------------------
    # win+i
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>i" -t "string" -s "xfce4-settings-manager"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>i" "string" "xfce4-settings-manager";
    # --------------------------------------------------------------------------

    # xkill --------------------------------------------------------------------
    # ctrl+alt+esc >> win+x
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>Escape" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>x" -t "string" -s "/bin/xkill"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>x" "string" "/bin/xkill";
    # --------------------------------------------------------------------------
}


function set_app_hotkey()
{
    # spotlight ----------------------------------------------------------------
    # alt+f2 >> ctrl+space (removed)
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>space" -t "string" -s "xfce4-appfinder"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>space" "string" "xfce4-appfinder --collapsed";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "xfce4-appfinder";

    # alt+f3
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------

    # terminal dropdown --------------------------------------------------------
    # f4 >> removed
    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        #       <property name="F4" type="string" value="xfce4-terminal --drop-down"/>
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/F4" "string" "";
    fi
    # --------------------------------------------------------------------------
}


function set_tiling_hotkey()
{
    # window tile (not used) ---------------------------------------------------
    # local tog_fs_path="${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"

    # win+keypad_up >> win+up
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "";

    # if [[ -f ${tog_fs_path} ]]; then
    #     xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Up" "string" ${tog_fs_path};
    # else
    #     xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "fill_window_key"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "fill_window_key";
    # fi
    # --------------------------------------------------------------------------

    # window tile (up) ---------------------------------------------------------
    # win+keypad_up >> win+up
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "fill_window_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "fill_window_key";

    # shift+win+up
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "tile_up_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "tile_up_key";
    # --------------------------------------------------------------------------

    # window tile (down, left, right) ------------------------------------------
    # win+keypad_down >> win+down
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Down" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Down" -t "stringv -s "tile_down_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Down" "string" "tile_down_key";

    # win+keypad_left >> win+left
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Left" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Left" -t "string" -s "tile_left_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Left" "string" "tile_left_key";

    # win+keypad_right >> win+right
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Right" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Right" -t "string" -s "tile_right_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Right" "string" "tile_right_key";
    # --------------------------------------------------------------------------

    # window to left/right screen ----------------------------------------------
    if [[ *"${CUR_VER}"* != *"ID=MX"* ]]; then  # not mxlinux
        # ----------------------------------------------------------------------
        # shift+win+left
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "";
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Left" -t "string" -s "move_window_to_monitor_left_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "move_window_to_monitor_left_key";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Left" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh";
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # shift+win+right
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "";
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Right" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Right" -t "string" -s "move_window_to_monitor_right_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "move_window_to_monitor_right_key";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Right" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_r_screen.sh"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Right" "string" "bash ${CORE_BIN_DIR}/tiling/move_r_screen.sh";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # maximize window ----------------------------------------------------------
    # alt+f10 (for mxlinux)
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>F10 -t string" -s "maximize_window_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Alt>F10" "string" "maximize_window_key";
    # --------------------------------------------------------------------------
}


function set_workspace_hotkey()
{
    # workspace : jump to workspace-number (with arrow-keys)--------------------
    # ctrl+alt+up >> ctrl+win+up
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Up" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Up" -t "string" -s "up_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Up" "string" "up_workspace_key";

    # ctrl+alt+down >> ctrl+win+down
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Down" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Down" -t "string" -s "down_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Down" "string" "down_workspace_key";

    # ctrl+alt+left >> ctrl+win+left
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Left" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Left" -t "string" -s "left_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Left" "string" "left_workspace_key";

    # ctrl+alt+right >> ctrl+win+right
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Right" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Right" -t "string" -s "right_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Right" "string" "right_workspace_key";
    # --------------------------------------------------------------------------

    # workspace : jump to workspace-number -------------------------------------
    local cur_num="";
    local nums="1 2 3 4 5 6 7 8 9 10 11 12"

    for cur_num in ${nums};
    do
        # workspace : jump to worksapce-number (with f-keys) -------------------
        # ctrl+f1 >> win+f1
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>F${cur_num}" "string" "";
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>F1" -t "stringv -s "workspace_1_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>F${cur_num}" "string" "workspace_${cur_num}_key";
        # ----------------------------------------------------------------------

        # workspace : move window to worksapce-number --------------------------
        # ctrl+alt+kp1 >> shift+win+f1
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>KP_${cur_num}" "string" "";
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>F1" -t "string" -s "move_window_workspace_1_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>F${cur_num}" "string" "move_window_workspace_${cur_num}_key";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    set_focus_hotkey;
    set_lock_hotkey;
    set_system_hotkey;
    set_app_hotkey;
    set_tiling_hotkey
    set_workspace_hotkey;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

