#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/office/gui/install_gridcraft.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/office/gui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="gridcraft";

# /tmp/gridcraft
TMP_DIR="/tmp/${APP_NAME}";

# /opt/gridcraft
OPT_DIR="/opt"
APP_DIR="${OPT_DIR}/${APP_NAME}";


APP_REPO_NAME="storytold/gridcraft";
# https://api.github.com/repos/storytold/gridcraft/releases/latest
API_URL="https://api.github.com/repos/${APP_REPO_NAME}/releases/latest";


# APP_ICON_URL="https://github.com/storytold/gridcraft/blob/main/assets/app-icon/hicolor/256x256/apps/ai.storyteller.gridcraft.png?raw=true";
APP_ICON_URL="https://raw.githubusercontent.com/storytold/gridcraft/refs/heads/main/assets/app-icon/hicolor/256x256/apps/ai.storyteller.gridcraft.png";
APP_ICON_PATH="${HOME_DIR}/.local/share/icons/${APP_NAME}.png";

APP_CAT="Graphics;GNOME;GTK;"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_gridcraft_for_deb()
{
    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/storytold/gridcraft/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.deb
        local cur_arch="linux-x86_64.deb";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.deb
        local cur_arch="linux-aarch64.deb";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.deb
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-riscv64.deb
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.deb

    # curl -s "https://api.github.com/repos/storytold/gridcraft/releases/latest" | jq -r '.assets[] | select(.name | test("linux-x86_64.deb")) | .browser_download_url'
    local deb_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${deb_url}"
    if [[ -z "${deb_url}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local deb_url="${DEB_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/deb/install_deb_funcs.sh && \
    install_debpkg "${app_name}" "${deb_url}";
    # --------------------------------------------------------------------------
}


function install_gridcraft_for_rpm()
{
    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/storytold/gridcraft/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.rpm
        local cur_arch="linux-x86_64.rpm";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.rpm
        local cur_arch="linux-aarch64.rpm";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.rpm
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-riscv64.rpm
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.rpm

    # curl -s "https://api.github.com/repos/storytold/gridcraft/releases/latest" | jq -r '.assets[] | select(.name | test("linux-x86_64.rpm")) | .browser_download_url'
    local rpm_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${rpm_url}"
    if [[ -z "${rpm_url}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local rpm_url="${RPM_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/rpm/install_rpm_funcs.sh && \
    install_rpmpkg "${app_name}" "${rpm_url}";
    # --------------------------------------------------------------------------
}


function install_gridcraft_for_portable()
{
    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/storytold/gridcraft/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.tar.gz
        local cur_arch="linux-x86_64.tar.gz";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.tar.gz
        local cur_arch="linux-aarch64.tar.gz";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.tar.gz
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-riscv64.tar.gz
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.tar.gz

    # curl -s "https://api.github.com/repos/storytold/gridcraft/releases/latest" | jq -r '.assets[] | select(.name | test("linux-aarch64.tar.gz")) | .browser_download_url'
    local portable_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${portable_url}"
    if [[ -z "${portable_url}" ]]; then
        return 0
    fi

    # gridcraft-0.15.0-linux-x86_64.tar.gz
    local portable_fname=$(basename "${portable_url}")
    # gridcraft-0.15.0-linux-x86_64
    local portable_name=$(basename "${portable_fname}" .tar.gz)

    # portable_path 설정시, 정확한 위치를 설정해야한다.
    # /opt/gridcraft-0.15.0-linux-x86_64/bin/gridcraft
    local portable_path="${OPT_DIR}/${portable_name}/bin/${APP_NAME}"
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


function install_gridcraft_for_flatpak()
{
    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/storytold/gridcraft/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.flatpak
        local cur_arch="linux-x86_64.flatpak";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.flatpak
        local cur_arch="linux-aarch64.flatpak";

    else
        return 0
    fi

    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.flatpak
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.flatpak

    # curl -s "https://api.github.com/repos/storytold/gridcraft/releases/latest" | jq -r '.assets[] | select(.name | test("linux-x86_64.flatpak")) | .browser_download_url'
    local flatpak_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${flatpak_url}"
    if [[ -z "${flatpak_url}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_fullname="${flatpak_url}";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}" "${cur_user}"
    # --------------------------------------------------------------------------
}


function install_gridcraft_for_appimage()
{
    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/storytold/gridcraft/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.AppImage
        local cur_arch="linux-x86_64.AppImage";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.AppImage
        local cur_arch="linux-aarch64.AppImage";

    else
        return 0
    fi

    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.AppImage
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.AppImage

    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-aarch64.AppImage.zsync
    # https://github.com/storytold/gridcraft/releases/download/v0.15.0/gridcraft-0.15.0-linux-x86_64.AppImage.zxync

    # curl -s "https://api.github.com/repos/storytold/gridcraft/releases/latest" | jq -r '.assets[] | select(.name | test("linux-x86_64.AppImage")) | .browser_download_url'
    local appimage_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\$\")) | .browser_download_url")
    # echo "${appimage_url}"
    if [[ -z "${appimage_url}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # gridcraft-gtk-latest-x86_64.AppImage
    local appimage_fname=$(basename "${appimage_url}");

    # /opt/gridcraft/gridcraft
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
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # # 방법1)
        # install_gridcraft_for_portable;

        # # 방법2)
        # install_gridcraft_for_flatpak;

        # # 방법3)
        install_gridcraft_for_appimage;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # # 방법1)
        # install_gridcraft_for_portable;

        # # 방법2)
        # install_gridcraft_for_flatpak;

        # # 방법3)
        # install_gridcraft_for_appimage;

        # # 방법4)
        install_gridcraft_for_deb;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # # 방법1)
        # install_gridcraft_for_portable;

        # # 방법2)
        # install_gridcraft_for_flatpak;

        # # 방법3)
        # install_gridcraft_for_appimage;

        # # 방법4)
        install_gridcraft_for_rpm;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # # 방법1)
        # install_gridcraft_for_portable;

        # # 방법2)
        # install_gridcraft_for_flatpak;

        # # 방법3)
        # install_gridcraft_for_appimage;

        # # 방법4)
        install_gridcraft_for_rpm;
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
