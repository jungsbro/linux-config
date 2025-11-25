#!/bin/bash

# timeshift ====================================================================
# bash /core/linux/bin/system/install_timeshift.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# main : x86_64, i686, aarch64 =================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^timeshift) ]] || apt install -y timeshift;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^timeshift) ]] || yum install -y timeshift;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^timeshift) ]] || dnf install -y timeshift;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0