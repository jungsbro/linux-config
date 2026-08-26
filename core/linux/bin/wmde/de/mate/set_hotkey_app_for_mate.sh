#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/mate/set_hotkey_app_for_mate.sh;
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
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
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

    # expose 추가
    # 1) 기존 win+tab 제거
    # settings >> hardware >> keyboard shortcut >> window Management >> Move between window, using a popup window
    # /org/mate/marco/global-keybindings/switch-windows
    #   'disabled'
    gsettings set "org.mate.Marco.global-keybindings" "switch-windows" '';


    # 2) skippy-xd 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Custom Shortcuts >> Add custom shortcut
    # /org/mate/desktop/keybindings/custom0/name
    #   'skippy-xd'

    # /org/mate/desktop/keybindings/custom0/action
    #   'skippy-xd --desktop -1'

    # /org/mate/desktop/keybindings/custom0/binding
    #   '<Mod4>Tab'

    # 커스텀 단축키 추가
    dconf write /org/mate/desktop/keybindings/custom0/name "'skippy-xd'"
    dconf write /org/mate/desktop/keybindings/custom0/action "'skippy-xd --desktop -1'"
    dconf write /org/mate/desktop/keybindings/custom0/binding "'<Mod4>Tab'"

    # 커스텀 단축키 확인
    # dconf read /org/mate/desktop/keybindings/custom0/name
    # dconf read /org/mate/desktop/keybindings/custom0/action
    # dconf read /org/mate/desktop/keybindings/custom0/binding

    # 커스텀 단축키 전체 확인
    # dconf dump /org/mate/desktop/keybindings/
    # --------------------------------------------------------------------------
}


