#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/network/install_firewall.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/network
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================

# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # [[ -n $(pacman -Q | grep -i ^nftables) ]] || pacman -S --needed --noconfirm nftables;

        [[ -n $(pacman -Q | grep -i ^ufw) ]] || pacman -S --needed --noconfirm ufw;
        ufw enable;

        # [[ -n $(pacman -Q | grep -i ^firewalld) ]] || pacman -S --needed --noconfirm firewalld;
        # source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv firewalld && restart_sv firewalld;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ufw) ]] || apt install -y ufw;
        ufw enable;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^firewalld) ]] || dnf install -y firewalld;
        source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv firewalld && restart_sv firewalld;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================


