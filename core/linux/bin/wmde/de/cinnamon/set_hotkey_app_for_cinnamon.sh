#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_hotkey_app_for_cinnamon.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/cinnamon
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
source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh

# set_attr_value "${attr_path}" "${attr_name}" "${val}";
# set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_expose()
{
    # --------------------------------------------------------------------------
    # workspace changer
    # win+shift+tab

    # workspace changer 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Show the window selection screen
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-up" "['<Control><Alt>Up', '<Alt>F1', '<Shift><Super>Tab']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="switch-to-workspace-up";
    local val="['<Control><Alt>Up', '<Alt>F1', '<Shift><Super>Tab']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # expose
    # win+tab

    # expose 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Show the workspace selection screen
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-down" "['<Control><Alt>Down', '<Super>Tab']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="switch-to-workspace-down";
    local val="['<Control><Alt>Down', '<Super>Tab']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
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
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Run dialog
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "panel-run-dialog" "[]"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="panel-run-dialog";
    local val="[]";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";


    # 2) launcher 추가
    # 방법1)
    # menu >> RMB >> Configure >> Keyboard shorcuts to open and close the menu : Alt + F2 추가

    # 방법2)
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Custom Shortcuts >> Add custom shortcut
    # gsettings set "org.cinnamon.desktop.keybindings" "custom-list" "['custom0']"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/" "name" "applauncher"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/" "command" "rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/" "binding" "['<Alt>F2']"
    local app_name="applauncher";
    local app_cmd="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'";
    local binding="['<Alt>F2']";
    set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    # --------------------------------------------------------------------------
    # Run dialog 추가
    # win+r

    # 1) 기존의 Alt + F2 제거
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Run dialog
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "panel-run-dialog" "[]"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="panel-run-dialog";
    local val="[]";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # 2) run dialog 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Run dialog
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "panel-run-dialog" "['<Super>r']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="panel-run-dialog";
    local val="['<Super>r']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # --------------------------------------------------------------------------
    # search dialog
    # win+s

    # search dialgo 추가 >> 반응이 없다.
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Launchers >> Search
    # gsettings set "org.cinnamon.desktop.keybindings.media-keys" "search" "['<Super>f']"
    local attr_path="org.cinnamon.desktop.keybindings.media-keys";
    local attr_name="search";
    local val="['<Super>f']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    # logout
    # alt+ctrl+delete

    # logout 이미 설정되 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> System >> Log out
    # gsettings set "org.cinnamon.desktop.keybindings.media-keys" "logout" "['<Primary><Alt>Delete']"
    local attr_path="org.cinnamon.desktop.keybindings.media-keys";
    local attr_name="logout";
    local val="['<Primary><Alt>Delete']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # --------------------------------------------------------------------------
    # lock
    # win+l

    # 1) Lockscreen을 Super + l 을 사용하기 위해서 기존을 삭제
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> General >> Troubleshooting >> Toggle Looking Glass
    # gsettings set "org.cinnamon.desktop.keybindings" "looking-glass-keybinding" "[]"
    local attr_path="org.cinnamon.desktop.keybindings";
    local attr_name="looking-glass-keybinding";
    local val="[]";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";


    # 2) win + l 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> System >> Lock screen
    # gsettings set "org.cinnamon.desktop.keybindings.media-keys" "screensaver" "['<Control><Alt>l', '<Super>l']"
    local attr_path="org.cinnamon.desktop.keybindings.media-keys";
    local attr_name="screensaver";
    local val="['<Control><Alt>l', '<Super>l']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    # screenshot
    # Print

    # 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> System >> Screenshots and Recording >> Task a screenshot
    # gsettings set "org.cinnamon.desktop.keybindings.media-keys" "screenshot" "['Print']"
    local attr_path="org.cinnamon.desktop.keybindings.media-keys";
    local attr_name="screenshot";
    local val="['Print']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    # displaysettings
    # win+p

    # 방법1) displaysettings 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> System >> Hardware >> Switch monitor configurations
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-monitor" "['<Super>p', 'XF86Display']"
    # local attr_path="org.cinnamon.desktop.keybindings.wm";
    # local attr_name="switch-monitor";
    # local val="['<Super>p', 'XF86Display']";
    # set_attr_value "${attr_path}" "${attr_name}" "${val}";


    # 방법2) displaysettings 추가
    # 1) 기존의 win + p 제거
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> System >> Hardware >> Switch monitor configurations
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-monitor" "['<Super>p', 'XF86Display']"
    local attr_path="org.cinnamon.desktop.keybindings.wm";
    local attr_name="switch-monitor";
    local val="['XF86Display']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # 2) displaysettings 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Custom Shortcuts >> Add custom shortcut
    # gsettings set "org.cinnamon.desktop.keybindings" "custom-list" "['custom0', 'custom1']"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/" "name" "displaysettings"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/" "command" "cinnamon-settings display"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/" "binding" "['<Super>p']"
    local app_name="displaysettings";
    local app_cmd="cinnamon-settings display";
    local binding="['<Super>p']";
    set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # --------------------------------------------------------------------------
    # taskmanager
    # ctrl+shift+esc

    # task-manager 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Custom Shortcuts >> Add custom shortcut
    # gsettings set "org.cinnamon.desktop.keybindings" "custom-list" "['custom0', 'custom1', 'custom2']"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom2/" "name" "taskmanager"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom2/" "command" "gnome-system-monitor"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom2/" "binding" "['<Primary><Shift>Escape']"
    local app_name="taskmanager";
    local app_cmd="gnome-system-monitor";
    local binding="['<Primary><Shift>Escape']";
    set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    # filemanager
    # win+e

    # filemanager 이미 추가 되어 있다.
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Launchers >> Home folder
    # gsettings set "org.cinnamon.desktop.keybindings.media-keys" "home" "['<Super>e', 'XF86Explorer']"
    local attr_path="org.cinnamon.desktop.keybindings.media-keys";
    local attr_name="home";
    local val="['<Super>e', 'XF86Explorer']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # --------------------------------------------------------------------------
    # control center
    # win+i

    # control-center 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Custom Shortcuts >> Add custom shortcut
    # gsettings set "org.cinnamon.desktop.keybindings" "custom-list" "['custom0', 'custom1', 'custom2', 'custom3']"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom3/" "name" "control-center"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom3/" "command" "cinnamon-settings"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom3/" "binding" "['<Super>i']"
    local app_name="control-center";
    local app_cmd="cinnamon-settings";
    local binding="['<Super>i']";
    set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    # terminal
    # ctrl+alt+t

    # terminal 이미 있음
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Launchers >> Luanch terminal
    # gsettings set "org.cinnamon.desktop.keybindings.media-keys" "terminal" "['<Primary><Alt>t']"
    local attr_path="org.cinnamon.desktop.keybindings.media-keys";
    local attr_name="terminal";
    local val="['<Primary><Alt>t']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}



function set_hotkey_for_xkill()
{
    # --------------------------------------------------------------------------
    # xkill
    # win+x

    # xkill 추가
    # System Settings >> Hardware >> Keyboard >> Shortcuts >> Custom Shortcuts >> Add custom shortcut
    # gsettings set "org.cinnamon.desktop.keybindings" "custom-list" "['custom0', 'custom1', 'custom2', 'custom3', 'custom4']"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom4/" "name" "xkill"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom4/" "command" "xkill"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom4/" "binding" "['<Super>x']"
    local app_name="xkill";
    local app_cmd="xkill";
    local binding="['<Super>x']";
    set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
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
        [[ -n $(pacman -Q | grep -i ^cinnamon) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^cinnamon) ]] && set_all_hotkey_for_app;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^cinnamon) ]] && set_all_hotkey_for_app;
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