#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_for_xfwm4.sh;
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
# set_prop_value "${ch}" "${prop}" "${typ}" "${val}";
source ${CORE_BIN_DIR}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------

function set_focus_hotkey()
{
    # expose -------------------------------------------------------------------
    # win+tab
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Tab" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Tab" "string" "";

    # sxhkdrc에서 설정
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "rofi -show window -show-icons"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'";

    # if [[ -f "skippy-xd" ]]; then
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "skippy-xd"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "skippy-xd";
    # elif [[ -f "/usr/local/bin/skippy-xd" ]]; then
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/usr/local/bin/skippy-xd"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "/usr/local/bin/skippy-xd";
    # else
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/home/jungs/.nix-profile/bin/skippy-xd"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "${HOME}/.nix-profile/bin/skippy-xd";
    # fi
    # --------------------------------------------------------------------------

    # show desktop -------------------------------------------------------------
    # ctrl+alt+d >> win+d
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>d" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>d" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>d" -t "string" -s "show_desktop_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>d" "string" "show_desktop_key";
    # --------------------------------------------------------------------------
}


function set_lock_hotkey()
{
    # screensaver --------------------------------------------------------------
    # ctrl+alt+l >> win+l
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>l" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>l" "string" "";

    # sxhkdrc에서 설정
    # if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xfce4-screensaver-command --activate"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "xfce4-screensaver-command --activate";
    #     # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "xfce4-screensaver-command --lock";
    # else
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xscreensaver-command -lock"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "xscreensaver-command -lock";
    # fi
    # --------------------------------------------------------------------------
}


function set_system_hotkey()
{
    # whiskermenu --------------------------------------------------------------
    if [[ "${CUR_VER}" != *"ID=MX"* ]]; then  # not mxlinux
        # ctrl+esc
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Escape" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>Escape" "string" "";

        # sxhkdrc에서 설정
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>Escape"" -t "string" -s "xfce4-popup-whiskermenu"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>Escape" "string" "xfce4-popup-whiskermenu";
    fi
    # --------------------------------------------------------------------------

    # appmenu ------------------------------------------------------------------
    # alt+f1 >> win+esc
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F1" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F1" "string" "";

    # sxhkdrc에서 설정
    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Escape" -t "string" -s "xfce4-popup-applicationsmenu"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Escape" "string" "xfce4-popup-applicationsmenu";
    # --------------------------------------------------------------------------

    # taskmanager --------------------------------------------------------------
    # ctrl+shift+esc (for mxlinux)

    # sxhkdrc에서 설정
    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Shift>Escape" -t "string" -s "xfce4-taskmanager"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Shift>Escape" "string" "xfce4-taskmanager";
    # --------------------------------------------------------------------------

    # settings -----------------------------------------------------------------
    # win+i

    # sxhkdrc에서 설정
    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>i" -t "string" -s "xfce4-settings-manager"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>i" "string" "xfce4-settings-manager";
    # --------------------------------------------------------------------------

    # xkill --------------------------------------------------------------------
    # ctrl+alt+esc >> win+x
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>Escape" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>Escape" "string" "";

    # sxhkdrc에서 설정
    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>x" -t "string" -s "/bin/xkill"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>x" "string" "/bin/xkill";
    # --------------------------------------------------------------------------
}


function set_app_hotkey()
{
    # spotlight1 ---------------------------------------------------------------
    # alt+f2 >> ctrl+space (removed)
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "";

    # sxhkdrc에서 설정
    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>space" -t "string" -s "xfce4-appfinder"
    # # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>space" "string" "xfce4-appfinder --collapsed";

    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -t "string" -s "xfce4-appfinder"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------

    # spotlight2 ---------------------------------------------------------------
    # alt+f3
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "";

    # sxhkdrc에서 설정
    # # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -t "string" -s "xfce4-appfinder"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------

    # terminal dropdown --------------------------------------------------------
    # f4 >> removed
    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
        #       <property name="F4" type="string" value="xfce4-terminal --drop-down"/>
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/F4" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/F4" "string" "";
    fi
    # --------------------------------------------------------------------------
}


function set_tiling_hotkey()
{
    # window tile (not used) ---------------------------------------------------
    # local tog_fs_path="${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"

    # win+keypad_up >> win+up
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Up" -t "string" -s ""
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s ""
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "";

    # if [[ -f "${tog_fs_path}" ]]; then
    #     xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Up" "string" "${tog_fs_path}";
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

    # window tile (up) ---------------------------------------------------------
    # shift+win+up
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "tile_up_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "tile_up_key";
    # --------------------------------------------------------------------------

    # window tile (down) -------------------------------------------------------
    # win+keypad_down >> win+down
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Down" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Down" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Down" -t "string" -s "tile_down_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Down" "string" "tile_down_key";
    # --------------------------------------------------------------------------

    # window tile (left) -------------------------------------------------------
    # win+keypad_left >> win+left
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Left" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Left" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Left" -t "string" -s "tile_left_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Left" "string" "tile_left_key";
    # --------------------------------------------------------------------------

    # window tile (right) ------------------------------------------------------
    # win+keypad_right >> win+right
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>KP_Right" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Right" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Right" -t "string" -s "tile_right_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Right" "string" "tile_right_key";
    # --------------------------------------------------------------------------

    # window to left/right screen ----------------------------------------------
    if [[ "${CUR_VER}" != *"ID=MX"* ]]; then  # not mxlinux
        # ----------------------------------------------------------------------
        # shift+win+left
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Left" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Left" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Left" -t "string" -s "move_window_to_monitor_left_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "move_window_to_monitor_left_key";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Left" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh";
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # shift+win+right
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Right" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Right" -t "string" -s ""
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
    # workspace : jump to workspace-number (with up) ---------------------------
    # ctrl+alt+up >> ctrl+win+up
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Up" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Up" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Up" -t "string" -s "up_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Up" "string" "up_workspace_key";
    # --------------------------------------------------------------------------

    # workspace : jump to workspace-number (with donw) -------------------------
    # ctrl+alt+down >> ctrl+win+down
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Down" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Down" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Down" -t "string" -s "down_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Down" "string" "down_workspace_key";
    # --------------------------------------------------------------------------

    # workspace : jump to workspace-number (with left) -------------------------
    # ctrl+alt+left >> ctrl+win+left
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Left" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Left" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Left" -t "string" -s "left_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Left" "string" "left_workspace_key";
    # --------------------------------------------------------------------------

    # workspace : jump to workspace-number (with right) ------------------------
    # ctrl+alt+right >> ctrl+win+right
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Right" -t "string" -s ""
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
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary>F1" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>F${cur_num}" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>F1" -t "string" -s "workspace_1_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>F${cur_num}" "string" "workspace_${cur_num}_key";
        # ----------------------------------------------------------------------

        # workspace : move window to worksapce-number --------------------------
        # ctrl+alt+kp1 >> shift+win+f1
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>KP_1" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>KP_${cur_num}" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>F1" -t "string" -s "move_window_workspace_1_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>F${cur_num}" "string" "move_window_workspace_${cur_num}_key";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}

function set_all_hotkey()
{
    # --------------------------------------------------------------------------
    set_focus_hotkey;
    set_lock_hotkey;
    set_system_hotkey;
    set_app_hotkey;
    set_tiling_hotkey
    set_workspace_hotkey;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^xfwm4) ]] && set_all_hotkey;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xfwm4) ]] && set_all_hotkey;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xfwm4) ]] && set_all_hotkey;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

