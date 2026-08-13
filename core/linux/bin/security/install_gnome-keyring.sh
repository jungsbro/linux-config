#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/security/install_gnome-keyring.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/security
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
function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^gnome-keyring) ]] || pacman -S --needed --noconfirm gnome-keyring;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^gnome-keyring) ]] || apt install -y --no-install-recommends gnome-keyring;
        [[ -n $(apt list --installed | grep -i ^libsecret) ]] || apt install -y libsecret-1-0 libsecret-1-dev;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-keyring) ]] || dnf install -y gnome-keyring;
        [[ -n $(dnf list --installed | grep -i ^libsecret) ]] || dnf install -y libsecret;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================