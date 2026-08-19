#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/mate/install_mate.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/mate
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

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_mate_for_dnf()
{
    # --------------------------------------------------------------------------
    local app_name="";

    local app_name_list=(
        # 1) 시스템 핵심 및 데스크탑 관리
        mate-desktop mate-session-manager mate-panel mate-settings-daemon
        mate-screensaver mate-backgrounds mate-menus marco mate-notification-daemon

        # 2) 파일 및 미디어 도구
        caja engrampa eom atril mate-media mate-screenshot

        # 3) 하드뒈어 및 전원관리
        mate-control-center mate-power-manager nm-connection-editor pavucontrol

        # 4) 시스템 모니터링 플러그인
        mate-system-monitor

        # 5) 생산성 및 업무 편의도구
        mate-terminal pluma mate-utils mate-menu

        # 6) 고급 사용자용 확장 및 자동화
        mate-applets

        # 7) 한/영 전환을 위해 의존성 패키지가 꼭 설치해야 한다
        gtk3 gtk3-immodule-xim
    )

    for app_name in "${app_name_list[@]}";
    do
        dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xrdp를 사용하기 위해서
    # ~/.xsession, ~/.Xclients
    source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "mate" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # update -------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 확인 필요

        local app_name="mate"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="mate-extra"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="task-mate-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="marco"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="pavucontrol"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # local app_name="task-mate-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2)
        # local app_name="mate-desktop-environment"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법3)
        local app_name="ubuntu-mate-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="@mate-desktop"; dnf install -y "${app_name}" || true

        # 방법2)
        # install_mate_for_dnf;

        # xrdp를 사용하기 위해서
        # ~/.xsession, ~/.Xclients
        source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "mate" "${CUR_USER}"

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_mate_for_dnf;

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


