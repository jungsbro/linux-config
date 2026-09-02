#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/install_xfce4.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_xfce4_for_dnf()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/gpu/install_x11.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name_list=(
        # 1) 시스템 핵심 및 데스크탑 관리
        xfwm4 xfdesktop xfce4-session xfce4-panel xfce4-settings xfce4-notifyd

        # 2) 파일 및 미디어 도구
        mousepad thunar ristretto xfce4-appfinder file-roller
        thunar-archive-plugin thunar-volman
        # tumbler

        # 3) 하드뒈어 및 전원관리
        xfce4-power-manager xfce4-screensaver xfce4-pulseaudio-plugin
        xfce4-xkb-plugin nm-connection-editor pavucontrol

        # 4) 시스템 모니터링 플러그인
        xfce4-taskmanager xfce4-cpugraph-plugin xfce4-cpufreq-plugin
        xfce4-systemload-plugin xfce4-netload-plugin xfce4-wavelan-plugin
        xfce4-sensors-plugin xfce4-fsguard-plugin xfce4-mount-plugin

        # 5) 생산성 및 업무 편의도구
        xfce4-terminal xfce4-screenshooter xfce4-clipman-plugin xfce4-notes-plugin
        xfce4-whiskermenu-plugin xfce4-dict xfce4-mailwatch-plugin

        # 6) 고급 사용자용 확장 및 자동화
        xfce4-genmon-plugin xfce4-verve-plugin xfce4-smartbookmark-plugin
        xfce4-weather-plugin xfce4-panel-profiles

        # 7) 한/영 전환을 위해 의존성 패키지가 꼭 설치해야 한다
        gtk3 gtk3-immodule-xim
    )

    local app_name="";
    for app_name in ${app_name_list[@]};
    do
        dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xrdp를 사용하기 위해서
    # ~/.xsession, ~/.Xclients
    source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "xfce4" "${CUR_USER}"
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

        local app_name="xfce4"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xfce4-goodies"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) tasksel
        local app_name="task-xfce-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) xfce raw
        # local app_name="xfce4"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) ubuntu xfce minimal
        local app_name="xubuntu-desktop-minimal"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) ubuntu xfce
        # local app_name="xubuntu-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # xrdp를 사용하기 위해서
        # ~/.xsession, ~/.Xclients
        source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "xfce4" "${CUR_USER}"

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="@xfce-desktop"; dnf install -y "${app_name}" || true

        # 방법2)
        # install_xfce4_for_dnf;

        # xrdp를 사용하기 위해서
        # ~/.xsession, ~/.Xclients
        source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "xfce4" "${CUR_USER}"

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) gnome,gdm을 함께 설치한다.
        # Available Environment Groups:
        #    Xfce
        # local app_name="Xfce"; dnf groupinstall -y "${app_name}" || true

        # 방법2) gnome, gdm없이 xfce4만 설치한다.
        install_xfce4_for_dnf;

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


