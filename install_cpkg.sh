#!/bin/bash
set -e

# usage ========================================================================
# sudo bash ./install_cpkg.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER="${1}"

while [[ -z "${CUR_USER}" ]]
do
    echo "Username not provided."
    read -p "Please input username : " CUR_USER
done

# echo "User selected: ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ${CORE_BIN_DIR}/ -------------------------------------------------------------
# CORE_DIR="./core";
# BIN_DIR="/core/linux/bin/";
# SRC_DIR="/core/linux/src/";

# # if [[ ! -d ${CORE_BIN_DIR} ]]; then
# cp -rf ${CORE_DIR} /;
# chmod -R 755 ${CORE_BIN_DIR};
# # fi

# [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
# chmod 777 ${SRC_DIR};
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # update -------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # tools (group) ------------------------------------------------------------
    bash ${CORE_BIN_DIR}/security/tools/install_security-tools.sh;

    bash ${CORE_BIN_DIR}/develop/tools/install_develop-tools.sh;
    bash ${CORE_BIN_DIR}/develop/tools/install_crud-tools.sh "${CUR_USER}";

    bash ${CORE_BIN_DIR}/pkgmgmt/tools/install_pkgmgmt-tools.sh;

    bash ${CORE_BIN_DIR}/mount/tools/install_mount-tools.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/network/tools/install_network-tools.sh;

    bash ${CORE_BIN_DIR}/monitoring/tools/install_info-tools.sh;
    bash ${CORE_BIN_DIR}/monitoring/tools/install_monitoring-tools.sh;

    bash ${CORE_BIN_DIR}/filemgr/cli/tools/install_filemgr-tools.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/archive/tools/install_archive-tools.sh;
    bash ${CORE_BIN_DIR}/fonts/tools/install_font-tools.sh "${CUR_USER}";

    bash ${CORE_BIN_DIR}/utilities/tools/install_util-tools.sh "${CUR_USER}";
    # bash ${CORE_BIN_DIR}/screensaver/tools/install_screensaver-tools.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/ide/install_vim.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/system/install_tmux.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # file-manager -------------------------------------------------------------
    # bash ${CORE_BIN_DIR}/filemgr/tui/install_mc.sh;
    # bash ${CORE_BIN_DIR}/filemgr/tui/nnn/install_nnn.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/filemgr/tui/install_ranger.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/filemgr/tui/yazi/install_yazi.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/system/install_zsh.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/mount/config_swap.sh;
    bash ${CORE_BIN_DIR}/mount/config_fstab.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


# reboot =======================================================================
#/usr/sbin/init 6;
# ==============================================================================

