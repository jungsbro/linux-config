#!/bin/bash

# marisa-trie ==================================================================
# source ${BIN_DIR}/system/install_korean/install_nimf_for_build/install_marisa-trie.sh
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
NAME="marisa-trie";

# https://github.com/s-yata/marisa-trie.git
URL="https://github.com/s-yata/marisa-trie.git";

TMP_DIR="/tmp";

# /tmp/marisa-trie
SRC_DIR="/tmp/${NAME}";

LOCAL_LIB64_DIR="/usr/local/lib64"

# /usr/local/lib/pkgconfig/marisa.pc
PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/marisa.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_marisa-trie_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="marisa-trie";

    # # https://github.com/s-yata/marisa-trie.git
    # local URL="https://github.com/s-yata/marisa-trie.git";

    # local TMP_DIR="/tmp";

    # # /tmp/marisa-trie
    # local SRC_DIR="/tmp/${NAME}";

    # local LOCAL_LIB64_DIR="/usr/local/lib64"

    # # /usr/local/lib/pkgconfig/marisa.pc
    # local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/marisa.pc"
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
    [[ -n $(dnf list installed | grep -i ^gcc-c++) ]] || dnf install -y gcc-c++;
    [[ -n $(dnf list installed | grep -i ^make) ]] || dnf install -y make;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_PREFIX_PATH=/usr/local
    make -j$(nproc)
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion marisa
    # pkg-config --libs marisa
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
    build_marisa-trie_for_dnf;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# exit 0