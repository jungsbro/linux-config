#!/bin/bash
set -e

[[ -n "${_BUILD_OPENCC_LOADED:-}" ]] && return 0
_BUILD_OPENCC_LOADED=1

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_opencc.sh && build_OpenCC_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_OpenCC_for_dnf()
{
    # --------------------------------------------------------------------------
    local pkg_name="OpenCC";

    # https://github.com/BYVoid/OpenCC.git
    local app_url="https://github.com/BYVoid/OpenCC.git";

    local tmp_dir="/tmp";

    # /tmp/OpenCC
    local src_dir="/tmp/${pkg_name}";

    local local_lib_dir="/usr/local/lib"
    local local_lib64_dir="/usr/local/lib64"

    # /usr/local/lib64/pkgconfig/opencc.pc
    local pc_path="${local_lib64_dir}/pkgconfig/opencc.pc"
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
    local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="cmake"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # local app_name="gcc-c++"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # local app_name="make"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) opencc build
    git clone "${app_url}" "${src_dir}";

    pushd "${src_dir}"
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/local
    make -j$(nproc)
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf가 build시에 opencc을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z "${PKG_CONFIG_PATH}" ]]; then
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig"

    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib64_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion opencc
    # pkg-config --libs opencc
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${pkg_name} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================