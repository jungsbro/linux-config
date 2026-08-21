#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/develop/tools/install_crud-tools.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/develop/tools
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/develop/install_crudini.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/develop/install_xmlstarlet.sh;
    bash ${CORE_BIN_DIR}/develop/install_jq.sh;
    bash ${CORE_BIN_DIR}/develop/install_yq.sh;

    bash ${CORE_BIN_DIR}/develop/install_crudini.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/develop/install_xmlstarlet.sh;
    bash ${CORE_BIN_DIR}/develop/install_jq.sh;
    bash ${CORE_BIN_DIR}/develop/install_yq.sh;

    bash ${CORE_BIN_DIR}/develop/install_glib2.sh;
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;

    bash ${CORE_BIN_DIR}/develop/install_yad.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================