#!/bin/bash

# xfce4-fsguard-plugin =========================================================
# bash /core/linux/bin/system/install_xfce4-fsguard-plugin.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func : x86_64, aarch64 =======================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^xfce4-fsguard-plugin) ]] || apt install -y xfce4-fsguard-plugin;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^xfce4-fsguard-plugin) ]] || yum install -y xfce4-fsguard-plugin;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^xfce4-fsguard-plugin) ]] || dnf install -y xfce4-fsguard-plugin;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0