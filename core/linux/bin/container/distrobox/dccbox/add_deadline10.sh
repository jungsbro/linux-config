#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# bash ${CORE_BIN_DIR}/container/distrobox/dccbox/add_deadline10.sh "${CTR_NAME}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# native
# /opt/Thinkbox/Deadline10/bin/deadlinelauncher

# distrobox
# ~/.local/bin/deadlinelauncher
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

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
DCC_NAME="deadline10"

DCC_DIR="/mnt/j4105-omv/core/linux/bin/cg/deadline"
DCC_PATH="${DCC_DIR}/install_dl-client.sh"

# /opt/Thinkbox/Deadline10/bin/deadlinebalancer
# /opt/Thinkbox/Deadline10/bin/deadlinelauncher
# /opt/Thinkbox/Deadline10/bin/deadlinemonitor
# /opt/Thinkbox/Deadline10/bin/deadlinepulse
# /opt/Thinkbox/Deadline10/bin/deadlineworker
DCC_BIN_NAMES="deadlinebalancer deadlinelauncher deadlinemonitor deadlinepulse deadlineworker";

# /opt/Thinkbox/Deadline10/deadlinebalancer10.desktop
# /opt/Thinkbox/Deadline10/deadlinelauncher10.desktop
# /opt/Thinkbox/Deadline10/deadlinemonitor10.desktop
# /opt/Thinkbox/Deadline10/deadlinepulse10.desktop
# /opt/Thinkbox/Deadline10/deadlineworker10.desktop
DCC_APP_NAMES="deadlinebalancer10 deadlinelauncher10 deadlinemonitor10 deadlinepulse10 deadlineworker10";

# /home/jungs/.local/bin/ayondeadline
# AYON_DCC_PATH="${HOME_DIR}/.local/bin/ayondeadline"

# /tmp/ayon_env_deadline10.sh
# AYON_ENV_PATH="/tmp/ayon_env_${DCC_NAME}.sh"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# rkl9-deadline10
CTR_NAME="${1}"
if [[ -z "${CTR_NAME}" ]]; then
    echo "Usage: bash ${BASH_SOURCE[0]} '${CTR_NAME}'"
    exit 0
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function add_dealine10()
{
    if [[ ! -f "${DCC_PATH}" ]]; then
        return 0
    fi

    # 1) install_deadline10-client ---------------------------------------------
    # cd /mnt/j4105-omv/core/linux/bin/cg/deadline
    # sudo bash ./install_dl-client.sh jungs
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${DCC_PATH} ${CUR_USER}"
    # --------------------------------------------------------------------------

    # 2) ~/.local/bin/deadline* ------------------------------------------------
    local cur_name="";

    # DCC_BIN_NAMES="deadlinebalancer deadlinelauncher deadlinemonitor deadlinepulse deadlineworker";
    for cur_name in ${DCC_BIN_NAMES};
    do
        local cur_path="/opt/Thinkbox/Deadline10/bin/${cur_name}";

        # distrobox-export --bin /opt/Thinkbox/Deadline10/bin/deadlinebalancer
        # distrobox-export --bin /opt/Thinkbox/Deadline10/bin/deadlinelauncher
        # distrobox-export --bin /opt/Thinkbox/Deadline10/bin/deadlinemonitor
        # distrobox-export --bin /opt/Thinkbox/Deadline10/bin/deadlinepulse
        # distrobox-export --bin /opt/Thinkbox/Deadline10/bin/deadlineworker
        distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${cur_path}";
    done
    # --------------------------------------------------------------------------

    # 3) ~/.local/share/applications/*.desktop ---------------------------------
    # DCC_APP_NAMES="deadlinebalancer10 deadlinelauncher10 deadlinemonitor10 deadlinepulse10 deadlineworker10";
    for cur_name in ${DCC_APP_NAMES};
    do
        local cur_path="/opt/Thinkbox/Deadline10/${cur_name}.desktop";

        # distrobox-export --app /opt/Thinkbox/Deadline10/deadlinebalancer10.desktop
        # distrobox-export --app /opt/Thinkbox/Deadline10/deadlinelauncher10.desktop
        # distrobox-export --app /opt/Thinkbox/Deadline10/deadlinemonitor10.desktop
        # distrobox-export --app /opt/Thinkbox/Deadline10/deadlinepulse10.desktop
        # distrobox-export --app /opt/Thinkbox/Deadline10/deadlineworker10.desktop
        distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${cur_path}";
    done
    # --------------------------------------------------------------------------
}


function execute_main()
{
    add_dealine10;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================