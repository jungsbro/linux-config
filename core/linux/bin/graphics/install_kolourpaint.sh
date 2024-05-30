#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# kolourpaint : x86_64, aarch64 ================================================
if [[ *"${CUR_VER}"* == *"debian"* ]]; then
    [[ -n $(apt list --installed | grep -i ^kolurpaint4) ]] || apt install -y kolourpaint;
elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^kolurpaint4) ]] || apt install -y kolourpaint4;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^kolourpaint) ]] || yum install -y kolourpaint;
fi
# ==============================================================================

exit 0