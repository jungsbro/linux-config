#!/bin/bash

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

CUR_WMDE=$(ls /usr/bin/*session);
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
        return
    fi
    # --------------------------------------------------------------------------

    local env_cmd='
# ------------------------------------------------------------------------------
if [ -e "$HOME/.nix-profile/lib/locale/locale-archive" ]; then
    export LOCALE_ARCHIVE="$HOME/.nix-profile/lib/locale/locale-archive"
fi
# ------------------------------------------------------------------------------
'
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        local env_path="${HOME_DIR}/.xprofile";

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        local env_path="${HOME_DIR}/.xsessionrc";

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        local env_path="${HOME_DIR}/.xprofile";
    fi

    if [[ -f ${env_path} ]]; then
        if [[ $(grep -i "locale-archive" ${env_path}) ]]; then
            return
        fi

        su - ${CUR_USER} -c "echo \"${env_cmd}\" >> ${env_path}";
    else
        su - ${CUR_USER} -c "echo '#!/bin/bash' > ${env_path}";
        su - ${CUR_USER} -c "echo \"${env_cmd}\" >> ${env_path}";
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^glibc-locales) ]] || pacman -S --needed --noconfirm glibc-locales;

        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg ${APP_NAME} "multi" ${CUR_USER}
        # set_locale_archive_env;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # [[ -n $(apt list --installed | grep -i ^glibc-locales) ]] || apt install -y glibc-locales;

        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
        set_locale_archive_env;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "glibcLocales is not supported for RHEL and Fedora"

        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        set_locale_archive_env;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================