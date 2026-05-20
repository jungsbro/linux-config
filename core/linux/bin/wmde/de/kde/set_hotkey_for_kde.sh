#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_for_kde.sh
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# vi ~/.config/kglobalshortcutsrc
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_focus_hotkey()
{
    # --------------------------------------------------------------------------
    # Tooggle Overview (expose) : Meta+Tab Meta+W
    # [kwin]
    # Overview=Meta+Tab\tMeta+W,Meta+W,Toggle Overview
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Overview" $'Meta+Tab\tMeta+W,Meta+W,Toggle Overview'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Peek at Desktop (show desktop) : Meta+D
    # [kwin]
    # Show Desktop=Meta+D,Meta+D,Peek at Desktop
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Show Desktop" "Meta+D,Meta+D,Peek at Desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # switch applications : Alt+Tab
    # [kwin]
    # Walk Through Windows=Alt+Tab,Alt+Tab,Walk Through Windows
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Walk Through Windows" "Alt+Tab,Alt+Tab,Walk Through Windows"
    # --------------------------------------------------------------------------
}

function set_lock_hotkey()
{
    # --------------------------------------------------------------------------
    # Show Logout Screen : Ctrl+Alt+Del
    # [ksmserver]
    # Log Out=Ctrl+Alt+Del,Ctrl+Alt+Del,Show Logout Screen
    kwriteconfig6 --file kglobalshortcutsrc --group "ksmserver" --key "Log Out" "Ctrl+Alt+Del,Ctrl+Alt+Del,Show Logout Screen"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Lock Session : Meta+L
    # [ksmserver]
    # Lock Session=Meta+L\tScreensaver,Meta+L\tScreensaver,Lock Session
    kwriteconfig6 --file kglobalshortcutsrc --group "ksmserver" --key "Lock Session" $'Meta+L\tScreensaver,Meta+L\tScreensaver,Lock Session'
    # --------------------------------------------------------------------------
}

function set_system_hotkey()
{
    # --------------------------------------------------------------------------
    # task manager : Meta+Esc Ctrl+Shift+Esc
    # [services][org.kde.plasma-systemmonitor.desktop]
    # _launch=Meta+Esc\tCtrl+Shift+Esc
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.plasma-systemmonitor.desktop" --key "_launch" $'Meta+Esc\tCtrl+Shift+Esc,System Monitor,System Monitor'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # control center : Meta+I
    # [services][systemsettings.desktop]
    # _launch=Meta+I\tTools
    kwriteconfig6 --file kglobalshortcutsrc --group "systemsettings.desktop" --key "_launch" "Meta+I,System Settings,System Settings"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Kill Winodw (xkill) : Meta+Ctrl+Esc Metx+X
    # [kwin]
    # Kill Window=Meta+X,Meta+Ctrl+Esc,Kill Window
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Kill Window" $'Meta+Ctrl+Esc\tMeta+X,Meta+Ctrl+Esc,Kill Window'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Close Window : Alt+F4
    # [kwin]
    # Window Close=Alt+F4,Alt+F4,Close Window
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Close" "Alt+F4,Alt+F4,Close Window"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Suepend Compsiting : Alt+Shift+F12
    # [kwin]
    # Suspend Compositing=Alt+Shift+F12,Alt+Shift+F12,Suspend Compositing
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Suspend Compositing" "Alt+Shift+F12,Alt+Shift+F12,Suspend Compositing"
    # --------------------------------------------------------------------------
}

function set_display_hotkey()
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

