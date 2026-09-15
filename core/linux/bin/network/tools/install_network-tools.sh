#!/bin/bash
set -e

# usage ========================================================================
# axcel, curl, iputils, net-tools, speedtest-cli, whois
# bash ${CORE_BIN_DIR}/network/tools/install_network-tools.sh;
# ==============================================================================

# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/network/tools
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
    bash ${CORE_BIN_DIR}/network/cli/install_axel.sh;
    bash ${CORE_BIN_DIR}/network/cli/install_curl.sh;
    bash ${CORE_BIN_DIR}/network/cli/install_iputils.sh;
    bash ${CORE_BIN_DIR}/network/cli/install_net-tools.sh;
    bash ${CORE_BIN_DIR}/network/cli/install_speedtest-cli.sh;
    bash ${CORE_BIN_DIR}/network/cli/install_whois.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


