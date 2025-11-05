#!/bin/bash

# drawing ======================================================================
# bash /core/linux/bin/graphics/install_pinta.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Main : x86_64, i686, aarch64 =================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
    [[ -n $(flatpak list --app | grep -i kolourpaint) ]] || flatpak install -y flathub com.github.PintaProject.Pinta;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "centos is not supported for drawing"
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
    [[ -n $(flatpak list --app | grep -i kolourpaint) ]] || flatpak install -y flathub com.github.PintaProject.Pinta;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0
