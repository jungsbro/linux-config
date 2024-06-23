#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# gnome-screenshot : x86_64, i686, aarch64 =====================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   [[ -n $(apt list --installed | grep -i ^gnome-screenshot) ]] || apt install -y gnome-screenshot;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   [[ -n $(yum list installed | grep -i ^gnome-screenshot) ]] || yum install -y gnome-screenshot;
fi
# ==============================================================================

exit 0