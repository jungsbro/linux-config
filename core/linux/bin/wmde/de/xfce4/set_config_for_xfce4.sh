#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_config_for_xfce4.sh "${CUR_USER}";

# dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_config_for_xfce4.sh "${CUR_USER}";
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_app_for_xfce4.sh;
    bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_window_for_xfce4.sh;
    bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_hotkey_workspace_for_xfce4.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_panel_for_xfce4.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_terminal;
    source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_noti;
    source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_screensaver_lock;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
        source ${CORE_BIN_DIR}/wmde/de/xfce4/set_theme_for_xfce4.sh && set_desktop;
        source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_thunar;
    else
        source ${CORE_BIN_DIR}/wmde/de/xfce4/set_theme_for_xfce4.sh && set_theme;
        # source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_default_app "${CUR_USER}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"Rocky"* ]]; then  # rocky
        # source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && fix_sound_disabled;
        echo ""
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================