#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/panel/install_xfce4-docklike.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/panel
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

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="xfce4-docklike-plugin"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function copy_nix-dokclike()
{
    # --------------------------------------------------------------------------
    local app_desktop_dir="/usr/share/xfce4/panel/plugins"
    local app_desktop_path="${app_desktop_dir}/docklike.desktop"

    local app_so_dir="/usr/lib/x86_64-linux-gnu/xfce4/panel/plugins"
    local app_so_path="${app_so_dir}/libdocklike.so"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f ${app_desktop_path} ]]; then
        return 0
    fi
    if [[ -f ${app_so_path} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # docklike.desktop ---------------------------------------------------------
    # ln -s ~/.nix-profile/share/xfce4/panel/plugins/docklike.desktop /usr/share/xfce4/panel/plugins/docklike.desktop
    local src_dir="${HOME_DIR}/.nix-profile/share/xfce4/panel/plugins"

    if [[ -d ${src_dir} ]]; then
        if [[ -d ${app_desktop_dir} ]]; then
            cp -u -L ${src_dir}/*.desktop "${app_desktop_dir}/"
        fi
    fi
    # --------------------------------------------------------------------------

    # libdocklike.so -----------------------------------------------------------
    # ln -s ~/.nix-profile/lib/xfce4/panel/plugins/libdocklike.so /usr/lib/x86_64-linux-gnu/xfce4/panel/plugins/libdocklike.so
    local src_dir="${HOME_DIR}/.nix-profile/lib/xfce4/panel/plugins"

    if [[ -d ${src_dir} ]]; then
        if [[ -d ${app_so_dir} ]]; then
            cp -u -L ${src_dir}/*.so "${app_so_dir}/"
        fi
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) nixpkg
        # local app_name="xfce.xfce4-docklike-plugin";
        # local user_type="multi";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # copy_nix-dokclike;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "docklike is not avialable on RHEL"

        # local app_name="xfce.xfce4-docklike-plugin";
        # local user_type="single";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # copy_nix-dokclike;
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