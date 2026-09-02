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
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="anydesk";

# /tmp/anydesk
TMP_DIR="/tmp/${APP_NAME}";

# https://download.anydesk.com/linux/anydesk_8.0.4-1_amd64.deb
# https://download.anydesk.com/rpi/anydesk_8.0.4-1_arm64.deb

# https://download.anydesk.com/linux/anydesk_8.0.4-1_x86_64.rpm
# https://download.anydesk.com/rpi/anydesk_8.0.4-1_aarch64.rpm
VER="8.0.4-1"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_anydesk_for_apt()      # not used
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


function install_anydesk_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="amd64";
        local cur_hw="linux"

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="arm64";
        local cur_hw="rpi"

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # anydesk_8.0.4-1_amd64.deb
    # anydesk_8.0.4-1_arm64.deb
    local deb_fname="${APP_NAME}_${VER}_${cur_arch}.deb";

    # https://download.anydesk.com/linux/anydesk_8.0.4-1_amd64.deb
    # https://download.anydesk.com/rpi/anydesk_8.0.4-1_arm64.deb
    local deb_url="https://download.anydesk.com/${cur_hw}/${deb_fname}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local deb_url="${DEB_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/deb/install_deb_funcs.sh && \
    install_debpkg "${app_name}" "${deb_url}";
    # --------------------------------------------------------------------------
}


function install_anydesk_for_rpm()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="x86_64";
        local cur_hw="linux"

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="aarch64";
        local cur_hw="rpi"

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # anydesk_8.0.4-1_x86_64.rpm
    # anydesk_8.0.4-1_aarch64.rpm
    local rpm_fname="${APP_NAME}_${VER}_${cur_arch}.rpm";

    # https://download.anydesk.com/linux/anydesk_8.0.4-1_x86_64.rpm
    # https://download.anydesk.com/rpi/anydesk_8.0.4-1_aarch64.rpm
    local rpm_url="https://download.anydesk.com/${cur_hw}/${rpm_fname}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local rpm_url="${RPM_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/rpm/install_rpm_funcs.sh && \
    install_rpmpkg "${app_name}" "${rpm_url}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        # local app_name="anydesk-legacy-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2)
        local app_name="anydesk-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_anydesk_for_deb;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_anydesk_for_rpm;
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