#!/bin/bash

# nimf =========================================================================
# source ${CORE_BIN_DIR}/ime/install_nimf_for_build/install_nimf_for_build.sh
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime/install_nimf_for_build
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="nimf";

# https://github.com/hamonikr/nimf.git
URL="https://github.com/hamonikr/nimf.git"

TMP_DIR="/tmp";

# /tmp/nimf
SRC_DIR="/tmp/${NAME}";

LOCAL_LIB_DIR="/usr/local/lib"
LOCAL_LIB64_DIR="/usr/local/lib64"
LIB64_DIR="/usr/lib64"

# /usr/local/lib/pkgconfig/nimf.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/nimf.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
function build_nimf_for_dnf()
{
    # --------------------------------------------------------------------------
    # local NAME="nimf";

    # # https://github.com/hamonikr/nimf.git
    # local URL="https://github.com/hamonikr/nimf.git"

    # local TMP_DIR="/tmp";

    # # /tmp/nimf
    # local SRC_DIR="/tmp/${NAME}";

    # local LOCAL_LIB_DIR="/usr/local/lib"
    # local LOCAL_LIB64_DIR="/usr/local/lib64"

    # # /usr/local/lib/pkgconfig/nimf.pc
    # local PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/nimf.pc"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${PC_PATH}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
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
    pushd ${SRC_DIR}
    ./autogen.sh
    ./configure --prefix=/usr/local
    make -j "$(nproc)"
    make install
    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # pkg-config --modversion nimf
    # pkg-config --libs nimf
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
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
}
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        echo ""
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        build_nimf_for_dnf;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
