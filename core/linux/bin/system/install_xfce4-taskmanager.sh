#!/bin/bash

# xfce4-taskmanager ============================================================
# bash /core/linux/bin/system/install_xfce4-taskmanager.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Func : x86_64, aarch64 =======================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^xfce4-taskmanager) ]] || apt install -y xfce4-taskmanager;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^xfce4-taskmanager) ]] || yum install -y xfce4-taskmanager;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^xfce4-taskmanager) ]] || dnf install -y xfce4-taskmanager;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0