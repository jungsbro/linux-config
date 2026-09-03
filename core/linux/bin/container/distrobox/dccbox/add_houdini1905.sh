#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/dccbox/add_houdini1905.sh "${CTR_NAME}";
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

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
DCC_NAME="houdini"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/houdini/hfs19.5.303"
DCC_PATH="${DCC_DIR}/sync1_j4105-omv_to_opt_for_hou1905303.sh"
DCC_BIN="/opt/hfs19.5/bin/houdinifx"
DCC_APP="houdinifx"

# /home/jungs/.local/bin/ayonhoudinifx
AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayon${DCC_APP}"

# /tmp/ayon_env_houdini.sh
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
function create_ayonhoudini()
{
    # --------------------------------------------------------------------------
    cmd="#!/bin/sh\n"
    cmd+="# distrobox_binary\n"

    # # name: rkl9-dcc
    cmd+="# name: ${CTR_NAME}\n"

    # if [ -z "${CONTAINER_ID}" ]; then
    cmd+="if [ -z \"\${CONTAINER_ID}\" ]; then\n"

    #     export -p > /tmp/ayon_env_houdini.sh
    cmd+="    export -p > ${AYON_ENV_PATH}\n"

    #     exec "/usr/bin/distrobox-enter"  -n "rkl9-dcc"  -- /bin/bash -c "source /tmp/ayon_env_houdini.sh && /opt/hfs19.5/bin/houdinifx ${@}"
    cmd+="    exec \"/usr/bin/distrobox-enter\"  -n \"${CTR_NAME}\"  -- /bin/bash -c \"source ${AYON_ENV_PATH} && ${DCC_BIN} \${@}\"\n"

    # elif [ -n "${CONTAINER_ID}" ] && [ "${CONTAINER_ID}" != "rkl9-dcc" ]; then
    cmd+="elif [ -n \"\${CONTAINER_ID}\" ] && [ \"\${CONTAINER_ID}\" != \"${CTR_NAME}\" ]; then\n"

    #     exec "distrobox-host-exec" "/home/jungs/.local/bin/ayonhoudinifx" "${@}"
    cmd+="    exec \"distrobox-host-exec\" \"${AYON_DCC_PATH}\" \"\${@}\"\n"

    # else
    cmd+="else\n"

    #     exec  "/opt/hfs19.5/bin/houdinifx" "${@}"
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


function create_ayon_toolbar()
{
    # --------------------------------------------------------------------------
    cmd="\
from ayon_core.pipeline import install_host
from ayon_houdini.api.pipeline import HoudiniHost
install_host(HoudiniHost())
"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    cmd="\
import os
import hou

def safe_install_ayon():
    try:
        # AYON 파이프라인 도구 임포트
        from ayon_core.pipeline import install_host, registered_host
        from ayon_houdini.api.pipeline import HoudiniHost

        # 2. 핵심 체크: 이미 등록된 호스트가 있는지 확인
        current_host = registered_host()

        if current_host and isinstance(current_host, HoudiniHost):
            print("AYON: HoudiniHost is already registered. Skipping installation.")
        else:
            # 등록된 호스트가 없거나 다른 호스트일 경우에만 설치
            print("AYON: No host registered. Installing HoudiniHost...")
            host = HoudiniHost()
            install_host(host)

    except Exception as e:
        print(f"AYON: [ERROR] Setup failed: {e}")

safe_install_ayon()
"
    # --------------------------------------------------------------------------
}


function add_hou1905()
{
    if [[ ! -e "${DCC_PATH}" ]]; then
        return 0
    fi

    # 1) install_houdini -------------------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/houdini/hfs19.5.303
    # sudo bash ./sync1_j4105-omv_to_opt_for_hou1905303.sh
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH}"
    # --------------------------------------------------------------------------

    # 2) ~/.local/bin/houdinifx ------------------------------------------------
    # distrobox-export --bin /opt/hfs19.5/bin/houdinifx
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${DCC_BIN}"

    # config (with nvidia)
    distrobox enter "${CTR_NAME}" -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_bin_with_nvidia ${CUR_USER} ${CTR_NAME} houdini"
    # --------------------------------------------------------------------------

    # 3) ~/.local/share/applications/houdinifx.desktop -------------------------
    # distrobox-export --app houdinifx
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${DCC_APP}"

    # config (with nvidia)
    distrobox enter "${CTR_NAME}" -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} houdini"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ayon >> clockify:off하면, ayon에서 굳이 ayonmaya를 사용할 필요없다.
    # create_ayonhoudini;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # native
    # export SESI_LMHOST=192.168.0.64 && /opt/hfs19.5/bin/houdinifx
    # export SESI_LMHOST=192.168.0.64 && /opt/hfs19.5.303/bin/houdinifx

    # distrobox
    # export SESI_LMHOST=192.168.0.64 && ~/.local/bin/houdinifx
    # --------------------------------------------------------------------------
}


function execute_main()
{
    add_hou1905;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================