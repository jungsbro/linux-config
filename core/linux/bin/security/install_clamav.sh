#!/bin/bash

# clamav =======================================================================
# bash /core/linux/bin/security/install_clamav.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func =========================================================================
function install_clamav()
{

    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------


    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^clamav) ]] || apt install -y clamav;
        [[ -n $(apt list --installed | grep -i ^clamav-daemon) ]] || apt install -y clamav-daemon;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^clamav) ]] || dnf install -y clamav;
        [[ -n $(dnf list installed | grep -i ^clamd) ]] || dnf install -y clamd;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    if systemctl list-unit-files | grep -iq clamav-daemon; then
        # To stop and disable clamav-daemon service:
        systemctl stop clamav-daemon
        systemctl disable clamav-daemon
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    install_clamav;

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    install_clamav;
fi
# ==============================================================================

exit 0