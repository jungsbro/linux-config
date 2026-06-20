#!/bin/bash

# usage ========================================================================
# ------------------------------------------------------------------------------
# bash ${CORE_BIN_DIR}/container/distrobox/dcc/add_comfyui.sh ${CTR_NAME};
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# native
# /usr/local/bin/run_comfyui.sh

# distrobox
# ~/.local/bin/run_comfyui.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/dcc
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$(whoami);
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
DCC_NAME="comfyui"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/comfyui"
DCC_PATH="${DCC_DIR}/install_comfyui.sh"

# /usr/local/bin/run_comfyui.sh
DCC_BIN="/usr/local/bin/run_comfyui.sh"

# /usr/share/applications/comfyui.desktop
DCC_APP="comfyui"


# /home/jungs/.local/bin/ayoncomfyui
# AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayoncomfyui"

# /tmp/ayon_env_comfyui.sh
# AYON_ENV_PATH="/tmp/ayon_env_${DCC_NAME}.sh"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ubu-comfyui
CTR_NAME="${1}"
if [[ -z "${CTR_NAME}" ]]; then
    echo "Usage: bash ${BASH_SOURCE[0]} '${CTR_NAME}'"
    return 0
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function add_comfyui()
{
    if [[ ! -f ${DCC_PATH} ]]; then
        return
    fi

    # 1) install comfyui--------------------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/comfyui
    # sudo bash ./install_comfyui.sh jungs
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH} ${CUR_USER}"
    # --------------------------------------------------------------------------


    # 2) ~/.local/bin/run_comfyui.sh -------------------------------------------
    # distrobox-export --bin /usr/local/bin/run_comfyui.sh
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${DCC_BIN}"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_bin_with_nvidia ${CUR_USER} ${CTR_NAME} comfyui"
    # --------------------------------------------------------------------------

    # 3) ~/.local/share/applications/comfyui.desktop ---------------------------
    # distrobox-export --app comfyui
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${DCC_APP}"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} comfyui"
    # --------------------------------------------------------------------------

}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    add_comfyui;
fi
# ==============================================================================

