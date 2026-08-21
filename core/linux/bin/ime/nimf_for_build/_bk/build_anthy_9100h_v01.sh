#!/bin/bash
set -e

[[ -n "${_BUILD_ANTHY_9100H_LOADED:-}" ]] && return 0
_BUILD_ANTHY_9100H_LOADED=1

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_anthy_9100h.sh && build_anthy-9100h_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_anthy-9100h_for_dnf()
{
    # --------------------------------------------------------------------------
    local pkg_name="anthy-9100h";

    # https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz
    local app_url="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/anthy/9100h-23ubuntu2/anthy_9100h.orig.tar.gz";

    local tmp_dir="/tmp";

    # /tmp/anthy-9100h
    local src_dir="/tmp/${pkg_name}";

    # /tmp/anthy-9100h/anthy-9100h.tar.gz
    local tgz_path="${src_dir}/${pkg_name}.tar.gz"

    local local_lib_dir="/usr/local/lib"

    # /usr/local/lib/pkgconfig/anthy.pc
    local pc_path="${local_lib_dir}/pkgconfig/anthy.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${pc_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";
    [[ -n $(dnf list --installed | grep -i ^pkg-config) ]] || dnf install -y pkg-config;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${src_dir}" ]] || mkdir -p "${src_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) anthy build
    wget "${app_url}" -O "${tgz_path}";
    tar -xzvf "${tgz_path}" -C "${src_dir}";

    # /tmp/m17n-db/anthy-9100h-1.8.0
    tgt_dir=$(ls -d "${src_dir}/*" | head -n 1)

    pushd "${tgt_dir}"
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) /usr/share/anthy symlink
    local src_anthy_dir="/usr/local/share/anthy"
    local dst_anthy_dir="/usr/share/anthy"

    if [[ -e "${src_anthy_dir}" ]] && [[ ! -e "${dst_anthy_dir}" ]]; then
        # ln -s /usr/local/share/anthy /usr/share/anthy
        ln -s "${src_anthy_dir}" "${dst_anthy_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) nimf가 build시에 anthy을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z "${PKG_CONFIG_PATH}" ]]; then
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig"

    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion anthy
    # pkg-config --libs anthy
    # --------------------------------------------------------------------------
}
# ==============================================================================