#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_system_for_gnome.sh;
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
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh

# set_attr_value "${attr_path}" "${attr_name}" "${val}";
# set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_desktop_iconsize()
{
    # --------------------------------------------------------------------------
    # Extensions >> Desktop Icons >> Settings >> Size for desktop icons

    # /org/gnome/nautilus/icon-view/default-zoom-level : 'small'
    gsettings set "org.gnome.nautilus.icon-view" "default-zoom-level" 'small'
    # --------------------------------------------------------------------------
}


function set_nightlight()
{
    # --------------------------------------------------------------------------
    # Settings >> Displays >> NightLight

    # Night Light: on
    # /org/gnome/settings-daemon/plugins/color/night-light-enabled
    #   true
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-enabled" 'true';


    # Night Light 시간설정
    # /org/gnome/settings-daemon/plugins/color/night-light-schedule-from
    #  6.0
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-schedule-from" '6.0';

    # /org/gnome/settings-daemon/plugins/color/night-light-schedule-to
    # 6.0
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-schedule-to" '6.0';


    # 색 온도 조절:
    # /org/gnome/settings-daemon/plugins/color/night-light-temperature
    #   uint32 3700
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-temperature" 'uint32 3700'

    # --------------------------------------------------------------------------
}



function set_hotkey_for_window-movement()
{
    # --------------------------------------------------------------------------
    # 이미 있음
    # gnome-tweaks >> Windows

    # org/gnome/desktop/wm/preferences/mouse-button-modifier
    #   '<Super>'
    gsettings set "org.gnome.desktop.wm.preferences" "mouse-button-modifier" '<Super>'
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_desktop_iconsize;
    set_nightlight;
    set_hotkey_for_window-movement;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================