#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_hotkey_app_for_gnome.sh;
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

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh

# set_attr_value "${attr_path}" "${attr_name}" "${val}";
# set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_expose()
{
    # --------------------------------------------------------------------------
    # expose
    # win+tab

    # 추가 (win+tab)
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> System >> Show the overview
    # /org/gnome/shell/keybindings/toggle-overview
    #   ['<Super>Tab']
    gsettings set "org.gnome.shell.keybindings" "toggle-overview" "['<Super>Tab']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_menu()    # not used
{
    # --------------------------------------------------------------------------
    # window menu
    # win
    # ctrl+esc

    # 이미 있음
    # gnome-tweaks >> Keyboard & Mouse

    # org/gnome/mutter/overlay-key
    #   'Super_L'
    gsettings set "org.gnome.mutter" "overlay-key" 'Super_L'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_appmenu()    # not used
{
    # --------------------------------------------------------------------------
    # appmenu
    # win+esc

    # appmenu 추가
    echo ""
    # --------------------------------------------------------------------------
}


function set_hotkey_for_launcher()
{
    # --------------------------------------------------------------------------
    # launcher 추가
    # alt+f2

    # 추가
    # 1) 초기화 (alt+f2)
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> System >> Show the run command prompt
    # /org/gnome/desktop/wm/keybindings/panel-run-dialog
    # []
    gsettings set "org.gnome.desktop.wm.keybindings" "panel-run-dialog" "[]";


    # 2) 추가 (win+a >> alt+f2)
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> System >> Show all apps
    # /org/gnome/shell/keybindings/toggle-application-view
    # ['<Alt>F2']
    gsettings set "org.gnome.shell.keybindings" "toggle-application-view" "['<Alt>F2']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    # --------------------------------------------------------------------------
    # Run dialog 추가
    # win+r

    # 수정 (alt+f2 >> win+r)
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> System >> Show the run command prompt
    # /org/gnome/desktop/wm/keybindings/panel-run-dialog
    #   ['<Super>r']
    gsettings set "org.gnome.desktop.wm.keybindings" "panel-run-dialog" "['<Super>r']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # --------------------------------------------------------------------------
    # search dialog
    # win+s

    echo "";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    # logout
    # alt+ctrl+delete

    # 이미 있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> System >> Logtout
    # /org/gnome/settings-daemon/plugins/media-keys/logout
    #   ['<Control><Alt>Delete']
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "logout" "['<Control><Alt>Delete']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # --------------------------------------------------------------------------
    # lock
    # win+l

    # 이미있음
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> System >> Lock screen
    # /org/gnome/settings-daemon/plugins/media-keys/screensaver
    #  ['<Super>l']
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "screensaver" "['<Super>l']";
    # --------------------------------------------------------------------------
}



function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    # screenshot
    # Print

    # 이미 있음

    # for gnome 40.10
    # Settings >> Keyboard >> Keyboard Shortcuts >> Customize Shortcuts >> Screenshots >> Save a screenshot to Pictures
    # /org/gnome/settings-daemon/plugins/media-keys/screenshot
    #   ['Print']

    # for gnome 40.10 이상부터 가능
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Screenshots >> Take a screenshot interactively
    # /org/gnome/shell/keybindings/show-screenshot-ui
    #   ['Print']
    gsettings set "org.gnome.shell.keybindings" "show-screenshot-ui" "['Print']" 2>/dev/null || true;
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    # displaysettings
    # win+p

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Custom shortcuts
    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
    # ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name
    # 'display-settings'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command
    # 'gnome-control-center display'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding
    # '<Super>p'

    # dconf dump "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "custom-keybindings" "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "name" 'display-settings'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "command" 'gnome-control-center display'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "binding" '<Super>p'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # --------------------------------------------------------------------------
    # taskmanager
    # ctrl+shift+esc

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Custom shortcuts
    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
    # ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name
    # 'gnome-system-monitor'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command
    # 'gnome-system-monitor'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding
    # '<Shift><Control>Escape'

    # dconf dump "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "custom-keybindings" "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "name" 'gnome-system-monitor'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "command" 'gnome-system-monitor'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "binding" '<Shift><Control>Escape'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    # filemanager
    # win+e

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Launchers >> Home folder
    # /org/gnome/settings-daemon/plugins/media-keys/home
    # ['<Super>e']
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "home" "['<Super>e']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # --------------------------------------------------------------------------
    # control center
    # win+i

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Launchers >> Settings
    # /org/gnome/settings-daemon/plugins/media-keys/control-center
    # ['<Super>i']

    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "control-center" "['<Super>i']";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    # terminal
    # ctrl+alt+t

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Custom shortcuts
    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
    # ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name
    # 'gnome-terminal'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command
    # 'gnome-terminal'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding
    # '<Control><Alt>t'

    # dconf dump "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "custom-keybindings" "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "name" 'gnome-terminal'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "command" 'gnome-terminal'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "binding" '<Control><Alt>t'
    # --------------------------------------------------------------------------
}



function set_hotkey_for_xkill()
{
    # --------------------------------------------------------------------------
    # xkill
    # win+x

    # 추가
    # Settings >> Keyboard >> Keyboard Shortcuts >> View and Customize Shortcuts >> Custom shortcuts >> xkill
    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
    #   ['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/name
    #   'xkill'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/command
    #   'xkill'

    # /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/binding
    #   '<Super>x'

    # dconf dump "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys" "custom-keybindings" "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "name" 'xkill'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "command" 'xkill'
    gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "binding" '<Super>x'
    # --------------------------------------------------------------------------
}


function set_all_hotkey_for_app()
{
    # --------------------------------------------------------------------------
    # set_hotkey_for_restarting;

    set_hotkey_for_expose;
    # set_hotkey_for_menu;
    # set_hotkey_for_appmenu
    set_hotkey_for_launcher;
    set_hotkey_for_rundialog;
    # set_hotkey_for_searchdialog;
    set_hotkey_for_logout;
    set_hotkey_for_lock;
    set_hotkey_for_screenshot;
    set_hotkey_for_displaysettings;
    set_hotkey_for_taskmanager;
    set_hotkey_for_filemanager;
    set_hotkey_for_controlcenter;
    set_hotkey_for_terminal;
    set_hotkey_for_xkill;
    # --------------------------------------------------------------------------
}

function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^gnome) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^gnome) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome) ]] && set_all_hotkey_for_app;
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



