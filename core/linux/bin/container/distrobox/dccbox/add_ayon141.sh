#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/dccbox/add_ayon141.sh "${CTR_NAME}";

# ------------------------------------------------------------------------------
# native
# /opt/ayon/AYON-1.4.1-linux-rocky9/ayon

# bin
# ~/.local/bin/ayon

# desktop (위에 bin을 실행하면 아래 desktop이 자동 생성된다.)
# ~/.local/share/AYON/shim/ayon.desktop
# ------------------------------------------------------------------------------
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
DCC_NAME="ayon"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/ayon"
DCC_PATH="${DCC_DIR}/install_ayon141.sh"

# /opt/ayon/AYON-1.4.1-linux-rocky9/ayon
DCC_BIN="/opt/ayon/AYON-1.4.1-linux-rocky9/ayon"

# ~/.local/share/AYON/shim/ayon.desktop
DCC_APP="${HOME_DIR}/.local/share/AYON/shim/ayon.desktop"

# /home/jungs/.local/bin/ayon
# AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayon"

# /tmp/ayon_env_ayon.sh
# AYON_ENV_PATH="/tmp/ayon_env_${DCC_NAME}.sh"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# rkl9-ayon141
CTR_NAME="${1}"
if [[ -z "${CTR_NAME}" ]]; then
    echo "Usage: bash ${BASH_SOURCE[0]} '${CTR_NAME}'"
    exit 0
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ~/.local/share/AYON/shim/AYON.png
LOCAL_ICON_PATH="${HOME_DIR}/.local/share/AYON/shim/AYON.png"

# ~/.local/share/applications/rkl9-ayon141-ayon.desktop
LOCAL_DESKTOP_PATH="${HOME_DIR}/.local/share/applications/${CTR_NAME}-${DCC_NAME}.desktop"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_desktop()
{
    if [[ -f "${LOCAL_ICON_PATH}" ]]; then
        return 0
    fi

    local desktop_cmd="[Desktop Entry]
Name=ayon (on ${CTR_NAME})
Exec=/usr/bin/distrobox-enter -n ${CTR_NAME} -- ${DCC_BIN}
Type=Application
Icon=${LOCAL_ICON_PATH}
"
    # ~/.local/share/applications/rkl9-ayon141-ayon.desktop
    echo "${desktop_cmd}" > "${LOCAL_DESKTOP_PATH}";
}


function add_ayon()
{
    if [[ ! -f "${DCC_PATH}" ]]; then
        return 0
    fi

    # 1) install_ayon ----------------------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/ayon
    # sudo bash ./install_ayon141.sh jungs
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH} ${CUR_USER}"
    # --------------------------------------------------------------------------

    # 2) ~/.local/bin/ayon -----------------------------------------------------
    # distrobox-export --bin /opt/ayon/AYON-1.4.1-linux-rocky9/ayon
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${DCC_BIN}"
    # --------------------------------------------------------------------------

    # 3) ~/.local/share/applications/ayon.desktop ------------------------------
    if [[ -f "${DCC_APP}" ]]; then
        # distrobox-export --app /home/jungs/.local/share/AYON/shim/ayon.desktop
        distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${DCC_APP}"
    else
        create_desktop;
    fi
    # --------------------------------------------------------------------------
}

function execute_main()
{
    add_ayon;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
