#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/mount/install_gvfs.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/mount
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

# ------------------------------------------------------------------------------
APP_NAME="gvfs";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
# gvfs : GNOME Virtual File System
# gvfs-backends : 다양한 프로토콜 지원 (SMB 포함)
# gvfs-fuse : GVFS를 FUSE로 연결해 /run/user/$UID/gvfs/ 아래 마운트
# thunar-volman : Thunar(xfce)에서 GVFS 볼륨 관리 지원
# samba-client : CLI에서 smbclient로 테스트 가능
# ------------------------------------------------------------------------------

function install_gvfs_for_pacman()
{
    local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    local app_name="gvfs-smb"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    if [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        local app_name="thunar-volman"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    fi

    local app_name="smbclient"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    local app_name="gvfs-dnssd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
}


function install_gvfs_for_apt()
{
    local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="gvfs-backends"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="gvfs-fuse"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    if [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        local app_name="thunar-volman"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    fi

    local app_name="smbclient"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
}


function install_gvfs_for_dnf()
{
    [[ -n $(dnf list --installed | grep -i ^gvfs$) ]] || dnf install -y gvfs gvfs-smb gvfs-fuse;
    local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="gvfs-smb"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="gvfs-fuse"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    if [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        local app_name="thunar-volman"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    fi

    local app_name="samba-client"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
}
# ==============================================================================


# Main =========================================================================
function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_gvfs_for_pacman;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_gvfs_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_gvfs_for_dnf;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # ----------------------------------------------------------------------
        install_gvfs_for_dnf;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# =============================================================================