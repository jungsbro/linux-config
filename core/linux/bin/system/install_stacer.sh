#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_stacer.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
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
APP_NAME="stacer"

# stacer
APP_UNIQUE_NAME="${APP_NAME}"

APP_CAT="Utility;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # [[ -n $(yay -Q | grep -i ^stacer-git) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm stacer-git";
        [[ -n $(yay -Q | grep -i ^stacer-bin) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm stacer-bin";
        # [[ -n $(yay -Q | grep -i ^stacer) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm stacer";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        echo "stacer is not supported for Debian13+"

        # [[ -n $(apt list --installed | grep -i ^stacer) ]] || apt install -y stacer;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^stacer) ]] || apt install -y stacer;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        echo "stacer is not supported for RHEL and Fedora"

        # "stacer for nix" has error
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
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