function set_hotkey_for_menu()    # not used
{
    # --------------------------------------------------------------------------
    # window menu
    # win
    # ctrl+esc

    # window menu 추가
    # menu >> RMB >> Configure
    echo ""
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

    # 1) 기존의 Alt + F2 제거
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Show the panel's "Run Application" dialog box
    # /org/mate/marco/global-keybindings/panel-run-dialog
    #   'disabled'
    gsettings set "org.mate.Marco.global-keybindings" "panel-run-dialog" '';

    # 2) rofi 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Custom Shortcuts
    # /org/mate/desktop/keybindings/custom1/name
    #   'rofi'

    # /org/mate/desktop/keybindings/custom1/action
    #   "rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"

    # /org/mate/desktop/keybindings/custom1/binding
    #   '<Alt>F2'

    dconf write /org/mate/desktop/keybindings/custom1/name "'rofi'"
    dconf write /org/mate/desktop/keybindings/custom1/action "'rofi -show drun -theme ~/.config/rofi/themes/j_launcher.rasi'"
    dconf write /org/mate/desktop/keybindings/custom1/binding "'<Alt>F2'"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    # --------------------------------------------------------------------------
    # Run dialog 추가
    # win+r

    # 추가 ( alt+f2 >> win+r )
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Show the panel's "Run Application" dialog box
    # /org/mate/marco/global-keybindings/panel-run-dialog
    # '<Mod4>r'

    gsettings set "org.mate.Marco.global-keybindings" "panel-run-dialog" '<Mod4>r';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # --------------------------------------------------------------------------
    # search dialog
    # win+s

    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Search
    # /org/mate/settings-daemon/plugins/media-keys/search
    # '<Mod4>s'

    gsettings set "org.mate.SettingsDaemon.plugins.media-keys" "search" '<Mod4>s';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    # logout
    # alt+ctrl+delete

    # 추가
    # 1) 기존 ctrl+alt+delete(shutdown) 제거
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Shut down
    # /org/mate/settings-daemon/plugins/media-keys/power
    # 'disabled'
    gsettings set "org.mate.SettingsDaemon.plugins.media-keys" "power" '';


    # 2) logout을 추가 >> 잘안되서 명령어로 대체 했다.
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Logout
    # /org/mate/settings-daemon/plugins/media-keys/logout
    # '<Primary><Alt>Delete'
    # gsettings set "org.mate.SettingsDaemon.plugins.media-keys" "logout" '<Primary><Alt>Delete';
    gsettings set "org.mate.SettingsDaemon.plugins.media-keys" "logout" '';


    # 3) logout 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Custom Shortcuts
    # /org/mate/desktop/keybindings/custom1/name
    #   'logout'

    # /org/mate/desktop/keybindings/custom1/action
    #   "/usr/bin/mate-session-save --logout-dialog"

    # /org/mate/desktop/keybindings/custom1/binding
    #   '<Primary><Alt>Delete'

    dconf write /org/mate/desktop/keybindings/custom2/name "'logout'"
    dconf write /org/mate/desktop/keybindings/custom2/action "'/usr/bin/mate-session-save --logout-dialog'"
    dconf write /org/mate/desktop/keybindings/custom2/binding "'<Primary><Alt>Delete'"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # --------------------------------------------------------------------------
    # lock
    # win+l

    # 추가 ( ctrl+alt+l >> win+l )
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Lock screen
    # /org/mate/settings-daemon/plugins/media-keys/screensaver
    # '<Mod4>l'

    gsettings set "org.mate.SettingsDaemon.plugins.media-keys" "screensaver" '<Mod4>l';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    # screenshot
    # Print

    # 수정
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Take a screen shot
    # org/mate/marco/global-keybindings/run-command-screenshot
    # 'disabled'
    gsettings set "org.mate.Marco.global-keybindings" "run-command-screenshot" '';


    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Take a screen shot of a window
    # /org/mate/marco/global-keybindings/run-command-window-screenshot
    # 'Print'
    gsettings set "org.mate.Marco.global-keybindings" "run-command-window-screenshot" 'Print';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    # displaysettings
    # win+p

    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Custom Shortcuts
    # /org/mate/desktop/keybindings/custom2/name
    # 'mate-display-properties'

    # /org/mate/desktop/keybindings/custom2/action
    # 'mate-display-properties'

    # /org/mate/desktop/keybindings/custom2/binding
    # '<Mod4>p'

    dconf write /org/mate/desktop/keybindings/custom3/name "'mate-display-properties'"
    dconf write /org/mate/desktop/keybindings/custom3/action "'mate-display-properties'"
    dconf write /org/mate/desktop/keybindings/custom3/binding "'<Mod4>p'"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # --------------------------------------------------------------------------
    # taskmanager
    # ctrl+shift+esc

    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Custom Shortcuts
    # /org/mate/desktop/keybindings/custom3/action
    # 'mate-system-monitor'

    # /org/mate/desktop/keybindings/custom3/name
    # 'mate-system-monitor'

    # /org/mate/desktop/keybindings/custom3/binding
    # '<Primary><Shift>Escape'

    dconf write /org/mate/desktop/keybindings/custom4/name "'mate-system-monitor'"
    dconf write /org/mate/desktop/keybindings/custom4/action "'mate-system-monitor'"
    dconf write /org/mate/desktop/keybindings/custom4/binding "'<Primary><Shift>Escape'"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    # filemanager
    # win+e

    # 이미 있음
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> home folder
    # /org/mate/settings-daemon/plugins/media-keys/home
    # '<Mod4>e'

    gsettings set "org.mate.SettingsDaemon.plugins.media-keys" "home" '<Mod4>e';
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # --------------------------------------------------------------------------
    # control center
    # win+i


    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Custom Shortcuts
    # /org/mate/desktop/keybindings/custom4/name
    # 'control-center'

    # /org/mate/desktop/keybindings/custom4/action
    # 'control-center'

    # /org/mate/desktop/keybindings/custom4/binding
    # '<Mod4>i'

    dconf write /org/mate/desktop/keybindings/custom5/name "'mate-control-center'"
    dconf write /org/mate/desktop/keybindings/custom5/action "'mate-control-center'"
    dconf write /org/mate/desktop/keybindings/custom5/binding "'<Mod4>i'"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    # terminal
    # ctrl+alt+t

    # 이미있음
    # settings >> Hardware >> Keyboard Shortcuts >> Desktop >> Run a terminal
    # org/mate/marco/global-keybindings/run-command-terminal
    #   '<Primary><Alt>t'

    gsettings set "org.mate.Marco.global-keybindings" "run-command-terminal" '<Primary><Alt>t';
    # --------------------------------------------------------------------------
}



function set_hotkey_for_xkill()
{
    # --------------------------------------------------------------------------
    # xkill
    # win+x

    # 추가
    # settings >> Hardware >> Keyboard Shortcuts >> Custom Shortcuts
    # /org/mate/desktop/keybindings/custom5/name
    #   'xkill'

    # /org/mate/desktop/keybindings/custom5/action
    #   'xkill'

    # /org/mate/desktop/keybindings/custom5/binding
    #   '<Mod4>x'

    dconf write /org/mate/desktop/keybindings/custom6/name "'xkill'"
    dconf write /org/mate/desktop/keybindings/custom6/action "'xkill'"
    dconf write /org/mate/desktop/keybindings/custom6/binding "'<Mod4>x'"
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
    # --------------------------------------------------------------------------
}

function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^mate) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^mate) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^mate) ]] && set_all_hotkey_for_app;
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


