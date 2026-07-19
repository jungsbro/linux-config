#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_font-manager.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/fonts
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
APP_NAME="font-manager"

APP_UNIQUE_NAME="org.gnome.FontManager"
NIX_UNIQUE_NAME="com.github.FontManager.FontManager"

APP_CAT="Utility;GTK;GNOME;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
# function install_font-manager_for_nix()
# {
#     # for x86_64 / i686 / aarch64
#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     # 1) env-vars settings -----------------------------------------------------
#     local APP_NAME="font-manager"

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

#     # 3) install_font-manager --------------------------------------------------
#     # https://search.nixos.org/packages
#     # nix-env -iA nixpkgs.font-manager
#     # nix profile add nixpkgs#font-manager
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
#     "font-manager" \
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
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^font-manager) ]] || pacman -S --needed --noconfirm font-manager;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^font-manager) ]] || apt install -y font-manager;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "font-manager is not supported for RHEL and Fedora"

        # install_font-manager_for_nix "single";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
