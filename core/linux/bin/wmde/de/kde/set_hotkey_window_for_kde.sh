#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_window_for_kde.sh
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
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# vi ~/.config/kglobalshortcutsrc
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_showdesktop()
{
    # --------------------------------------------------------------------------
    # Peek at Desktop (show desktop) : Meta+D

    # [kwin]
    # Show Desktop=Meta+D,Meta+D,Peek at Desktop
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Show Desktop" "Meta+D,Meta+D,Peek at Desktop"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-switching()
{
    # --------------------------------------------------------------------------
    # switch applications : Alt+Tab

    # [kwin]
    # Walk Through Windows=Alt+Tab,Alt+Tab,Walk Through Windows
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Walk Through Windows" "Alt+Tab,Alt+Tab,Walk Through Windows"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-close()
{
    # --------------------------------------------------------------------------
    # Close Window : Alt+F4
    # [kwin]
    # Window Close=Alt+F4,Alt+F4,Close Window
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Close" "Alt+F4,Alt+F4,Close Window"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_filling-window()
{
    # --------------------------------------------------------------------------
    # Maximize Window : Meta+PgUp Meta+Up

    # [kwin]
    # Window Maximize=Meta+PgUp\tMeta+Up,Meta+PgUp,Maximize Window
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Maximize" $'Meta+PgUp\tMeta+Up,Meta+PgUp,Maximize Window'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-top()
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
}


function set_hotkey_for_tile-window-to-bottom()
{
    # --------------------------------------------------------------------------
    # Quick Tile Window to the Bottom : Meta+Down

    # [kwin]
    # Window Quick Tile Bottom=Meta+Down,Meta+Down,Quick Tile Window to the Bottom
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Bottom" "Meta+Down,Meta+Down,Quick Tile Window to the Bottom"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-left()
{
    # --------------------------------------------------------------------------
    # Quick Tile Window to the Left : Meta+Left

    # [kwin]
    # Window Quick Tile Left=Meta+Left,Meta+Left,Quick Tile Window to the Left
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Left" "Meta+Left,Meta+Left,Quick Tile Window to the Left"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_tile-window-to-right()
{
    # --------------------------------------------------------------------------
    # Quick Tile Window to the Right : Meta+Right

    # [kwin]
    # Window Quick Tile Right=Meta+Right,Meta+Right,Quick Tile Window to the Right
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window Quick Tile Right" "Meta+Right,Meta+Right,Quick Tile Window to the Right"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_left-screen()
{
    # --------------------------------------------------------------------------
    # Move Indow to Previous Screen : Meta+Shift+Left

    # [kwin]
    # Window to Previous Screen=Meta+Shift+Left,Meta+Shift+Left,Move Window to Previous Screen
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Previous Screen" "Meta+Shift+Left,Meta+Shift+Left,Move Window to Previous Screen"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-screen()
{
    # --------------------------------------------------------------------------
    # Move Indow to Next Screen : Meta+Shift+Right

    # [kwin]
    # Window to Next Screen=Meta+Shift+Right,Meta+Shift+Right,Move Window to Next Screen
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Next Screen" "Meta+Shift+Right,Meta+Shift+Right,Move Window to Next Screen"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_showdesktop;
    set_hotkey_for_window-switching;
    set_hotkey_for_window-close;

    set_hotkey_for_filling-window;
    set_hotkey_for_tile-window-to-top;
    set_hotkey_for_tile-window-to-bottom;
    set_hotkey_for_tile-window-to-left;
    set_hotkey_for_tile-window-to-right;

    set_hotkey_for_left-screen;
    set_hotkey_for_right-screen;
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