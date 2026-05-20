#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_virtualbox.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="virtualbox-7.0";

# /core/linux/src/virtualbox-7.0
TMP_DIR= "/core/linux/src/${NAME}";

# https://download.virtualbox.org/virtualbox/7.1.12/virtualbox-7.1_7.1.12-169651~Debian~bookworm_amd64.deb
VER="7.1.12"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64 ================================================================
function install_vbox_for_apt()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local REPO_PATH="/etc/apt/sources.list";
    local REPO_CMD=$(cat ${REPO_PATH});
    local VBOX_REPO_CMD="deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bullseye contrib";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /etc/apt/sources.list
    if [[ -e ${REPO_PATH} ]] && [[ *"${REPO_CMD}"* != *"${VBOX_REPO_CMD}"* ]]; then
        echo "" >> ${REPO_PATH};
        echo "${VBOX_REPO_CMD}" >> ${REPO_PATH};
    fi

    wget -O- "https://www.virtualbox.org/download/oracle_vbox_2016.asc" | gpg --yes --output "/usr/share/keyrings/oracle-virtualbox-2016.gpg" --dearmor;
    apt update;
    apt install -y virtualbox-7.0;
    # --------------------------------------------------------------------------
}

function install_vbox_for_ubu20()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    local FNAME1="${NAME}_${VER}-162988~Ubuntu~focal_amd64.deb";

    # https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    local URL1="https://download.virtualbox.org/virtualbox/${VER}/${FNAME1}";

    # Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local FNAME2="Oracle_VM_VirtualBox_Extension_Pack-${VER}.vbox-extpack";

    # https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local URL2="https://download.virtualbox.org/virtualbox/${VER}/${FNAME2}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /core/linux/src/virtualbox-7.0/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    if [[ ! -e ${TMP_DIR}/${FNAME1} ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
        wget ${URL1} -O ${TMP_DIR}/${FNAME1};
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
        wget ${URL2} -O ${TMP_DIR}/${FNAME2};
        # ----------------------------------------------------------------------
    fi

    # /core/linux/src/virtualbox-7.0/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    apt install -y ${TMP_DIR}/${FNAME1};
    # --------------------------------------------------------------------------
}

function install_vbox_for_dnf()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(dnf list --installed | grep -i ^virtualbox) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    local FNAME1="${NAME}-${VER}_162988_el7-1.x86_64.rpm";

    # https://download.virtualbox.org/virtualbox/7.0.18/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    local URL1="https://download.virtualbox.org/virtualbox/${VER}/${FNAME1}";

    # Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local FNAME2="Oracle_VM_VirtualBox_Extension_Pack-${VER}.vbox-extpack";

    # https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local URL2="https://download.virtualbox.org/virtualbox/${VER}/${FNAME1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /core/linux/src/virtualbox-7.0/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    if [[ ! -e ${TMP_DIR}/${FNAME1} ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
        wget ${URL1} -O ${TMP_DIR}/${FNAME1};
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
        wget ${URL2} -O ${TMP_DIR}/${FNAME2};
        # ----------------------------------------------------------------------
    fi

    # /core/linux/src/virtualbox-7.0/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    dnf install -y ${TMP_DIR}/${FNAME1};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^virtualbox) ]] || pacman -S --needed --noconfirm virtualbox virtualbox-guest-iso;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        install_vbox_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^virtualbox) ]] || apt install -y virtualbox virtualbox-guest-additions-iso;
        # install_vbox_for_ubu20;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_vbox_for_dnf;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^virtualbox) ]] || dnf install -y VirtualBox virtualbox-guest-additions;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
