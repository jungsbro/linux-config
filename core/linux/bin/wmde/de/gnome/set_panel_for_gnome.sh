#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_panel_for_gnome.sh;
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
function set_panel_height()
{
    # --------------------------------------------------------------------------
    echo "";
    # --------------------------------------------------------------------------
}


function set_workspace()
{
    # --------------------------------------------------------------------------
    # Settings >> Multitasking >> Workspaces >> Fixed Number of Workspaces: on
    # gnome-tweaks >> Workspaces

    # /org/gnome/mutter/dynamic-workspaces
    #   false
    gsettings set "org.gnome.mutter" "dynamic-workspaces" 'false';

    # /org/gnome/desktop/wm/preferences/num-workspaces
    #   4
    gsettings set "org.gnome.desktop.wm.preferences" "num-workspaces" '4'
    # --------------------------------------------------------------------------
}


function set_panel_clock()
{
    # --------------------------------------------------------------------------
    # Settings >> System >> Date & Time >> Time Format
    # 24-hour >> AM/PM

    # /org/gnome/desktop/interface/clock-format
    #   '12h'
    gsettings set "org.gnome.desktop.interface" "clock-format" '12h';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # gnome-tweaks >> Top Bar >> Clock >> Weekday:on / Date:on

    # /org/gnome/desktop/interface/clock-show-weekday
    #   true
    gsettings set "org.gnome.desktop.interface" "clock-show-weekday" 'true' 2> /dev/null || true;


    # /org/gnome/desktop/interface/clock-show-date
    #   true
    gsettings set "org.gnome.desktop.interface" "clock-show-date" 'true' 2> /dev/null || true;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_panel_height;
    set_workspace;
    set_panel_clock;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================