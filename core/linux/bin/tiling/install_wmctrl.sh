#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/tiling/install_wmctrl.sh ${CUR_USER}; # not used

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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function cp_toggle_fullscreen()     # not used
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local SRC_DIR=$(dirname "$0");
    local DST_DIR="${HOME_DIR}/.local/bin";
    local SCRIPT_NAME='toggle_fullscreen.sh';

    # su - ${CUR_USER} -c "echo \"${DST_DIR}\"";
    # su - ${CUR_USER} -c "echo ${SRC_DIR}/${SCRIPT_NAME}";
    # su - ${CUR_USER} -c "echo ${DST_DIR}/${SCRIPT_NAME}";

    su - ${CUR_USER} -c "[[ -d ${DST_DIR} ]] || mkdir -p ${DST_DIR}";
    su - ${CUR_USER} -c "[[ -f '${DST_DIR}/${SCRIPT_NAME}' ]] || cp -f ${SRC_DIR}/${SCRIPT_NAME} ${DST_DIR}/${SCRIPT_NAME}";
    su - ${CUR_USER} -c "chmod 755 ${DST_DIR}/${SCRIPT_NAME}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^wmctrl) ]] || pacman -S --needed --noconfirm wmctrl;
        [[ -n $(pacman -Q | grep -i ^xdotool) ]] || pacman -S --needed --noconfirm xdotool;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^wmctrl) ]] || apt install -y wmctrl;
        [[ -n $(apt list --installed | grep -i ^xdotool) ]] || apt install -y xdotool;
        # ----------------------------------------------------------------------
        # cp_toggle_fullscreen;

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^wmctrl) ]] || dnf install -y wmctrl;
        [[ -n $(dnf list --installed | grep -i ^xdotool) ]] || dnf install -y xdotool;
        # ----------------------------------------------------------------------
        # cp_toggle_fullscreen;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^wmctrl) ]] || dnf install -y wmctrl;
        [[ -n $(dnf list --installed | grep -i ^xdotool) ]] || dnf install -y xdotool;
        # ----------------------------------------------------------------------
        # cp_toggle_fullscreen;
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================