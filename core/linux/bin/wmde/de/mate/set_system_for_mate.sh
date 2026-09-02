#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/mate/set_system_for_mate.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/mate
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh

# set_attr_value "${attr_path}" "${attr_name}" "${val}";
# set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_window-movement()
{
    # --------------------------------------------------------------------------
# settings >> Look and Feel >> Windows >> Behavior >> Special key to move and resize windows:<Super>

# 추가
# settings >> Look and Feel >> Windows >> Behaviour >> Movement Key
# /org/mate/marco/general/mouse-button-modifier
# '<Super>'

gsettings set "org.mate.Marco.general" "mouse-button-modifier" '<Super>';
    # --------------------------------------------------------------------------
}


function set_terminal()
{
    # --------------------------------------------------------------------------
    # mate-terminal >> Edit >> Keyboard Shorcuts

    # /org/mate/terminal/global/use-mnemonics
    #   false
    gsettings set "org.mate.terminal.global" "use-mnemonics" "false";

    # /org/mate/terminal/global/use-menu-accelerators
    #   false
    gsettings set "org.mate.terminal.global" "use-menu-accelerators" "false";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_hotkey_for_window-movement;
    set_terminal;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================