#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
FONT_NAME="HackNerdFont";

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_fonts-hacknerdfont()
{
    # --------------------------------------------------------------------------
    local font_name="${FONT_NAME}";
    local font_url="${FONT_URL}";

    source ${CORE_BIN_DIR}/fonts/install_fonts_funcs.sh && install_fonts_with_curl "${font_name}" "${font_url}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        local app_name="ttf-hack-nerd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2)
        # local app_name="ttf-hack-nerd"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # dnf copr enable lyessaadi/nerd-fonts
        # local app_name="font-hack-nerd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2)
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
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