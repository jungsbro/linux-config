#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# flatpak : x86_64, aarch64 ====================================================
function add_flathub()
{
    if [[ *"$(flatpak remotes)"* == *"flathub"* ]]; then
        return
    fi
    
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^flatpak) ]] || apt install -y flatpak;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^flatpak) ]] || yum install -y flatpak
fi

add_flathub;
# ==============================================================================

exit 0