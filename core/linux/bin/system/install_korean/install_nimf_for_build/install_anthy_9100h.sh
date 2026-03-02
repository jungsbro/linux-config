#!/bin/bash

# anthy-9100h ==================================================================
# source ${BIN_DIR}/system/install_korean/install_nimf_for_build/install_anthy-9100h.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/install_korean/install_nimf_for_build
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="anthy-9100h";

# https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz
URL="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz";

TMP_DIR="/tmp";

# /tmp/anthy-9100h
SRC_DIR="/tmp/${NAME}";

# /tmp/anthy-9100h/anthy-9100h.tar.gz
TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/lib/pkgconfig/anthy.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/anthy.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_anthy-9100h_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="anthy-9100h";

    # # https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz
    # local URL="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz";

    # local TMP_DIR="/tmp";

    # # /tmp/anthy-9100h
    # local SRC_DIR="/tmp/${NAME}";

    # # /tmp/anthy-9100h/anthy-9100h.tar.gz
    # local TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

    # local LOCAL_LIB_DIR="/usr/local/lib"

    # # /usr/local/lib/pkgconfig/anthy.pc
    # local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/anthy.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    wget ${URL} -O ${TGZ_PATH};
    tar -xzvf "${TGZ_PATH}" -C ${SRC_DIR};

    # /tmp/m17n-db/anthy-9100h-1.8.0
    tgt_dir=$(ls -d ${SRC_DIR}/* | head -n 1)

    pushd "${tgt_dir}"
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local SRC_ANTHY_DIR="/usr/local/share/anthy"
    local DST_ANTHY_DIR="/usr/share/anthy"

    if [[ -e ${SRC_ANTHY_DIR} ]] && [[ ! -e ${DST_ANTHY_DIR} ]]; then
        # ln -s /usr/local/share/anthy /usr/share/anthy
        ln -s ${SRC_ANTHY_DIR} ${DST_ANTHY_DIR}
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion anthy
    # pkg-config --libs anthy
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        echo ""
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        build_anthy-9100h_for_dnf;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

