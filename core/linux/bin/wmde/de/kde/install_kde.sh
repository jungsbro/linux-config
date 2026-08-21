#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/kde/install_kde.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/kde
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
        local app_name="plasma-desktop"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2) full
        # local app_name="plasma"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) tasksel
        local app_name="task-kde-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) kde raw (minimal)
        # local app_name="kde-plasma-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법3) kde raw (standard)
        # local app_name="kde-standard"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법3) kde raw (full)
        # local app_name="kde-full"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_sddm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then     # wayland only
        # ----------------------------------------------------------------------
        # ubuntu kde
        local app_name="kubuntu-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_sddm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="@kde-desktop"; dnf install -y "${app_name}" || true
        local app_name="plasma-workspace-x11"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2)
        # ID                   Name Installed
        # kde-desktop          KDE         no
        # local app_name="kde-desktop"; dnf groupinstall -y "${app_name}" || true

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_sddm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # Available Environment Groups:
        #   KDE (K Desktop Environment)
        #   KDE Plasma Workspaces

        # 방법1) minimal
        # local app_name="KDE (K Desktop Environment)"; dnf groupinstall -y "${app_name}" || true

        # 방법2) full
        local app_name="KDE Plasma Workspaces"; dnf groupinstall -y "${app_name}" || true

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_sddm.sh;
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