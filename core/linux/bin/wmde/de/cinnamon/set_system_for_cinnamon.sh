#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_system_for_cinnamon.sh;
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
function set_desktop_icons()
{
    # --------------------------------------------------------------------------
    # System Settings >> Preferences >> Desktop

    # gsettings set "org.nemo.desktop" "computer-icon-visible" "true";
    local attr_path="org.nemo.desktop";
    local attr_name="computer-icon-visible";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.nemo.desktop" "home-icon-visible" "true";
    local attr_path="org.nemo.desktop";
    local attr_name="home-icon-visible";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.nemo.desktop" "trash-icon-visible" "true";
    local attr_path="org.nemo.desktop";
    local attr_name="trash-icon-visible";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.nemo.desktop" "computer-icon-visible" "true";
    local attr_path="org.nemo.desktop";
    local attr_name="computer-icon-visible";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.nemo.desktop" "volumes-visible" "true";
    local attr_path="org.nemo.desktop";
    local attr_name="volumes-visible";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.nemo.desktop" "network-icon-visible" "true";
    local attr_path="org.nemo.desktop";
    local attr_name="network-icon-visible";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}

function set_screensaver-time()
{
    # --------------------------------------------------------------------------
    # System Settings >> Preferences >> screen saver >> user-settings

    # gsettings set "org.cinnamon.desktop.screensaver" "use-custom-format" "true";
    local attr_path="org.cinnamon.desktop.screensaver";
    local attr_name="use-custom-format";
    local val="true";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.cinnamon.desktop.screensaver" "time-format"  '%p %I:%M';
    local attr_path="org.cinnamon.desktop.screensaver";
    local attr_name="time-format";
    local val='%p %I:%M';
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.cinnamon.desktop.screensaver" "date-format" '%y-%m-%d (%a)';
    local attr_path="org.cinnamon.desktop.screensaver";
    local attr_name="date-format";
    local val='%y-%m-%d (%a)';
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-movement()
{
    # --------------------------------------------------------------------------
    # 추가
    # settings >> Preferences >> Windows >> Behavior >> Special key to move and resize windows:<Super>
    # gsettings set "org.cinnamon.desktop.wm.preferences" "mouse-button-modifier" "<Super>"
    local attr_path="org.cinnamon.desktop.wm.preferences";
    local attr_name="mouse-button-modifier";
    local val="<Super>";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_desktop_icons;
    set_screensaver-time;
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