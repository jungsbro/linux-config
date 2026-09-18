#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/cli/install_tmux.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/cli
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
TMP_DIR="/tmp";

# /tmp/tmux-config
CONFIG_DIR="${TMP_DIR}/tmux-config";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="tmux";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_deps_for_tmux()
{
    # --------------------------------------------------------------------------
    # 버전관리
    bash ${CORE_BIN_DIR}/develop/cli/install_git.sh;

    # x11 clipboard
    bash ${CORE_BIN_DIR}/clipboard/cli/install_xclip.sh;    # text, image 지원
    # bash ${CORE_BIN_DIR}/clipboard/cli/install_xsel.sh;   # text만 지원

    # powerline
    bash ${CORE_BIN_DIR}/theme/tui/install_powerline.sh;
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-powerline.sh;
    # --------------------------------------------------------------------------
}


function install_tmux()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}


function config_tmux()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    if [[ -d "${CONFIG_DIR}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${TMP_DIR}" ]] || mkdir -p "${TMP_DIR}";
    # --------------------------------------------------------------------------

    # powerline.conf for tmux --------------------------------------------------
    local ROCKY_TMUX_DIR="/usr/share/tmux";

    local DEB_TMUX_BIND_DIR="/usr/share/powerline/bindings";

    # /usr/share/powerline/bindings/tmux
    local DEB_TMUX_DIR="${DEB_TMUX_BIND_DIR}/tmux";

    if [[ -d "${ROCKY_TMUX_DIR}" ]] && [[ ! -d "${DEB_TMUX_BIND_DIR}" ]]; then
        mkdir -p "${DEB_TMUX_BIND_DIR}";
        ln -s "${ROCKY_TMUX_DIR}" "${DEB_TMUX_DIR}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - "${CUR_USER}" -c "git clone https://github.com/jungsbro/tmux-config.git ${CONFIG_DIR}";
    su - "${CUR_USER}" -c "cp -Rf ${CONFIG_DIR}/.tmux ~/";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    install_deps_for_tmux;
    install_tmux;
    config_tmux;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================