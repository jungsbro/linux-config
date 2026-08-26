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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="google-chrome";

# /tmp/google-chrome
TMP_DIR="/tmp/${NAME}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function fix_exec_cmd()
{
    local GC_DESKTOP_PATH="/usr/share/applications/google-chrome.desktop"
    local GC_DESKTOP_PATH2="/usr/share/applications/google-chrome.desktop2"

    # --------------------------------------------------------------------------
    # /usr/share/applications/google-chrome.desktop
    if [[ ! -f "${GC_DESKTOP_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local GC_DESKTOP_CMDS=$(cat "${GC_DESKTOP_PATH}");

    local SRC_STR="google-chrome-stable"

    local PW_STORE="--password-store=basic";

    # google-chrome-stable --password-store=basic
    local DST_STR="${SRC_STR} ${PW_STORE}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${GC_DESKTOP_CMDS}" == *"${PW_STORE}"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    sed "s/${SRC_STR}/${DST_STR}/g" "${GC_DESKTOP_PATH}" > "${GC_DESKTOP_PATH2}";
    mv -f "${GC_DESKTOP_PATH2}" "${GC_DESKTOP_PATH}";
    # --------------------------------------------------------------------------
}

function install_google-chrome()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi

    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi

    if [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ -n $(apt list --installed | grep -i ^google-chrome) ]]; then
            return 0
        fi
        # ----------------------------------------------------------------------
    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        if [[ -n $(dnf list --installed | grep -i ^google-chrome) ]]; then
            return 0
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="google-chrome-stable_current_amd64.deb";
        # ----------------------------------------------------------------------
        # "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        local URL="https://dl.google.com/linux/direct/${FNAME}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="google-chrome-stable_current_x86_64.rpm";
        # ----------------------------------------------------------------------
        # "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
        local URL="https://dl.google.com/linux/direct/${FNAME}";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -d "${TMP_DIR}" ]]; then
        # /tmp/google-chrome
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
    fi
    if [[ ! -f "${TMP_DIR}/${FNAME}" ]]; then
        # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
        # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
        wget "${URL}" -O "${TMP_DIR}/${FNAME}";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
        apt install -y "${TMP_DIR}/${FNAME}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
        dnf install -y "${TMP_DIR}/${FNAME}";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    fix_exec_cmd;
}


function install_google-chrome_for_apt()    # not used
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^google-chrome) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local FNAME="google-chrome-stable_current_amd64.deb";

    # "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    local URL="https://dl.google.com/linux/direct/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/google-chrome
    if [[ ! -d "${TMP_DIR}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
        wget "${URL}" -O "${TMP_DIR}/${FNAME}";
        # ----------------------------------------------------------------------
    fi

    # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
    apt install -y "${TMP_DIR}/${FNAME}";
    # --------------------------------------------------------------------------
}


function install_google-chrome_for_dnf()    # not used
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0
    fi
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(dnf list --installed | grep -i ^google-chrome) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local FNAME="google-chrome-stable_current_x86_64.rpm";

    # "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    local URL="https://dl.google.com/linux/direct/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/google-chrome
    if [[ ! -d "${TMP_DIR}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
        wget "${URL}" -O "${TMP_DIR}/${FNAME}";
        # ----------------------------------------------------------------------
    fi

    # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
    dnf install -y "${TMP_DIR}/${FNAME}";
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
        install_google-chrome;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_google-chrome;
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
