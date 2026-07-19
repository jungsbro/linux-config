#!/bin/bash

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
    if [[ *"${cur_ver}"* == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^pciutils) ]] || pacman -S --needed --noconfirm pciutils;

    elif [[ *"${cur_ver}"* == *"debian.org"* ]] || [[ *"${cur_ver}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^pciutils) ]] || apt install -y pciutils;

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
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
# ==============================================================================