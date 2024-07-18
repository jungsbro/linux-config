#!/bin/bash

# usage ========================================================================
# sudo bash ./install_tmux.sh jungs;
# ==============================================================================

# ==============================================================================
# ------------------------------------------------------------------------------
CUR_USER=$1;
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
TMP_DIR="/core/linux/src";

# /core/linux/src/tmux-config
CONFIG_DIR="${TMP_DIR}/tmux-config";
# ------------------------------------------------------------------------------
# ==============================================================================

# tmux =========================================================================
function install_tmux()
{
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;
        [[ -n $(apt list --installed | grep -i ^xclip) ]] || apt install -y xclip xsel;
        [[ -n $(apt list --installed | grep -i ^powerline) ]] || apt install -y powerline fonts-powerline python3-powerline;
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(yum list installed | grep -i ^tmux) ]] || yum install -y tmux;
        # ----------------------------------------------------------------------
        [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(yum list installed | grep -i ^xclip) ]] || yum install -y xclip xsel;
        # ----------------------------------------------------------------------
        # yum install -y powerline fonts-powerline python3-powerline;
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^tmux) ]] || dnf install -y tmux;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^xclip) ]] || dnf install -y xclip xsel;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^powerline) ]] || dnf install -y powerline;
        [[ -n $(dnf list installed | grep -i ^powerline-fonts) ]] || dnf install -y powerline-fonts;
        [[ -n $(dnf list installed | grep -i ^tmux-powerline) ]] || dnf install -y tmux-powerline;
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
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
        
    elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux_ct7.conf ~/.tmux.conf";
        
    elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
    fi
    # --------------------------------------------------------------------------
}

# ------------------------------------------------------------------------------
install_tmux;
config_tmux;
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0