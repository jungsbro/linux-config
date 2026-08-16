#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/remote/gui/install_anydesk.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/remote/gui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="anydesk";

# /tmp/anydesk
TMP_DIR="/tmp/${NAME}";

# https://download.anydesk.com/linux/anydesk_7.0.1-1_x86_64.rpm
VER="7.0.1-1"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_anydesk_for_apt()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^anydesk) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -;
    echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list;
    apt update && apt install -y anydesk;
    # --------------------------------------------------------------------------
}


function install_anydesk_for_dnf()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(dnf list --installed | grep -i ^anydesk) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # anydesk-6.3.2-1.el7.x86_64.rpm
    local FNAME="${NAME}-${VER}.el7.x86_64.rpm";

    # https://download.anydesk.com/linux/anydesk-6.3.2-1.el7.x86_64.rpm
    local URL="https://download.anydesk.com/linux/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
        wget ${URL} -O ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------
    fi

    # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
    dnf install -y ${TMP_DIR}/${FNAME};
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        # local app_name="anydesk-legacy-bin"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2)
        local app_name="anydesk-bin"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_anydesk_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_anydesk_for_dnf;
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