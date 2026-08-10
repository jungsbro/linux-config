#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_marisa-trie.sh && build_marisa-trie_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_marisa-trie_for_dnf()
{
    # --------------------------------------------------------------------------
    local NAME="marisa-trie";

    # https://github.com/s-yata/marisa-trie.git
    local URL="https://github.com/s-yata/marisa-trie.git";

    local TMP_DIR="/tmp";

    # /tmp/marisa-trie
    local SRC_DIR="/tmp/${NAME}";

    local LOCAL_LIB64_DIR="/usr/local/lib64"

    # /usr/local/lib64/pkgconfig/marisa.pc
    local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/marisa.pc"
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
    [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list --installed | grep -i ^cmake) ]] || dnf install -y cmake;
    [[ -n $(dnf list --installed | grep -i ^gcc-c++) ]] || dnf install -y gcc-c++;
    [[ -n $(dnf list --installed | grep -i ^make) ]] || dnf install -y make;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) marisa-trie build
    git clone ${URL} ${SRC_DIR};

    pushd ${SRC_DIR}
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_PREFIX_PATH=/usr/local
    make -j$(nproc)
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf가 build시에 marisa-trie을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion marisa
    # pkg-config --libs marisa
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${NAME} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================



# Main =========================================================================

# ==============================================================================