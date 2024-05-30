#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# update =======================================================================
function add_epel_repo()
{
    if [[ -n $(yum list installed | grep -i ^epel-release) ]]; then
        return
    fi
    yum install -y epel-release;
    
    yum check-update;
}

function add_nux_dextop_repo()
{
    if [[ -n $(yum list installed | grep -i ^nux-dextop) ]]; then
        return
    fi
    rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm;
    
    yum check-update;
}

function add_neofetch_repo()
{
    if [[ -n $(yum list installed | grep -i ^neofetch) ]]; then
        return
    fi
    curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo \
    https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo;
    
    yum check-update;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    apt update;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    add_epel_repo;
    add_nux_dextop_repo;
    add_neofetch_repo;
    
    yum check-update;
fi
# ==============================================================================

exit 0