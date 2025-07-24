#!/bin/bash

# doublecmd ====================================================================
# bash /core/linux/bin/filemgr/install_doublecmd.sh;
# ==============================================================================

# ==============================================================================
# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
DC_NAME="doublecmd";

# /tmp/doublecmd
TMP_DIR="/tmp/${DC_NAME}";

# /opt/doublecmd
OPT_DIR="/opt"
DC_DIR="${OPT_DIR}/${DC_NAME}";

# https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz/download
DC_VER="1.1.26";

DC_ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";

# doublecmd.png
DC_ICON_NAME="${DC_NAME}.png";
# ------------------------------------------------------------------------------
# ==============================================================================



# file-manager : x86_64, aarch64, i686 =========================================
function set_desktop()
{
    # --------------------------------------------------------------------------
    local EXEC_PATH=${1}
    local ICON_PATH=${2}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /opt/doublecmd/doublecmd.png
    wget ${DC_ICON_URL} -O ${ICON_PATH};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local DESKTOP_CMD="[Desktop Entry]
Encoding=UTF-8
Name=${DC_NAME}
Comment=${DC_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Terminal=false
Type=Application
Categories=System;FileTools;Utility;Core;GTK;FileManager;Development";

    # /usr/share/applications/doublecmd.deskop
    local DESKTOP_PATH="/usr/share/applications/${DC_NAME}.desktop";

    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    # --------------------------------------------------------------------------
}


function install_dc_portable()
{
    # --------------------------------------------------------------------------
    # /opt/doublecmd
    if [[ -d "${DC_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    # "https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz"
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${DC_VER}.gtk2.aarch64.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${DC_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${DC_VER}.gtk2.i386.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2032%20bit/Double%20Commander%20${DC_VER}/${FNAME}"        
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${DC_VER}.gtk2.x86_64.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${DC_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 2) ZIP_PATH --------------------------------------------------------------
    if [[ ! -e "${TMP_DIR}" ]]; then
        # /tmp/doublecmd
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi
    
    # /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz
    ZIP_PATH="${TMP_DIR}/${FNAME}"
    
    if [[ ! -e "${ZIP_PATH}" ]]; then
        wget "${SRC_URL}" -O "${ZIP_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 3) DC_DIR ----------------------------------------------------------------
    # tar -Jxvf /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz -C /opt;   
    tar -Jxvf "${ZIP_PATH}" -C ${OPT_DIR};
    rm -f "${ZIP_PATH}";

    # /opt/doublecmd
    if [[ ! -d "${DC_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 4) DESKTOP_PATH ----------------------------------------------------------
    # /opt/doublecmd/doublecmd
    local EXEC_PATH="${DC_DIR}/${DC_NAME}"

    # /opt/doublecmd/doublecmd.png
    local ICON_PATH="${DC_DIR}/${DC_ICON_NAME}";

    set_desktop ${EXEC_PATH} ${ICON_PATH};
    # --------------------------------------------------------------------------
}


function install_dc_for_appimg()
{
    # appimage for only x86_64 -------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # /opt/doublecmd
    if [[ -e "${DC_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    local FNAME="doublecmd-gtk-latest-x86_64.AppImage";

    # https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage
    local SRC_URL="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/${FNAME}";
    # --------------------------------------------------------------------------

    # 2) EXEC_PATH -------------------------------------------------------------
    # /opt/doublecmd/doublecmd-gtk-latest-x86_64.AppImage
    local EXEC_PATH="${DC_DIR}/${FNAME}"

    # /opt/doublecmd
    mkdir -p ${DC_DIR};

    wget ${SRC_URL} -O ${EXEC_PATH};
    chmod +x ${EXEC_PATH};
    # --------------------------------------------------------------------------

    # 3) ICON_PATH -------------------------------------------------------------
    # /opt/doublecmd/doublecmd.png
    local ICON_PATH="${DC_DIR}/${DC_ICON_NAME}";
    # --------------------------------------------------------------------------
    
    # 4) DESKTOP_PATH ----------------------------------------------------------    
    set_desktop ${EXEC_PATH} ${ICON_PATH};
    # --------------------------------------------------------------------------
}


# ------------------------------------------------------------------------------
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^doublecmd) ]] || apt install -y doublecmd-gtk;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "";
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        install_dc_portable;
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        install_dc_portable;
    else
        install_dc_for_appimg;
    fi
    # --------------------------------------------------------------------------
fi
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0