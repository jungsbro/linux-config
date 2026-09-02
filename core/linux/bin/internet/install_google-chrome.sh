#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/internet/install_google-chrome.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/internet
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

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
APP_NAME="google-chrome";

# /tmp/google-chrome
TMP_DIR="/tmp/${APP_NAME}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function fix_exec_cmd()
{
    local gc_desktop_path="/usr/share/applications/google-chrome.desktop"
    local gc_desktop_path2="/usr/share/applications/google-chrome.desktop2"

    # --------------------------------------------------------------------------
    # /usr/share/applications/google-chrome.desktop
    if [[ ! -f "${gc_desktop_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local gc_desktop_cmds=$(cat "${gc_desktop_path}");

    local src_str="google-chrome-stable"

    local pw_store="--password-store=basic";

    # google-chrome-stable --password-store=basic
    local dst_str="${src_str} ${pw_store}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${gc_desktop_cmds}" == *"${pw_store}"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    sed "s/${src_str}/${dst_str}/g" "${gc_desktop_path}" > "${gc_desktop_path2}";
    mv -f "${gc_desktop_path2}" "${gc_desktop_path}";
    # --------------------------------------------------------------------------
}


function install_google-chrome_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="amd64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # google-chrome-stable_current_amd64.deb
    local deb_fname="google-chrome-stable_current_${cur_arch}.deb";

    # "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    local deb_url="https://dl.google.com/linux/direct/${deb_fname}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local deb_url="${DEB_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/deb/install_deb_funcs.sh && \
    install_debpkg "${app_name}" "${deb_url}";
    # --------------------------------------------------------------------------
}


function install_google-chrome_for_rpm()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="amd64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # google-chrome-stable_current_x86_64.rpm
    local rpm_fname="google-chrome-stable_current_x86_64.rpm";

    # "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    local rpm_url="https://dl.google.com/linux/direct/${rpm_fname}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local rpm_url="${RPM_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/rpm/install_rpm_funcs.sh && \
    install_rpmpkg "${app_name}" "${rpm_url}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="google-chrome"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_google-chrome_for_deb;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_google-chrome_for_rpm;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    fix_exec_cmd;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
