#!/bin/bash
set -e

# usage ========================================================================
# crudini, xmlstarlet, jq, yq
# bash ${CORE_BIN_DIR}/datamgmt/tools/install_data-tools.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/datamgmt/tools
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    # data 관리
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_crudini.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_xmlstarlet.sh;
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_jq.sh;
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_yq.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================