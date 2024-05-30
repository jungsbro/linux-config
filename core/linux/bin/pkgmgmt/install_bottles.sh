#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================

# bottles : x86_64 =============================================================
function install_bottles()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        [[ -n $(yum list installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh
    fi
    
    # ~/.local/share/applications/KakaoTalk.desktop
    [[ -n $(flatpak list --app | grep -i bottles) ]] || flatpak install -y flathub com.usebottles.bottles;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   install_bottles;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   echo "";
fi
# ==============================================================================

exit 0