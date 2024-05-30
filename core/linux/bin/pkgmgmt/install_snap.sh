#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# snap : x86_64, aarch64 =======================================================
function install_snapd_deb()
{
    if [[ -n $(apt list --installed | grep -i ^snapd) ]]; then
        return
    fi

    # linuxmint ----------------------------------------------------------------
    local SRC_PATH="/etc/apt/preferences.d/nosnap.pref"
    local DST_DIR="~/Documents"
    local DST_PATH="${DST_DIR}/nosnap.backup"

    if [[ -e ${SRC_PATH} ]]; then
        [[ -e ${DST_DIR} ]] || mkdir -p ${DST_DIR};
        mv ${SRC_PATH} ${DST_DIR};
        apt update;
    fi
    # --------------------------------------------------------------------------

    apt install -y snapd;

    init 6;
}

function install_snapd_rpm()
{
    if [[ -n $(yum list installed | grep -i ^snapd) ]]; then
        return
    fi

    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    yum install -y snapd;

    systemctl enable --now snapd.socket;
    #systemctl enable snapd;

    ln -s /var/lib/snapd/snap /snap;

    init 6;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    install_snapd_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    install_snapd_rpm;
fi

[[ -n $(snap list | grep -i ^core) ]] || snap install core;
# ==============================================================================

exit 0