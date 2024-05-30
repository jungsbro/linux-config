#!/bin/bash

# usage ========================================================================
# sudo bash ./install_tmux.sh jungs;
# ==============================================================================

# ==============================================================================
CUR_USER=$1;
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# tmux =========================================================================
function install_tmux()
{
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;
        [[ -n $(apt list --installed | grep -i ^xclip) ]] || apt install -y xclip xsel;
        [[ -n $(apt list --installed | grep -i ^powerline) ]] || apt install -y powerline fonts-powerline python3-powerline;
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        [[ -n $(yum list installed | grep -i ^tmux) ]] || yum install -y tmux;

        [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(yum list installed | grep -i ^xclip) ]] || yum install -y xclip xsel;

        #yum install -y powerline fonts-powerline python3-powerline;
    fi
}

function config_tmux()
{
    if [[ -z ${CUR_USER} ]]; then
        return
    fi

    local TMP_DIR="/core/linux/src";
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};

    local CONFIG_DIR="${TMP_DIR}/tmux-config";

    if [[ -d ${CONFIG_DIR} ]]; then
        return
    fi

    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/tmux-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.tmux ~/";

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux_ct7.conf ~/.tmux.conf";
    fi
}

install_tmux;
config_tmux;
# ==============================================================================

exit 0