#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_panel_for_xfce4.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/xfce4
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
# set_prop_value "${ch}" "${prop}" "${typ}" "${val}";
source ${CORE_BIN_DIR}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_workspace()
{
    # Cycle through windows on all workspaces : on -----------------------------
    # xfconf-query -c "xfwm4" -p "/general/cycle_workspaces" -t "bool" -s "true"
    set_prop_value "xfwm4" "/general/cycle_workspaces" "bool" "true";
    # --------------------------------------------------------------------------

    # Use mouse wheel on title bar to roll up the window : off -----------------
    # xfconf-query -c "xfwm4" -p "/general/mousewheel_rollup" -t "bool" -s "false"
    set_prop_value "xfwm4" "/general/mousewheel_rollup" "bool" "false";
    # --------------------------------------------------------------------------

    # scroll workspace : off ---------------------------------------------------
    # xfconf-query -c "xfwm4" -p "/general/scroll_workspaces" -t "bool" -s "false"
    set_prop_value "xfwm4" "/general/scroll_workspaces" "bool" "false";
    # --------------------------------------------------------------------------

    # workspace count : 2 ------------------------------------------------------
    # xfconf-query -c "xfwm4" -p "/general/workspace_count" -t "int" -s "4"
    set_prop_value "xfwm4" "/general/workspace_count" "int" "4";
    # --------------------------------------------------------------------------
}


function set_panel_clock()
{
    if [[ "${CUR_RELEASE}" == *"ID=MX"* ]]; then  # mxlinux
        local sel_plugin="plugin-1"
    else
        local sel_plugin="plugin-12"
    fi

    # digital layout -----------------------------------------------------------
    # xfconf-query -c "xfce4-panel" -p "/plugins/plugin-1/digital-layout" -t "uint" -s "1"
    set_prop_value "xfce4-panel" "/plugins/${sel_plugin}/digital-layout" "uint" "1";
    # --------------------------------------------------------------------------

    # date : 25-12-12 ----------------------------------------------------------
    # xfconf-query -c "xfce4-panel" -p "/plugins/plugin-1/digital-date-format" -t "string" -s "%y-%m-%d (%a)"
    set_prop_value "xfce4-panel" "/plugins/${sel_plugin}/digital-date-format" "string" "%y-%m-%d (%a)";
    # --------------------------------------------------------------------------

    # time : 12:00:AM ----------------------------------------------------------
    # xfconf-query -c "xfce4-panel" -p "/plugins/plugin-1/digital-time-format" -t "string" -s "%I:%M %p"
    set_prop_value "xfce4-panel" "/plugins/${sel_plugin}/digital-time-format" "string" "%I:%M %p";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
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