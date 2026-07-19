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
# function install_docklike_for_nix()
# {
#     # for x86_64 / i686 / aarch64
#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------


#     # 1) env-vars settings -----------------------------------------------------
#     local APP_NAME="xfce.xfce4-docklike-plugin"

#     local mod=${1}  # multi / single

#     if [[ *"${mod}"* == *"multi"* ]]; then
#         # multi-user
#         local nix_env_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
#     else
#         # single-user
#         local nix_env_path="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
#     fi
#     # --------------------------------------------------------------------------

#     # 2) install nix -----------------------------------------------------------
#     bash ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix.sh ${CUR_USER};
#     # --------------------------------------------------------------------------

#     # 3) install_docklike -------------------------------------------------------
#     # https://search.nixos.org/packages
#     # nix-env -iA nixpkgs.xfce.xfce4-docklike-plugin
#     # nix profile add nixpkgs#xfce.xfce4-docklike-plugin
#     su - ${CUR_USER} -c "source ${nix_env_path} && \
#     nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
#     nix profile add nixpkgs#${APP_NAME}"
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     if [[ *"${mod}"* == *"multi"* ]]; then
#         return
#     fi
#     return
#     # --------------------------------------------------------------------------

#     # 4) bins settings ---------------------------------------------------------
#     local cur_fname="";

#     local FNAME_LIST=(\
#     "docklike" \
#     )

#     local src_dir="${HOME_DIR}/.nix-profile/bin"

#     local dst_dir="${HOME_DIR}/.local/bin"
#     if [[ ! -d ${dst_dir} ]]; then
#         su - ${CUR_USER} -c "mkdir -p ${dst_dir}"
#     fi

#     for cur_fname in "${FNAME_LIST[@]}";
#     do
#         src_path="${src_dir}/${cur_fname}";
#         if [[ ! -f ${src_path} ]]; then
#             continue
#         fi

#         dst_path="${dst_dir}/${cur_fname}";
#         if [[ -f ${dst_path} ]]; then
#             continue
#         fi

#         ln -s ${src_path} ${dst_path};
#     done
#     # --------------------------------------------------------------------------

#     # 5) icon settngs ----------------------------------------------------------
#     local src_dir="${HOME_DIR}/.nix-profile/share/icons"
#     local dst_dir="/usr/share/icons"

#     if [[ -d ${src_dir} ]]; then
#         mkdir -p "${dst_dir}"
#         # -r : recursive
#         # -u : update
#         cp -ru ${src_dir}/* "${dst_dir}/"

#         gtk-update-icon-cache "${dst_dir}" 2>/dev/null
#     fi
#     # --------------------------------------------------------------------------

#     # 6) desktop settings ------------------------------------------------------
#     local src_dir="${HOME_DIR}/.nix-profile/share/applications"
#     local dst_dir="${HOME_DIR}/.local/share/applications"

#     if [[ -d ${src_dir} ]]; then
#         su - ${CUR_USER} -c "mkdir -p \"${dst_dir}\""

#         # ----------------------------------------------------------------------
#         # -u : update
#         # -L : dereference
#         cp -u -L ${src_dir}/*.desktop "${dst_dir}/"
#         chown -R ${CUR_USER}:${CUR_USER} "${dst_dir}"
#         chmod -R 744 ${dst_dir}
#         # ----------------------------------------------------------------------

#         update-desktop-database "${dst_dir}"
#     fi
#     # --------------------------------------------------------------------------
# }


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

        # install_docklike_for_nix "multi";
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

        # install_docklike_for_nix "single";
        # APP_NAME="xfce.xfce4-docklike-plugin"
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        # copy_nix-dokclike;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
