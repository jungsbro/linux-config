#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/gui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="pcmanfm"
APP_CAT="System;FileTools;Utility;Core;GTK;FileManager;Development"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            [[ -n $(pacman -Q | grep -i ^pcmanfm-qt$) ]] || pacman -S --needed --noconfirm pcmanfm-qt;
        else
            [[ -n $(pacman -Q | grep -i ^pcmanfm$) ]] || pacman -S --needed --noconfirm pcmanfm;
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^pcmanfm-qt$) ]] || apt install -y pcmanfm-qt;
        else
            [[ -n $(apt list --installed | grep -i ^pcmanfm$) ]] || apt install -y pcmanfm;
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^pcmanfm-qt$) ]] || dnf install -y pcmanfm-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^pcmanfm$) ]] || dnf install -y pcmanfm;
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "pcmanfm is not supported for RHEL"
        # return 0

        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
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

