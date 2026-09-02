#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/remote/gui/install_remmina.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="remmina"

APP_FULLNAME="org.remmina.Remmina";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # for x86_64, i686, aarch64
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # remmina needs gnome-keyring

        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="freerdp"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # remmina needs gnome-keyring

        # 방법1)
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="remmina-plugin-rdp"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) nixpkg
        # local app_name="${APP_NAME}";
        # local user_type="single";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # 방법3) flatpak
        # local app_fullname="${APP_FULLNAME}";
        # source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # remmina needs gnome-keyring

        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # remmina needs gnome-keyring

        # 방법1)
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2) nixpkg
        # local app_name="${APP_NAME}";
        # local user_type="single";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # 방법3) flapak
        # local app_fullname="${APP_FULLNAME}";
        # source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}"
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