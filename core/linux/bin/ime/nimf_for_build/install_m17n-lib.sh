#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_m17n-lib.sh && build_m17n-lib_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_m17n-lib_for_dnf()
{
    # --------------------------------------------------------------------------
    local NAME="m17n-lib";

    # https://github.com/deepin-community/m17n-lib

    # https://packages.debian.org/bookworm/source/m17n-lib
    # http://deb.debian.org/debian/pool/main/m/m17n-lib/m17n-lib_1.8.0.orig.tar.gz
    # local URL="http://deb.debian.org/debian/pool/main/m/m17n-lib/m17n-lib_1.8.0.orig.tar.gz";

    # https://download-mirror.savannah.gnu.org/releases/m17n/
    # https://download-mirror.savannah.gnu.org/releases/m17n/m17n-lib-1.8.0.tar.gz
    local URL="https://download-mirror.savannah.gnu.org/releases/m17n/m17n-lib-1.8.0.tar.gz";


    local TMP_DIR="/tmp";

    # /tmp/m17n-lib
    local SRC_DIR="/tmp/${NAME}";

    # /tmp/m17n-lib/m17n-lib.tar.gz
    local TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

    local LOCAL_LIB_DIR="/usr/local/lib"

    # /usr/local/lib/pkgconfig/m17n-core.pc
    local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/m17n-core.pc"
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
    [[ -n $(dnf list --installed | grep -i ^libX11-devel) ]] || dnf install -y libX11-devel;
    [[ -n $(dnf list --installed | grep -i ^libXaw-devel) ]] || dnf install -y libXaw-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) m17n-lib build
    wget ${URL} -O ${TGZ_PATH};
    tar -xvf "${TGZ_PATH}" -C ${SRC_DIR};

    # /tmp/m17n-db/m17n-lib-1.8.0
    tgt_dir=$(ls -d ${SRC_DIR}/* | head -n 1)

    pushd "${tgt_dir}"
    ./configure --prefix=/usr/local --enable-shared
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf가 build시에 m17n-lib을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig" ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion m17n-core
    # pkg-config --libs m17n-core
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${NAME} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================


# Main =========================================================================

# ==============================================================================
