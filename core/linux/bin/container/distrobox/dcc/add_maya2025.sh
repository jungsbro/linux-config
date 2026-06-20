#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/dcc/add_maya2025.sh ${CTR_NAME};
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
DCC_NAME="maya"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/maya/maya2025"
DCC_PATH="${DCC_DIR}/install_maya2025.sh"
DCC_BIN="/usr/autodesk/maya2025/bin/maya"
DCC_APP="maya"

# /home/jungs/.local/bin/ayonmaya
AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayon${DCC_APP}"

# /tmp/ayon_env_maya.sh
AYON_ENV_PATH="/tmp/ayon_env_${DCC_NAME}.sh"
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# rkl9-dcc
CTR_NAME="${1}"
if [[ -z "${CTR_NAME}" ]]; then
    echo "Usage: bash ${BASH_SOURCE[0]} '${CTR_NAME}'"
    return 0
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_ayonmaya()
{
    # --------------------------------------------------------------------------
    cmd="#!/bin/sh\n"
    cmd+="# distrobox_binary\n"

    # # name: rkl9-dcc
    cmd+="# name: ${CTR_NAME}\n"

    # if [ -z "${CONTAINER_ID}" ]; then
    cmd+="if [ -z \"\${CONTAINER_ID}\" ]; then\n"

    #     export -p > /tmp/ayon_env_maya.sh
    cmd+="    export -p > ${AYON_ENV_PATH}\n"

    #     exec "/usr/bin/distrobox-enter"  -n "rkl9-dcc"  -- /bin/bash -c "source /tmp/ayon_env_maya.sh && /usr/autodesk/maya2025/bin/maya ${@}"
    cmd+="    exec \"/usr/bin/distrobox-enter\"  -n \"${CTR_NAME}\"  -- /bin/bash -c \"source ${AYON_ENV_PATH} && ${DCC_BIN} \${@}\"\n"

    # elif [ -n "${CONTAINER_ID}" ] && [ "${CONTAINER_ID}" != "rkl9-dcc" ]; then
    cmd+="elif [ -n \"\${CONTAINER_ID}\" ] && [ \"\${CONTAINER_ID}\" != \"${CTR_NAME}\" ]; then\n"

    #     exec "distrobox-host-exec" "/home/jungs/.local/bin/ayonmaya" "${@}"
    cmd+="    exec \"distrobox-host-exec\" \"${AYON_DCC_PATH}\" \"\${@}\"\n"

    # else
    cmd+="else\n"

    #     exec  "/usr/autodesk/maya2025/bin/maya" "${@}"
    cmd+="    exec \"${DCC_BIN}\" \"\${@}\"\n"

    # fi
    cmd+="fi"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -e ${AYON_DCC_PATH} ]]; then
        return
    fi

    echo -e "${cmd}" > ${AYON_DCC_PATH}
    chmod +x ${AYON_DCC_PATH}
    # --------------------------------------------------------------------------
}


function add_maya2025()
{
    if [[ ! -e ${DCC_PATH} ]]; then
        return
    fi

    # 1) install_maya.sh -------------------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/maya/maya2025
    # sudo bash ./install_maya2025.sh
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH}"
    # --------------------------------------------------------------------------

    # 2) ~/.local/bin/maya -----------------------------------------------------
    # distrobox-export --bin /usr/autodesk/maya2025/bin/maya
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${DCC_BIN}"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_bin_with_nvidia ${CUR_USER} ${CTR_NAME} maya"
    # --------------------------------------------------------------------------

    # 3) ~/.local/share/applications/maya.desktop ------------------------------
    # distrobox-export --app maya
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${DCC_APP}"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} maya"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ayon >> clockify:off하면, ayon에서 굳이 ayonmaya를 사용할 필요없다.
    # create_ayonmaya;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # native
    # /usr/autodesk/maya2023/bin/maya

    # distrobox
    # /home/jungs/.local/bin/maya
    # /home/jungs/.local/bin/ayonmaya
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.local/bin/maya
    # echo 'xhost +local:' >> ~/.xprofile
    # echo 'xhost +local:' >> ~/.xinitrc
    # echo 'export DISPLAY=:0' >> ~/.bashrc
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    add_maya2025;
fi
# ==============================================================================