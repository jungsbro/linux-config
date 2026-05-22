#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/dcc/add_resolve2033.sh ${CTR_NAME};
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
DCC_NAME="resolve"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/resolve/resolve2033"
DCC_PATH="${DCC_DIR}/install_resolve2033.sh"
DCC_BIN="/opt/resolve2033/bin/resolve"
DCC_APP="resolve"

# /home/jungs/.local/bin/ayonresolve
AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayonresolve"

# /tmp/ayon_env_resolve.sh
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
function create_ayonresolve()
{
    # --------------------------------------------------------------------------
    cmd="#!/bin/sh\n"
    cmd+="# distrobox_binary\n"

    # # name: rkl9-dcc
    cmd+="# name: ${CTR_NAME}\n"

    # if [ -z "${CONTAINER_ID}" ]; then
    cmd+="if [ -z \"\${CONTAINER_ID}\" ]; then\n"

    #     export -p > /tmp/ayon_env_resolve.sh
    cmd+="    export -p > ${AYON_ENV_PATH}\n"

    #     exec "/usr/bin/distrobox-enter"  -n "rkl9-dcc"  -- /bin/bash -c "source /tmp/ayon_env_resolve.sh && /opt/resolve16.0v6/resolve16.0 ${@}"
    cmd+="    exec \"/usr/bin/distrobox-enter\"  -n \"${CTR_NAME}\"  -- /bin/bash -c \"source ${AYON_ENV_PATH} && ${DCC_BIN} \${@}\"\n"

    # elif [ -n "${CONTAINER_ID}" ] && [ "${CONTAINER_ID}" != "rkl9-dcc" ]; then
    cmd+="elif [ -n \"\${CONTAINER_ID}\" ] && [ \"\${CONTAINER_ID}\" != \"${CTR_NAME}\" ]; then\n"

    #     exec "distrobox-host-exec" "/home/jungs/.local/bin/ayonresolve16.0" "${@}"
    cmd+="    exec \"distrobox-host-exec\" \"${AYON_DCC_PATH}\" \"\${@}\"\n"

    # else
    cmd+="else\n"

    #     exec  "/opt/resolve16.0v6/resolve16.0" "${@}"
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

function add_resolve2033()
{
    if [[ ! -e ${DCC_PATH} ]]; then
        return
    fi

    # --------------------------------------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/resolve/resolve2033
    # sudo bash ./install_resolve2033.sh
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH}"


    # distrobox-export --bin /opt/resolve2033/bin/resolve
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${DCC_BIN}"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_bin_with_nvidia ${CUR_USER} ${CTR_NAME} resolve"


    # distrobox-export --app resolve
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${DCC_APP}"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} resolve"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ayon >> clockify:off하면, ayon에서 굳이 ayonmaya를 사용할 필요없다.
    # create_ayonresolve;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # native
    # /opt/resolve2033/bin/resolve

    # distrobox
    # ~/.local/bin/resolve
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    add_resolve2033;
fi
# ==============================================================================