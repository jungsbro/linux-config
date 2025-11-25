#!/bin/bash

# xfce4-screensaver ============================================================
# bash /core/linux/bin/system/install_xfce4-screensaver.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func : x86_64, aarch64 =======================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    echo "Debian is not supported for xfce4-screensaver.";
    # [[ -n $(apt list --installed | grep -i ^xfce4-screensaver) ]] || apt install -y xfce4-screensaver;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^xfce4-screensaver) ]] || yum install -y xfce4-screensaver;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^xfce4-screensaver) ]] || dnf install -y xfce4-screensaver;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0