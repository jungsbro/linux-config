#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_workspace_for_xfce4.sh;
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
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# set_prop_value ${ch} ${prop} ${typ} ${val};
source ${CORE_BIN_DIR}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_left-ws()
{
    # workspace : jump to workspace-number (with left) -------------------------
    # ctrl+alt+left >> ctrl+win+left

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Left" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Left" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Left" -t "string" -s "left_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Left" "string" "left_workspace_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-ws()
{
    # workspace : jump to workspace-number (with right) ------------------------
    # ctrl+alt+right >> ctrl+win+right

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Right" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Right" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Right" -t "string" -s "right_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Right" "string" "right_workspace_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_up-ws()
{
    # workspace : jump to workspace-number (with up) ---------------------------
    # ctrl+alt+up >> ctrl+win+up

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Up" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Up" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Up" -t "string" -s "up_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Up" "string" "up_workspace_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_down-ws()
{
    # workspace : jump to workspace-number (with donw) -------------------------
    # ctrl+alt+down >> ctrl+win+down

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Down" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Down" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Down" -t "string" -s "down_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Down" "string" "down_workspace_key";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_fkey-ws()
{
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
    done
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-ws()
{
    # workspace : jump to workspace-number -------------------------------------
    local cur_num="";
    local nums="1 2 3 4 5 6 7 8 9 10 11 12"

    for cur_num in ${nums};
    do
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


function set_all_hotkey_for_workspace()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_left-ws;
    set_hotkey_for_right-ws;
    set_hotkey_for_up-ws;
    set_hotkey_for_down-ws;

    set_hotkey_for_fkey-ws;

    set_hotkey_for_app-to-ws;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^xfwm4) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xfwm4) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xfwm4) ]] && set_all_hotkey_for_workspace;
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