#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh;
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

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# main : x86_64, i686, aarch64 =================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(pacman -Q | grep -i ^pcmanfm-qt$) ]] || pacman -S --needed --noconfirm pcmanfm-qt;
        else
            [[ -n $(pacman -Q | grep -i ^pcmanfm$) ]] || pacman -S --needed --noconfirm pcmanfm;
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^pcmanfm-qt$) ]] || apt install -y pcmanfm-qt;
        else
            [[ -n $(apt list --installed | grep -i ^pcmanfm$) ]] || apt install -y pcmanfm;
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^pcmanfm-qt$) ]] || dnf install -y pcmanfm-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^pcmanfm$) ]] || dnf install -y pcmanfm;
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "pcmanfm is not supported for RHEL"
        return 0
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================


