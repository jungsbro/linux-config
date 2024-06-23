#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================

# chromium : x86_64 ============================================================
function install_chrome_deb()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^google-chrome) ]]; then
        return
    fi

    local NAME="google-chrome";
    local TMP_DIR="/core/linux/src/${NAME}";

    local FNAME="google-chrome-stable_current_amd64.deb";
    # "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    local URL="https://dl.google.com/linux/direct/${FNAME}";

    if [[ ! -d ${TMP_DIR} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    apt install -y ${TMP_DIR}/${FNAME};
}

function install_chrome_rpm()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(yum list installed | grep -i ^google-chrome) ]]; then
        return
    fi
    
    local NAME="google-chrome";
    local TMP_DIR="/core/linux/src/${NAME}";

    local FNAME="google-chrome-stable_current_x86_64.rpm";
    # "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    local URL="https://dl.google.com/linux/direct/${FNAME}";

    if [[ ! -d ${TMP_DIR} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    yum localinstall -y ${TMP_DIR}/${FNAME};
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then   
    install_chrome_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    echo "";
    # install_chrome_rpm;
fi
# ==============================================================================

exit 0