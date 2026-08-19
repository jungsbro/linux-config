#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_libhangul.sh && build_libhangul_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_libhangul_for_dnf()
{

    # --------------------------------------------------------------------------
    local pkg_name="libhangul";

    # https://github.com/choehwanjin/libhangul.git
    local app_url="https://github.com/choehwanjin/${pkg_name}.git";

    local tmp_dir="/tmp";

    # /tmp/libhangul
    local src_dir="/tmp/${pkg_name}";
    local BUILD_DIR="/tmp/${pkg_name}/build";

    local local_lib64_dir="/usr/local/lib64"

    # /etc/ld.so.conf.d/libhangul.conf
    local ENV_CONF_PATH="/etc/ld.so.conf.d/${pkg_name}.conf"

    # /usr/local/lib64/pkgconfig/libhangul.pc
    local pc_path="${local_lib64_dir}/pkgconfig/libhangul.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${pc_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";

    local app_name="pkg-config"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="cmake"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="check-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 구버전 libhangul 제거
    [[ -n $(dnf list --installed | grep -i ^libhangul) ]] && dnf remove -y libhangul;

    [[ -d ${tmp_dir} ]] || mkdir -p ${tmp_dir};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) libhangul build
    git clone "${app_url}" "${src_dir}"
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
    local rst_dir="${local_lib64_dir}/pkgconfig/${pkg_name}.pc"

    # /usr/local/lib64/pkgconfig/libhangul.pc/libhangul.pc
    local rst_path="${rst_dir}/${pkg_name}.pc"

    if [[ -d ${rst_dir} ]] && [[ -f ${rst_path} ]]; then
        # /usr/local/lib64/pkgconfig/libhangul.pc
        cp "${rst_path}" "${local_lib64_dir}/pkgconfig/${pkg_name}_tmp.pc"
        rm -rf "${rst_dir}"
        mv "${local_lib64_dir}/pkgconfig/${pkg_name}_tmp.pc" "${local_lib64_dir}/pkgconfig/${pkg_name}.pc"
    fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # pkg-config --modversion libhangul
    # local RST=$(pkg-config --modversion ${pkg_name})
    # if [[ "${local RST}" == *"not found"* ]]; then
    #     return 0
    # fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 5) nimf가 build시에 linbhangul을 인식할 수 있도록 /usr/local/lib64 등록
    # 방법1) /etc/ld.so.conf.d/libhangul.conf (중요)
    if [[ ! -e "${ENV_CONF_PATH}" ]]; then
        # echo "/usr/local/lib64" | tee /etc/ld.so.conf.d/libhangul.conf;
        echo "${local_lib64_dir}" | tee ${ENV_CONF_PATH};
        ldconfig;
    fi

    # 방법1) /etc/ld.so.conf.d/libhangul.conf
    # RST=$(cat ${ENV_CONF_PATH} 2> /dev/null);
    # if [[ "${RST}" != *"${local_lib64_dir}"* ]]; then
    #     echo "${local_lib64_dir}" >> ${ENV_CONF_PATH};
    #     ldconfig;
    # fi

    # 방법2)
    if [[ -z ${LD_LIBRARY_PATH} ]]; then
        export LD_LIBRARY_PATH="${local_lib64_dir}"

    elif [[ "${LD_LIBRARY_PATH}" != *"${local_lib64_dir}"* ]]; then

        # export LD_LIBRARY_PATH="/usr/local/lib64:$LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH="${local_lib64_dir}:$LD_LIBRARY_PATH"
    fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # pkg-config --modversion libhangul
    # pkg-config --libs libhangul
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${pkg_name} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================
