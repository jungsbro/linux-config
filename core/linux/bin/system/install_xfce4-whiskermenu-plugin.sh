#!/bin/bash

# xfce4-appmenu-plugin =========================================================
# bash /core/linux/bin/system/install_xfce4-whiskermenu-plugin.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^xfce4-whiskermenu-plugin) ]] || apt install -y xfce4-whiskermenu-plugin;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^xfce4-whiskermenu-plugin) ]] || dnf install -y xfce4-whiskermenu-plugin;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


exit 0