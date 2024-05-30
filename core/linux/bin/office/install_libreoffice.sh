#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# libreoffice : x86_64, aarch64 ================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^libreoffice) ]] || apt install -y libreoffice;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^libreoffice) ]] || yum install -y libreoffice;
fi
# ==============================================================================

exit 0