#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# vlc : x86_64, aarch64 ========================================================
function install_vlc_rpm()
{
    if [[ -n $(yum list installed | grep -i ^vlc) ]]; then
        return
    fi
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^nux-dextop) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    yum install -y vlc;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^vlc) ]] || apt install -y vlc;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    install_vlc_rpm;
fi
# ==============================================================================

exit 0