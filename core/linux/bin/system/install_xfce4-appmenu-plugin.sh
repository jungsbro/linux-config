#!/bin/bash

# xfce4-appmenu-plugin =========================================================
# bash /core/linux/bin/system/install_xfce4-appmenu-plugin.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^xfce4-appmenu-plugin) ]] || apt install -y xfce4-appmenu-plugin;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "CentOS is not supported for xfce4-appmenu-plugin"
    # [[ -n $(yum list installed | grep -i ^xfce4-appmenu-plugin) ]] || yum install -y xfce4-appmenu-plugin;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    echo "Rocky is not supported for xfce4-appmenu-plugin"
    # [[ -n $(dnf list installed | grep -i ^xfce4-appmenu-plugin) ]] || dnf install -y xfce4-appmenu-plugin;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


exit 0