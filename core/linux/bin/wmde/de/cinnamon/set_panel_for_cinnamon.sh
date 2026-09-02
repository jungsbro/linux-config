#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_panel_for_cinnamon.sh;
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
function set_panel_height()
{
    # --------------------------------------------------------------------------
    # Panel >> RMB >> Panel settings

    # gsettings set "org.cinnamon" "panels-height" "['1:40']"
    local attr_path="org.cinnamon";
    local attr_name="panels-height";
    local val="['1:40']";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_workspace()
{
    # --------------------------------------------------------------------------
    echo "";
    # --------------------------------------------------------------------------
}


function set_panel_clock()
{
    # --------------------------------------------------------------------------
    # Settings >> Preferences >> Date & Time
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법1) 13:00

    # gsettings set "org.cinnamon.desktop.interface" "clock-use-24h"  "true"
    # local attr_path="org.cinnamon.desktop.interface";
    # local attr_name="clock-use-24h";
    # local val="true";
    # set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.gnome.desktop.interface" "clock-format"  "24h"
    # local attr_path="org.gnome.desktop.interface";
    # local attr_name="clock-format";
    # local val="24h";
    # set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법2) 01:00 PM

    # gsettings set "org.cinnamon.desktop.interface" "clock-use-24h" "false"
    local attr_path="org.cinnamon.desktop.interface";
    local attr_name="clock-use-24h";
    local val="false";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.gnome.desktop.interface" "clock-format" "12h"
    local attr_path="org.gnome.desktop.interface";
    local attr_name="clock-format";
    local val="12h";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_panel_height;
    # set_workspace;
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