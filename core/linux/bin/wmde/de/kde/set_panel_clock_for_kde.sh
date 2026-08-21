#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/set_panel_clock_for_kde.sh
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
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# vi ~/.config/plasma-org.kde.plasma.desktop-appletsrc
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# [Containments][2][Applets][20][Configuration][Appearance]
# customDateFormat=yy-MM-dd (ddd)
# dateDisplayFormat=BelowTime
# dateFormat=custom
# fontWeight=400
# showDate=true
# use24hFormat=0
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 시계 설정 주입 (파일명 주의: plasma-org.kde.plasma.desktop-appletsrc)
FILE="plasma-org.kde.plasma.desktop-appletsrc"

# [Containments][2][Applets][20][Configuration][Appearance] >> 20
# CLOCK_ID=$(grep -o 'Applets\]\[[0-9]*\]\[Configuration\]\[Appearance\]' ~/.config/plasma-org.kde.plasma.desktop-appletsrc | cut -d'[' -f2 | cut -d']' -f1 | sort -u)
CLOCK_ID=$(grep -o 'Applets\]\[[0-9]*\]\[Configuration\]\[Appearance\]' ~/.config/${FILE} | cut -d'[' -f2 | cut -d']' -f1 | sort -u)
# Applets][20][Configuration][Appearance]  >>  20][Configuration][Appearance]  >>  20
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_panel_clock()
{
    # --------------------------------------------------------------------------
    if [ -n "${CLOCK_ID}" ]; then
        echo "시계 ID: ${CLOCK_ID} 에 설정을 적용합니다."

        # ----------------------------------------------------------------------
        # 01:00 PM
        # 26-01-01 (Thu)
        kwriteconfig6 --file "${FILE}" --group  "Containments" --group "2" --group "Applets" --group "${CLOCK_ID}" --group "Configuration" --group "Appearance" --key "showDate" "true"
        kwriteconfig6 --file "${FILE}" --group  "Containments" --group "2" --group "Applets" --group "${CLOCK_ID}" --group "Configuration" --group "Appearance" --key "dateDisplayFormat" "BelowTime"
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 0: 12h
        # 1: Use region defaults
        # 2: 24h
        kwriteconfig6 --file "${FILE}" --group  "Containments" --group "2" --group "Applets" --group "${CLOCK_ID}" --group "Configuration" --group "Appearance" --key "use24hFormat" "0"
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 26-01-01 (Thu)
        kwriteconfig6 --file "${FILE}" --group  "Containments" --group "2" --group "Applets" --group "${CLOCK_ID}" --group "Configuration" --group "Appearance" --key "dateFormat" "custom"
        kwriteconfig6 --file "${FILE}" --group  "Containments" --group "2" --group "Applets" --group "${CLOCK_ID}" --group "Configuration" --group "Appearance" --key "customDateFormat" "yy-MM-dd (ddd)"
        # ----------------------------------------------------------------------

    else
        echo "ID를 찾지 못했습니다."
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_panel_clock;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_plasmashell;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================