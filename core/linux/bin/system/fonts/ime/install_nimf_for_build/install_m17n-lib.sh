#!/bin/bash

# m17n-lib =====================================================================
# source ${CORE_BIN_DIR}/system/fonts/ime/install_nimf_for_build/install_m17n-lib.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/fonts/ime/install_nimf_for_build
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="m17n-lib";

# https://download-mirror.savannah.gnu.org/releases/m17n/m17n-lib-1.8.0.tar.gz
URL="https://download-mirror.savannah.gnu.org/releases/m17n/m17n-lib-1.8.0.tar.gz";

TMP_DIR="/tmp";

# /tmp/m17n-lib
SRC_DIR="/tmp/${NAME}";

# /tmp/m17n-lib/m17n-lib.tar.gz
TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/lib/pkgconfig/m17n-core.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/m17n-core.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_m17n-lib_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="m17n-lib";

    # # https://download-mirror.savannah.gnu.org/releases/m17n/m17n-lib-1.8.0.tar.gz
    # local URL="https://download-mirror.savannah.gnu.org/releases/m17n/m17n-lib-1.8.0.tar.gz";

    # local TMP_DIR="/tmp";

    # # /tmp/m17n-lib
    # local SRC_DIR="/tmp/${NAME}";

    # # /tmp/m17n-lib/m17n-lib.tar.gz
    # local TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

    # local LOCAL_LIB_DIR="/usr/local/lib"

    # # /usr/local/lib/pkgconfig/m17n-core.pc
    # local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/m17n-core.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list --installed | grep -i ^libX11-devel) ]] || dnf install -y libX11-devel;
    [[ -n $(dnf list --installed | grep -i ^libXaw-devel) ]] || dnf install -y libXaw-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    wget ${URL} -O ${TGZ_PATH};
    tar -xzvf "${TGZ_PATH}" -C ${SRC_DIR};

    # /tmp/m17n-db/m17n-lib-1.8.0
    tgt_dir=$(ls -d ${SRC_DIR}/* | head -n 1)

    pushd "${tgt_dir}"
    ./configure --prefix=/usr/local --enable-shared
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig" ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion m17n-core
    # pkg-config --libs m17n-core
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
        build_m17n-lib_for_dnf;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
