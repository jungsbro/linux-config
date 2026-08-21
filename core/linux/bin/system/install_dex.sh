#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# for autostart (~/.config/autostart/*.desktop)

# bash ${CORE_BIN_DIR}/system/install_dex.sh;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 방법1)
# dex -a -s "$HOME/.config/autostart" &
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 방법2)
# vi ~/.config/openbox/autostart

# /usr/local/bin/autostart-runner.sh &
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="dex"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_autostart-runner()
{
    local dst_path="/usr/local/bin/autostart-runner.sh";

    local cmd='#!/bin/bash

# 1) dex for Debian/Ubuntu/Fedora/Arch
if command -v dex >/dev/null 2>&1; then
    dex -a -s "$HOME/.config/autostart" &

# 2) openbox-xdg-autostart for RHEL/CentOS
elif [ -x /usr/libexec/openbox-xdg-autostart ]; then
    /usr/libexec/openbox-xdg-autostart --stage run &

# 3) etc
elif command -v fbautostart >/dev/null 2>&1; then
    fbautostart &
fi
'
    # --------------------------------------------------------------------------
    if [[ -f "${dst_path}" ]]; then
        return 0
    fi

    echo "${cmd}" > "${dst_path}";
    chmod +x "${dst_path}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="dex-autostart"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        echo "dex is not available on rhel";
    fi

    # --------------------------------------------------------------------------
    create_autostart-runner;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================