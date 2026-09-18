#!/bin/bash
set -e

# usage ========================================================================
# fastfetch, hdparm, ncdu, procps, tldr
# bash ${CORE_BIN_DIR}/info/tools/install_info-tools.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/info/tools
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/info/cli/install_fastfetch.sh;
    bash ${CORE_BIN_DIR}/info/cli/install_hdparm.sh;
    bash ${CORE_BIN_DIR}/info/cli/install_ncdu.sh;
    bash ${CORE_BIN_DIR}/info/cli/install_procps.sh;
    bash ${CORE_BIN_DIR}/info/cli/install_tldr.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================