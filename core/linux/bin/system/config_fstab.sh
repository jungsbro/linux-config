#!/bin/bash

# fstab ========================================================================
# bash /core/linux/bin/system/config_fstab.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func =========================================================================
function config_fstab()
{
    # --------------------------------------------------------------------------
    mkdir -p /mnt/a3004ns-m/hdd1;
    mkdir -p /mnt/{ds920p,j4105-omv,rpi4b8-omv};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local FSTAB_PATH="/etc/fstab";

    local MOUNT_CMD="# samba
# //192.168.0.0/hdd1  /mnt/a3004ns-m/hdd1    cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/j4105/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0

# nfs
# 192.168.0.0:/volume1/docker_data  /mnt/rpi4b8/docker_data nfs defaults    0   0
# 192.168.0.0:/export/docker_data   /mnt/rpi4b8/docker_data nfs defaults    0   0

# disk
# UUID=a1111111-1111-1111-1111-111111111111   /volume1    ext4    defaults,noatime,nofail 0   0
# UUID=b1111111-1111-1111-1111-111111111111   /volume2    ext4    defaults,noatime,nofail 0   0";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -e ${FSTAB_PATH} ]] && [[ *"$(cat ${FSTAB_PATH})"* != *"${MOUNT_CMD}"* ]]; then
        echo "" >> ${FSTAB_PATH};
        echo "${MOUNT_CMD}" >> ${FSTAB_PATH};
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
config_fstab;
# ==============================================================================

exit 0
