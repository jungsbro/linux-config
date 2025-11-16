#!/bin/bash

# doublecmd ====================================================================
# bash /core/linux/bin/filemgr/install_doublecmd.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="doublecmd";

# doublecmd
APP_UNIQUE_NAME="${APP_NAME}"

# /tmp/doublecmd
TMP_DIR="/tmp/${APP_NAME}";

# /opt/doublecmd
OPT_DIR="/opt"
APP_DIR="${OPT_DIR}/${APP_NAME}";

# https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz/download
APP_VER="1.1.26";

APP_ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";

# doublecmd.png
APP_ICON_NAME="${APP_UNIQUE_NAME}.png";

APP_GRP="System;FileTools;Utility;Core;GTK;FileManager;Development"
# ------------------------------------------------------------------------------
# ==============================================================================



# file-manager : x86_64, aarch64, i686 (portable, appimage) ====================
function set_desktop()
{
    # args ---------------------------------------------------------------------
    # ${APP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------
    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}
Terminal=false
Encoding=UTF-8
Comment=${APP_NAME}";

    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
}

function install_dc_for_portable()
{
    # --------------------------------------------------------------------------
    # /opt/doublecmd
    if [[ -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    # "https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz"
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${APP_VER}.gtk2.aarch64.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${APP_VER}.gtk2.i386.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2032%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${APP_VER}.gtk2.x86_64.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
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

    # 3) APP_DIR ----------------------------------------------------------------
    # tar -Jxvf /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz -C /opt;
    tar -Jxvf "${ZIP_PATH}" -C ${OPT_DIR};
    rm -f "${ZIP_PATH}";

    # /opt/doublecmd
    if [[ ! -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 4) EXEC_PATH -------------------------------------------------------------
    # /opt/doublecmd/doublecmd
    local EXEC_PATH="${APP_DIR}/${APP_NAME}"
    # --------------------------------------------------------------------------

    # 5) ICON_PATH -------------------------------------------------------------
    # 5-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/doublecmd/doublecmd.png
    # local ICON_PATH="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${ICON_PATH};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 5-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/doublecmd.svg
    local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 6) DESKTOP_PATH ----------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    set_desktop;
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
    if [[ -e "${APP_DIR}" ]]; then
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
    local EXEC_PATH="${APP_DIR}/${FNAME}"

    # /opt/doublecmd
    mkdir -p ${APP_DIR};

    wget ${SRC_URL} -O ${EXEC_PATH};
    chmod +x ${EXEC_PATH};
    # --------------------------------------------------------------------------

    # 3) ICON_PATH -------------------------------------------------------------
    # 3-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/doublecmd/doublecmd.png
    # local ICON_PATH="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${ICON_PATH};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 3-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/doublecmd.svg
    local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 4) DESKTOP_PATH ----------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    set_desktop;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
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
        install_dc_for_portable;
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        install_dc_for_portable;
    else                        # x86_64
        install_dc_for_portable;
        # install_dc_for_appimg;
    fi
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0