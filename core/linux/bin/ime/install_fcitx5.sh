#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime
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
APP_NAME="fcitx5"

# org.fcitx.Fcitx5
APP_UNIQUE_NAME="org.fcitx.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_fcitx5_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    local cmd='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
# ------------------------------------------------------------------------------
'
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${APP_NAME}" "${cmd}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function set_fcitx5_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="${APP_NAME}"

    # local icon_path="/usr/share/icons/hicolor/128x128/apps/${APP_UNIQUE_NAME}.png"
    local icon_path="${APP_UNIQUE_NAME}"

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm \
            fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-qt;
        else
            [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm \
            fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-gtk;
        fi

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm fcitx5-gtk;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y --install-recommends \
        # fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-config-qt ;

        # 방법2)
        # [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y \
        # fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2;

        # 방법3)
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y \
            fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-qt* fcitx5-module-dbus;
        else
            [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y \
            fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-gtk* fcitx5-module-dbus;
        fi

        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^fcitx5) ]] || dnf install -y fcitx5 \
        fcitx5-hangul fcitx5-configtool fcitx5-autostart ;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "fcitx5 is not supported for RHEL"
        exit 0
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    set_fcitx5_env

    set_fcitx5_autostart;
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================