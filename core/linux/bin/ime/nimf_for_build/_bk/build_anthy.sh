#!/bin/bash
set -e

[[ -n "${_BUILD_ANTHY_LOADED:-}" ]] && return 0
_BUILD_ANTHY_LOADED=1

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_anthy.sh && build_anthy_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_anthy_for_dnf()
{
    # --------------------------------------------------------------------------
    local pkg_name="anthy";

    # https://salsa.debian.org/gniibe/anthy.git
    local app_url="https://salsa.debian.org/gniibe/anthy.git";

    local tmp_dir="/tmp";

    # /tmp/anthy
    local src_dir="/tmp/${pkg_name}";

    local local_lib_dir="/usr/local/lib"

    # /usr/local/lib/pkgconfig/anthy.pc
    local pc_path="${local_lib_dir}/pkgconfig/anthy.pc"
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
    [[ -n $(dnf list --installed | grep -i ^automake) ]] || dnf install -y automake;
    [[ -n $(dnf list --installed | grep -i ^autoconf) ]] || dnf install -y autoconf;
    [[ -n $(dnf list --installed | grep -i ^libtool) ]] || dnf install -y libtool;
    [[ -n $(dnf list --installed | grep -i ^gettext-devel) ]] || dnf install -y gettext-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${tmp_dir} ]] || mkdir -p ${tmp_dir};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) anthy build
    git clone ${app_url} ${src_dir};

    pushd ${src_dir}
    ./autogen.sh
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) nimf가 build시에 anthy을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig"
    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================