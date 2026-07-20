#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_hotkey_app_for_ob.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/lxde/set_funcs_for_lxde.sh

OB_NS="http://openbox.org/3.4/rc";

OBRC_PATH="${HOME_DIR}/.config/openbox/rc.xml";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_restarting()
{
    # --------------------------------------------------------------------------
    local hotkey="W-S-r";
    local comment="Keybindings for restarting-settings";
    local action="Execute";
    local cmd="openbox --reconfigure";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_expose()
{
    # --------------------------------------------------------------------------
    local hotkey="W-Tab";
    local comment="Keybindings for window-switching";
    local action="Execute";
    # local cmd="rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'";
    local cmd="skippy-xd --expose --desktop -1";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_menu()
{
    # --------------------------------------------------------------------------
    local hotkey="C-Escape";
    local comment="Keybindings for menu";
    local action="Execute";
    local cmd="jgmenu_run";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_launcher()
{
    # --------------------------------------------------------------------------
    local hotkey="A-F2";
    local comment="Keybindings for launcher";
    local action="Execute";
    local cmd="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    # --------------------------------------------------------------------------
    local hotkey="W-r";
    local comment="";
    local action="Execute";
    local cmd="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # --------------------------------------------------------------------------
    local hotkey="W-s";
    local comment="";
    local action="Execute";
    local cmd="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    local hotkey="A-C-Delete";
    local comment="Keybindings for logout";
    local action="Execute";
    local cmd='yad --center --undecoreated --skip-taskbar \
--button="Reboot:reboot" \
--button="Shutdown:shutdown" \
--button="Logtout:pkill openbox" \
--button="Cancel:1"';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # --------------------------------------------------------------------------
    local hotkey="W-l";
    local comment="Keybindings for lock";
    local action="Execute";
    local cmd="loginctl lock-session";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    local hotkey="Print";
    local comment="Keybindings for screenshot";
    local action="Execute";
    local cmd="xfce4-screenshooter";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    local hotkey="W-p";
    local comment="Keybindings for display-settings";
    local action="Execute";
    local cmd="arandr";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # --------------------------------------------------------------------------
    local hotkey="S-C-Escape";
    local comment="Keybindings for taskmanager";
    local action="Execute";
    local cmd="xfce4-terminal -e 'htop'";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    local hotkey="W-e";
    local comment="Keybindings for file-manager";
    local action="Execute";
    local cmd="pcmanfm";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # --------------------------------------------------------------------------
    local hotkey="W-i";
    local comment="Keybindings for control-center";
    local action="Execute";
    local cmd="python3 ~/.local/bin/lxcc.py";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    local hotkey="C-A-t";
    local comment="Keybindings for set_hotkey_for_terminal";
    local action="Execute";
    local cmd="xfce4-terminal";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_xkill()
{
    # --------------------------------------------------------------------------
    local hotkey="W-x";
    local comment="Keybindings for set_hotkey_for_xkill";
    local action="Execute";
    local cmd="xkill";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_app "${OB_NS}" "${hotkey}" "${comment}" "${action}" "${cmd}" "${OBRC_PATH}";
    # --------------------------------------------------------------------------
}

function set_all_hotkey_for_app()
{
    # --------------------------------------------------------------------------
    local comment=" ====================== My Custom App Shortcuts ====================== ";

    xmlstarlet ed -L -N x="${OB_NS}" \
    -a "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v "${comment}" "${OBRC_PATH}";
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
    # set_hotkey_for_controlcenter
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

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================
