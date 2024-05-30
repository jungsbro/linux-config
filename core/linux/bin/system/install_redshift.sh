#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# redshift : x86_64, aarch64 ===================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^redshift) ]] || apt install -y redshift-gtk;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^redshift) ]] || yum install -y redshift-gtk;
fi
# ==============================================================================

exit 0