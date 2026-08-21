#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh "${CUR_USER}";
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="sxhkd"

APP_CAT="System;Utility;Development"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_sxhkd()
{
    # for x86_64, aarch64, i686
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="sxhkd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="sxhkd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="sxhkd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "sxhkd is not avialable on RHEL"
        # return 0

        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
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
    if [[ -f "${dst_sxhkdrc_path}" ]]; then
        return 0
    fi
    if [[ ! -d "${dst_sxhkdrc_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_sxhkdrc_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) copy templates to ~/.config/sxhkd
    if [[ -d "${src_sxhkdrc_dir}" ]]; then
        su - "${CUR_USER}" -c "cp -Rf ${src_sxhkdrc_dir}/* ${dst_sxhkdrc_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) copy sxhkdrc to ~/.config/sxhkd
    local src_template_dir="${src_sxhkdrc_dir}/templates";

    if [[ "${CUR_WMDE}" != *"lxsession"* ]] && [[ "${CUR_WMDE}" == *"openbox"* ]]; then
        local src_template_path="${src_template_dir}/wm_sxhkdrc";

    elif [[ "${CUR_WMDE}" == *"lxsession"* ]]; then
        local src_template_path="${src_template_dir}/lxde_sxhkdrc";

    elif [[ "${CUR_WMDE}" == *"lxqt"* ]]; then
        local src_template_path="${src_template_dir}/lxqt_sxhkdrc";

    elif [[ "${CUR_WMDE}" == *"xfce4"* ]]; then
        local src_template_path="${src_template_dir}/xfce4_sxhkdrc";

    elif [[ "${CUR_WMDE}" == *"mate"* ]]; then
        local src_template_path="${src_template_dir}/mate_sxhkdrc";

    elif [[ "${CUR_WMDE}" != *"cinnamon"* ]] && [[ "${CUR_WMDE}" == *"gnome"* ]]; then
        local src_template_path="${src_template_dir}/gnome_sxhkdrc";

    elif [[ "${CUR_WMDE}" == *"cinnamon"* ]]; then
        local src_template_path="${src_template_dir}/cinnamon_sxhkdrc";

    elif [[ "${CUR_WMDE}" == *"plasma"* ]]; then
        local src_template_path="${src_template_dir}/kde_sxhkdrc";

    else
        local src_template_path="${src_template_dir}/wm_sxhkdrc";
    fi

    if [[ -f "${src_template_path}" ]]; then
        su - "${CUR_USER}" -c "cp -f ${src_template_path} ${dst_sxhkdrc_path}"
    fi
    # --------------------------------------------------------------------------
}


function create_desktop_for_sxhkd()     # deprecated
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
    if [[ -f "${autostart_path}" ]]; then
        return 0
    fi
    if [[ ! -d "${autostart_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${autostart_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    printf '%b\n' "${sxhkd_desktop_cmd}" | sudo -u "${CUR_USER}" tee "${autostart_path}" > /dev/null
    # --------------------------------------------------------------------------
}


function set_autostart_for_sxhkd()      # deprecated
{
    if [[ "${CUR_WMDE}" == *"lxsession"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ "${CUR_WMDE}" == *"lxqt"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ "${CUR_WMDE}" == *"xfce4"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ "${CUR_WMDE}" == *"mate"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ "${CUR_WMDE}" != *"cinnamon"* ]] && [[ "${CUR_WMDE}" == *"gnome"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ "${CUR_WMDE}" == *"cinnamon"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ "${CUR_WMDE}" == *"plasma"* ]]; then
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


function set_sxhkd_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="${APP_NAME}"

    local icon_path=""

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - "${CUR_USER}" -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    # if [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
    #     return 0
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) install sxhkd
    install_sxhkd;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/sxhkd/sxhkdrc
    # 방법1)
    # bash ${CORE_BIN_DIR}/hotkey/sxhkd/create_sxhkdrc.sh "${CUR_USER}";

    # 방법2)
    copy_sxhkdrc_to_home;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) ~/.config/autostart/sxhkd.desktop
    # set_autostart_for_sxhkd;
    set_sxhkd_autostart
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
