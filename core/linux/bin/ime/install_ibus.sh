#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_ibus.sh ${CUR_USER};
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
APP_NAME="ibus"

# com.github.ibus.ibus
APP_UNIQUE_NAME="com.github.ibus.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_ibus_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    local cmd='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
# ------------------------------------------------------------------------------
'
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${APP_NAME}" "${cmd}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function set_ibus_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="sh -c 'ibus-daemon -drx'"

    # local icon_path="/usr/share/icons/hicolor/scalable/apps/${APP_NAME}.png"
    local icon_path="${APP_NAME}"

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # for gnome, cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^ibus) ]] || pacman -S --needed --noconfirm ibus ibus-hangul;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ibus) ]] || apt install -y ibus ibus-hangul;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ibus-hangul has a problem when using google-docs
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^ibus) ]] || dnf install -y ibus ibus-hangul;
        # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
        #     [[ -n $(dnf list --installed | grep -i ^im-chooser) ]] || dnf install -y im-chooser;
        # fi
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    set_ibus_env

    set_ibus_autostart;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================