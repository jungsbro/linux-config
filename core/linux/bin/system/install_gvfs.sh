#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_gvfs.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
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
    [[ -n $(pacman -Q | grep -i ^gvfs) ]] || pacman -S --needed --noconfirm gvfs gvfs-smb;

    if [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        [[ -n $(pacman -Q | grep -i ^thunar-volman) ]] || pacman -S --needed --noconfirm thunar-volman;
    fi

    [[ -n $(pacman -Q | grep -i ^smbclient) ]] || pacman -S --needed --noconfirm smbclient;
    [[ -n $(pacman -Q | grep -i ^gvfs-dnssd) ]] || pacman -S --needed --noconfirm gvfs-dnssd;
}


function install_gvfs_for_apt()
{
    [[ -n $(apt list --installed | grep -i ^gvfs$) ]] || apt install -y gvfs gvfs-backends gvfs-fuse;

    if [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        [[ -n $(apt list --installed | grep -i ^thunar-volman) ]] || apt install -y thunar-volman;
    fi

    [[ -n $(apt list --installed | grep -i ^smbclient) ]] || apt install -y smbclient;
}


function install_gvfs_for_dnf()
{
    [[ -n $(dnf list --installed | grep -i ^gvfs$) ]] || dnf install -y gvfs gvfs-smb gvfs-fuse;

    if [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^thunar-volman) ]] || dnf install -y thunar-volman;
    fi

    [[ -n $(dnf list --installed | grep -i ^samba-client) ]] || dnf install -y samba-client;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_gvfs_for_pacman;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_gvfs_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_gvfs_for_dnf;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # ----------------------------------------------------------------------
        install_gvfs_for_dnf;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================