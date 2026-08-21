#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_hotkey_workspace_for_ob.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/wm/openbox
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

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/lxde/set_funcs_for_lxde.sh

OB_NS="http://openbox.org/3.4/rc";

OBRC_PATH="${HOME_DIR}/.config/openbox/rc.xml";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_left-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Left";
    local comment="Keybinding for workspace movement1";
    local action="DesktopLeft";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Right";
    local comment="";
    local action="DesktopRight";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_up-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Up";
    local comment="";
    local action="DesktopUp";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_down-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Down";
    local comment="";
    local action="DesktopDown";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_fkey-ws()
{
    # workspace : jump to workspace-number -------------------------------------
    local cur_num="";
    local nums="1 2 3 4"

    local hotkey="";
    local comment="";
    local ws_num="";

    for cur_num in ${nums};
    do
        # workspace : jump to worksapce-number (with f-keys) -------------------
        hotkey="W-F${cur_num}";
        ws_num="${cur_num}";
        set_hotkey_for_going-to-desktop "${OB_NS}" "${hotkey}" "${comment}" "${ws_num}" "${OBRC_PATH}";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-ws()
{
    # workspace : jump to workspace-number -------------------------------------
    local cur_num="";
    local nums="1 2 3 4"

    local hotkey="";
    local comment="";
    local action="SendToDesktop";
    local key1="to";
    local value1="";

    for cur_num in ${nums};
    do
        # workspace : move window to worksapce-number --------------------------
        hotkey="W-S-F${cur_num}";
        value1="${cur_num}";

    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-left-ws()    # W-S-Left를 이미 사용했기때문에 사용하지 않는다.
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Left";
    local comment="Keybinding for app-to-workspace";
    local action="SendToDesktopLeft";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-right-ws()    # W-S-Right를 이미 사용했기때문에 사용하지 않는다.
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Right";
    local comment="";
    local action="SendToDesktopRight";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-up-ws()    # W-S-Up을 이미 사용했기때문에 사용하지 않는다.
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Up";
    local comment="";
    local action="SendToDesktopUp";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-down-ws()    # W-S-Down을 이미 사용했기때문에 사용하지 않는다.
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Down";
    local comment="";
    local action="SendToDesktopDown";
    local key1="dialog";
    local value1="no";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${key1}" "${value1}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_all_hotkey_for_workspace()
{
    # --------------------------------------------------------------------------
    local comment=" ==================== My Custom Workspace Shortcuts ==================== ";

    xmlstarlet ed -L -N x="${OB_NS}" \
    -a "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v "${comment}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_left-ws;
    set_hotkey_for_right-ws;
    set_hotkey_for_up-ws;
    set_hotkey_for_down-ws;

    set_hotkey_for_fkey-ws;

    set_hotkey_for_app-to-ws;

    # set_hotkey_for_app-to-left-ws;
    # set_hotkey_for_app-to-right-ws;
    # set_hotkey_for_app-to-up-ws;
    # set_hotkey_for_app-to-down-ws;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^openbox) ]] && set_all_hotkey_for_workspace
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_workspace;
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