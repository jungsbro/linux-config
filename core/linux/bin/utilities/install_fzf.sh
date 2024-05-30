#!/bin/bash

# ==============================================================================
CUR_USER=$1;
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# fzf ==========================================================================
function install_fzf_git()
{
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    
    local FZF_CMD="git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf;
~/.fzf/install --all;"
    
    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -e "~/.fzf" ]] || eval '${FZF_CMD}'";
    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        [[ -e "/root/.fzf" ]] || eval '${FZF_CMD}';
    fi
    # --------------------------------------------------------------------------
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   install_fzf_git;
fi
# ==============================================================================

exit 0