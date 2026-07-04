#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxde/set_hotkey_app_for_lxde.sh ${CUR_USER};
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
function set_hotkey_for_restarting()
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-r";
    local comment="Keybindings for restarting-settings";
    local action="Execute";
    local cmd="/usr/bin/openbox --reconfigure";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_expose()
{
    # --------------------------------------------------------------------------
    local hotkey="W-Tab";
    local comment="Keybindings for window-switching";
    local action="Execute";
    local cmd="/usr/bin/rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_menu()
{
    # --------------------------------------------------------------------------
    local hotkey="C-Escape";
    local comment="Keybindings for menu";
    local action="Execute";
    local cmd="/usr/bin/lxpanelctl menu";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_launcher()
{
    # --------------------------------------------------------------------------
    local hotkey="A-F2";
    local comment="Keybindings for launcher";
    local action="Execute";
    local cmd="/usr/bin/rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    # --------------------------------------------------------------------------
    local hotkey="W-r";
    local comment="";
    local action="Execute";
    local cmd="/usr/bin/lxpanelctl run";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # --------------------------------------------------------------------------
    local hotkey="W-s";
    local comment="";
    local action="Execute";
    local cmd="/usr/bin/rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    local hotkey="A-C-Delete";
    local comment="Keybindings for logout";
    local action="Execute";
    local cmd="/usr/bin/lxde-logout";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # --------------------------------------------------------------------------
    local hotkey="W-l";
    local comment="Keybindings for lock";
    local action="Execute";
    local cmd="/usr/bin/lxlock";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    local hotkey="Print";
    local comment="Keybindings for screenshot";
    local action="Execute";
    local cmd="/usr/bin/gnome-screenshot -i";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    local hotkey="W-p";
    local comment="Keybindings for display-settings";
    local action="Execute";
    local cmd="/usr/bin/lxrandr";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # --------------------------------------------------------------------------
    local hotkey="S-C-Escape";
    local comment="Keybindings for taskmanager";
    local action="Execute";
    local cmd="/usr/bin/lxtask";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    local hotkey="W-e";
    local comment="Keybindings for file-manager";
    local action="Execute";
    local cmd="/usr/bin/pcmanfm";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # --------------------------------------------------------------------------
    local hotkey="W-i";
    local comment="Keybindings for control-center";
    local action="Execute";
    local cmd="/usr/bin/python3 ~/.local/bin/lxcc.py";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    local hotkey="C-A-t";
    local comment="Keybindings for set_hotkey_for_terminal";
    local action="Execute";
    local cmd="/usr/bin/lxterminal";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_xkill()
{
    # --------------------------------------------------------------------------
    local hotkey="W-x";
    local comment="Keybindings for set_hotkey_for_xkill";
    local action="Execute";
    local cmd="/usr/bin/xkill";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${LXDE_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}

function set_all_hotkey_for_app()
{
    # --------------------------------------------------------------------------
    local comment=" ====================== My Custom App Shortcuts ====================== ";

    xmlstarlet ed -L -N x="${LXDE_NS}" \
    -a "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v "${comment}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_restarting;
    set_hotkey_for_expose;
    set_hotkey_for_menu;
    set_hotkey_for_launcher;
    set_hotkey_for_rundialog;
    set_hotkey_for_searchdialog;
    set_hotkey_for_logout;
    set_hotkey_for_lock;
    set_hotkey_for_screenshot;
    set_hotkey_for_displaysettings
    set_hotkey_for_taskmanager;
    set_hotkey_for_filemanager
    set_hotkey_for_controlcenter
    set_hotkey_for_terminal;
    set_hotkey_for_xkill;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^openbox) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

