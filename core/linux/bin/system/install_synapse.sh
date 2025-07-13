#!/bin/bash

# synapse ======================================================================
# bash /core/linux/bin/system/install_synapse.sh;
# ==============================================================================

# ==============================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# synapse : x86_64, i686, aarch64 ==============================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^synapse) ]] || apt install -y synapse;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "synapse is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    # [[ -n $(yum list installed | grep -i ^synapse) ]] || yum install -y synapse;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    echo "synapse is not supported for rocky"
    # [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    # [[ -n $(dnf list installed | grep -i ^synapse) ]] || dnf install -y synapse;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0