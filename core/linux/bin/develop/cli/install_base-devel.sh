#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# bash ${CORE_BIN_DIR}/develop/cli/install_base-devel.sh;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 코드로부터 프로그램을 컴파일하고 빌드하는 데 필요한 핵심 컴파일러와 필수 도구 모음
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/develop/cli
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="base-devel";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_base-devel()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 방법2)
        # 컴파일러 및 바이너리 도구
        # local app_name="gcc"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="binutils"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 빌드 및 자동화 유틸리티
        # local app_name="make"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="glibc"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="autoconf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="automake"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="libtool"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="pkgconf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="m4"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="bison"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="flex"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 패키징 및 보조도구
        # local app_name="patch"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="texinfo"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="groff"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="file"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="which"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # aur 전용
        # local app_name="fakeroot"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="build-essential"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 방법2)
        # local app_name="gcc"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="g++"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="binutils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="make"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="libc6-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # debian 전용
        # local app_name="dpkg-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="c-development"; dnf group install -y "${app_name}";
        local app_name="development-tools"; dnf group install -y "${app_name}";
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 방법2)
        # 핵심 컴파일러 및 라이브러리 (c-development)
        # local app_name="gcc"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gcc-c++"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="binutils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="make"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="glibc-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 빌드 자동화 및 설정도구
        # local app_name="autoconf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="automake"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="libtool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="pkgconf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="bison"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="flex"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 소스관리 및 유틸리티(development-tools)
        # local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="patch"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gdb"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="subversion"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="diffstat"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="strace"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # rpm 전용
        # local app_name="rpm-build"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="Development Tools"; dnf group install -y "${app_name}";
        # ----------------------------------------------------------------------
    fi
}


function install_extra-pkgs()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # base-devel에 아래는 이미 포함되어있다.
        # local app_name="autoconf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="automake"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="libtool"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="pkgconf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        echo "";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # build-essential에 아래는 포함되어있지 않다
        local app_name="autoconf"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="automake"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="libtool"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="pkg-config"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # "Development Tools"에 아래는 이미 포함되어있다
        # local app_name="autoconf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="automake"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="libtool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="pkgconf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        echo "";
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # base-devel에 git은 포함되어있지 않다
    # build-essential에 git은 포함되어있지 않다
    # "Development Tools"에 git은 이미 포함되어있다
    bash ${CORE_BIN_DIR}/develop/cli/install_git.sh;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    install_base-devel;
    install_extra-pkgs;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================