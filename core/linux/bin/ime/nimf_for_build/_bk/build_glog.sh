#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_glog.sh && build_glog_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_glog_for_dnf()
{
    # --------------------------------------------------------------------------
    local pkg_name="glog";

    # https://github.com/google/glog.git
    local app_url="https://github.com/google/glog.git";

    local tmp_dir="/tmp";

    # /tmp/glog
    local src_dir="/tmp/${pkg_name}";

    local local_lib64_dir="/usr/local/lib64"

    # /usr/local/lib/pkgconfig/glog.pc
    local pc_path="${local_lib64_dir}/pkgconfig/glog.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ -f "${pc_path}" ]]; then
    #     return 0
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list --installed | grep -i ^cmake) ]] || dnf install -y cmake;
    [[ -n $(dnf list --installed | grep -i ^glog-devel) ]] && dnf remove -y glog-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${tmp_dir} ]] || mkdir -p ${tmp_dir};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) glog build
    git clone ${app_url} ${src_dir};

    pushd ${src_dir}
    # rime has error because of "glog v0.5.0+"
    # git checkout v0.5.0
    # git checkout v0.4.0
    mkdir build && cd build

    # cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_GFLAGS=ON -DWITH_PKGCONFIG=ON -DCMAKE_PREFIX_PATH=/usr/local
    cmake .. -DCMAKE_BUILD_TYPE=Release \
        -DWITH_GFLAGS=ON \
        -DWITH_PKGCONFIG=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_PREFIX_PATH=/usr/local

    make -j$(nproc)
    make install
    ldconfig ${local_lib64_dir}
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) rime이 build시에 glog을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ ! -f "${local_lib64_dir}/pkgconfig/${pkg_name}.pc" ]]; then
        CONF_CMD="prefix=/usr/local
exec_prefix=${prefix}
libdir=${exec_prefix}/lib64
includedir=${prefix}/include

Name: glog
Description: Google logging library
Version: 0.4.0
Libs: -L${libdir} -lglog
Cflags: -I${includedir}
"
        echo "$CONF_CMD" > ${local_lib64_dir}/pkgconfig/${pkg_name}.pc
    fi

    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig"
    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib64_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion glog
    # pkg-config --libs glog
    # --------------------------------------------------------------------------
}
# ==============================================================================
