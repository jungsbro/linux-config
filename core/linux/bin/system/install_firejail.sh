#!/bin/bash

# firejail =====================================================================
# bash /core/linux/bin/system/install_firejail.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Main : x86_64, i686, aarch64 =================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^firejail) ]] || apt install -y firejail firejail-profiles firetools;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^firejail) ]] || yum install -y firejail;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^firejail) ]] || dnf install -y firejail;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0