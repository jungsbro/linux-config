#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_fonts-d2coding.sh ${CUR_USER};
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
# ==============================================================================


# Funcs ========================================================================
function install_fonts-d2coding()
{
    # --------------------------------------------------------------------------
    local FONT_NAME="D2Coding"
    local FONT_URL="https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip"
    local FONT_ZIP_PATH="/tmp/${FONT_NAME}.zip";

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/TTF";
        if [[ -f "${FONT_DST_DIR}/${FONT_NAME}.ttc" ]]; then
            return 0
        fi

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/truetype/${FONT_NAME}";
        if [[ -d "${FONT_DST_DIR}" ]]; then
            return 0
        fi

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/${FONT_NAME}";
        if [[ -d "${FONT_DST_DIR}" ]]; then
            return 0
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # wget "https://github.com/naver/d2codingfont/releases/download/VER1.3.2/D2Coding-Ver1.3.2-20180524.zip" -O "/tmp/D2Coding.zip"
    wget ${FONT_URL} -O ${FONT_ZIP_PATH}

    # sudo unzip /tmp/D2Coding.zip -d /usr/share/fonts/D2Coding
    sudo unzip ${FONT_ZIP_PATH} -d ${FONT_DST_DIR}
    rm -f ${FONT_ZIP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    fc-cache -fv
    # fc-list | grep -i "d2coding"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1) D2Coding
        local app_name="ttf-d2coding"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2) Nerd Fonts
        # local app_name="ttf-d2coding-nerd"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-d2coding;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-d2coding;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-d2coding;
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