#!/bin/bash

# glog =========================================================================
# source /core/linux/bin/system/install_korean/install_nimf_for_build/install_glog.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="glog";

# https://github.com/google/glog.git
URL="https://github.com/google/glog.git";

TMP_DIR="/tmp";

# /tmp/glog
SRC_DIR="/tmp/${NAME}";

LOCAL_LIB64_DIR="/usr/local/lib64"

# /usr/local/lib/pkgconfig/glog.pc
PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/glog.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_glog_for_rocky()
{
    # --------------------------------------------------------------------------
    # local NAME="glog";

    # # https://github.com/google/glog.git
    # local URL="https://github.com/google/glog.git";

    # local TMP_DIR="/tmp";

    # # /tmp/glog
    # local SRC_DIR="/tmp/${NAME}";

    # local LOCAL_LIB64_DIR="/usr/local/lib64"

    # # /usr/local/lib/pkgconfig/glog.pc
    # local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/glog.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ -f "${PC_PATH}" ]]; then
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list installed | grep -i ^cmake) ]] || dnf install -y cmake;
    [[ -n $(dnf list installed | grep -i ^glog-devel) ]] && dnf remove -y glog-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    # rime has error because of "glog v0.5.0+"
    # git checkout v0.5.0
    # git checkout v0.4.0
    mkdir build && cd build

    # cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_GFLAGS=ON -DWITH_PKGCONFIG=ON -DCMAKE_PREFIX_PATH=/usr/local
    cmake .. -DCMAKE_BUILD_TYPE=Release \
        -DWITH_GFLAGS=ON \
        -DWITH_PKGCONFIG=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_PREFIX_PATH=/usr/local

    make -j$(nproc)
    make install
    ldconfig ${LOCAL_LIB64_DIR}
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}.pc" ]]; then
        CONF_CMD="prefix=/usr/local
exec_prefix=${prefix}
libdir=${exec_prefix}/lib64
includedir=${prefix}/include

Name: glog
Description: Google logging library
Version: 0.4.0
Libs: -L${libdir} -lglog
Cflags: -I${includedir}
"
        echo "$CONF_CMD" > ${LOCAL_LIB64_DIR}/pkgconfig/${NAME}.pc
    fi

    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig"
    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion glog
    # pkg-config --libs glog
    # --------------------------------------------------------------------------
}
# ==============================================================================




# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    echo ""
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo ""
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    build_glog_for_rocky;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# exit 0



