#!/bin/bash
set -e

[[ -n "${_BUILD_ANTHY_LOADED:-}" ]] && return 0
_BUILD_ANTHY_LOADED=1

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/gui/nimf_for_build/build_anthy.sh && build_anthy_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function get_core_bin_dir_from_nimf-for-build()
{
    # /core/linux/bin/ime/gui/nimf_for_build
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}


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
    # local app_name="Development Tools"; dnf group install -y "${app_name}";
    local core_bin_dir=$(get_core_bin_dir_from_nimf-for-build);
    bash ${core_bin_dir}/develop/cli/install_base-devel.sh;

    local app_name="gettext-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) anthy build
    git clone "${app_url}" "${src_dir}";

    pushd "${src_dir}"
    ./autogen.sh
    ./configure
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) nimf가 build시에 anthy을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z "${PKG_CONFIG_PATH}" ]]; then
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig"
    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================