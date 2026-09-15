#!/bin/bash
set -e

# usage ========================================================================
# atool, 7zip, unzip, tar, libarchive
# bash ${CORE_BIN_DIR}/archive/tools/install_archive-tools.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/archive/tools
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


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    # cli
    bash ${CORE_BIN_DIR}/archive/cli/install_atool.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_7zip.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_unzip.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_tar.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_libarchive.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================