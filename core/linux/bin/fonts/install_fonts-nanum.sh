#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_fonts-nanum.sh "${CUR_USER}";
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
APP_NAME="fonts-nanum";

FONT_NAME="nanum";
FONT_URL="https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_fonts-nanum()
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
        local app_name="ttf-nanum"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="fonts-nanum"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="fonts-nanum-eco"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="fonts-nanum-extra"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-nanum;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-nanum
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