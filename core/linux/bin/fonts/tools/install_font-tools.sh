#!/bin/bash
set -e

# usage ========================================================================
# fontconfig, fonts-d2coding, fonts-hacknerdfont, fonts-nanum, locales, fonts-emoji, gnome-characters
# bash ${CORE_BIN_DIR}/fonts/tools/install_font-tools.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/fonts/tools
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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

# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/fonts/cli/install_fontconfig.sh
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-d2coding.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-hacknerdfont.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-nanum.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/fonts/cli/locale/install_locales.sh;
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-emoji.sh;
    bash ${CORE_BIN_DIR}/fonts/gui/install_gnome-characters.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================