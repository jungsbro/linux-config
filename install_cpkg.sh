#!/bin/bash

# usage ========================================================================
# sudo bash ./install_cpkg.sh jungs;
# ==============================================================================


# ENV ==========================================================================
# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER=$1;
while [[ -z ${CUR_USER} ]]
do
    echo "${CUR_USER} not found";
    read -p "Please input username : " CUR_USER;
done
# echo "your name : ${CUR_USER}";
# ------------------------------------------------------------------------------

# CUR_VER ----------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# CUR_ARCH ---------------------------------------------------------------------
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# /core/linux/bin/ -------------------------------------------------------------
CORE_DIR="./core";
BIN_DIR="/core/linux/bin/";
SRC_DIR="/core/linux/src/";

# if [[ ! -d ${BIN_DIR} ]]; then
cp -rf ${CORE_DIR} /;
chmod -R 755 ${BIN_DIR};
# fi

[[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
chmod 777 ${SRC_DIR};
# ------------------------------------------------------------------------------
# ==============================================================================


# update =======================================================================
bash /core/linux/bin/pkgmgmt/update_repo.sh;
# ==============================================================================


# development ==================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^git) ]] || apt install -y git build-essential;
    apt install -y python3-pip python3-dev python3-setuptools;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    [[ -n $(dnf list installed | grep -i ^git) ]] || dnf install -y git;
    dnf install -y python3 python3-libs python3-pip python3-setuptools;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


# maintenance ==================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^unattended) ]] || apt install -y unattended-upgrades;
    [[ -n $(apt list --installed | grep -i ^rsync) ]] || apt install -y rsync;
    [[ -n $(apt list --installed | grep -i ^locales) ]] || apt install -y locales;
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]]; then
        [[ -n $(apt list --installed | grep -i ^nala) ]] || apt install -y nala;
    fi
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    [[ -n $(dnf list installed | grep -i ^rsync) ]] || dnf install -y rsync;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


# security =====================================================================
bash /core/linux/bin/security/install_clamav.sh;
# ==============================================================================


# storage ======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^samba$) ]] || apt install -y samba;
    [[ -n $(apt list --installed | grep -i ^samba-common) ]] || apt install -y samba-common;
    [[ -n $(apt list --installed | grep -i ^cifs-utils) ]] || apt install -y cifs-utils;
    [[ -n $(apt list --installed | grep -i ^smbclient) ]] || apt install -y smbclient;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^ntfs-3g) ]] || apt install -y ntfs-3g;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^exfat) ]] || apt install -y exfat-fuse;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^nfs-kernel-server) ]] || apt install -y nfs-kernel-server;
    [[ -n $(apt list --installed | grep -i ^rpcbind) ]] || apt install -y rpcbind;
    [[ -n $(apt list --installed | grep -i ^nfs-commo) ]] || apt install -y nfs-common;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^autofs) ]] || apt install -y autofs;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^rclone) ]] || apt install -y rclone;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^samba$) ]] || dnf install -y samba;
    [[ -n $(dnf list installed | grep -i ^samba-common) ]] || dnf install -y samba-common;
    [[ -n $(dnf list installed | grep -i ^cifs-utils) ]] || dnf install -y cifs-utils;
    [[ -n $(dnf list installed | grep -i ^samba-client) ]] || dnf install -y samba-client;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^ntfs-3g) ]] || dnf install -y ntfs-3g;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^exfatprogs) ]] || dnf install -y exfatprogs;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^nfs-utils) ]] || dnf install -y nfs-utils;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^autofs) ]] || dnf install -y autofs;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^rclone) ]] || dnf install -y rclone;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


# network ======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^net-tools) ]] || apt install -y net-tools;
    [[ -n $(apt list --installed | grep -i ^whois) ]] || apt install -y whois;
    [[ -n $(apt list --installed | grep -i ^iputils) ]] || apt install -y iputils-ping;
    [[ -n $(apt list --installed | grep -i ^speedtest-cli) ]] || apt install -y speedtest-cli;
    [[ -n $(apt list --installed | grep -i ^axel) ]] || apt install -y axel;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^net-tools) ]] || dnf install -y net-tools;
    [[ -n $(dnf list installed | grep -i ^whois) ]] || dnf install -y whois;
    [[ -n $(dnf list installed | grep -i ^iputils) ]] || dnf install -y iputils;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


# info =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    if [[ -n $(apt list | grep -i ^neofetch) ]]; then
        [[ -n $(apt list --installed | grep -i ^neofetch) ]] || apt install -y neofetch;
    fi
    if [[ -n $(apt list | grep -i ^fastfetch) ]]; then
        [[ -n $(apt list --installed | grep -i ^fastfetch) ]] || apt install -y fastfetch;
    fi
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^hdparm) ]] || apt install -y hdparm;
    [[ -n $(apt list --installed | grep -i ^ncdu) ]] || apt install -y ncdu;
    [[ -n $(apt list --installed | grep -i ^procps) ]] || apt install -y procps;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^neofetch) ]] || dnf install -y neofetch;
    [[ -n $(dnf list installed | grep -i ^fastfetch) ]] || dnf install -y fastfetch;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^hdparm) ]] || dnf install -y hdparm;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^ncdu) ]] || dnf install -y ncdu;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^procps-ng) ]] || dnf install -y procps-ng;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


# monitoring ===================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^htop) ]] || apt install -y htop;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^btop) ]] || apt install -y btop;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^nmon) ]] || apt install -y nmon;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^glances) ]] || apt install -y glances;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^powertop) ]] || apt install -y powertop;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^htop) ]] || dnf install -y htop;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^btop) ]] || dnf install -y btop;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^nmon) ]] || dnf install -y nmon;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^glances) ]] || dnf install -y glances;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^powertop) ]] || dnf install -y powertop;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


# etc ==========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^p7zip-full) ]] || apt install -y p7zip-full;
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^lsd) ]] || apt install -y lsd;
    # [[ -n $(apt list --installed | grep -i ^tldr) ]] || apt install -y tldr;
    # [[ -n $(apt list --installed | grep -i ^nyancat) ]] || apt install -y nyancat;
    # [[ -n $(apt list --installed | grep -i ^cmatrix) ]] || apt install -y cmatrix;
    # [[ -n $(apt list --installed | grep -i ^tty-clock) ]] || apt install -y tty-clock;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
    [[ -n $(dnf list installed | grep -i ^p7zip-plugins) ]] || dnf install -y p7zip-plugins;
    # --------------------------------------------------------------------------
    # dnf install -y nyancat cmatrix tty-clock;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# vim ==========================================================================
bash /core/linux/bin/ide/install_vim.sh ${CUR_USER};
# ==============================================================================

# tmux =========================================================================
bash /core/linux/bin/system/install_tmux.sh ${CUR_USER};
# ==============================================================================

# file-manager =================================================================
bash /core/linux/bin/filemgr/install_mc.sh;
bash /core/linux/bin/filemgr/install_ranger.sh ${CUR_USER};
# ==============================================================================

# zsh ==========================================================================
bash /core/linux/bin/system/install_zsh.sh ${CUR_USER};
# ==============================================================================

# swap =========================================================================
bash /core/linux/bin/system/config_swap.sh;
# ==============================================================================

# fstab ========================================================================
bash /core/linux/bin/system/config_fstab.sh;
# ==============================================================================


# reboot =======================================================================
#/usr/sbin/init 6;
# ==============================================================================
