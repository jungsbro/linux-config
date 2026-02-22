#!/bin/bash

# gvfs =========================================================================
# bash ${BIN_DIR}/system/install_gvfs.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/system
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/.."
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
# ------------------------------------------------------------------------------
# gvfs : GNOME Virtual File System
# gvfs-backends : 다양한 프로토콜 지원 (SMB 포함)
# gvfs-fuse : GVFS를 FUSE로 연결해 /run/user/$UID/gvfs/ 아래 마운트
# thunar-volman : Thunar(xfce)에서 GVFS 볼륨 관리 지원
# samba-client : CLI에서 smbclient로 테스트 가능
# ------------------------------------------------------------------------------

function install_gvfs_for_deb()
{
    [[ -n $(apt list --installed | grep -i ^gvfs$) ]] || apt install -y gvfs;
    [[ -n $(apt list --installed | grep -i ^gvfs-backends) ]] || apt install -y gvfs-backends;
    [[ -n $(apt list --installed | grep -i ^gvfs-fuse) ]] || apt install -y gvfs-fuse;

    if [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        [[ -n $(apt list --installed | grep -i ^thunar-volman) ]] || apt install -y thunar-volman;
    fi

    [[ -n $(apt list --installed | grep -i ^smbclient) ]] || apt install -y smbclient;
}

function install_gvfs_for_dnf()
{
    [[ -n $(dnf list installed | grep -i ^gvfs$) ]] || dnf install -y gvfs;
    [[ -n $(dnf list installed | grep -i ^gvfs-smb) ]] || dnf install -y gvfs-smb;
    [[ -n $(dnf list installed | grep -i ^gvfs-fuse) ]] || dnf install -y gvfs-fuse;

    if [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        [[ -n $(dnf list installed | grep -i ^thunar-volman) ]] || dnf install -y thunar-volman;
    fi

    [[ -n $(dnf list installed | grep -i ^samba-client) ]] || dnf install -y samba-client;
}
# ==============================================================================


# main : x86_64, i686, aarch64 =================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_gvfs_for_deb;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------
    install_gvfs_for_dnf;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0