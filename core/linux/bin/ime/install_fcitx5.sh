#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="fcitx5"

# org.fcitx.Fcitx5
APP_FULLNAME="org.fcitx.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_fcitx5_env()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
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
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="${APP_NAME}"

    # local icon_path="/usr/share/icons/hicolor/128x128/apps/${APP_FULLNAME}.png"
    local icon_path="${APP_FULLNAME}"

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
    # for cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="fcitx5"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
            local app_name="fcitx5-hangul"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
            local app_name="fcitx5-configtool"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
            local app_name="fcitx5-qt"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        else
            local app_name="fcitx5"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
            local app_name="fcitx5-hangul"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
            local app_name="fcitx5-configtool"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
            local app_name="fcitx5-gtk"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        fi

        # 방법2)
        # local app_name="fcitx5-gtk"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # local app_name="fcitx5"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="fcitx5-hangul"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="fcitx5-configtool"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="fcitx5-config-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2)
        # local app_name="fcitx5-frontend-gtk3"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="fcitx5-frontend-qt5"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="libfcitx5utils2"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법3)
        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            local app_name="fcitx5"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-hangul"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-config-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-frontend-qt5"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-frontend-qt6"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-module-dbus"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            local app_name="fcitx5"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-hangul"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-config-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-frontend-gtk2"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-frontend-gtk3"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-frontend-gtk4"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="fcitx5-module-dbus"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="fcitx5"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="fcitx5-hangul"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="fcitx5-configtool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="fcitx5-autostart"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "fcitx5 is not avialable on RHEL"
        return 0
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    set_fcitx5_env

    set_fcitx5_autostart;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================