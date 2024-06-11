#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# skippy-xd : x86_64, aarch64 ==================================================
function install_skippy-xd()
{
    if [[ -e "/usr/bin/skippy-xd" ]]; then
        return
    fi

    local TMP_DIR="/core/linux/src";
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    
    cd ${TMP_DIR}
    git clone https://github.com/dreamcat4/skippy-xd.git
    cd skippy-xd

    make
    make install
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^libimlib2-dev) ]] || apt install -y libimlib2-dev;
    [[ -n $(apt list --installed | grep -i ^libfontconfig1-dev) ]] || apt install -y libfontconfig1-dev;
    [[ -n $(apt list --installed | grep -i ^libfreetype6-dev) ]] || apt install -y libfreetype6-dev;
    [[ -n $(apt list --installed | grep -i ^libx11-dev) ]] || apt install -y libx11-dev;
    [[ -n $(apt list --installed | grep -i ^libxext-dev) ]] || apt install -y libxext-dev;
    [[ -n $(apt list --installed | grep -i ^libxft-dev) ]] || apt install -y libxft-dev;
    [[ -n $(apt list --installed | grep -i ^libxrender-dev) ]] || apt install -y libxrender-dev;
    [[ -n $(apt list --installed | grep -i ^zlib1g-dev) ]] || apt install -y zlib1g-dev;
    [[ -n $(apt list --installed | grep -i ^libxinerama-dev) ]] || apt install -y libxinerama-dev;
    [[ -n $(apt list --installed | grep -i ^libxcomposite-dev) ]] || apt install -y libxcomposite-dev;
    [[ -n $(apt list --installed | grep -i ^libxdamage-dev) ]] || apt install -y libxdamage-dev;
    [[ -n $(apt list --installed | grep -i ^libxfixes-dev) ]] || apt install -y libxfixes-dev;
    [[ -n $(apt list --installed | grep -i ^libxmu-dev) ]] || apt install -y libxmu-dev;

    install_skippy-xd;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    echo ""
fi
# ==============================================================================

exit 0