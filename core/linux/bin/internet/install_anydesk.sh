#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================

# anydesk : x86_64 =============================================================
function install_anydesk_deb()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^anydesk) ]]; then
        return
    fi
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -;
    echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list;
    apt update && apt install -y anydesk;
}

function install_anydesk_rpm1()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(yum list installed | grep -i ^anydesk) ]]; then
        return
    fi
    
    local NAME="anydesk";
    local TMP_DIR= "/tmp/${NAME}";
    
    local VER="6.3.2-1"
    # anydesk-6.3.2-1.el7.x86_64.rpm
    local FNAME="${NAME}-${VER}.el7.x86_64.rpm";
    # https://download.anydesk.com/linux/anydesk-6.3.2-1.el7.x86_64.rpm
    local URL="https://download.anydesk.com/linux/${FNAME}";
    
          
    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    yum localinstall -y ${TMP_DIR}/${FNAME};
}

function install_anydesk_rpm2()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # repo error : not working!!!
    if [[ -n $(yum list installed | grep -i ^anydesk) ]]; then
        return
    fi
    local REPO_CMD="[anydesk]
name=AnyDesk CentOS - stable
baseurl=http://rpm.anydesk.com/centos/$releasever/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY";

    local REPO_PATH="/etc/yum.repos.d/AnyDesk-CentOS.repo";
    
    echo "${REPO_CMD}" > ${REPO_PATH};
    yum install -y anydesk;
}


if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   install_anydesk_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   install_anydesk_rpm1;
fi
# ==============================================================================

exit 0