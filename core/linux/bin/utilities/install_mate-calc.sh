#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# mate-calc : x86_64, aarch64 ==================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   [[ -n $(apt list --installed | grep -i ^mate-calc) ]] || apt install -y mate-calc;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   [[ -n $(yum list installed | grep -i ^mate-calc) ]] || yum install -y mate-calc;
fi
# ==============================================================================

exit 0