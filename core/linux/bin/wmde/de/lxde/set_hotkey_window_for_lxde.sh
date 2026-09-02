#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxde/set_hotkey_window_for_lxde.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
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
function set_hotkey_for_showdesktop()
{
    # --------------------------------------------------------------------------
    local hotkey="W-d";
    local comment="Keybindings for show-desktop";
    local action="ToggleShowDesktop";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_window "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # C-A-d 초기화
    local hotkey="C-A-d";
    local comment="";
    local action="";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_window "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------

}


function set_hotkey_for_window-switching()
{
    # --------------------------------------------------------------------------
    local hotkey="A-Tab";
    local comment="Keybindings for window-switching";
    local action="NextWindow";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_window "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filling-window()
{
    # --------------------------------------------------------------------------
    local hotkey="W-Up";
    local comment="Keybindings for window-tiling";
    local action="Maximize";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_window "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_restoring-window()
{
    # --------------------------------------------------------------------------
    local hotkey="W-Down";
    local comment="";
    local action="Unmaximize";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_window "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-top()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-S-Up">
    #             <action name="UnmaximizeFull"/>
    #             <action name="MoveResizeTo">
    #                 <x>+0</x>
    #                 <y>+0</y>
    #                 <width>100/100</width>
    #                 <height>50/100</height>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local hotkey="W-S-Up";
    local comment="";
    local value1="+0";
    local value2="+0";
    local value3="100/100";
    local value4="50/100";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_half-window "${LXDE_NS}" "${hotkey}" "${comment}" "${value1}" "${value2}" "${value3}" "${value4}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-bottom()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-Down">
    #             <action name="Unmaximize"/>
    #             <action name="UnmaximizeFull"/>
    #             <action name="MoveResizeTo">
    #                 <x>-0</x>
    #                 <y>-0</y>
    #                 <width>100/100</width>
    #                 <height>50/100</height>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local hotkey="W-Down";
    local comment="";
    local value1="-0";
    local value2="-0";
    local value3="100/100";
    local value4="50/100";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_half-window "${LXDE_NS}" "${hotkey}" "${comment}" "${value1}" "${value2}" "${value3}" "${value4}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-left()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-Left">
    #             <action name="UnmaximizeFull"/>
    #             <action name="MoveResizeTo">
    #                 <x>+0</x>
    #                 <y>+0</y>
    #                 <width>50/100</width>
    #                 <height>100/100</height>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local hotkey="W-Left";
    local comment="";
    local value1="+0";
    local value2="+0";
    local value3="50/100";
    local value4="100/100";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_half-window "${LXDE_NS}" "${hotkey}" "${comment}" "${value1}" "${value2}" "${value3}" "${value4}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-right()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-Right">
    #             <action name="UnmaximizeFull"/>
    #             <action name="MoveResizeTo">
    #                 <x>-0</x>
    #                 <y>+0</y>
    #                 <width>50/100</width>
    #                 <height>100/100</height>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local hotkey="W-Right";
    local comment="";
    local value1="-0";
    local value2="+0";
    local value3="50/100";
    local value4="100/100";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_half-window "${LXDE_NS}" "${hotkey}" "${comment}" "${value1}" "${value2}" "${value3}" "${value4}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_all_hotkey_for_window()
{
    # --------------------------------------------------------------------------
    local comment=" =================== My Custom Window Shortcuts =================== ";

    xmlstarlet ed -L -N x="${LXDE_NS}" \
    -a "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v "${comment}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_showdesktop;
    set_hotkey_for_window-switching;

    set_hotkey_for_filling-window;
    # set_hotkey_for_restoring-window;

    set_hotkey_for_tile-window-to-top;
    set_hotkey_for_tile-window-to-bottom;
    set_hotkey_for_tile-window-to-left;
    set_hotkey_for_tile-window-to-right;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^openbox) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_window;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_window;
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