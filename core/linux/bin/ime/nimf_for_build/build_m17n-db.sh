#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/build_m17n-db.sh && build_m17n-db_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_m17n-db_for_dnf()
{
    # --------------------------------------------------------------------------
    local pkg_name="m17n-db";

    # https://github.com/deepin-community/m17n-db

    # https://packages.debian.org/bookworm/source/m17n-db
    # http://deb.debian.org/debian/pool/main/m/m17n-db/m17n-db_1.8.0.orig.tar.gz
    # local app_url="http://deb.debian.org/debian/pool/main/m/m17n-db/m17n-db_1.8.0.orig.tar.gz"

    # # https://download-mirror.savannah.gnu.org/releases/m17n/
    # https://download-mirror.savannah.gnu.org/releases/m17n/m17n-db-1.8.0.tar.gz
    local app_url="https://download-mirror.savannah.gnu.org/releases/m17n/m17n-db-1.8.0.tar.gz";


    local tmp_dir="/tmp";

    # /tmp/m17n-db
    local src_dir="/tmp/${pkg_name}";

    # /tmp/m17n-db/m17n-db.tar.gz
    local tgz_path="${src_dir}/${pkg_name}.tar.gz"

    local local_lib_dir="/usr/local/lib"

    # /usr/local/share/pkgconfig/m17n-db.pc
    local pc_path="/usr/local/share/pkgconfig/m17n-db.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${pc_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 의존성 패키지 설치
    [[ -n $(dnf group list --installed | grep "Development Tools") ]] || dnf groupinstall -y "Development Tools";

    local app_name="pkg-config"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    local app_name="autoconf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    local app_name="automake"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    local app_name="libtool"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    local app_name="gettext-devel"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${src_dir} ]] || mkdir -p ${src_dir};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) m17n-db build
    wget ${app_url} -O ${tgz_path};
    tar -xvf "${tgz_path}" -C ${src_dir};

    # /tmp/m17n-db/m17n-db-1.8.0
    tgt_dir=$(ls -d ${src_dir}/* | head -n 1)

    pushd "${tgt_dir}"
    ./get-glibc.sh
    ./configure --with-charmaps=./glibc-2.3.2/localedata/charmaps
    make
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf가 build시에 m17n-db을 인식할 수 있도록 pkgconfig 경로 등록
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig"

    elif [[ "${PKG_CONFIG_PATH}" != *"${local_lib_dir}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${local_lib_dir}/pkgconfig:$PKG_CONFIG_PATH"
    fi

    # pkg-config --modversion m17n-db
    # pkg-config --libs m17n-db
    # --------------------------------------------------------------------------

    echo "---------------------------------------------------------------------"
    echo "${pkg_name} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================