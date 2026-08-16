#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_glibc-locales.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/fonts
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
APP_NAME="glibcLocales"
APP_CAT="System;Utility"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_locale_archive_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local kwd="locale-archive";
    # --------------------------------------------------------------------------

    local cmd='
# ------------------------------------------------------------------------------
if [ -e "$HOME/.nix-profile/lib/locale/locale-archive" ]; then
    export LOCALE_ARCHIVE="$HOME/.nix-profile/lib/locale/locale-archive"
fi
# ------------------------------------------------------------------------------
'
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${kwd}" "${cmd}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="glibc-locales"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 방법2)
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg ${APP_NAME} "multi" ${CUR_USER}
        # set_locale_archive_env;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # local app_name="glibc-locales"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 방법2)
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
        set_locale_archive_env;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "glibcLocales is not avialable on RHEL and Fedora"

        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        set_locale_archive_env;
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