#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# xscreensaver : x86_64, aarch64 ===============================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   [[ -n $(apt list --installed | grep -i ^xscreensaver) ]] || apt install -y xscreensaver;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   [[ -n $(yum list installed | grep -i ^xscreensaver) ]] || yum install -y xscreensaver;
fi
# ==============================================================================

exit 0