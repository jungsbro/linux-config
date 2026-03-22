#!/bin/bash

# usage ========================================================================
# sudo bash ./install_wmde.sh jungs;
# ==============================================================================

# ENV ==========================================================================
# ------------------------------------------------------------------------------
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER=$1;
while [[ -z ${CUR_USER} ]]
do
    echo "${CUR_USER} not found";
    read -p "Please input username : " CUR_USER;
done
# echo "your name : ${CUR_USER}";
# ------------------------------------------------------------------------------

# CUR_VER ----------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# CUR_ARCH ---------------------------------------------------------------------
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# CUR_WMDE ---------------------------------------------------------------------
CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# update =======================================================================
bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
# ==============================================================================

# graphic driver ===============================================================
function install_nvidia_deb()
{
    if [[ -n $(apt list --installed | grep -i ^nvidia-detect) ]]; then
        return
    fi
    apt install -y nvidia-detect;
    nvidia-detect;
    apt install -y nvidia-driver;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    echo "";
    #install_nvidia_deb;

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
    echo "";
    #dnf update;
    #dnf install kernel-devel kernel-headers gcc make;
    #echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist.conf
    #dracut /boot/initramfs-$(uname -r).img $(uname -r) --force
    #reboot

    #/sbin/init 3
    #alt + ctrl + F1
    #cd /core/utils/drivers/NVIDIA-Linux/
    #sh NVIDIA-Linux-x86_64-440.59.run

    #/sbin/init 5
    #alt + ctrl + F7
fi
# ==============================================================================

# desktop environment ==========================================================
bash ${BIN_DIR}/wmde/config_wmde.sh ${CUR_USER};
# ==============================================================================

# korean =======================================================================
bash ${BIN_DIR}/system/fonts/install_korean.sh ${CUR_USER};
bash ${BIN_DIR}/system/fonts/install_font-manager.sh ${CUR_USER};
# ==============================================================================