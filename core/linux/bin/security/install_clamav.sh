#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/security/install_clamav.sh;
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

# ------------------------------------------------------------------------------
APP_NAME="clamav"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_clamav()
{

    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="clamav-daemon"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="clamd"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="clamd"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files clamav-daemon.service &>/dev/null; then
            # To stop and disable clamav-daemon service:
            systemctl stop clamav-daemon
            systemctl disable clamav-daemon
        fi
    else    # sysVinit
        return 0
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_clamav;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_clamav;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_clamav;
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