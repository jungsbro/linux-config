#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# monitoring ===================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   [[ -n $(apt list --installed | grep -i ^conky) ]] || apt install -y conky;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
   [[ -n $(yum list installed | grep -i ^conky) ]] || yum install -y conky;
fi
# ==============================================================================

exit 0