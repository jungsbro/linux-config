#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/dccbox/add_nuke1606.sh "${CTR_NAME}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/dccbox
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$(whoami);
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
DCC_NAME="nuke"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/nuke/Nuke16.0v6"
DCC_PATH="${DCC_DIR}/sync1_j4105-omv_to_opt_for_nk1606.sh"
DCC_BIN="/opt/Nuke16.0v6/Nuke16.0"
DCC_APP="Nuke16.0v6"

# /home/jungs/.local/bin/ayonNuke16.0
AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayonNuke16.0"

# /tmp/ayon_env_nuke.sh
AYON_ENV_PATH="/tmp/ayon_env_${DCC_NAME}.sh"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# rkl9-dcc
CTR_NAME="${1}"
if [[ -z "${CTR_NAME}" ]]; then
    echo "Usage: bash ${BASH_SOURCE[0]} '${CTR_NAME}'"
    exit 0
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_ayonNuke()
{
    # --------------------------------------------------------------------------
    cmd="#!/bin/sh\n"
    cmd+="# distrobox_binary\n"

    # # name: rkl9-dcc
    cmd+="# name: ${CTR_NAME}\n"

    # if [ -z "${CONTAINER_ID}" ]; then
    cmd+="if [ -z \"\${CONTAINER_ID}\" ]; then\n"

    #     export -p > /tmp/ayon_env_nuke.sh
    cmd+="    export -p > ${AYON_ENV_PATH}\n"

    #     exec "/usr/bin/distrobox-enter"  -n "rkl9-dcc"  -- /bin/bash -c "source /tmp/ayon_env_nuke.sh && /opt/Nuke16.0v6/Nuke16.0 ${@}"
    cmd+="    exec \"/usr/bin/distrobox-enter\"  -n \"${CTR_NAME}\"  -- /bin/bash -c \"source ${AYON_ENV_PATH} && ${DCC_BIN} \${@}\"\n"

    # elif [ -n "${CONTAINER_ID}" ] && [ "${CONTAINER_ID}" != "rkl9-dcc" ]; then
    cmd+="elif [ -n \"\${CONTAINER_ID}\" ] && [ \"\${CONTAINER_ID}\" != \"${CTR_NAME}\" ]; then\n"

    #     exec "distrobox-host-exec" "/home/jungs/.local/bin/ayonNuke16.0" "${@}"
    cmd+="    exec \"distrobox-host-exec\" \"${AYON_DCC_PATH}\" \"\${@}\"\n"

    # else
    cmd+="else\n"

    #     exec  "/opt/Nuke16.0v6/Nuke16.0" "${@}"
    cmd+="    exec \"${DCC_BIN}\" \"\${@}\"\n"

    # fi
    cmd+="fi"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -e "${AYON_DCC_PATH}" ]]; then
        return 0
    fi

    # 방법1)
    # -e : enable interpretation of backslash escapes
    echo -e "${cmd}" > "${AYON_DCC_PATH}"

    # 방법2)
    # printf '%b\n' "${cmd}" | sudo -u "${CUR_USER}" tee "${AYON_DCC_PATH}" >/dev/null

    chmod +x "${AYON_DCC_PATH}"
    # --------------------------------------------------------------------------
}

function add_nk1606()
{
    if [[ ! -e "${DCC_PATH}" ]]; then
        return 0
    fi

    # 1) install nuke ----------------------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/nuke/Nuke16.0v6
    # sudo bash ./sync1_j4105-omv_to_opt_for_nk1606.sh
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH}"
    # --------------------------------------------------------------------------

    # 2) ~/.local/bin/nuke -----------------------------------------------------
    # distrobox-export --bin /opt/Nuke16.0v6/Nuke16.0
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${DCC_BIN}"

    # config (with nvidia)
    distrobox enter "${CTR_NAME}" -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_bin_with_nvidia ${CUR_USER} ${CTR_NAME} nuke"
    # --------------------------------------------------------------------------

    # 3) ~/.local/share/applications/nuke.desktop ------------------------------
    # distrobox-export --app Nuke16.0v6
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${DCC_APP}"

    # config (with nvidia)
    distrobox enter "${CTR_NAME}" -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} nuke"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ayon >> clockify:off하면, ayon에서 굳이 ayonmaya를 사용할 필요없다.
    # create_ayonNuke;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # native
    # export foundry_LICENSE="4101@192.168.0.68" && /opt/Nuke16.0v6/Nuke16.0 --nukex

    # distrobox
    # export foundry_LICENSE="4101@192.168.0.68" && ~/.local/bin/Nuke16.0 --nukex
    # --------------------------------------------------------------------------
}


function execute_main()
{
    add_nk1606;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
