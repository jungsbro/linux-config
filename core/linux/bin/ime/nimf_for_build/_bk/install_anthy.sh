#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_anthy.sh && build_anthy_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_anthy_for_dnf()
{
    # --------------------------------------------------------------------------
    local NAME="anthy";

    # https://salsa.debian.org/gniibe/anthy.git
    local URL="https://salsa.debian.org/gniibe/anthy.git";

    local TMP_DIR="/tmp";

    # /tmp/anthy
    local SRC_DIR="/tmp/${NAME}";

    local LOCAL_LIB_DIR="/usr/local/lib"

    # /usr/local/lib/pkgconfig/anthy.pc
    local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/anthy.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ -f "${PC_PATH}" ]]; then
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list --installed | grep -i ^automake) ]] || dnf install -y automake;
    [[ -n $(dnf list --installed | grep -i ^autoconf) ]] || dnf install -y autoconf;
    [[ -n $(dnf list --installed | grep -i ^libtool) ]] || dnf install -y libtool;
    [[ -n $(dnf list --installed | grep -i ^gettext-devel) ]] || dnf install -y gettext-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) anthy build
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    ./autogen.sh
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) nimf가 build시에 anthy을 인식할 수 있도록 pkgconfig 경로 등록
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

# ==============================================================================
