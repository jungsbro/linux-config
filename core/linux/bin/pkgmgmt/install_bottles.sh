#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/pkgmgmt/install_bottles.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt
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
APP_NAME="bottles"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_bottles_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.local/share/applications/KakaoTalk.desktop
    [[ -n $(flatpak list --app | grep -i bottles) ]] || flatpak install -y flathub com.usebottles.bottles;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        local app_name="${APP_NAME}"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2)
        # local app_name="bottles-git"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then    # x86_64
            install_bottles_for_flatpak;

        elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then # aarch64
            echo "bottles-aarch64 is not avialable on Debian"

            # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
            # install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
        else                                            # i868
            echo "bottles-i686 is not avialable on Debian"
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then    # x86_64
            install_bottles_for_flatpak;

        elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then # aarch64
            echo "bottles-aarch64 is not avialable on RHEL"

            # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
            # install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        else                                            # i868
            echo "bottles-i686 is not avialable on RHEL"
        fi
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