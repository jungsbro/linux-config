#!/bin/bash
set -e

[[ -n "${_INSTALL_GPU_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_GPU_FUNCS_LOADED=1

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/gpu/install_gpu_funcs.sh
# VENDOR=$(set_vendor);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/gpu/install_gpu_funcs.sh
# local vendor=$(set_vendor);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_vendor()
{
    local cur_release=$(cat /etc/*-release 2>/dev/null);

    # --------------------------------------------------------------------------
    # pciutils is needed for lspci
    if [[ "${cur_release}" == *"archlinux"* ]]; then
        local app_name="pciutils"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    elif [[ "${cur_release}" == *"debian.org"* ]] || [[ "${cur_release}" == *"ubuntu"* ]]; then
        local app_name="pciutils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    elif [[ "${cur_release}" == *"Fedora"* ]] || [[ "${cur_release}" == *"CentOS"* ]] || [[ "${cur_release}" == *"rocky"* ]]; then
        local app_name="pciutils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # GPU 감지 (lspci 사용)
    local gpu_info=$(lspci 2>/dev/null || true)

    # 소문자로 변환
    local gpu_lower="${gpu_info,,}"

    if [[ "${gpu_lower}" =~ nvidia ]]; then
        local vendor="nvidia";

    elif [[ "${gpu_lower}" =~ (amd|radeon) ]]; then
        local vendor="radeon";

    elif [[ "${gpu_lower}" =~ intel ]]; then
        local vendor="intel";

    else
        local vendor="unknown";
    fi

    echo "${vendor}"
    # --------------------------------------------------------------------------
}
# ==============================================================================