#!/bin/bash
set -e

# usage ========================================================================
# autofs, exfat, nfs, ntfs-3g, rclone, samba
# bash ${CORE_BIN_DIR}/mount/tools/install_mount-tools.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/mount/tools
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/mount/cli/install_autofs.sh;
    bash ${CORE_BIN_DIR}/mount/cli/install_exfat.sh;
    bash ${CORE_BIN_DIR}/mount/cli/install_nfs.sh;
    bash ${CORE_BIN_DIR}/mount/cli/install_ntfs-3g.sh;
    bash ${CORE_BIN_DIR}/mount/cli/install_rclone.sh;
    bash ${CORE_BIN_DIR}/mount/cli/install_samba.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# =============================================================================