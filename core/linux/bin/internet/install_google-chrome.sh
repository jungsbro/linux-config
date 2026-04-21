#!/bin/bash

# google-chrome ================================================================
# bash ${CORE_BIN_DIR}/internet/install_google-chrome.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/internet
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="google-chrome";

# /tmp/google-chrome
TMP_DIR="/tmp/${NAME}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64 ================================================================
function fix_exec_cmd()
{
    local GC_DESKTOP_PATH="/usr/share/applications/google-chrome.desktop"
    local GC_DESKTOP_PATH2="/usr/share/applications/google-chrome.desktop2"

    # --------------------------------------------------------------------------
    # /usr/share/applications/google-chrome.desktop
    if [[ ! -f ${GC_DESKTOP_PATH} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local GC_DESKTOP_CMDS=$(cat ${GC_DESKTOP_PATH});

    local SRC_STR="google-chrome-stable"

    local PW_STORE="--password-store=basic";

    # google-chrome-stable --password-store=basic
    local DST_STR="${SRC_STR} ${PW_STORE}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${GC_DESKTOP_CMDS}"* == *"${PW_STORE}"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    sed "s/${SRC_STR}/${DST_STR}/g" ${GC_DESKTOP_PATH} > ${GC_DESKTOP_PATH2};
    mv -f ${GC_DESKTOP_PATH2} ${GC_DESKTOP_PATH}
    # --------------------------------------------------------------------------
}

function install_google-chrome()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi

    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ -n $(apt list --installed | grep -i ^google-chrome) ]]; then
            return
        fi
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ -n $(dnf list --installed | grep -i ^google-chrome) ]]; then
            return
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="google-chrome-stable_current_amd64.deb";
        # ----------------------------------------------------------------------
        # "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        local URL="https://dl.google.com/linux/direct/${FNAME}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="google-chrome-stable_current_x86_64.rpm";
        # ----------------------------------------------------------------------
        # "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
        local URL="https://dl.google.com/linux/direct/${FNAME}";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -d ${TMP_DIR} ]]; then
        # /tmp/google-chrome
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi
    if [[ ! -f ${TMP_DIR}/${FNAME} ]]; then
        # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
        # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
        wget ${URL} -O ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
        apt install -y ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
        dnf install -y ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    fix_exec_cmd;
}


function install_google-chrome_for_apt()    # not used
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^google-chrome) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local FNAME="google-chrome-stable_current_amd64.deb";

    # "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    local URL="https://dl.google.com/linux/direct/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/google-chrome
    if [[ ! -d ${TMP_DIR} ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
        wget ${URL} -O ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------
    fi

    # /tmp/google-chrome/google-chrome-stable_current_amd64.deb
    apt install -y ${TMP_DIR}/${FNAME};
    # --------------------------------------------------------------------------
}


function install_google-chrome_for_dnf()    # not used
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(dnf list --installed | grep -i ^google-chrome) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local FNAME="google-chrome-stable_current_x86_64.rpm";

    # "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    local URL="https://dl.google.com/linux/direct/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/google-chrome
    if [[ ! -d ${TMP_DIR} ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
        wget ${URL} -O ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------
    fi

    # /tmp/google-chrome/google-chrome-stable_current_x86_64.rpm
    dnf install -y ${TMP_DIR}/${FNAME};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^google-chrome) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm google-chrome";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_google-chrome;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_google-chrome;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

