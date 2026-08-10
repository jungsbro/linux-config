#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_libhangul.sh && build_libhangul_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_libhangul_for_dnf()
{

    # --------------------------------------------------------------------------
    local NAME="libhangul";

    # https://github.com/choehwanjin/libhangul.git
    local URL="https://github.com/choehwanjin/${NAME}.git";

    local TMP_DIR="/tmp";

    # /tmp/libhangul
    local SRC_DIR="/tmp/${NAME}";
    local BUILD_DIR="/tmp/${NAME}/build";

    local LOCAL_LIB64_DIR="/usr/local/lib64"

    # /etc/ld.so.conf.d/libhangul.conf
    local ENV_CONF_PATH="/etc/ld.so.conf.d/${NAME}.conf"

    # /usr/local/lib64/pkgconfig/libhangul.pc
    local PC_PATH="${LOCAL_LIB64_DIR}/pkgconfig/libhangul.pc"
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
    [[ -n $(dnf list --installed | grep -i ^cmake$) ]] || dnf install -y cmake;
    [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list --installed | grep -i ^check-devel) ]] || dnf install -y check-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 구버전 libhangul 제거
    [[ -n $(dnf list --installed | grep -i ^libhangul) ]] && dnf remove -y libhangul;

    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) libhangul build
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
    # 4) 문제가 되는는 pkgconfig 경로 수정
    # /usr/local/lib64/pkgconfig/libhangul.pc
    local RST_DIR="${LOCAL_LIB64_DIR}/pkgconfig/${NAME}.pc"

    # /usr/local/lib64/pkgconfig/libhangul.pc/libhangul.pc
    local RST_PATH="${RST_DIR}/${NAME}.pc"

    if [[ -d ${RST_DIR} ]] && [[ -f ${RST_PATH} ]]; then
        # /usr/local/lib64/pkgconfig/libhangul.pc
        cp "${RST_PATH}" "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}_tmp.pc"
        rm -rf "${RST_DIR}"
        mv "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}_tmp.pc" "${LOCAL_LIB64_DIR}/pkgconfig/${NAME}.pc"
    fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # pkg-config --modversion libhangul
    # local RST=$(pkg-config --modversion ${NAME})
    # if [[ "${local RST}" == *"not found"* ]]; then
    #     return 0
    # fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 5) nimf가 build시에 linbhangul을 인식할 수 있도록 /usr/local/lib64 등록
    # 방법1) /etc/ld.so.conf.d/libhangul.conf (중요)
    if [[ ! -e "${ENV_CONF_PATH}" ]]; then
        # echo "/usr/local/lib64" | tee /etc/ld.so.conf.d/libhangul.conf;
        echo "${LOCAL_LIB64_DIR}" | tee ${ENV_CONF_PATH};
        ldconfig;
    fi

    # 방법1) /etc/ld.so.conf.d/libhangul.conf
    # RST=$(cat ${ENV_CONF_PATH} 2> /dev/null);
    # if [[ *"${RST}"* != *"${LOCAL_LIB64_DIR}"* ]]; then
    #     echo "${LOCAL_LIB64_DIR}" >> ${ENV_CONF_PATH};
    #     ldconfig;
    # fi

    # 방법2)
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

    echo "---------------------------------------------------------------------"
    echo "${NAME} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================



# Main =========================================================================

# ==============================================================================


