#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_opencc.sh && build_OpenCC_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_OpenCC_for_dnf()
{
    # --------------------------------------------------------------------------
    local NAME="OpenCC";

    # https://github.com/BYVoid/OpenCC.git
    local URL="https://github.com/BYVoid/OpenCC.git";

    local TMP_DIR="/tmp";

    # /tmp/OpenCC
    local SRC_DIR="/tmp/${NAME}";

    local LOCAL_LIB_DIR="/usr/local/lib"
    local LOCAL_LIB64_DIR="/usr/local/lib64"

    # /usr/local/lib64/pkgconfig/opencc.pc
    local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/opencc.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list --installed | grep -i ^cmake) ]] || dnf install -y cmake;
    # [[ -n $(dnf list --installed | grep -i ^gcc-c++) ]] || dnf install -y gcc-c++;
    # [[ -n $(dnf list --installed | grep -i ^make) ]] || dnf install -y make;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) opencc build
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/local
    make -j$(nproc)
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf가 build시에 opencc을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion opencc
    # pkg-config --libs opencc
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${NAME} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================


# Main =========================================================================

# ==============================================================================



