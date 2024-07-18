#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# fstab ========================================================================
function config_fstab()
{
    # --------------------------------------------------------------------------
    mkdir -p /mnt/{a3004ns,jessie,lucy,j4105}/{_share,_private};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local FSTAB_PATH="/etc/fstab";
    
    local MOUNT_CMD="# samba
# //192.168.0.0/hdd1  /mnt/a3004ns    cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/jessie/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/lucy/_share   cifs    username=jungs,password=apple8282,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/j4105/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0

# nfs
# 192.168.0.0:/volume1/docker_data  /mnt/jessie/_private/docker_data nfs defaults    0   0
# 192.168.0.0:/export/docker_data   /mnt/j4105/_private/docker_data nfs defaults    0   0

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

# ------------------------------------------------------------------------------
config_fstab;
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0