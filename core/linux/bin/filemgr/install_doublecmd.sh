#!/bin/bash

# ==============================================================================
# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
NAME="doublecmd";

OPT_DIR="/opt";

# /opt/doublecmd
DC_DIR="${OPT_DIR}/${NAME}";

PORT_VER="1.1.16";

ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";

# doublecmd.png
ICON_NAME="${NAME}.png";

# /usr/share/applications/doublecmd.deskop
DESKTOP_PATH="/usr/share/applications/${NAME}.desktop";
# ------------------------------------------------------------------------------
# ==============================================================================



# file-manager : x86_64, aarch64, i686 =========================================
function get_desktop_cmd()
{
    local EXEC_PATH=${1}
    
    # desktop_cmd --------------------------------------------------------------
    local DESKTOP_CMD="[Desktop Entry]
Encoding=UTF-8
Name=${NAME}
Comment=${NAME}
Exec=${EXEC_PATH}
Icon=${DC_DIR}/${ICON_NAME}
Terminal=false
Type=Application
Categories=System;FileTools;Utility;Core;GTK;FileManager;Development";
    # --------------------------------------------------------------------------
    
    echo "${DESKTOP_CMD}"
}


function install_dc_port()
{
    # --------------------------------------------------------------------------
    # /opt/doublecmd
    if [[ -d "${DC_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------
    
    # port_url -----------------------------------------------------------------
    # "https://versaweb.dl.sourceforge.net/project/doublecmd/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.16/doublecmd-1.1.16.gtk2.x86_64.tar.xz"
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # ----------------------------------------------------------------------
        local PORT_NAME="doublecmd-${PORT_VER}.gtk2.aarch64.tar.xz";
        local PORT_URL="https://versaweb.dl.sourceforge.net/project/doublecmd/DC%20for%20Linux%2064%20bit/Double%20Commander%20${PORT_VER}/${PORT_NAME}"
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        # ----------------------------------------------------------------------
        local PORT_NAME="doublecmd-${PORT_VER}.gtk2.i386.tar.xz";
        local PORT_URL="https://versaweb.dl.sourceforge.net/project/doublecmd/DC%20for%20Linux%2032%20bit/Double%20Commander%20${PORT_VER}/${PORT_NAME}"
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        local PORT_NAME="doublecmd-${PORT_VER}.gtk2.x86_64.tar.xz";
        local PORT_URL="https://jaist.dl.sourceforge.net/project/doublecmd/DC%20for%20Linux%2064%20bit/Double%20Commander%20${PORT_VER}/${PORT_NAME}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # dc_port ------------------------------------------------------------------
    # /opt/doublecmd-1.1.16.gtk2.x86_64.tar.xz
    wget "${PORT_URL}" -O "${OPT_DIR}/${PORT_NAME}";
    if [[ -f "${OPT_DIR}/${PORT_NAME}" ]]; then
        tar -Jxvf "${OPT_DIR}/${PORT_NAME}" -C ${OPT_DIR};
        rm -f "${OPT_DIR}/${PORT_NAME}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /opt/doublecmd
    if [[ ! -d "${DC_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------
    
    # dc_icon ------------------------------------------------------------------
    # /opt/doublecmd/doublecmd.png
    wget ${ICON_URL} -O ${DC_DIR}/${ICON_NAME};
    # --------------------------------------------------------------------------
    
    # dc_desktop ---------------------------------------------------------------   
    # /opt/doublecmd/doublecmd
    local EXEC_PATH="${DC_DIR}/${NAME}"
    local DESKTOP_CMD=$(get_desktop_cmd ${EXEC_PATH})
    # --------------------------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    # --------------------------------------------------------------------------
}


function install_dc_appimg()
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

    # appimage_url -------------------------------------------------------------
    local APPIMG_NAME="doublecmd-gtk-latest-x86_64.AppImage";
    
    # https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage
    local APPIMG_URL="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/${APPIMG_NAME}";
    # --------------------------------------------------------------------------

    # dc_appimage --------------------------------------------------------------
    # appimage dir : /opt/doublecmd
    mkdir -p ${DC_DIR};
    
    # appimage path : /opt/doublecmd/doublecmd-gtk-latest-x86_64.AppImage
    wget ${APPIMG_URL} -O ${DC_DIR}/${APPIMG_NAME};
    chmod +x ${DC_DIR}/${APPIMG_NAME};
    # --------------------------------------------------------------------------
    
    # dc_icon ------------------------------------------------------------------
    # icon path : /opt/doublecmd/doublecmd.png
    wget ${ICON_URL} -O ${DC_DIR}/${ICON_NAME};
    # --------------------------------------------------------------------------
    
    # dc_desktop ---------------------------------------------------------------
    # /opt/doublecmd/doublecmd-gtk-latest-x86_64.AppImage
    local EXEC_PATH="${DC_DIR}/${APPIMG_NAME}"
    local DESKTOP_CMD=$(get_desktop_cmd ${EXEC_PATH})
        
    # desktop path : /usr/share/applications/doublecmd.deskop
    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
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
        install_dc_port;
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        install_dc_port;
    else
        install_dc_appimg;
    fi
    # --------------------------------------------------------------------------
fi
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0