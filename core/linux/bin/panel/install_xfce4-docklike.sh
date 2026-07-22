#!/bin/bash

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

CUR_WMDE=$(ls /usr/bin/*session);
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
        return
    fi
    if [[ -f ${app_so_path} ]]; then
        return
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
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^${APP_NAME}) ]] || pacman -S --needed --noconfirm ${APP_NAME};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^${APP_NAME}) ]] || apt install -y ${APP_NAME};

        # APP_NAME="xfce.xfce4-docklike-plugin"
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
        # copy_nix-dokclike;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^${APP_NAME}) ]] || dnf install -y ${APP_NAME};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "docklike is not supported for RHEL"

        # APP_NAME="xfce.xfce4-docklike-plugin"
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        # copy_nix-dokclike;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================