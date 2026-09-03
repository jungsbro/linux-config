#!/bin/bash
set -e

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
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="xorg-server"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # for startx
        local app_name="xorg-xinit"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # xorg-x11-utils
        local app_name="xorg-xwininfo"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xorg-xprop"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xorg-xrandr"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xorg-xkill"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="xorg"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # for startx
        local app_name="xinit"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # xorg-x11-utils
        local app_name="x11-utils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="xorg-x11-server-Xorg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xorg-x11-drv-libinput"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # for startx
        local app_name="xorg-x11-xinit"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # xorg-x11-utils
        local app_name="xwininfo"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xprop"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xrandr"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xkill"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="xorg-x11-server-Xorg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # for startx
        local app_name="xorg-x11-xinit"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # xorg-x11-utils
        local app_name="xorg-x11-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
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
