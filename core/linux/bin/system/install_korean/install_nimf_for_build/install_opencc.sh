#!/bin/bash

# OpenCC =======================================================================
# source ${BIN_DIR}/system/install_korean/install_nimf_for_build/install_opencc.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/system/install_korean/install_nimf_for_build
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/../../.."
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="OpenCC";

# https://github.com/BYVoid/OpenCC.git
URL="https://github.com/BYVoid/OpenCC.git";

TMP_DIR="/tmp";

# /tmp/OpenCC
SRC_DIR="/tmp/${NAME}";

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/lib/pkgconfig/opencc.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/opencc.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_OpenCC_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="OpenCC";

    # # https://github.com/BYVoid/OpenCC.git
    # local URL="https://github.com/BYVoid/OpenCC.git";

    # local TMP_DIR="/tmp";

    # # /tmp/OpenCC
    # local SRC_DIR="/tmp/${NAME}";

    # local LOCAL_LIB_DIR="/usr/local/lib"

    # # /usr/local/lib/pkgconfig/opencc.pc
    # local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/opencc.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list installed | grep -i ^cmake) ]] || dnf install -y cmake;
    # [[ -n $(dnf list installed | grep -i ^gcc-c++) ]] || dnf install -y gcc-c++;
    # [[ -n $(dnf list installed | grep -i ^make) ]] || dnf install -y make;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/local
    make -j$(nproc)
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

    # pkg-config --modversion opencc
    # pkg-config --libs opencc
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
    build_OpenCC_for_dnf;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# exit 0



