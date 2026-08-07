#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_x11.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/gpu
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

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


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^xorg-server) ]] || pacman -S --needed --noconfirm xorg-server;
        # for startx
        [[ -n $(pacman -Q | grep -i ^xorg-xinit) ]] || pacman -S --needed --noconfirm xorg-xinit;
        # xorg-x11-utils
        [[ -n $(pacman -Q | grep -i ^xorg-xwininfo) ]] || pacman -S --needed --noconfirm xorg-xwininfo;
        [[ -n $(pacman -Q | grep -i ^xorg-xprop) ]] || pacman -S --needed --noconfirm xorg-xprop;
        [[ -n $(pacman -Q | grep -i ^xorg-xrandr) ]] || pacman -S --needed --noconfirm xorg-xrandr;
        [[ -n $(pacman -Q | grep -i ^xorg-xkill) ]] || pacman -S --needed --noconfirm xorg-xkill;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xorg) ]] || apt install -y xorg;
        # for startx
        [[ -n $(apt list --installed | grep -i ^xinit) ]] || apt install -y xinit;
        # xorg-x11-utils
        [[ -n $(apt list --installed | grep -i ^x11-utils) ]] || apt install -y x11-utils;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xorg-x11-server-Xorg) ]] || dnf install -y xorg-x11-server-Xorg;
        [[ -n $(dnf list --installed | grep -i ^xorg-x11-drv-libinput) ]] || dnf install -y xorg-x11-drv-libinput;
        # for startx
        [[ -n $(dnf list --installed | grep -i ^xorg-x11-xinit) ]] || dnf install -y xorg-x11-xinit;
        # xorg-x11-utils
        [[ -n $(dnf list --installed | grep -i ^xwininfo) ]] || dnf install -y xwininfo;
        [[ -n $(dnf list --installed | grep -i ^xprop) ]] || dnf install -y xprop;
        [[ -n $(dnf list --installed | grep -i ^xrandr) ]] || dnf install -y xrandr;
        [[ -n $(dnf list --installed | grep -i ^xkill) ]] || dnf install -y xkill;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xorg-x11-server-Xorg) ]] || dnf install -y xorg-x11-server-Xorg;
        # for startx
        [[ -n $(dnf list --installed | grep -i ^xorg-x11-xinit) ]] || dnf install -y xorg-x11-xinit;
        # xorg-x11-utils
        [[ -n $(dnf list --installed | grep -i ^xorg-x11-utils) ]] || dnf install -y xorg-x11-utils;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================
