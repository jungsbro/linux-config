#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/install_gnome.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/gnome
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # update -------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 확인 필요

        # 방법1) minimal
        local app_name="gnome-shell"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2) full
        # local app_name="gnome"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) tasksel
        local app_name="task-gnome-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) gnome raw
        # local app_name="gnome"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_gdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then     # wayland only
        # ----------------------------------------------------------------------
        # 방법1) ubuntu gnome minimal
        local app_name="ubuntu-desktop-minimal"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || local app_name="ubuntu-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) ubuntu gnome
        # local app_name="ubuntu-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_gdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then     # wayland only
        # ----------------------------------------------------------------------
        local app_name="@gnome-desktop"; dnf install -y "${app_name}" || true

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_gdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # # Available Environment Groups:
        #     Servier with GUI
        #     Workstation
        #     GNOME Desktop Environment

        # 방법1)
        local app_name="Server with GUI"; dnf groupinstall -y "${app_name}" || true

        # 방법2)
        # local app_name="Workstation"; dnf groupinstall -y "${app_name}" || true

        # 방법2)
        # local app_name="GNOME Desktop Environment"; dnf groupinstall -y "${app_name}" || true

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_gdm.sh;
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



