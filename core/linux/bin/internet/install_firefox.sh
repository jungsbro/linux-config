#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# firefox : x86_64, aarch64 ====================================================
if [[ *"${CUR_VER}"* == *"debian"* ]]; then
    echo "";
elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^firefox) ]] || apt install -y firefox;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^firefox) ]] || yum install -y firefox;
fi
# ==============================================================================

exit 0