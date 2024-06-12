#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# theme ========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^dconf-cli) ]] || apt install -y dconf-cli;
    [[ -n $(apt list --installed | grep -i ^dconf-editor) ]] || apt install -y dconf-editor;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^dconf) ]] || yum install -y dconf;
    [[ -n $(yum list installed | grep -i ^dconf-editor) ]] || yum install -y dconf-editor;
fi
# ==============================================================================

exit 0