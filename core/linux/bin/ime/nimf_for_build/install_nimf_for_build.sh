#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/nimf_for_build/install_nimf_for_build.sh && build_nimf_for_dnf;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function build_nimf_for_dnf()
{
    # --------------------------------------------------------------------------
    local NAME="nimf";

    # https://github.com/hamonikr/nimf.git
    local URL="https://github.com/hamonikr/nimf.git"

    local TMP_DIR="/tmp";

    # /tmp/nimf
    local SRC_DIR="/tmp/${NAME}";

    local LOCAL_LIB_DIR="/usr/local/lib"
    local LOCAL_LIB64_DIR="/usr/local/lib64"
    local LIB64_DIR="/usr/lib64"

    # /usr/local/lib/pkgconfig/nimf.pc
    local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/nimf.pc"
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
    [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
    [[ -n $(dnf list --installed | grep -i ^gtk-doc) ]] || dnf install -y gtk-doc;
    [[ -n $(dnf list --installed | grep -i ^gtk2-devel) ]] || dnf install -y gtk2-devel;
    [[ -n $(dnf list --installed | grep -i ^gtk3-devel) ]] || dnf install -y gtk3-devel;
    [[ -n $(dnf list --installed | grep -i ^wayland-devel) ]] || dnf install -y wayland-devel;
    [[ -n $(dnf list --installed | grep -i ^wayland-protocols-devel) ]] || dnf install -y wayland-protocols-devel;
    [[ -n $(dnf list --installed | grep -i ^libxkbcommon-devel) ]] || dnf install -y libxkbcommon-devel;
    [[ -n $(dnf list --installed | grep -i ^libayatana-appindicator-gtk3-devel) ]] || dnf install -y libayatana-appindicator-gtk3-devel;
    [[ -n $(dnf list --installed | grep -i ^libxklavier-devel) ]] || dnf install -y libxklavier-devel;
    # nimf needs "libhangul"
    # nimf needs "m17n-lib"
    # nimf needs "m17n-db"
    # nimf needs "anthy"
    # nimf needs "rime"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) nimf가 build시에 언어엔진을 인식할 수 있도록 pkgconfig 경로 등록
    # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:$PKG_CONFIG_PATH
    if [[ -z ${PKG_CONFIG_PATH} ]]; then
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig"

    elif [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi


    if [[ *"${PKG_CONFIG_PATH}"* != *"${LOCAL_LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LOCAL_LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi


    if [[ *"${PKG_CONFIG_PATH}"* != *"${LIB64_DIR}/pkgconfig"* ]]; then
        # export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:$PKG_CONFIG_PATH
        export PKG_CONFIG_PATH="${LIB64_DIR}/pkgconfig:$PKG_CONFIG_PATH"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    git clone "${URL}" "${SRC_DIR}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nimf/modules/engines/Makefile.am
    # nimf/configure.ac
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) nimf build
    pushd ${SRC_DIR}
    ./autogen.sh

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 방법1) all languages를 사용한다.
    # ./configure --prefix=/usr/local
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # 방법2) anthy(japanese), rime(chinese)를 사용하지 않는다.
    ./configure --prefix=/usr/local \
        --disable-nimf-anthy \
        --disable-nimf-rime \
        --disable-nimf-m17n \
        --enable-nimf-libhangul
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
    local SCH_SRC_PATH1="${SRC_DIR}/.schemas/org.nimf.clients.qt5.gschema.xml";
    local SCH_SRC_PATH2="${SRC_DIR}/.schemas/org.nimf.clients.qt6.gschema.xml";
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
    echo "${NAME} installed";
    date;
    echo "---------------------------------------------------------------------"
}
# ==============================================================================



# Main =========================================================================

# ==============================================================================
