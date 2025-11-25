#!/bin/bash

# snap =========================================================================
# bash /core/linux/bin/pkgmgmt/install_snap.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function install_snapd_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ -n $(apt list --installed | grep -i ^snapd) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # for linuxmint ------------------------------------------------------------
    local SRC_PATH="/etc/apt/preferences.d/nosnap.pref"

    local DST_DIR="~/Documents"

    # ~/Documents/nosnap.backup
    local DST_PATH="${DST_DIR}/nosnap.backup"

    # /etc/apt/preferences.d/nosnap.pref
    if [[ -e ${SRC_PATH} ]]; then

        # ~/Documents/nosnap.backup
        [[ -e ${DST_DIR} ]] || mkdir -p ${DST_DIR};

        mv ${SRC_PATH} ${DST_DIR};
        apt update;
    fi
    # --------------------------------------------------------------------------

    apt install -y snapd;

    init 6;
}


function install_snapd_for_cent()
{
    # --------------------------------------------------------------------------
    if [[ -n $(yum list installed | grep -i ^snapd) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    yum install -y snapd;

    systemctl enable --now snapd.socket;
    #systemctl enable snapd;

    ln -s /var/lib/snapd/snap /snap;

    init 6;
    # --------------------------------------------------------------------------
}


function install_snapd_for_rocky()
{
    # --------------------------------------------------------------------------
    if [[ -n $(dnf list installed | grep -i ^snapd) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    dnf install -y snapd;

    systemctl enable --now snapd.socket;

    ln -s /var/lib/snapd/snap /snap;

    init 6;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_snapd_for_deb;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    install_snapd_for_cent;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_snapd_for_rocky;
    # --------------------------------------------------------------------------
fi

# [[ -n $(snap list | grep -i ^core) ]] || snap install core;
# ==============================================================================

exit 0