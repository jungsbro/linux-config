#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/gui/install_doublecmd.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/gui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="doublecmd";

# /tmp/doublecmd
TMP_DIR="/tmp/${APP_NAME}";

# /opt/doublecmd
OPT_DIR="/opt"
APP_DIR="${OPT_DIR}/${APP_NAME}";

# https://sourceforge.net/p/doublecmd/wiki/Download/
# https://sourceforge.net/projects/doublecmd/files/Double%20Commander/v1.2.8/doublecmd-1.2.8.gtk2.x86_64.tar.xz
APP_VER="1.2.8";

APP_ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";
APP_ICON_PATH="${HOME_DIR}/.local/share/icons/${APP_NAME}.png";

APP_CAT="System;FileTools;Utility;Core;GTK;FileManager;Development"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_doublecmd_for_portable()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="x86_64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        local cur_arch="i386";

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="aarch64";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://sourceforge.net/p/doublecmd/wiki/Download/
    # https://sourceforge.net/projects/doublecmd/files/Double%20Commander/v1.2.8
    local portable_root_url="https://sourceforge.net/projects/doublecmd/files/Double%20Commander/v${APP_VER}";

    # doublecmd-1.2.8.gtk2.x86_64.tar.xz
    # doublecmd-1.2.8.gtk2.i386.tar.xz
    # doublecmd-1.2.8.gtk2.aarch64.tar.xz
    local portable_fname="doublecmd-${APP_VER}.gtk2.${cur_arch}.tar.xz";

    # https://sourceforge.net/projects/doublecmd/files/Double%20Commander/v1.2.8/doublecmd-1.2.8.gtk2.x86_64.tar.xz
    # https://sourceforge.net/projects/doublecmd/files/Double%20Commander/v1.2.8/doublecmd-1.2.8.gtk2.i386.tar.xz
    # https://sourceforge.net/projects/doublecmd/files/Double%20Commander/v1.2.8/doublecmd-1.2.8.gtk2.aarch64.tar.xz
    local portable_url="${portable_root_url}/${portable_fname}"

    # /opt/doublecmd/doublecmd
    local portable_path="${APP_DIR}/${APP_NAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";

    # local portable_url="${PORTABLE_URL}";
    # local portable_path="${PORTABLE_PATH}";

    local icon_url="${APP_ICON_URL}";
    local icon_path="${APP_ICON_PATH}";

    local app_cat="${APP_CAT}";
    local app_hidden="${APP_HIDDEN}";
    local cur_user="${CUR_USER}";

    source ${CORE_BIN_DIR}/pkgmgmt/portable/install_portable_funcs.sh && \
    install_portablepkg "${app_name}" "${portable_url}" "${portable_path}" "${icon_url}" "${icon_path}" "${app_cat}" "${app_hidden}" "${cur_user}";
    # --------------------------------------------------------------------------
}


function install_doublecmd_for_appimage()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage
        local appimage_url="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # doublecmd-gtk-latest-x86_64.AppImage
    local appimage_fname=$(basename "${appimage_url}");

    # /opt/doublecmd/doublecmd
    local appimage_path="${APP_DIR}/${appimage_fname}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";

    # local appimage_url="${APPIMAGE_URL}";
    # local appimage_path="${APPIMAGE_PATH}";

    local icon_url="${APP_ICON_URL}";
    local icon_path="${APP_ICON_PATH}";

    local app_cat="${APP_CAT}";
    local app_hidden="${APP_HIDDEN}";
    local cur_user="${CUR_USER}";

    source ${CORE_BIN_DIR}/pkgmgmt/appimage/install_appimage_funcs.sh && \
    install_appimagepkg "${app_name}" "${appimage_url}" "${appimage_path}" "${icon_url}" "${icon_path}" "${app_cat}" "${app_hidden}" "${cur_user}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) qt5
        # local app_name="doublecmd-qt5"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2) qt6
        local app_name="doublecmd-qt6"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="doublecmd-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            local app_name="doublecmd-gtk"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            # 방법1) qt5
            local app_name="doublecmd-qt"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

            # 방법2) qt6
            # local app_name="doublecmd-qt6"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            local app_name="doublecmd-gtk"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # distrobox를 사용한다.
        # echo "doublecmd is not avialable on RHEL"

        # 방법2) nix
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # 방법3)
        # if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        #     install_doublecmd_for_portable;
        # elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        #     install_doublecmd_for_portable;
        # else                        # x86_64
        #     install_doublecmd_for_portable;
        #     # install_doublecmd_for_appimage;
        # fi
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
