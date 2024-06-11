#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# theme ========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^papirus-icon) ]] || apt install -y papirus-icon-theme;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^snapd) ]] || bash /core/linux/bin/pkgmgmt/install_snap.sh;
    [[ -n $(snap list | grep -i ^icon-theme-papirus) ]] || snap install icon-theme-papirus;
fi
# ==============================================================================

exit 0