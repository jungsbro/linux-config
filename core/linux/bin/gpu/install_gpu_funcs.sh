#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# VENDOR
# source ${CORE_BIN_DIR}/gpu/install_gpu_funcs.sh && set_vendor;
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_vendor()
{
    local cur_ver=$(cat /etc/*-release 2> /dev/null);

    # --------------------------------------------------------------------------
    # pciutils is needed for lspci
    if [[ "${cur_ver}" == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^pciutils) ]] || pacman -S --needed --noconfirm pciutils;

    elif [[ "${cur_ver}" == *"debian.org"* ]] || [[ "${cur_ver}" == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^pciutils) ]] || apt install -y pciutils;

    elif [[ "${cur_ver}" == *"Fedora"* ]] || [[ "${cur_ver}" == *"CentOS"* ]] || [[ "${cur_ver}" == *"rocky"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^pciutils) ]] || dnf install -y pciutils;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # GPU 감지 (lspci 사용)
    local gpu_info=$(lspci 2>/dev/null || true)

    # 소문자로 변환
    local gpu_lower="${gpu_info,,}"

    if [[ "${gpu_lower}" =~ nvidia ]]; then
        VENDOR="nvidia"

    elif [[ "${gpu_lower}" =~ (amd|radeon) ]]; then
        VENDOR="radeon"

    elif [[ "${gpu_lower}" =~ intel ]]; then
        VENDOR="intel"

    else
        return 0
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================