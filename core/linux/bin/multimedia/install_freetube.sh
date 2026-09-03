#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/multimedia/install_freetube.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/multimedia
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="freetube";

# freetube
APP_FULLNAME="io.freetubeapp.FreeTube"

# /tmp/freetube
TMP_DIR="/tmp/${APP_NAME}";

# /opt/freetube
APP_DIR="/opt/${APP_NAME}";

APP_VER="0.25.3"

# https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta-linux-amd64-portable.zip
# https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta-amd64.AppImage
APP_ROOT_URL="https://github.com/FreeTubeApp/FreeTube/releases/download"

APP_ICON_URL="https://freetubeapp.io/images/iconWhite.png";
APP_ICON_PATH="${HOME_DIR}/.local/share/icons/${APP_NAME}.png";

APP_CAT="AudioVideo;Player"

APP_HIDDEN="false";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_freetube_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="amd64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="arm64";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # freetube_0.25.3_beta_amd64.deb
    # freetube_0.25.3_beta_arm64.deb
    local deb_fname="${APP_NAME}_${APP_VER}_beta_${cur_arch}.deb";

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube_0.25.3_beta_amd64.deb
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube_0.25.3_beta_arm64.deb
    local deb_url="${APP_ROOT_URL}/v${APP_VER}-beta/${deb_fname}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local deb_url="${DEB_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/deb/install_deb_funcs.sh && \
    install_debpkg "${app_name}" "${deb_url}";
    # --------------------------------------------------------------------------
}


function install_freetube_for_rpm()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="amd64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="arm64";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # freetube-0.25.3-beta.amd64.rpm
    # freetube-0.25.3-beta.arm64.rpm
    local rpm_fname="${APP_NAME}-${APP_VER}-beta.${cur_arch}.rpm";

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta.amd64.rpm
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta.arm64.rpm
    local rpm_url="${APP_ROOT_URL}/v${APP_VER}-beta/${rpm_fname}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local rpm_url="${RPM_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/rpm/install_rpm_funcs.sh && \
    install_rpmpkg "${app_name}" "${rpm_url}";
    # --------------------------------------------------------------------------
}


function install_freetube_for_portable()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="x64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="arm64";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # freetube-0.25.3-beta-linux-x64-portable.zip
    # freetube-0.25.3-beta-linux-arm64-portable.zip
    local portable_fname="${APP_NAME}-${APP_VER}-beta-linux-${cur_arch}-portable.zip";

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta-linux-x64-portable.zip
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta-linux-arm64-portable.zip
    local portable_url="${APP_ROOT_URL}/v${APP_VER}-beta/${portable_fname}";

    # /opt/freetube/freetube
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


function install_freetube_for_appimage()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="amd64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="arm64";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta-amd64.AppImage
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta-arm64.AppImage
    local appimage_url="${APP_ROOT_URL}/v${APP_VER}-beta/${APP_NAME}-${APP_VER}-beta-${cur_arch}.AppImage";

    # freetube-0.25.3-amd64.AppImage
    # freetube-0.25.3-arm64.AppImage
    local appimage_fname=$(basename "${appimage_url}");

    # /opt/freetube/freetube-0.25.3-amd64.AppImage
    # /opt/freetube/freetubee-0.25.3-arm64.AppImage
    local appimage_path="${APP_DIR}/${appimage_fname}";
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
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        # local app_name="freetube"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2)
        local app_name="freetube-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법3)
        # local app_name="freetube-git"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then  # i686
            echo "freetube-i686 is not avialable on Debian/Ubuntu"
            # local app_name="${APP_NAME}";
            # local user_type="multi";
            # local cur_user="${CUR_USER}";
            # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        else                                        # x86_64, aarch64
            install_freetube_for_deb;
        fi

        # 방법2)
        # local app_fullname="${APP_FULLNAME}";
        # source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}"

        # 방법3)
        # install_freetube_for_portable;

        # 방법4)
        # install_freetube_for_appimage;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then  # i686
            echo "freetube-i686 is not avialable on RHEL"
            # local app_name="${APP_NAME}";
            # local user_type="single";
            # local cur_user="${CUR_USER}";
            # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        else                                        # x86_64, aarch64
            install_freetube_for_rpm;
        fi
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================