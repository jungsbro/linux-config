#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_hotkey_workspace_for_cinnamon.sh;
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
function set_hotkey_for_left-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with left)
    # ctrl+alt+left
    # ctrl+win+left

    # 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Workspaces >> Switch to left workspace
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-left" "['<Control><Alt>Left', '<Primary><Super>Left']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="switch-to-workspace-left";
    local val="['<Control><Alt>Left', '<Primary><Super>Left']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with right)
    # ctrl+alt+right
    # ctrl+win+right

    # 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Workspaces >> Switch to right workspace
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-right" "['<Control><Alt>Right', '<Primary><Super>Right']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="switch-to-workspace-right";
    local val="['<Control><Alt>Right', '<Primary><Super>Right']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_up-ws()     # not used
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with up)
    # ctrl+win+up

    echo ""
    # --------------------------------------------------------------------------
}


function set_hotkey_for_down-ws()     # not used
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with donw)
    # ctrl+win+down

    echo ""
    # --------------------------------------------------------------------------
}


function set_hotkey_for_fkey-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number
    local cur_num="";
    local nums="1 2 3 4 5 6 7 8 9 10 11 12"

    local attr_path="";
    local attr_name="";
    local val="";

    for cur_num in ${nums};
    do
        # workspace : jump to worksapce-number (with f-keys) -------------------
        # win+f1

        # 추가
        # System Settings >> Hardware >> Keyboard >> Shortcuts >> Workspaces >> Direct Nvigation >> Switch to workspace 1
        # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-${cur_num}" "['<Super>F${cur_num}']"
        attr_path="org.cinnamon.desktop.keybindings.wm";
        attr_name="switch-to-workspace-${cur_num}";
        val="['<Super>F${cur_num}']";
        set_attr_value "${attr_path}" "${attr_name}" "${val}";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number
    local cur_num="";
    local nums="1 2 3 4 5 6 7 8 9 10 11 12"

    local attr_path="";
    local attr_name="";
    local val="";

    for cur_num in ${nums};
    do
        # workspace : move window to worksapce-number --------------------------
        # shift+win+f1

        # 추가
        # System Settings >> Hardware >> Keyboard >> Shortcuts >> Windows >> Inter-workspace >> Move window to workspace1
        # gsettings set "org.cinnamon.desktop.keybindings.wm" "move-to-workspace-${cur_num}" "['<Shift><Super>F${cur_num}']"
        attr_path="org.cinnamon.desktop.keybindings.wm";
        attr_name="move-to-workspace-${cur_num}";
        val="['<Shift><Super>F${cur_num}']";
        set_attr_value "${attr_path}" "${attr_name}" "${val}";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}


function set_all_hotkey_for_workspace()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_left-ws;
    set_hotkey_for_right-ws;
    # set_hotkey_for_up-ws;
    # set_hotkey_for_down-ws;

    set_hotkey_for_fkey-ws;

    set_hotkey_for_app-to-ws;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^cinnamon) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^cinnamon) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^cinnamon) ]] && set_all_hotkey_for_workspace;
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