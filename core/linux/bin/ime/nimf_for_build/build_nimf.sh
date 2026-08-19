#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_nimf.sh && build_nimf_for_dnf "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_nimf_for_dnf()
{
    # --------------------------------------------------------------------------
    local cur_user=${1}
    local home_dir=$(eval echo ~${cur_user});

    local nix_dir="${home_dir}/.nix-profile"
    local nix_lib_dir="${nix_dir}/lib"
    local nix_share_dir="${nix_dir}/share"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local pkg_name="nimf";

    # https://github.com/hamonikr/nimf.git
    local app_url="https://github.com/hamonikr/nimf.git"

    local tmp_dir="/tmp";

    # /tmp/nimf
    local src_dir="/tmp/${pkg_name}";

    local local_lib_dir="/usr/local/lib"
    local local_lib64_dir="/usr/local/lib64"
    local LIB64_DIR="/usr/lib64"

    local local_share_dir="/usr/local/share"

    # /usr/local/lib/pkgconfig/nimf.pc
    local pc_path="${local_lib_dir}/pkgconfig/nimf.pc"
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
    local app_name="gtk-doc"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="gtk2-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="gtk3-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="wayland-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="wayland-protocols-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libxkbcommon-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libayatana-appindicator-gtk3-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libxklavier-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # nimf needs "libhangul"
    # nimf needs "m17n-lib"
    # nimf needs "m17n-db"
    # nimf needs "anthy"
    # nimf needs "rime"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) nimf가 build시에 언어엔진을 인식할 수 있도록 pkgconfig 경로 등록 (for native)

    # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:$PKG_CONFIG_PATH
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig"

    # /usr/local/lib/pkgconfig : m17n-core.pc, anthy.pc
    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # /usr/local/lib64/pkgconfig : marisa.pc, opencc.pc, rime.pc
    if [[ "${PKG_CONFIG_PATH}" != *"${local_lib64_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib64_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # /usr/lib64/pkgconfig : libhangul.pc
    if [[ "${PKG_CONFIG_PATH}" != *"${LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # /usr/local/share/pkgconfig : m17n-db.pc
    if [[ "${PKG_CONFIG_PATH}" != *"${local_share_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/share/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_share_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) nimf가 build시에 언어엔진을 인식할 수 있도록 pkgconfig 경로 등록 (for nixpkg)
    # ~/.nix-profile/lib/pkgconfig : anthy.pc, libhangul.pc, m17n-core.pc, rime.pc
    if [[ "${PKG_CONFIG_PATH}" != *"${nix_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=~/.nix-profile/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${nix_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # ~/.nix-profile/share/pkgconfig : m17n-db.pc
    if [[ "${PKG_CONFIG_PATH}" != *"${nix_share_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=~/.nix-profile/share/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${nix_share_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${tmp_dir} ]] || mkdir -p ${tmp_dir};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d ${src_dir} ]]; then
        rm -rf ${src_dir}
    fi

    git clone "${app_url}" "${src_dir}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nimf/modules/engines/Makefile.am
    # nimf/configure.ac
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf build
    pushd ${src_dir}
    ./autogen.sh

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 방법1) all languages를 사용한다.
    # ./configure --prefix=/usr/local
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 방법2) libhangul 만을 사용한다 (anthy(japanese), m17n(muliti), rime(chinese)를 사용하지 않는다.)
    ./configure --prefix=/usr/local \
        --disable-nimf-anthy \
        --disable-nimf-m17n \
        --disable-nimf-rime \
        --enable-nimf-libhangul
        # NIMF_ANTHY_DEPS_CFLAGS=" " \
        # NIMF_ANTHY_DEPS_LIBS=" "
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    make -j "$(nproc)"
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # pkg-config --modversion nimf
    # pkg-config --libs nimf
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nimf ui를 제대로 띄울수 있도록 수정
    # nimf-settings needs this schema
    local SCH_SRC_PATH1="${src_dir}/.schemas/org.nimf.clients.qt5.gschema.xml";
    local SCH_SRC_PATH2="${src_dir}/.schemas/org.nimf.clients.qt6.gschema.xml";
    local SCH_DST_DIR="/usr/local/share/glib-2.0/schemas";

    if [[ -f "${SCH_SRC_PATH1}" ]]; then
        cp -f "${SCH_SRC_PATH1}" "${SCH_DST_DIR}/"
    fi
    if [[ -f "${SCH_SRC_PATH2}" ]]; then
        cp -f "${SCH_SRC_PATH2}" "${SCH_DST_DIR}/"
    fi

    glib-compile-schemas "${SCH_DST_DIR}"
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${pkg_name} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================