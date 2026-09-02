#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/panel/install_plank.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="plank"

APP_CAT="Utility"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_plank_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local AUTOSTART_DIR="${HOME_DIR}/.config/autostart"
    local AUTOSTART_PATH="${AUTOSTART_DIR}/plank.desktop"

    local AUTOSTART_CMD="[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=plank
Comment=Dock
Exec=plank
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - "${CUR_USER}" -c "[[ -d ${AUTOSTART_DIR} ]] || mkdir -p ${AUTOSTART_DIR}";
    su - "${CUR_USER}" -c "[[ -f ${AUTOSTART_PATH} ]] || echo \"${AUTOSTART_CMD}\" > ${AUTOSTART_PATH}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # set_plank_autostart;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) distrobox를 사용한다.
        # echo "plank is not avialable on RHEL"

        # 방법2) nixpkg
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # set_plank_autostart;
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