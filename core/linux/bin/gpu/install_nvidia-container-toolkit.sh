#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_nvidia-container-toolkit.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/gpu
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

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


# Func : x86_64, i686, aarch64 =================================================
function set_vendor()
{
    # --------------------------------------------------------------------------
    # pciutils is needed for lspci
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^pciutils) ]] || pacman -S --needed --noconfirm pciutils;

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^pciutils) ]] || apt install -y pciutils;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^pciutils) ]] || dnf install -y pciutils;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # GPU 감지 (lspci 사용)
    local GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -iE "nvidia|intel|amd|radeon")

    if echo "${GPU_VENDOR}" | grep -iq "nvidia"; then
        VENDOR="nvidia"

    elif echo "${GPU_VENDOR}" | grep -iq "amd\|radeon"; then
        VENDOR="radeon"

    elif echo "${GPU_VENDOR}" | grep -iq "intel"; then
        VENDOR="intel"

    else
        return
    fi
    # --------------------------------------------------------------------------
}


function install_nvidia-container-toolkit_for_pacman()
{
    # --------------------------------------------------------------------------
    # nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    [[ -n $(pacman -Q | grep -i ^nvidia-container-toolkit) ]] || pacman -S --needed --noconfirm nvidia-container-toolkit;
    # --------------------------------------------------------------------------
}


function install_nvidia-container-toolkit_for_apt()
{
    # --------------------------------------------------------------------------
    # nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 의존성 pkg 설치
    [[ -n $(apt list --installed | grep -i ^ca-certificates) ]] || apt install -y ca-certificates;
    [[ -n $(apt list --installed | grep -i ^curl) ]] || apt install -y curl;
    [[ -n $(apt list --installed | grep -i ^gnupg2) ]] || apt install -y gnupg2;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    [[ -n $(apt list --installed | grep -i ^nvidia-container-toolkit) ]] || apt install -y nvidia-container-toolkit;
    # [[ -n $(apt list --installed | grep -i ^nvidia-container-toolkit-base) ]] || apt install -y nvidia-container-toolkit-base;
    # [[ -n $(apt list --installed | grep -i ^libnvidia-container-tools) ]] || apt install -y libnvidia-container-tools;
    # [[ -n $(apt list --installed | grep -i ^libnvidia-container1) ]] || apt install -y libnvidia-container1;
    # --------------------------------------------------------------------------
}

function install_nvidia-container-toolkit_for_dnf()
{
    # --------------------------------------------------------------------------
    # nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 의존성 pkg 설치
    [[ -n $(dnf list --installed | grep -i ^curl) ]] || dnf install -y curl;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    [[ -n $(dnf list --installed | grep -i ^nvidia-container-toolkit) ]] || dnf install -y nvidia-container-toolkit;
    # [[ -n $(dnf list --installed | grep -i ^nvidia-container-toolkit-base) ]] || dnf install -y nvidia-container-toolkit-base;
    # [[ -n $(dnf list --installed | grep -i ^libnvidia-container-tools) ]] || dnf install -y libnvidia-container-tools;
    # [[ -n $(dnf list --installed | grep -i ^libnvidia-container1) ]] || dnf install -y libnvidia-container1;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_vendor;
    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_pacman
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_dnf;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

fi
# ==============================================================================