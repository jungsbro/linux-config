#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ide/featherpad/install_featherpad.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ide/featherpad
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/config";
    local src_path="${src_dir}/fp.conf";

    local dst_dir="${HOME_DIR}/.config/featherpad";
    local dst_path="${dst_dir}/fp.conf";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ -f "${dst_path}" ]]; then
    #     return 0
    # fi
    if [[ ! -d "${dst_dir}" ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${src_path}" ]]; then
        su - ${CUR_USER} -c "cp -f ${src_path} ${dst_path}";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="featherpad"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="featherpad"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="featherpad"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="featherpad"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
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