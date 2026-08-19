#!/bin/bash
set -e

[[ -n "${_INSTALL_GPU_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_GPU_FUNCS_LOADED=1

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
        local app_name="pciutils"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    elif [[ "${cur_ver}" == *"debian.org"* ]] || [[ "${cur_ver}" == *"ubuntu"* ]]; then
        local app_name="pciutils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    elif [[ "${cur_ver}" == *"Fedora"* ]] || [[ "${cur_ver}" == *"CentOS"* ]] || [[ "${cur_ver}" == *"rocky"* ]]; then
        local app_name="pciutils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
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