#!/bin/bash
set -e

# usage ========================================================================
# nixpkg 사용사, locale 문제가 있을때 사용한다.(nixpkg rofi를 사용할때 필수)

# bash ${CORE_BIN_DIR}/fonts/locale/install_locales_for_nix.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/fonts/locale
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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
APP_NAME="glibcLocales"

APP_CAT="System;Utility"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_locale-archive_env()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
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
        local app_name="${APP_NAME}";
        local user_type="multi";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}";
        local user_type="multi";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "glibcLocales is not avialable on RHEL and Fedora"
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    set_locale-archive_env;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================