#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxde/set_hotkey_workspace_for_lxde.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/lxde
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
source ${CORE_BIN_DIR}/wmde/de/lxde/set_funcs_for_lxde.sh

LXDE_NS="http://openbox.org/3.4/rc";

LXDERC_PATH="${HOME_DIR}/.config/openbox/lxde-rc.xml";

SRC_LXDE_PANEL_PATH="/etc/xdg/lxpanel/LXDE/panels/panel";

if is_rpios; then
    DST_LXDE_PANEL_PATH="${HOME_DIR}/.config/lxpanel/LXDE-pi/panels/panel";
    LXSESSION_CONF_PATH="${HOME_DIR}/.config/lxsession/LXDE-pi/desktop.conf";
    PCMANFM_ITEMS_PATH="${HOME_DIR}/.config/pcmanfm/LXDE-pi/desktop-items-0.conf";
else
    DST_LXDE_PANEL_PATH="${HOME_DIR}/.config/lxpanel/LXDE/panels/panel";
    LXSESSION_CONF_PATH="${HOME_DIR}/.config/lxsession/LXDE/desktop.conf";
    PCMANFM_ITEMS_PATH="${HOME_DIR}/.config/pcmanfm/LXDE/desktop-items-0.conf";
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_left-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Left";
    local comment="Keybinding for workspace movement1";
    local action="DesktopLeft";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Right";
    local comment="";
    local action="DesktopRight";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_up-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Up";
    local comment="";
    local action="DesktopUp";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_down-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-C-Down";
    local comment="";
    local action="DesktopDown";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f1-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-F1";
    local comment="Keybinding for workspace movement2";
    local ws_num="1";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_fkey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${ws_num}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f2-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-F2";
    local comment="";
    local ws_num="2";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_fkey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${ws_num}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f3-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-F3";
    local comment="";
    local ws_num="3";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_fkey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${ws_num}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f4-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-F4";
    local comment="";
    local ws_num="4";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_fkey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${ws_num}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-left-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Left";
    local comment="Keybinding for app-to-workspace";
    local action="SendToDesktopLeft";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-right-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Right";
    local comment="";
    local action="SendToDesktopRight";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-up-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Up";
    local comment="";
    local action="SendToDesktopUp";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-down-ws()
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-Down";
    local comment="";
    local action="SendToDesktopDown";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_ws_akey_movement "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_all_hotkey_for_workspace()
{
    # --------------------------------------------------------------------------
    local comment=" ==================== My Custom Workspace Shortcuts ==================== ";

    xmlstarlet ed -L -N x="${LXDE_NS}" \
    -a "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v "${comment}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_left-ws;
    set_hotkey_for_right-ws;
    set_hotkey_for_up-ws;
    set_hotkey_for_down-ws;

    set_hotkey_for_f1-ws;
    set_hotkey_for_f2-ws;
    set_hotkey_for_f3-ws;
    set_hotkey_for_f4-ws;

    set_hotkey_for_app-to-left-ws;
    set_hotkey_for_app-to-right-ws;
    set_hotkey_for_app-to-up-ws;
    set_hotkey_for_app-to-down-ws;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^openbox) ]] && set_all_hotkey_for_workspace
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_workspace;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

