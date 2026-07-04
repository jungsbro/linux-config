#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_workspace_for_kde.sh
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
function set_hotkey_for_left-ws()
{
    # --------------------------------------------------------------------------
    # Switch ONe Desktop to the Left : Meta+Ctrl+Left

    # [kwin]
    # Switch One Desktop to the Left=Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop to the Left" "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_right-ws()
{
    # --------------------------------------------------------------------------
    # Switch ONe Desktop to the Right : Meta+Ctrl+Right

    # [kwin]
    # Switch One Desktop to the Right=Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop to the Right" "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_up-ws()
{
    # --------------------------------------------------------------------------
    # Switch One Desktop Up : Meta+Ctrl+Up

    # [kwin]
    # Switch One Desktop Up=Meta+Ctrl+Up,Meta+Ctrl+Up,Switch One Desktop Up
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop Up" "Meta+Ctrl+Up,Meta+Ctrl+Up,Switch One Desktop Up"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_down-ws()
{
    # --------------------------------------------------------------------------
    # Switch One Desktop Down : Meta+Ctrl+Down

    # [kwin]
    # Switch One Desktop Down=Meta+Ctrl+Down,Meta+Ctrl+Down,Switch One Desktop Down
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch One Desktop Down" "Meta+Ctrl+Down,Meta+Ctrl+Down,Switch One Desktop Down"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f1-ws()
{
    # --------------------------------------------------------------------------
    # Switch to Desktop 1 : Ctrl+F1 Meta+F1

    # [kwin]
    # Switch to Desktop 1=Ctrl+F1\tMeta+F1,Ctrl+F1,Switch to Desktop 1
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 1" $'Ctrl+F1\tMeta+F1,Ctrl+F1,Switch to Desktop 1'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f2-ws()
{
    # --------------------------------------------------------------------------
    # Switch to Desktop 2 : Ctrl+F2 Meta+F2

    # [kwin]
    # Switch to Desktop 2=Meta+F2\tCtrl+F2,Ctrl+F2,Switch to Desktop 2
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 2" $'Meta+F2\tCtrl+F2,Ctrl+F2,Switch to Desktop 2'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f3-ws()
{
    # --------------------------------------------------------------------------
    # Switch to Desktop 3 : Ctrl+F3 Meta+F3

    # [kwin]
    # Switch to Desktop 3=Meta+F3\tCtrl+F3,Ctrl+F3,Switch to Desktop 3
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 3" $'Meta+F3\tCtrl+F3,Ctrl+F3,Switch to Desktop 3'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_f4-ws()
{
    # --------------------------------------------------------------------------
    # Switch to Desktop 4 : Ctrl+F4 Meta+F4

    # [kwin]
    # Switch to Desktop 4=Ctrl+F4\tMeta+F4,Ctrl+F4,Switch to Desktop 4
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Switch to Desktop 4" $'Ctrl+F4\tMeta+F4,Ctrl+F4,Switch to Desktop 4'
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-f1-ws()
{
    # --------------------------------------------------------------------------
    # Window to Desktop 1 : Meta+Shift+F1

    # [kwin]
    # Window to Desktop 1=Meta+Shift+F1,none,Window to Desktop 1
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 1" "Meta+Shift+F1,none,Window to Desktop 1"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-f2-ws()
{
    # --------------------------------------------------------------------------
    # Window to Desktop 2 : Meta+Shift+F2

    # [kwin]
    # Window to Desktop 2=Meta+Shift+F2,none,Window to Desktop 2
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 2" "Meta+Shift+F2,none,Window to Desktop 2"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-f3-ws()
{
    # --------------------------------------------------------------------------
    # Window to Desktop 3 : Meta+Shift+F3

    # [kwin]
    # Window to Desktop 3=Meta+Shift+F3,none,Window to Desktop 3
    kwriteconfig6 --file kglobalshortcutsrc --group "kwin" --key "Window to Desktop 3" "Meta+Shift+F3,none,Window to Desktop 3"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_app-to-f4-ws()
{
    # --------------------------------------------------------------------------
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
    set_hotkey_for_left-ws;
    set_hotkey_for_right-ws;
    set_hotkey_for_up-ws;
    set_hotkey_for_down-ws;

    set_hotkey_for_f1-ws;
    set_hotkey_for_f2-ws;
    set_hotkey_for_f3-ws;
    set_hotkey_for_f4-ws;

    set_hotkey_for_app-to-f1-ws;
    set_hotkey_for_app-to-f2-ws;
    set_hotkey_for_app-to-f3-ws;
    set_hotkey_for_app-to-f4-ws;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kglobalaccel;
    # --------------------------------------------------------------------------
fi
# ==============================================================================
