#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/tiling/install_wmctrl.sh "${CUR_USER}"; # not used

# bash ${CORE_BIN_DIR}/tiling/install_wmctrl.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/tiling
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
# ==============================================================================


# Funcs ========================================================================
function cp_toggle_fullscreen()     # not used
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local SRC_DIR=$(dirname "$0");
    local DST_DIR="${HOME_DIR}/.local/bin";
    local SCRIPT_NAME='toggle_fullscreen.sh';

    # su - "${CUR_USER}" -c "echo \"${DST_DIR}\"";
    # su - "${CUR_USER}" -c "echo ${SRC_DIR}/${SCRIPT_NAME}";
    # su - "${CUR_USER}" -c "echo ${DST_DIR}/${SCRIPT_NAME}";

    su - "${CUR_USER}" -c "[[ -d ${DST_DIR} ]] || mkdir -p ${DST_DIR}";
    su - "${CUR_USER}" -c "[[ -f '${DST_DIR}/${SCRIPT_NAME}' ]] || cp -f ${SRC_DIR}/${SCRIPT_NAME} ${DST_DIR}/${SCRIPT_NAME}";
    su - "${CUR_USER}" -c "chmod 755 ${DST_DIR}/${SCRIPT_NAME}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="wmctrl"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xdotool"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="wmctrl"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="xdotool"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # cp_toggle_fullscreen;

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="wmctrl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xdotool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # cp_toggle_fullscreen;

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="wmctrl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xdotool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # cp_toggle_fullscreen;
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
