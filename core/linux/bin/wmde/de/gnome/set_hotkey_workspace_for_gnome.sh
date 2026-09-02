#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_hotkey_workspace_for_gnome.sh;
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

    # 수정해야함
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navigation >> Move window one workspace to the left
    # /org/gnome/desktop/wm/keybindings/move-to-workspace-left
    #   ['<Control><Super>Left']

    gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-left" "['<Control><Super>Left']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-ws()
{
    # --------------------------------------------------------------------------
    # workspace : jump to workspace-number (with right)
    # ctrl+alt+right
    # ctrl+win+right

    # 수정해야함
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navigation >> Move window one workspace to the right
    # /org/gnome/desktop/wm/keybindings/move-to-workspace-right
    #   ['<Control><Super>Right']

    gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-right" "['<Control><Super>Right']";
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

    # 1) 초기화
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Launchers >> Launch help browser
    # /org/gnome/settings-daemon/plugins/media-keys/help
    # @as []
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "help" "[]";


    for cur_num in ${nums};
    do
        # workspace : jump to worksapce-number (with f-keys) -------------------
        # win+f1

        # 2) 수정해야 한다.
        # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navigation >> Switch to workspace 1
        # /org/gnome/desktop/wm/keybindings/switch-to-workspace-1
        # ['<Super>F1']
        gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-${cur_num}" "['<Super>F${cur_num}']";
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

        # 수정
        # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Navigation >> Move window to workspace 1
        # /org/gnome/desktop/wm/keybindings/move-to-workspace-1
        # ['<Shift><Super>F1']
        gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-${cur_num}" "['<Shift><Super>F${cur_num}']";
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
        [[ -n $(pacman -Q | grep -i ^gnome) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^gnome) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome) ]] && set_all_hotkey_for_workspace;
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