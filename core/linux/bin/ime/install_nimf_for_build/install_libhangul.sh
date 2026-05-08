#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/install_nimf_for_build/install_libhangul.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime/install_nimf_for_build
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="libhangul";

# https://github.com/choehwanjin/libhangul.git
URL="https://github.com/choehwanjin/${NAME}.git";

TMP_DIR="/tmp";

# /tmp/libhangul
SRC_DIR="/tmp/${NAME}";
BUILD_DIR="/tmp/${NAME}/build";

LOCAL_LIB64_DIR="/usr/local/lib64"

# /etc/ld.so.conf.d/libhangul.conf
ENV_CONF_PATH="/etc/ld.so.conf.d/${NAME}.conf"

# /usr/local/lib/pkgconfig/libhangul.pc
PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/libhangul.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_libhangul_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="libhangul";

    # # https://github.com/choehwanjin/libhangul.git
    # local URL="https://github.com/choehwanjin/${NAME}.git";

    # local TMP_DIR="/tmp";

    # # /tmp/libhangul
    # local SRC_DIR="/tmp/${NAME}";
    # local BUILD_DIR="/tmp/${NAME}/build";

    # local LOCAL_LIB64_DIR="/usr/local/lib64"

    # # /etc/ld.so.conf.d/libhangul.conf
    # local ENV_CONF_PATH="/etc/ld.so.conf.d/${NAME}.conf"

    # # /usr/local/lib/pkgconfig/libhangul.pc
    # local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/libhangul.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list --installed | grep -i ^cmake$) ]] || dnf install -y cmake;
    [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list --installed | grep -i ^check-devel) ]] || dnf install -y check-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf list --installed | grep -i ^libhangul) ]] && dnf remove -y libhangul;

    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone "${URL}" "${SRC_DIR}"
    [[ -d ${BUILD_DIR} ]] || mkdir -p ${BUILD_DIR};

    pushd ${BUILD_DIR}
    cmake ..
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/local/lib64/pkgconfig/libhangul.pc
    local RST_DIR="${LOCAL_LIB64_DIR}/pkgconfig/${NAME}.pc"

    # /usr/local/lib64/pkgconfig/libhangul.pc/libhangul.pc
    local RST_PATH="${RST_DIR}/${NAME}.pc"

    if [[ ! -d ${RST_DIR} ]] || [[ ! -f ${RST_PATH} ]]; then
        return
    fi
    # /usr/local/lib64/pkgconfig/libhangul.pc
    cp "${RST_PATH}" "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}_tmp.pc"
    rm -rf "${RST_DIR}"
    mv "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}_tmp.pc" "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}.pc"
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # pkg-config --modversion libhangul
    # local RST=$(pkg-config --modversion ${NAME})
    # if [[ *"${local RST}"* == *"not found"* ]]; then
    #     return
    # fi

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if [[ ! -e "${ENV_CONF_PATH}" ]]; then
        # echo "/usr/local/lib64" | tee /etc/ld.so.conf.d/libhangul.conf;
        echo "${LOCAL_LIB64_DIR}" | tee ${ENV_CONF_PATH};
        ldconfig;
    fi
    # RST=$(cat ${ENV_CONF_PATH} 2> /dev/null);
    # if [[ *"${RST}"* != *"${LOCAL_LIB64_DIR}"* ]]; then
    #     echo "${LOCAL_LIB64_DIR}" >> ${ENV_CONF_PATH};
    #     ldconfig;
    # fi

    if [[ -z ${LD_LIBRARY_PATH} ]]; then
        export LD_LIBRARY_PATH="${LOCAL_LIB64_DIR}"
    elif [[ *"${LD_LIBRARY_PATH}"* != *"${LOCAL_LIB64_DIR}"* ]]; then
        # export LD_LIBRARY_PATH="/usr/local/lib64:$LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH="${LOCAL_LIB64_DIR}:$LD_LIBRARY_PATH"
    fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # pkg-config --modversion libhangul
    # pkg-config --libs libhangul
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
        build_libhangul_for_dnf;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
