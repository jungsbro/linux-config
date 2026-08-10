#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/remote/gui/xrdp
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

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
PROTOCOL="tcp";

PORT="3389";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================

# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^xrdp) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm xrdp";
        [[ -n $(yay -Q | grep -i ^xorgxrdp) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm xorgxrdp";
        # [[ -n $(pacman -Q | grep -i ^xrdp) ]] || pacman -S --needed --noconfirm xrdp;
        # [[ -n $(pacman -Q | grep -i ^xorgxrdp) ]] || pacman -S --needed --noconfirm xorgxrdp;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^xrdp) ]] || apt install -y xrdp;
        [[ -n $(apt list --installed | grep -i ^xorgxrdp) ]] || apt install -y xorgxrdp;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^xrdp) ]] || dnf install -y xrdp;
        [[ -n $(dnf list --installed | grep -i ^xorgxrdp) ]] || dnf install -y xorgxrdp;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^xrdp) ]] || dnf install -y xrdp;
        [[ -n $(dnf list --installed | grep -i ^xorgxrdp) ]] || dnf install -y xorgxrdp;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # alow xrdp-port
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_firewall "${PROTOCOL}" "${PORT}";

    # restart xrdp
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv xrdp && restart_sv xrdp;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fix xrdp-settings for wm

    # /usr/libexec/xrdp/startwm-bash.sh
    # source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && fix_startwm_for_xsession;

    # ~/.xsession, ~/.Xclients
    # source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "${APP_NAME}" "${CUR_USER}"
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================


