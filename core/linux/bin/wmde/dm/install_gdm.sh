#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/dm/install_gdm.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/dm
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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
function set_gdm_enable()
{
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files gdm.service &>/dev/null; then
            systemctl enable gdm
            systemctl set-default graphical.target
            systemctl restart gdm
        fi
    else    # sysVinit
        return 0
    fi
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^gdm) ]] || pacman -S --needed --noconfirm gdm;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^gdm3) ]] || apt install -y gdm3;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gdm) ]] || dnf install -y gdm;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # only working for fedora and rhel
    source ${CORE_BIN_DIR}/wmde/dm/install_dm_funcs.sh && set_xprofile_enable;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_gdm_enable;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


