#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kglobalaccel;
# source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kwin;
# source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_kded6;
# source ${CORE_BIN_DIR}/wmde/de/kde/set_funcs_for_kde.sh && restart_plasmashell;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/kde
CUR_DIR="$(dirname "$(realpath "$0")")"

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
# ==============================================================================


# Funcs ========================================================================
function restart_kglobalaccel()
{
    # --------------------------------------------------------------------------
    # 단축키 설정 변경 반영
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl --user list-unit-files | grep -iq plasma-kglobalaccel; then
            # systemd를 통해 서비스를 재시작
            systemctl --user restart plasma-kglobalaccel
        fi
    fi
    # --------------------------------------------------------------------------
}

function restart_kwin()
{
    # --------------------------------------------------------------------------
    # 창 제목 폰트, 가상 데스크톱 설정 반영
    qdbus6 org.kde.KWin /KWin org.kde.KWin.reconfigure
    # --------------------------------------------------------------------------
}

function restart_kded6()
{
    # --------------------------------------------------------------------------
    # 다크 테마, 일반 폰트, 아이콘 변경 설정 반영
    qdbus6 org.kde.kded6 /kded org.kde.kded6.reconfigure
    # --------------------------------------------------------------------------
}

function restart_plasmashell()
{
    # --------------------------------------------------------------------------
    # 패널 시계, 위젯, 플로팅 설정 반영
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl --user list-unit-files | grep -iq plasma-plasmashell; then
            systemctl --user restart plasma-plasmashell
        fi
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================

