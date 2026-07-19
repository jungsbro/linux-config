#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/hotkey/sxhkd
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

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="sxhkd"
APP_CAT="System;Utility;Development"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
# function install_sxhkd_for_nix()
# {
#     # for x86_64 / i686 / aarch64
#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     # 1) env-vars_settings -----------------------------------------------------
#     local APP_NAME="sxhkd"

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

#     # 3) install_sxhkd -------------------------------------------------------
#     # https://search.nixos.org/packages
#     # nix-env -iA nixpkgs.sxhkd
#     # nix profile add nixpkgs#sxhkd
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
#     local cur_fname=""

#     local FNAME_LIST=(\
#     "sxhkd" \
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

#     # 7) etc -------------------------------------------------------------------
#     # ~/.nix-profile/share/sxhkd
#     # --------------------------------------------------------------------------
# }


function install_sxhkd()
{
    # for x86_64, aarch64, i686
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^sxhkd) ]] || pacman -S --needed --noconfirm sxhkd;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^sxhkd) ]] || apt install -y sxhkd;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^sxhkd) ]] || dnf install -y sxhkd;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "sxhkd is not supported for RHEL"
        # return 0

        # install_sxhkd_for_nix "single";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        # ----------------------------------------------------------------------
    fi
}


function copy_sxhkdrc_to_home()
{
    # --------------------------------------------------------------------------
    local src_sxhkdrc_dir="${CUR_DIR}/config";
    local src_sxhkdrc_path="${src_sxhkdrc_dir}/sxhkdrc";

    local dst_sxhkdrc_dir="${HOME_DIR}/.config/sxhkd";
    local dst_sxhkdrc_path="${dst_sxhkdrc_dir}/sxhkdrc";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f ${dst_sxhkdrc_path} ]]; then
        return
    fi
    if [[ ! -d ${dst_sxhkdrc_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_sxhkdrc_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) copy templates to ~/.config/sxhkd
    if [[ -d ${src_sxhkdrc_dir} ]]; then
        su - ${CUR_USER} -c "cp -rf ${src_sxhkdrc_dir}/* ${dst_sxhkdrc_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) copy sxhkdrc to ~/.config/sxhkd
    local src_template_dir="${src_sxhkdrc_dir}/templates";

    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        local src_template_path="${src_template_dir}/lxde_sxhkdrc";

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        local src_template_path="${src_template_dir}/lxqt_sxhkdrc";

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        local src_template_path="${src_template_dir}/xfce4_sxhkdrc";

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        local src_template_path="${src_template_dir}/mate_sxhkdrc";

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        local src_template_path="${src_template_dir}/gnome_sxhkdrc";

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        local src_template_path="${src_template_dir}/cinnamon_sxhkdrc";

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        local src_template_path="${src_template_dir}/kde_sxhkdrc";

    else
        local src_template_path="${src_template_dir}/wm_sxhkdrc";
    fi

    if [[ -f ${src_template_path} ]]; then
        su - ${CUR_USER} -c "cp -f ${src_template_path} ${dst_sxhkdrc_path}"
    fi
    # --------------------------------------------------------------------------
}


function create_desktop_for_sxhkd()
{
    local autostart_dir="${HOME_DIR}/.config/autostart";
    local autostart_path="${autostart_dir}/sxhkd.desktop";
    local sxhkd_desktop_cmd="[Desktop Entry]
Exec=sxhkd
Name=sxhkd
Type=Application
Version=1.0
X-LXQt-X11-Only=true
"

    # --------------------------------------------------------------------------
    if [[ -f ${autostart_path} ]]; then
        return
    fi
    if [[ ! -d ${autostart_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${autostart_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    printf '%b\n' "${sxhkd_desktop_cmd}" | sudo -u ${CUR_USER} tee ${autostart_path} > /dev/null
    # --------------------------------------------------------------------------
}


function set_autostart_for_sxhkd()
{
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        create_desktop_for_sxhkd;
    fi

    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        echo ""
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        echo ""
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        echo ""
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    # if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) install sxhkd
    install_sxhkd;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/sxhkd/sxhkdrc
    # 방법1)
    # bash ${CORE_BIN_DIR}/hotkey/sxhkd/create_sxhkdrc.sh ${CUR_USER};

    # 방법2)
    copy_sxhkdrc_to_home;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) ~/.config/autostart/sxhkd.desktop
    set_autostart_for_sxhkd;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

