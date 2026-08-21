#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/set_config_for_kde.sh "${CUR_USER}";

# dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/kde/set_config_for_kde.sh "${CUR_USER}";
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_app_for_kde.sh;
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_window_for_kde.sh;
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_hotkey_workspace_for_kde.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_panel_clock_for_kde.sh;
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_panel_float_for_kde.sh;
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_panel_vdesktop_for_kde.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 수동으로 dark 테마 변환하는게 깔끔해서 주석처리했다.
    # bash ${CORE_BIN_DIR}/wmde/de/kde/set_theme_dark_for_kde.sh;

    bash ${CORE_BIN_DIR}/wmde/de/kde/set_theme_font_for_kde.sh;
    bash ${CORE_BIN_DIR}/wmde/de/kde/set_theme_icon_for_kde.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kglobalaccel;

    source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kwin;
    source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kded6;

    source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_plasmashell;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================