function set_app_hotkey()
{
    # --------------------------------------------------------------------------
    # laucnh application (spotlight) : Alt+Space Search Alt+F2
    # [services][org.kde.krunner.desktop]
    # _launch=Alt+Space\tSearch\tAlt+F2
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.krunner.desktop" --key "_launch" $'Alt+Space\tAlt+F2,Search,Search'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # screenshot : Print Meta+Shift+S
    # [services][org.kde.spectacle.desktop]
    # _launch=Meta+Shift+S\tPrint
    kwriteconfig6 --file kglobalshortcutsrc --group "org.kde.spectacle.desktop" --key "_launch" $'Meta+Shift+S\tPrint,Spectacle,Spectacle'
    # --------------------------------------------------------------------------

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

function set_tiling_hotkey()
{
    # --------------------------------------------------------------------------
    # Quick Tile Window to the Top : Meta+Shift+Up
    # [kwin]
    # Window Quick Tile Top=Meta+Shift+Up,Meta+Up,Quick Tile Window to the Top

    # 방법1)
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Top" "Meta+Shift+Up,Meta+Up,Quick Tile Window to the Top"

    # 방법2)
    # kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Top" "none,Quick Tile Window to the Top"
    # kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Top" "Meta+Shift+Up,Quick Tile Window to the Top"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Maximize Window : Meta+PgUp Meta+Up
    # [kwin]
    # Window Maximize=Meta+PgUp\tMeta+Up,Meta+PgUp,Maximize Window
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Maximize" $'Meta+PgUp\tMeta+Up,Meta+PgUp,Maximize Window'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Quick Tile Window to the Bottom : Meta+Down
    # [kwin]
    # Window Quick Tile Bottom=Meta+Down,Meta+Down,Quick Tile Window to the Bottom
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Bottom" "Meta+Down,Meta+Down,Quick Tile Window to the Bottom"

    # Quick Tile Window to the Left : Meta+Left
    # [kwin]
    # Window Quick Tile Left=Meta+Left,Meta+Left,Quick Tile Window to the Left
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Left" "Meta+Left,Meta+Left,Quick Tile Window to the Left"

    # Quick Tile Window to the Right : Meta+Right
    # [kwin]
    # Window Quick Tile Right=Meta+Right,Meta+Right,Quick Tile Window to the Right
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Right" "Meta+Right,Meta+Right,Quick Tile Window to the Right"
    # --------------------------------------------------------------------------

    # move focus to screen -----------------------------------------------------
    # Move Indow to Previous Screen : Meta+Shift+Left
    # [kwin]
    # Window to Previous Screen=Meta+Shift+Left,Meta+Shift+Left,Move Window to Previous Screen
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Previous Screen" "Meta+Shift+Left,Meta+Shift+Left,Move Window to Previous Screen"

    # Move Indow to Next Screen : Meta+Shift+Right
    # [kwin]
    # Window to Next Screen=Meta+Shift+Right,Meta+Shift+Right,Move Window to Next Screen
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Next Screen" "Meta+Shift+Right,Meta+Shift+Right,Move Window to Next Screen"
    # --------------------------------------------------------------------------
}

function set_workspace_hotkey()
{
    # workspace movement1 ------------------------------------------------------
    # Switch One Desktop Down : Meta+Ctrl+Down
    # [kwin]
    # Switch One Desktop Down=Meta+Ctrl+Down,Meta+Ctrl+Down,Switch One Desktop Down
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop Down" "Meta+Ctrl+Down,Meta+Ctrl+Down,Switch One Desktop Down"

    # Switch ONe Desktop to the Left : Meta+Ctrl+Left
    # [kwin]
    # Switch One Desktop to the Left=Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop to the Left" "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"

    # Switch ONe Desktop to the Right : Meta+Ctrl+Right
    # [kwin]
    # Switch One Desktop to the Right=Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop to the Right" "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"

    # Switch One Desktop Up : Meta+Ctrl+Up
    # [kwin]
    # Switch One Desktop Up=Meta+Ctrl+Up,Meta+Ctrl+Up,Switch One Desktop Up
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop Up" "Meta+Ctrl+Up,Meta+Ctrl+Up,Switch One Desktop Up"
    # --------------------------------------------------------------------------

    # workspace movement2 ------------------------------------------------------
    # Switch to Desktop 1 : Ctrl+F1 Meta+F1
    # [kwin]
    # Switch to Desktop 1=Ctrl+F1\tMeta+F1,Ctrl+F1,Switch to Desktop 1
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 1" $'Ctrl+F1\tMeta+F1,Ctrl+F1,Switch to Desktop 1'

    # Switch to Desktop 2 : Ctrl+F2 Meta+F2
    # [kwin]
    # Switch to Desktop 2=Meta+F2\tCtrl+F2,Ctrl+F2,Switch to Desktop 2
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 2" $'Meta+F2\tCtrl+F2,Ctrl+F2,Switch to Desktop 2'

    # Switch to Desktop 3 : Ctrl+F3 Meta+F3
    # [kwin]
    # Switch to Desktop 3=Meta+F3\tCtrl+F3,Ctrl+F3,Switch to Desktop 3
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 3" $'Meta+F3\tCtrl+F3,Ctrl+F3,Switch to Desktop 3'

    # Switch to Desktop 4 : Ctrl+F4 Meta+F4
    # [kwin]
    # Switch to Desktop 4=Ctrl+F4\tMeta+F4,Ctrl+F4,Switch to Desktop 4
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 4" $'Ctrl+F4\tMeta+F4,Ctrl+F4,Switch to Desktop 4'
    # --------------------------------------------------------------------------

    # window to workspace ------------------------------------------------------
    # Window to Desktop 1 : Meta+Shift+F1
    # [kwin]
    # Window to Desktop 1=Meta+Shift+F1,none,Window to Desktop 1
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 1" "Meta+Shift+F1,none,Window to Desktop 1"

    # Window to Desktop 2 : Meta+Shift+F2
    # [kwin]
    # Window to Desktop 2=Meta+Shift+F2,none,Window to Desktop 2
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 2" "Meta+Shift+F2,none,Window to Desktop 2"

    # Window to Desktop 3 : Meta+Shift+F3
    # [kwin]
    # Window to Desktop 3=Meta+Shift+F3,none,Window to Desktop 3
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 3" "Meta+Shift+F3,none,Window to Desktop 3"

    # Window to Desktop 4 : Meta+Shift+F4
    # [kwin]
    # Window to Desktop 4=Meta+Shift+F4,none,Window to Desktop 4
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 4" "Meta+Shift+F4,none,Window to Desktop 4"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    set_focus_hotkey;
    set_lock_hotkey;
    set_system_hotkey;
    set_display_hotkey;
    set_app_hotkey;
    set_tiling_hotkey
    set_workspace_hotkey;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kglobalaccel;
    # --------------------------------------------------------------------------
fi
# ==============================================================================
