#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_tmux.sh "${CUR_USER}";
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
TMP_DIR="/tmp";

# /tmp/tmux-config
CONFIG_DIR="${TMP_DIR}/tmux-config";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_tmux()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="tmux"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xclip"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xsel"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="powerline"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="powerline-fonts"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="tmux"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="xclip"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="xsel"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="powerline"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="fonts-powerline"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="python3-powerline"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="tmux"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xclip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xsel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="powerline"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="powerline-fonts"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="tmux-powerline"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="tmux"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xclip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xsel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="powerline"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="powerline-fonts"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="tmux-powerline"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
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
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
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