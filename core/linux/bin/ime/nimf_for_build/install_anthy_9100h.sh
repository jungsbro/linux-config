#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_anthy_9100h.sh && build_anthy-9100h_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_anthy-9100h_for_dnf()
{
    # --------------------------------------------------------------------------
    local NAME="anthy-9100h";

    # https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz
    local URL="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz";


    local TMP_DIR="/tmp";

    # /tmp/anthy-9100h
    local SRC_DIR="/tmp/${NAME}";

    # /tmp/anthy-9100h/anthy-9100h.tar.gz
    local TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

    local LOCAL_LIB_DIR="/usr/local/lib"

    # /usr/local/lib/pkgconfig/anthy.pc
    local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/anthy.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) anthy build
    wget ${URL} -O ${TGZ_PATH};
    tar -xvf "${TGZ_PATH}" -C ${SRC_DIR};

    # /tmp/m17n-db/anthy-9100h-1.8.0
    tgt_dir=$(ls -d ${SRC_DIR}/* | head -n 1)

    pushd "${tgt_dir}"
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) /usr/share/anthy symlink
    local SRC_ANTHY_DIR="/usr/local/share/anthy"
    local DST_ANTHY_DIR="/usr/share/anthy"

    if [[ -e ${SRC_ANTHY_DIR} ]] && [[ ! -e ${DST_ANTHY_DIR} ]]; then
        # ln -s /usr/local/share/anthy /usr/share/anthy
        ln -s ${SRC_ANTHY_DIR} ${DST_ANTHY_DIR}
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) nimf가 build시에 anthy을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion anthy
    # pkg-config --libs anthy
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${NAME} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================