#!/bin/bash

# m17n-db ======================================================================
# source /core/linux/bin/system/install_korean/install_nimf_for_build/install_m17n-db.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="m17n-db";

# https://download-mirror.savannah.gnu.org/releases/m17n/m17n-db-1.8.0.tar.gz
URL="https://download-mirror.savannah.gnu.org/releases/m17n/m17n-db-1.8.0.tar.gz";

TMP_DIR="/tmp";

# /tmp/m17n-db
SRC_DIR="/tmp/${NAME}";

# /tmp/m17n-db/m17n-db.tar.gz
TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/share/pkgconfig/m17n-db.pc
PC_PATH="/usr/local/share/pkgconfig/m17n-db.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_m17n-db_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="m17n-db";

    # # https://download-mirror.savannah.gnu.org/releases/m17n/m17n-db-1.8.0.tar.gz
    # local URL="https://download-mirror.savannah.gnu.org/releases/m17n/m17n-db-1.8.0.tar.gz";

    # local TMP_DIR="/tmp";

    # # /tmp/m17n-db
    # local SRC_DIR="/tmp/${NAME}";

    # # /tmp/m17n-db/m17n-db.tar.gz
    # local TGZ_PATH="${SRC_DIR}/${NAME}.tar.gz"

    # local LOCAL_LIB_DIR="/usr/local/lib"

    # # /usr/local/share/pkgconfig/m17n-db.pc
    # local PC_PATH="/usr/local/share/pkgconfig/m17n-db.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list installed | grep -i ^autoconf) ]] || dnf install -y autoconf;
    [[ -n $(dnf list installed | grep -i ^automake) ]] || dnf install -y automake;
    [[ -n $(dnf list installed | grep -i ^libtool) ]] || dnf install -y libtool;
    [[ -n $(dnf list installed | grep -i ^gettext-devel) ]] || dnf install -y gettext-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    wget ${URL} -O ${TGZ_PATH};
    tar -xzvf "${TGZ_PATH}" -C ${SRC_DIR};

    # /tmp/m17n-db/m17n-db-1.8.0
    tgt_dir=$(ls -d ${SRC_DIR}/* | head -n 1)

    pushd "${tgt_dir}"
    ./get-glibc.sh
    ./configure --with-charmaps=./glibc-2.3.2/localedata/charmaps
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

    # pkg-config --modversion m17n-db
    # pkg-config --libs m17n-db
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
    build_m17n-db_for_dnf;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# exit 0