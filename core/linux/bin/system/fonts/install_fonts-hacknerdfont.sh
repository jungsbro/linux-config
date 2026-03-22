#!/bin/bash

# korean =======================================================================
# bash ${BIN_DIR}/system/fonts/install_fonts-hacknerdfont.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/fonts
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function install_fonts-hacknerdfont()
{
    # --------------------------------------------------------------------------
    local FONT_NAME="HackNerdFont"
    local FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"
    local FONT_ZIP_PATH="/tmp/${FONT_NAME}.zip";

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/truetype/${FONT_NAME}";
        if [[ -d "${FONT_DST_DIR}" ]]; then
            return
        fi

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/${FONT_NAME}";
        if [[ -d "${FONT_DST_DIR}" ]]; then
            return
        fi

    elif [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        local FONT_DST_DIR="/usr/share/fonts/TTF";
        if [[ -f "${FONT_DST_DIR}/${FONT_NAME}-Regular.ttf" ]]; then
            return
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

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        dnf copr enable lyessaadi/nerd-fonts
        [[ -n $(dnf list installed | grep -i ^font-hack-nerd) ]] || dnf install -y font-hack-nerd;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(pacman -Q | grep -i ^ttf-hack-nerd) ]] || pacman -S --noconfirm ttf-hack-nerd;
        # [[ -n $(yay -Q | grep -i ^ttf-hack-nerd) ]] || su - ${CUR_USER} -c "yay -S --noconfirm ttf-hack-nerd";
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
