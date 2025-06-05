#!/bin/bash

# stacer =======================================================================
# bash /core/linux/bin/system/install_stacer.sh;
# ==============================================================================

# ==============================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# stacer : x86_64, i686, aarch64 ===============================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^stacer) ]] || apt install -y stacer;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "stacer is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    # [[ -n $(yum list installed | grep -i ^stacer) ]] || yum install -y stacer;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    echo "stacer is not supported for rocky"
    # [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    # [[ -n $(dnf list installed | grep -i ^stacer) ]] || dnf install -y stacer;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0