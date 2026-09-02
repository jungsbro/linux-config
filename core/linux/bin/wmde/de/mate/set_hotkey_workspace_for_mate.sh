#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/mate/set_hotkey_workspace_for_mate.sh;
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
function set_hotkey_for_left-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with left)
    # ctrl+alt+left
    # ctrl+win+left

    # 수정
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Switch to workspace on the left of the current workspace
    # /org/mate/marco/global-keybindings/switch-to-workspace-left
    # '<Primary><Mod4>Left'
    gsettings set "org.mate.Marco.global-keybindings" "switch-to-workspace-left" '<Primary><Mod4>Left';
    # --------------------------------------------------------------------------
}



function set_hotkey_for_right-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with right)
    # ctrl+alt+right
    # ctrl+win+right

    # 수정
    # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Switch to workspace on the right of the current workspace
    # /org/mate/marco/global-keybindings/switch-to-workspace-right
    # '<Primary><Mod4>Right'
    gsettings set "org.mate.Marco.global-keybindings" "switch-to-workspace-right" '<Primary><Mod4>Right';
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
    local nums="1 2 3 4"

    local attr_path="";
    local attr_name="";
    local val="";

    for cur_num in ${nums};
    do
        # workspace : jump to worksapce-number (with f-keys) -------------------
        # win+f1

        # 추가
        # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Switch to workspace 1
        # /org/mate/marco/global-keybindings/switch-to-workspace-1
        # '<Mod4>F1'
        gsettings set "org.mate.Marco.global-keybindings" "switch-to-workspace-${cur_num}" "<Mod4>F${cur_num}";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number
    local cur_num="";
    local nums="1 2 3 4"

    local attr_path="";
    local attr_name="";
    local val="";

    for cur_num in ${nums};
    do
        # workspace : move window to worksapce-number --------------------------
        # shift+win+f1

        # 추가
        # settings >> Hardware >> Keyboard Shortcuts >> Window Mangement >> Move window to workspace 1
        # /org/mate/marco/window-keybindings/move-to-workspace-1
        # '<Shift><Mod4>F1'
        gsettings set "org.mate.Marco.window-keybindings" "move-to-workspace-${cur_num}" "<Shift><Mod4>F${cur_num}";
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
        [[ -n $(pacman -Q | grep -i ^mate) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^mate) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^mate) ]] && set_all_hotkey_for_workspace;
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