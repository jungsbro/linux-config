#!/bin/bash

# theme ========================================================================
# bash /core/linux/bin/system/install_theme.sh;
# ==============================================================================

# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^papirus-icon) ]] || apt install -y papirus-icon-theme;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "CentOS does not support papirus-icon-theme installation via yum";
    # [[ -n $(yum list installed | grep -i ^snapd) ]] || bash /core/linux/bin/pkgmgmt/install_snap.sh;
    # [[ -n $(snap list | grep -i ^icon-theme-papirus) ]] || snap install icon-theme-papirus;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^papirus-icon-theme) ]] || dnf install -y papirus-icon-theme;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0