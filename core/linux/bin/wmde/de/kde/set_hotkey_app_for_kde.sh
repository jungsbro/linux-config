#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_app_for_kde.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/kde
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
# vi ~/.config/kglobalshortcutsrc
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_expose()
{
    # --------------------------------------------------------------------------
    # Tooggle Overview (expose) : Meta+Tab Meta+W

    # [kwin]
    # Overview=Meta+Tab\tMeta+W,Meta+W,Toggle Overview
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Overview" $'Meta+Tab\tMeta+W,Meta+W,Toggle Overview'
    # --------------------------------------------------------------------------
}

function set_hotkey_for_menu()
{
    echo ""
}


function set_hotkey_for_appmenu()
{
    echo ""
}


function set_hotkey_for_launcher()
{
    # --------------------------------------------------------------------------
    # laucnh application (launcher) : Alt+Space Search Alt+F2

    # [services][org.kde.krunner.desktop]
    # _launch=Alt+Space\tSearch\tAlt+F2
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.krunner.desktop" --key "_launch" $'Alt+Space\tAlt+F2,Search,Search'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    echo ""
}


function set_hotkey_for_searchdialog()
{
    echo ""
}


function set_hotkey_for_logout()
{
    # --------------------------------------------------------------------------
    # Show Logout Screen : Ctrl+Alt+Del

    # [ksmserver]
    # Log Out=Ctrl+Alt+Del,Ctrl+Alt+Del,Show Logout Screen
    kwriteconfig6 --file kglobalshortcutsrc --group "ksmserver" --key "Log Out" "Ctrl+Alt+Del,Ctrl+Alt+Del,Show Logout Screen"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lock()
{
    # --------------------------------------------------------------------------
    # Lock Session : Meta+L

    # [ksmserver]
    # Lock Session=Meta+L\tScreensaver,Meta+L\tScreensaver,Lock Session
    kwriteconfig6 --file kglobalshortcutsrc --group "ksmserver" --key "Lock Session" $'Meta+L\tScreensaver,Meta+L\tScreensaver,Lock Session'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # --------------------------------------------------------------------------
    # screenshot : Print Meta+Shift+S

    # [services][org.kde.spectacle.desktop]
    # _launch=Meta+Shift+S\tPrint
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.spectacle.desktop" --key "_launch" $'Meta+Shift+S\tPrint,Spectacle,Spectacle'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_displaysettings()
{
    # --------------------------------------------------------------------------
    # Switch Display : Meta+P Display

    # [services][org.kde.kscreen.desktop]
    # ShowOSD=Meta+P\tDisplay
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.kscreen.desktop" --key "ShowOSD" $'Meta+P\tDisplay,Switch Display,Switch Display'
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # Display Configuration : Meta+Shift+P

    # [services][systemsettings.desktop]
    # kcm-kscreen=Meta+Shift+P
    kwriteconfig6 --file kglobalshortcutsrc --group "systemsettings.desktop" --key "kcm-kscreen" "Meta+Shift+P,Display Configuration,Display Configuration"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # --------------------------------------------------------------------------
    # task manager : Meta+Esc Ctrl+Shift+Esc

    # [services][org.kde.plasma-systemmonitor.desktop]
    # _launch=Meta+Esc\tCtrl+Shift+Esc
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.plasma-systemmonitor.desktop" --key "_launch" $'Meta+Esc\tCtrl+Shift+Esc,System Monitor,System Monitor'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filemanager()
{
    # --------------------------------------------------------------------------
    # explorer : Meta+E

    # [services][org.kde.dolphin.desktop]
    # _launch=Meta+E

    # 방법1)
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.dolphin.desktop" --key "_launch" "Meta+E,Dolphin,Dolphin"

    # 방법2)
    # kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.dolphin.desktop" --key "_launch" "none,Dolphin,Dolphin"
    # kwriteconfig6 --file kglobalshortcutsrc --group "thunar.desktop" --key "_launch" "Meta+E,Thunar,Thunar"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # --------------------------------------------------------------------------
    # control center : Meta+I

    # [services][systemsettings.desktop]
    # _launch=Meta+I\tTools
    kwriteconfig6 --file kglobalshortcutsrc --group "systemsettings.desktop" --key "_launch" "Meta+I,System Settings,System Settings"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # --------------------------------------------------------------------------
    # terminal : Ctrl+Alt+T

    # [services][org.kde.konsole.desktop]
    # _launch=Ctrl+Alt+T

    # 방법1)
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.konsole.desktop" --key "_launch" "Ctrl+Alt+T,Konsole,Konsole"

    # 방법2)
    # kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.konsole.desktop" --key "_launch" "none,Konsole,Konsole"
    # kwriteconfig6 --file kglobalshortcutsrc --group "xfce4-terminal.desktop" --key "_launch" "Ctrl+Alt+T,xfce4-terminal,xfce4-terminal"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_xkill()
{
    # --------------------------------------------------------------------------
    # Kill Winodw (xkill) : Meta+Ctrl+Esc Metx+X

    # [kwin]
    # Kill Window=Meta+X,Meta+Ctrl+Esc,Kill Window
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Kill Window" $'Meta+Ctrl+Esc\tMeta+X,Meta+Ctrl+Esc,Kill Window'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_toggle_compositing()
{
    # --------------------------------------------------------------------------
    # Suepend Compsiting : Alt+Shift+F12

    # [kwin]
    # Suspend Compositing=Alt+Shift+F12,Alt+Shift+F12,Suspend Compositing
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Suspend Compositing" "Alt+Shift+F12,Alt+Shift+F12,Suspend Compositing"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_expose;
    # set_hotkey_for_menu;
    # set_hotkey_for_appmenu;
    set_hotkey_for_launcher;
    # set_hotkey_for_rundialog;
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
    set_hotkey_for_toggle_compositing;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kglobalaccel;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================