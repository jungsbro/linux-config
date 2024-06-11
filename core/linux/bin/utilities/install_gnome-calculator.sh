#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# gnome-calculator : x86_64, aarch64 ===========================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   [[ -n $(apt list --installed | grep -i ^gnome-calculator) ]] || apt install -y gnome-calculator;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   [[ -n $(yum list installed | grep -i ^gnome-calculator) ]] || yum install -y gnome-calculator;
fi
# ==============================================================================

exit 0