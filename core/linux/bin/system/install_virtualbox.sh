#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================

# virtualbox : x86_64 ==========================================================
function install_vbox_deb()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return
    fi
    
    local REPO_PATH="/etc/apt/sources.list";
    local REPO_CMD=$(cat ${REPO_PATH});
    local VBOX_REPO_CMD="deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bullseye contrib";

    if [[ -e ${REPO_PATH} ]] && [[ *"${REPO_CMD}"* != *"${VBOX_REPO_CMD}"* ]]; then
        echo "" >> ${REPO_PATH};
        echo "${VBOX_REPO_CMD}" >> ${REPO_PATH};
    fi
    wget -O- "https://www.virtualbox.org/download/oracle_vbox_2016.asc" | gpg --yes --output "/usr/share/keyrings/oracle-virtualbox-2016.gpg" --dearmor;
    apt update;
    apt install -y virtualbox-7.0;
}

function install_vbox_ubu20()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return
    fi

    local NAME="virtualbox-7.0";
    local TMP_DIR= "/core/linux/src/${NAME}";
    
    local VER="7.0.18"
    # virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    local FNAME1="${NAME}_${VER}-162988~Ubuntu~focal_amd64.deb";
    # https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb
    local URL1="https://download.virtualbox.org/virtualbox/${VER}/${FNAME1}";
    
    # Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local FNAME2="Oracle_VM_VirtualBox_Extension_Pack-${VER}.vbox-extpack";
    # https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local URL2="https://download.virtualbox.org/virtualbox/${VER}/${FNAME2}";
    
       
    if [[ ! -e ${TMP_DIR}/${FNAME1} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL1} -O ${TMP_DIR}/${FNAME1};
        wget ${URL2} -O ${TMP_DIR}/${FNAME2};
    fi

    apt install -y ${TMP_DIR}/${FNAME1};
}

function install_vbox_rpm()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ -n $(yum list installed | grep -i ^virtualbox) ]]; then
        return
    fi

    local NAME="VirtualBox-7.0";
    local TMP_DIR= "/core/linux/src/${NAME}";
    
    local VER="7.0.18"
    # VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    local FNAME1="${NAME}-${VER}_162988_el7-1.x86_64.rpm";
    # https://download.virtualbox.org/virtualbox/7.0.18/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm
    local URL1="https://download.virtualbox.org/virtualbox/${VER}/${FNAME1}";
    
    # Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local FNAME2="Oracle_VM_VirtualBox_Extension_Pack-${VER}.vbox-extpack";
    # https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    local URL2="https://download.virtualbox.org/virtualbox/${VER}/${FNAME1}";
           
    if [[ ! -e ${TMP_DIR}/${FNAME1} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL1} -O ${TMP_DIR}/${FNAME1};
        wget ${URL2} -O ${TMP_DIR}/${FNAME2};
    fi

    yum localinstall -y ${TMP_DIR}/${FNAME1};
}

if [[ *"${CUR_VER}"* == *"debian"* ]]; then
   install_vbox_deb;
elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
   install_vbox_ubu20;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
   install_vbox_rpm;
fi
# ==============================================================================

exit 0