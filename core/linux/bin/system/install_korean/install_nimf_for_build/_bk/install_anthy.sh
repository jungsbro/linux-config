#!/bin/bash

# anthy ========================================================================
# source /core/linux/bin/system/install_korean/install_nimf_for_build/install_anthy.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="anthy";

# https://salsa.debian.org/gniibe/anthy.git
URL="https://salsa.debian.org/gniibe/anthy.git";

TMP_DIR="/tmp";

# /tmp/anthy
SRC_DIR="/tmp/${NAME}";

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/lib/pkgconfig/anthy.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/anthy.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_anthy_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="anthy";

    # # https://salsa.debian.org/gniibe/anthy.git
    # local URL="https://salsa.debian.org/gniibe/anthy.git";

    # local TMP_DIR="/tmp";

    # # /tmp/anthy
    # local SRC_DIR="/tmp/${NAME}";

    # local LOCAL_LIB_DIR="/usr/local/lib"

    # # /usr/local/lib/pkgconfig/anthy.pc
    # local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/anthy.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ -f "${PC_PATH}" ]]; then
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list installed | grep -i ^automake) ]] || dnf install -y automake;
    [[ -n $(dnf list installed | grep -i ^autoconf) ]] || dnf install -y autoconf;
    [[ -n $(dnf list installed | grep -i ^libtool) ]] || dnf install -y libtool;
    [[ -n $(dnf list installed | grep -i ^gettext-devel) ]] || dnf install -y gettext-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    ./autogen.sh
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"
    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    echo ""
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    build_anthy_for_dnf;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# exit 0