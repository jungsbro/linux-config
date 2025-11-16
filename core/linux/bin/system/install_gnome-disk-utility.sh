#!/bin/bash

# gnome-disk-utility(disks) ====================================================
# bash /core/linux/bin/system/install_gnome-disk-utility.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Main : x86_64, i686, aarch64 ==================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^gnome-disk-utility) ]] || apt install -y gnome-disk-utility;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    # [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^gnome-disk-utility) ]] || yum install -y gnome-disk-utility;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    # [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^gnome-disk-utility) ]] || dnf install -y gnome-disk-utility;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0
