#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_fonts-nanum.sh ${CUR_USER};
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
# ==============================================================================


# Funcs ========================================================================
function install_fonts-nanum()
{
    # --------------------------------------------------------------------------
    # local FONT_URL="https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-all_new.zip"

    # NanumGothicCoding
    local FONT_NAME="nanum"
    local FONT_URL="https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip"
    local FONT_ZIP_PATH="/tmp/${FONT_NAME}.zip";

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/TTF";
        if [[ -f "${FONT_DST_DIR}/${FONT_NAME}Gothic.ttf" ]]; then
            return
        fi

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/truetype/${FONT_NAME}";
        if [[ -d "${FONT_DST_DIR}" ]]; then
            return
        fi

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/${FONT_NAME}";
        if [[ -d "${FONT_DST_DIR}" ]]; then
            return
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # wget "https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip" -O "/tmp/nanum.zip"
    wget ${FONT_URL} -O ${FONT_ZIP_PATH}

    # sudo unzip /tmp/nanum.zip -d /usr/share/fonts/nanum
    sudo unzip ${FONT_ZIP_PATH} -d ${FONT_DST_DIR}
    rm -f ${FONT_ZIP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    fc-cache -fv
    # fc-list | grep -i "nanum"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^ttf-nanum) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm ttf-nanum";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # install_fonts-nanum;
        [[ -n $(apt list --installed | grep -i ^fonts-nanum) ]] || apt install -y fonts-nanum*;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-nanum;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-nanum;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
