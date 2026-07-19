#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_app_for_xfce4.sh;
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# set_prop_value ${ch} ${prop} ${typ} ${val};
source ${CORE_BIN_DIR}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_expose()
{
    # expose -------------------------------------------------------------------
    # win+tab

    # 초기화
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Tab" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Tab" "string" "";
    # --------------------------------------------------------------------------

    # using rofi ---------------------------------------------------------------
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "rofi -show window -show-icons"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'";
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "skippy-xd --expose --desktop -1";
    # --------------------------------------------------------------------------

    # using skippy-xd ----------------------------------------------------------
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
}


function set_hotkey_for_menu()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        return
    fi
    # --------------------------------------------------------------------------

    # whiskermenu --------------------------------------------------------------
    # ctrl+esc

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>Escape" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>Escape" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>Escape"" -t "string" -s "xfce4-popup-whiskermenu"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>Escape" \
    "string" "xfce4-popup-whiskermenu";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_appmenu()
{
    # appmenu ------------------------------------------------------------------
    # alt+f1 >> win+esc

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F1" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F1" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Escape" -t "string" -s "xfce4-popup-applicationsmenu"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Escape" \
    "string" "xfce4-popup-applicationsmenu";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_launcher()
{
    # launcher1 ----------------------------------------------------------------
    # alt+f2 >> ctrl+space (removed)

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>space" -t "string" -s "xfce4-appfinder"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>space" "string" "xfce4-appfinder --collapsed";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" \
    "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------

    # launcher2 ----------------------------------------------------------------
    # alt+f3

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" \
    "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------
}



function set_hotkey_for_rundialog()
{
    # --------------------------------------------------------------------------
    # win + r

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>r" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>r" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>r" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>r" \
    "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # --------------------------------------------------------------------------
    # win + s

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>s" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>s" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>s" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>s" \
    "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    # ctrl + alt + delete

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>Delete" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>Delete" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>Delete" -t "string" -s "xfce4-session-logout"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>Delete" \
    "string" "xfce4-session-logout";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # screensaver --------------------------------------------------------------
    # ctrl+alt+l >> win+l

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Alt>l" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>l" "string" "";

    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        # ----------------------------------------------------------------------
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xfce4-screensaver-command --activate"

        # 방법1)
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" \
        "string" "xfce4-screensaver-command --activate";

        # 방법2)
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" \
        # "string" "xfce4-screensaver-command --lock";
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # 방법1)
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xscreensaver-command -lock"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" \
        "string" "xscreensaver-command -lock";

        # 방법2)
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xflock4"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" \
        # "string" "xflock4";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    # Print

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/Print" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/Print" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/Print" -t "string" -s "xfce4-screenshooter"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/Print" \
    "string" "xfce4-screenshooter";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    # win + p

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>p" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>p" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>p" -t "string" -s "xfce4-display-settings --minimal"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>p" \
    "string" "xfce4-display-settings --minimal";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # taskmanager --------------------------------------------------------------
    # ctrl+shift+esc (for mxlinux)

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Shift>Escape" -t "string" -s "xfce4-taskmanager"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Shift>Escape" \
    "string" "xfce4-taskmanager";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    # win + e

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>e" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>e" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>e" -t "string" -s "thunar"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>e" \
    "string" "thunar";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # settings -----------------------------------------------------------------
    # win+i

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>i" -t "string" -s "xfce4-settings-manager"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>i" \
    "string" "xfce4-settings-manager";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    # ctrl+alt+t

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>t" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>t" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>t" -t "string" -s "xfce4-terminal"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>t" \
    "string" "xfce4-terminal";
    # --------------------------------------------------------------------------
}



function set_hotkey_for_xkill()
{
    # xkill --------------------------------------------------------------------
    # ctrl+alt+esc >> win+x

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Alt>Escape" -t "string" -s ""
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>Escape" "string" "";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>x" -t "string" -s "/bin/xkill"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>x" \
    "string" "/bin/xkill";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_etc()
{
    # terminal dropdown --------------------------------------------------------
    # f4 >> removed

    if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
        #       <property name="F4" type="string" value="xfce4-terminal --drop-down"/>
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/F4" -t "string" -s ""
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/F4" "string" "";
    fi
    # --------------------------------------------------------------------------
}

function set_all_hotkey_for_app()
{
    # --------------------------------------------------------------------------
    # set_hotkey_for_restarting;

    set_hotkey_for_expose;
    set_hotkey_for_menu;
    set_hotkey_for_launcher;
    set_hotkey_for_rundialog;
    set_hotkey_for_searchdialog;
    set_hotkey_for_logout;
    set_hotkey_for_lock;
    set_hotkey_for_screenshot;
    set_hotkey_for_displaysettings;
    set_hotkey_for_taskmanager;
    set_hotkey_for_filemanager;
    set_hotkey_for_controlcenter;
    set_hotkey_for_terminal;
    set_hotkey_for_xkill;

    set_hotkey_for_etc;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^xfwm4) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xfwm4) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xfwm4) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

