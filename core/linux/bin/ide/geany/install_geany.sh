#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ide/geany/install_geany.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ide/geany
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
APP_NAME="geany";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/config";

    local dst_dir="${HOME_DIR}/.config/geany";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${dst_dir}" ]]; then
        return 0
    else
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${src_dir}" ]]; then
        su - "${CUR_USER}" -c "cp -Rf ${src_dir}/* ${dst_dir}/";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="geany-plugins"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="geany-plugins"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="geany-plugins-addons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="geany-plugins-addons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi

    copy_config_to_home;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================