#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/clipboard/install_xfce4-clipman.sh;

# xfce4-screenshooter를 clipboard로 보내려면 xfce4-clipman을 설치해야 한다
# xfce4-clipman이 bg에 있어야 한다. ( xfce4-clipman & )
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/clipboard
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

# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^xfce4-clipman-plugin) ]] || pacman -S --needed --noconfirm xfce4-clipman-plugin;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xfce4-clipman) ]] || apt install -y --no-install-recommends xfce4-clipman;
        # [[ -n $(apt list --installed | grep -i ^xfce4-clipman-plugin) ]] || apt install -y --no-install-recommends xfce4-clipman-plugin;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xfce4-clipman-plugin) ]] || dnf install -y xfce4-clipman-plugin;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================