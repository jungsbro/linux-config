#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# korean =======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^fontconfig) ]] || apt install -y fontconfig;
    
    [[ -n $(apt list --installed | grep -i ^fonts-nanum) ]] || apt install -y \
    fonts-nanum fonts-nanum-coding fonts-nanum-extra;
    
    [[ -n $(apt list --installed | grep -i ^uim) ]] || apt install -y uim uim-byeoru;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^fontconfig) ]] || yum install -y fontconfig;
    # yum search fonts | grep -i korean;
    # yum install -y fonts-nanum*;
fi
#fc-cache -f -v;
# ==============================================================================

exit 0