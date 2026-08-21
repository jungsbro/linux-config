#!/bin/bash
set -e

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
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="virtualbox-7.0";

# /core/linux/src/virtualbox-7.0
TMP_DIR= "/core/linux/src/${NAME}";

# https://download.virtualbox.org/virtualbox/7.1.12/virtualbox-7.1_7.1.12-169651~Debian~bookworm_amd64.deb
VER="7.1.12"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_vbox_for_apt()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local REPO_PATH="/etc/apt/sources.list";
    local REPO_CMD=$(cat "${REPO_PATH}");
    local VBOX_REPO_CMD="deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bullseye contrib";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /etc/apt/sources.list
    if [[ -e "${REPO_PATH}" ]] && [[ "${REPO_CMD}" != *"${VBOX_REPO_CMD}"* ]]; then
        echo "" >> "${REPO_PATH}";
        echo "${VBOX_REPO_CMD}" >> "${REPO_PATH}";
    fi

    wget -O- "https://www.virtualbox.org/download/oracle_vbox_2016.asc" | gpg --yes --output "/usr/share/keyrings/oracle-virtualbox-2016.gpg" --dearmor;
    apt update;
    apt install -y virtualbox-7.0;
    # --------------------------------------------------------------------------
}

function install_vbox_for_ubu20()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return 0
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
    if [[ ! -e "${TMP_DIR}/${FNAME1}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
        wget "${URL1}" -O "${TMP_DIR}/${FNAME1}";
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
        wget "${URL2}" -O "${TMP_DIR}/${FNAME2}";
        # ----------------------------------------------------------------------
    fi

    # /core/linux/src/virtualbox-7.0/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    apt install -y "${TMP_DIR}/${FNAME1}";
    # --------------------------------------------------------------------------
}

function install_vbox_for_dnf()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(dnf list --installed | grep -i ^virtualbox) ]]; then
        return 0
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
    if [[ ! -e "${TMP_DIR}/${FNAME1}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
        wget "${URL1}" -O "${TMP_DIR}/${FNAME1}";
        # ----------------------------------------------------------------------
        # /core/linux/src/virtualbox-7.0/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
        wget "${URL2}" -O "${TMP_DIR}/${FNAME2}";
        # ----------------------------------------------------------------------
    fi

    # /core/linux/src/virtualbox-7.0/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    dnf install -y "${TMP_DIR}/${FNAME1}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="virtualbox"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="virtualbox-guest-iso"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        install_vbox_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="virtualbox"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="virtualbox-guest-additions-iso"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2)
        # install_vbox_for_ubu20;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="VirtualBox"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="virtualbox-guest-additions"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_vbox_for_dnf;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================