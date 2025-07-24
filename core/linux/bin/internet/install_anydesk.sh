#!/bin/bash

# anydesk ======================================================================
# bash /core/linux/bin/internet/install_anydesk.sh;
# ==============================================================================

# ==============================================================================
# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="anydesk";

# /tmp/anydesk
TMP_DIR="/tmp/${NAME}";

# https://download.anydesk.com/linux/anydesk_7.0.1-1_x86_64.rpm
VER="7.0.1-1"
# ------------------------------------------------------------------------------
# ==============================================================================


# anydesk : x86_64 =============================================================
function install_anydesk_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^anydesk) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -;
    echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list;
    apt update && apt install -y anydesk;
    # --------------------------------------------------------------------------
}

function install_anydesk_for_cent1()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(yum list installed | grep -i ^anydesk) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # anydesk-6.3.2-1.el7.x86_64.rpm
    local FNAME="${NAME}-${VER}.el7.x86_64.rpm";

    # https://download.anydesk.com/linux/anydesk-6.3.2-1.el7.x86_64.rpm
    local URL="https://download.anydesk.com/linux/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};

        # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
    yum install -y ${TMP_DIR}/${FNAME};
    # --------------------------------------------------------------------------
}

function install_anydesk_for_cent2()
{
    # --------------------------------------------------------------------------
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
    # --------------------------------------------------------------------------

    # desktop ------------------------------------------------------------------
    local REPO_CMD="[anydesk]
name=AnyDesk CentOS - stable
baseurl=http://rpm.anydesk.com/centos/$releasever/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY";

    local REPO_PATH="/etc/yum.repos.d/AnyDesk-CentOS.repo";

    echo "${REPO_CMD}" > ${REPO_PATH};
    # --------------------------------------------------------------------------

    yum install -y anydesk;
}

function install_anydesk_for_rocky()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(dnf list installed | grep -i ^anydesk) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # anydesk-6.3.2-1.el7.x86_64.rpm
    local FNAME="${NAME}-${VER}.el7.x86_64.rpm";

    # https://download.anydesk.com/linux/anydesk-6.3.2-1.el7.x86_64.rpm
    local URL="https://download.anydesk.com/linux/${FNAME}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
        wget ${URL} -O ${TMP_DIR}/${FNAME};
        # ----------------------------------------------------------------------
    fi

    # /tmp/anydesk/anydesk-6.3.2-1.el7.x86_64.rpm
    dnf install -y ${TMP_DIR}/${FNAME};
    # --------------------------------------------------------------------------
}

# ------------------------------------------------------------------------------
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_anydesk_for_deb;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    install_anydesk_for_cent1;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_anydesk_for_rocky;
    # --------------------------------------------------------------------------
fi
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0