#!/bin/bash
set -e

[[ -n "${_BUILD_RIME_LOADED:-}" ]] && return 0
_BUILD_RIME_LOADED=1

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_rime.sh && build_rime_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_rime_for_dnf()
{
    # --------------------------------------------------------------------------
    local pkg_name="rime";

    # https://github.com/rime/librime.git
    local app_url="https://github.com/rime/librime.git";

    local tmp_dir="/tmp";

    # /tmp/rime
    local src_dir="/tmp/${pkg_name}";

    local local_lib_dir="/usr/local/lib"
    local local_lib64_dir="/usr/local/lib64"

    # /usr/local/lib64/pkgconfig/rime.pc
    local pc_path="${local_lib64_dir}/pkgconfig/rime.pc"
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
    local app_name="gtest-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="leveldb-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="boost-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="yaml-cpp-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="glog-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # rime needs "marisa-devel"
    # rime needs "opencc-devel"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) rime build시에 marisa-trie,opencc을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z "${PKG_CONFIG_PATH}" ]]; then
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig"

    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi


    if [[ -z "${PKG_CONFIG_PATH}" ]]; then
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig"
    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib64_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig:$PKG_CONFIG_PATH"

    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) rime build
    git clone "${app_url}" "${src_dir}";

    # Removing "IsGoogleLoggingInitialized" in setup.cc ~~~~~~~~~~~~~~~~~~~~~~~~
    # 90-96
    # vi librime/src/rime/setup.cc
    # ..........................................................................
    # if (google::IsGoogleLoggingInitialized()) {
    #     LOG(WARNING) << "Glog is already initialized.";
    # } else {
    #     google::InitGoogleLogging(app_name);
    # }
    # ..........................................................................
    local RIME_SETUP_PATH="${src_dir}/src/rime/setup.cc"

    if [[ -f "${RIME_SETUP_PATH}" ]]; then
        sed -i '/IsGoogleLoggingInitialized/{N;N;N;N;s/^/\/\//;s/\n/\n\/\//g}' "${RIME_SETUP_PATH}"
    fi
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    pushd "${src_dir}"
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    # cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TEST=OFF
    make -j$(nproc)
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # pkg-config --modversion rime
    # pkg-config --libs rime
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${pkg_name} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================
