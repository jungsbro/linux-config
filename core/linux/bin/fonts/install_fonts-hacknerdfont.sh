#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh ${CUR_USER};
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
function install_fonts-hacknerdfont()
{
    if [[ -n $(fc-list |grep -i hacknerdfont) ]]; then
        return 0
    fi

    # --------------------------------------------------------------------------
    local FONT_NAME="HackNerdFont"
    local FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"
    local FONT_ZIP_PATH="/tmp/${FONT_NAME}.zip";

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/TTF";
        if [[ -f "${FONT_DST_DIR}/${FONT_NAME}-Regular.ttf" ]]; then
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
    # wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip" -O "/tmp/HackNerdFont.zip"
    wget ${FONT_URL} -O ${FONT_ZIP_PATH}

    # sudo unzip /tmp/HackNerdFont.zip -d /usr/share/fonts/HackNerdFont
    sudo unzip ${FONT_ZIP_PATH} -d ${FONT_DST_DIR}
    rm -f ${FONT_ZIP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    fc-cache -fv
    # fc-list | grep -i "hacknerdfont"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(pacman -Q | grep -i ^ttf-hack-nerd) ]] || pacman -S --needed --noconfirm ttf-hack-nerd;
        # [[ -n $(yay -Q | grep -i ^ttf-hack-nerd) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm ttf-hack-nerd";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # dnf copr enable lyessaadi/nerd-fonts
        # [[ -n $(dnf list installed | grep -i ^font-hack-nerd) ]] || dnf install -y font-hack-nerd;

        # 방법2)
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================