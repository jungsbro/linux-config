#!/bin/bash

# rime =========================================================================
# source /core/linux/bin/system/install_korean/install_nimf_for_build/install_rime.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="rime";

# https://github.com/rime/librime.git
URL="https://github.com/rime/librime.git";

TMP_DIR="/tmp";

# /tmp/rime
SRC_DIR="/tmp/${NAME}";

LOCAL_LIB_DIR="/usr/local/lib"
LOCAL_LIB64_DIR="/usr/local/lib64"

# /usr/local/lib64/pkgconfig/rime.pc
PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/rime.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_rime_for_rocky()
{
    # --------------------------------------------------------------------------
    # local NAME="rime";

    # # https://github.com/rime/librime.git
    # local URL="https://github.com/rime/librime.git";

    # local TMP_DIR="/tmp";

    # # /tmp/rime
    # local SRC_DIR="/tmp/${NAME}";

    # local LOCAL_LIB_DIR="/usr/local/lib"
    # local LOCAL_LIB64_DIR="/usr/local/lib64"

    # # /usr/local/lib64/pkgconfig/rime.pc
    # local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/rime.pc"
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
    [[ -n $(dnf list installed | grep -i ^gtest-devel) ]] || dnf install -y gtest-devel;
    [[ -n $(dnf list installed | grep -i ^leveldb-devel) ]] || dnf install -y leveldb-devel;
    [[ -n $(dnf list installed | grep -i ^boost-devel) ]] || dnf install -y boost-devel;
    [[ -n $(dnf list installed | grep -i ^yaml-cpp-devel) ]] || dnf install -y yaml-cpp-devel;
    [[ -n $(dnf list installed | grep -i ^glog-devel) ]] || dnf install -y glog-devel;
    # rime needs "marisa-devel"
    # rime needs "opencc-devel"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"
    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig"
    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone ${URL} ${SRC_DIR};

    # Removing "IsGoogleLoggingInitialized" in setup.cc ~~~~~~~~~~~~~~~~~~~~~~~~
    # 90-96
    # vi librime/src/rime/setup.cc
    # ..........................................................................
    # if (google::IsGoogleLoggingInitialized()) {
    #     LOG(WARNING) << "Glog is already initialized.";
    # } else {
    #     google::InitGoogleLogging(app_name);
    # }
    # ..........................................................................
    local RIME_SETUP_PATH="${SRC_DIR}/src/rime/setup.cc"

    if [[ -f ${RIME_SETUP_PATH} ]]; then
        sed -i '/IsGoogleLoggingInitialized/{N;N;N;N;s/^/\/\//;s/\n/\n\/\//g}' ${RIME_SETUP_PATH}
    fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    pushd ${SRC_DIR}
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    # cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TEST=OFF
    make -j$(nproc)
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # pkg-config --modversion rime
    # pkg-config --libs rime
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
    build_rime_for_rocky;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# exit 0

