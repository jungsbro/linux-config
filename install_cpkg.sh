#!/bin/bash
set -e

# usage ========================================================================
# sudo bash ./install_cpkg.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
ROOT_DIR="$(dirname "$(realpath "${0}")")"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER="${1:? 'Username not provided.'}";

while [[ -z "${CUR_USER}" ]]
do
    echo "Username not provided."
    read -p "Please input username : " CUR_USER
done

# echo "User selected: ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ${CORE_BIN_DIR}/ -------------------------------------------------------------
# CORE_DIR="./core";
# BIN_DIR="/core/linux/bin/";
# SRC_DIR="/core/linux/src/";

# # if [[ ! -d "${CORE_BIN_DIR}" ]]; then
# cp -Rf "${CORE_DIR}" /;
# chmod -R 755 "${CORE_BIN_DIR}";
# # fi

# [[ -d "${SRC_DIR}" ]] || mkdir -p "${SRC_DIR}";
# chmod 777 "${SRC_DIR}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # update -------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # tools1 -------------------------------------------------------------------
    # firewall, ssh, clamav
    bash ${CORE_BIN_DIR}/security/tools/install_security-tools.sh;

    # base-devel, python
    bash ${CORE_BIN_DIR}/develop/tools/install_develop-tools.sh;

    # crudini, xmlstarlet, jq, yq
    bash ${CORE_BIN_DIR}/datamgmt/tools/install_data-tools.sh "${CUR_USER}";

    # nala
    bash ${CORE_BIN_DIR}/pkgmgmt/tools/install_pkgmgmt-tools.sh;
    # --------------------------------------------------------------------------

    # tools2 -------------------------------------------------------------------
    # autofs, exfat, nfs, ntfs-3g, rclone, samba
    bash ${CORE_BIN_DIR}/mount/tools/install_mount-tools.sh;

    # axcel, curl, iputils, net-tools, speedtest-cli, whois
    bash ${CORE_BIN_DIR}/network/tools/install_network-tools.sh;

    # fastfetch, hdparm, ncdu, procps, tldr
    bash ${CORE_BIN_DIR}/info/tools/install_info-tools.sh "${CUR_USER}";

    # btop, glances, htop, nmon, powertop
    bash ${CORE_BIN_DIR}/monitoring/tools/install_monitoring-tools.sh;
    # --------------------------------------------------------------------------

    # tools3 -------------------------------------------------------------------
    # fzf, ripgrep, fd-find, zoxide, fasd, plocate
    bash ${CORE_BIN_DIR}/filemgr/tools/install_find-tools.sh "${CUR_USER}";

    # bat, eza, lsd, tree
    bash ${CORE_BIN_DIR}/filemgr/tools/install_ls-tools.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # tools4 -------------------------------------------------------------------
    # atool, 7zip, unzip, tar, libarchive
    bash ${CORE_BIN_DIR}/archive/tools/install_archive-tools.sh;

    # fontconfig, fonts-d2coding, fonts-hacknerdfont, fonts-nanum, locales, fonts-emoji, gnome-characters
    bash ${CORE_BIN_DIR}/fonts/tools/install_font-tools.sh "${CUR_USER}";

    # rsync, inotify-tools
    bash ${CORE_BIN_DIR}/utilities/tools/install_util-tools.sh;

    # cmatrix, tty-clock, nyancat
    # bash ${CORE_BIN_DIR}/screensaver/tools/install_screensaver-tools.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/ide/tui/install_vim.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/system/cli/install_tmux.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # file-manager -------------------------------------------------------------
    # bash ${CORE_BIN_DIR}/filemgr/tui/install_mc.sh;
    # bash ${CORE_BIN_DIR}/filemgr/tui/nnn/install_nnn.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/filemgr/tui/install_ranger.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/filemgr/tui/yazi/install_yazi.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/system/cli/install_zsh.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/mount/cli/config_swap.sh;
    bash ${CORE_BIN_DIR}/mount/cli/config_fstab.sh;
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

