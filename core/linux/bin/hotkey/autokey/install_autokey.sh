#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/hotkey/autokey/install_autokey.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/hotkey/autokey
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
APP_NAME="autokey";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # for x86_64, aarch64, i686
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="autokey-qt"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        else
            local app_name="autokey-gtk"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="autokey-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            local app_name="autokey-gtk"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="autokey-qt"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            local app_name="autokey-gtk"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rhel8
            echo "autokey not working on rhel8";
            return 0
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="autokey-qt"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            local app_name="autokey-gtk"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        fi
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
        config_autokey "${CUR_USER}" && \
        set_autokey_autostart "${CUR_USER}"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================