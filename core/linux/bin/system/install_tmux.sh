#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_tmux.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
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
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^git) ]] || pacman -S --needed --noconfirm git;
        [[ -n $(pacman -Q | grep -i ^tmux) ]] || pacman -S --needed --noconfirm tmux;
        [[ -n $(pacman -Q | grep -i ^xclip) ]] || pacman -S --needed --noconfirm xclip xsel;
        [[ -n $(pacman -Q | grep -i ^powerline) ]] || pacman -S --needed --noconfirm powerline powerline-fonts;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^git) ]] || apt install -y git;
        [[ -n $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;
        [[ -n $(apt list --installed | grep -i ^xclip) ]] || apt install -y xclip xsel;
        [[ -n $(apt list --installed | grep -i ^powerline) ]] || apt install -y powerline fonts-powerline python3-powerline;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;
        [[ -n $(dnf list --installed | grep -i ^xclip) ]] || dnf install -y xclip xsel;
        [[ -n $(dnf list --installed | grep -i ^powerline) ]] || dnf install -y powerline powerline-fonts tmux-powerline;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^xclip) ]] || dnf install -y xclip xsel;
        # ----------------------------------------------------------------------
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^powerline) ]] || dnf install -y powerline powerline-fonts tmux-powerline;
        # ----------------------------------------------------------------------
    fi
}

function config_tmux()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    if [[ -d ${CONFIG_DIR} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # powerline.conf for tmux --------------------------------------------------
    local ROCKY_TMUX_DIR="/usr/share/tmux";

    local DEB_TMUX_BIND_DIR="/usr/share/powerline/bindings";

    # /usr/share/powerline/bindings/tmux
    local DEB_TMUX_DIR="${DEB_TMUX_BIND_DIR}/tmux";

    if [[ -d ${ROCKY_TMUX_DIR} ]] && [[ ! -d ${DEB_TMUX_BIND_DIR} ]]; then
        mkdir -p ${DEB_TMUX_BIND_DIR};
        ln -s ${ROCKY_TMUX_DIR} ${DEB_TMUX_DIR};
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/tmux-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.tmux ~/";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_tmux;
    config_tmux;
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================