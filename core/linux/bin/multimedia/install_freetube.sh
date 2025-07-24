#!/bin/bash

# freetube ======================================================================
# bash /core/linux/bin/multimedia/install_freetube.sh;
# ==============================================================================

# ==============================================================================
# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
FT_NAME="freetube";

# /tmp/freetube
TMP_DIR="/tmp/${FT_NAME}";

# /opt/freetube
FT_DIR="/opt/${FT_NAME}";

FT_VER="0.23.5"

FT_ROOT_URL="https://github.com/FreeTubeApp/FreeTube/releases/download"

FT_ICON_URL="https://freetubeapp.io/images/iconWhite.png";

# freetube-icon.png
FT_ICON_NAME="${FT_NAME}-icon.png";
# ------------------------------------------------------------------------------
# ==============================================================================



# freetube : x86_64, aarch64 (deb, rpm) ========================================
function install_freetube_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^freetube) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then
        # freetube_0.23.5_amd64.deb
        local FNAME="${FT_NAME}_${FT_VER}_amd64.deb";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # freetube_0.23.5_arm64.deb
        local FNAME="${FT_NAME}_${FT_VER}_arm64.deb";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube_0.23.5_amd64.deb
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube_0.23.5_arm64.deb
    local SRC_URL="${FT_ROOT_URL}/v${FT_VER}-beta/${FNAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/freetube/freetube_0.23.5_amd64.deb
    # /tmp/freetube/freetube_0.23.5_arm64.deb
    local SRC_PATH="${TMP_DIR}/${FNAME}"

    if [[ ! -e ${SRC_PATH} ]]; then
        # /tmp/freetube
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};

        wget "${SRC_URL}" -O "${SRC_PATH}"
    fi

    apt install -y ${SRC_PATH}
    # --------------------------------------------------------------------------
}


function install_freetube_for_rpm()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^freetube) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then
        # freetube-0.23.5.amd64.rpm
        local FNAME="${FT_NAME}_${FT_VER}_amd64.rpm";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # freetube_0.23.5_arm64.rpm
        local FNAME="${FT_NAME}_${FT_VER}_arm64.rpm";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube_0.23.5_amd64.rpm
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube_0.23.5_arm64.rpm
    local SRC_URL="${FT_ROOT_URL}/v${FT_VER}-beta/${FNAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/freetube/freetube_0.23.5_amd64.rpm
    # /tmp/freetube/freetube_0.23.5_arm64.rpm
    local SRC_PATH="${TMP_DIR}/${FNAME}"

    if [[ ! -e ${SRC_PATH} ]]; then
        # /tmp/freetube
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};

        wget "${SRC_URL}" -O "${SRC_PATH}"
    fi

    dnf install -y ${SRC_PATH}
    # --------------------------------------------------------------------------
}
# ==============================================================================



# freetube : x86_64, aarch64 (flatpak) =========================================
function install_freetube_for_flatpak()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
        [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;

    elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        [[ -n $(dnf list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # flatpak run io.freetubeapp.FreeTube
    [[ -n $(flatpak list --app | grep -i FreeTube) ]] || flatpak install -y flathub io.freetubeapp.FreeTube
    # --------------------------------------------------------------------------
}
# ==============================================================================



# freetube : x86_64, aarch64 (appimage, portable-zip) ==========================
function set_desktop()
{
    # --------------------------------------------------------------------------
    local EXEC_PATH=${1}
    local ICON_PATH=${2}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /opt/freetube/freetube-icon.png
    wget ${FT_ICON_URL} -O ${ICON_PATH};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------       
    local DESKTOP_CMD="[Desktop Entry]
Encoding=UTF-8
Name=${FT_NAME}
Comment=Watch YouTube videos without ads and tracking
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Terminal=false
Type=Application
Categories=AudioVideo;Player";

    # /usr/share/applications/freetube.deskop
    local DESKTOP_PATH="/usr/share/applications/${FT_NAME}.desktop";

    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    # --------------------------------------------------------------------------
}


function install_freetube_for_portable()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi

    # /opt/freetube
    if [[ -e ${FT_DIR} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then
        # freetube-0.23.5-linux-x64-portable.zip
        local FNAME="${FT_NAME}-${FT_VER}-linux-x64-portable.zip";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # freetube-0.23.5-linux-arm64-portable.zip
        local FNAME="${FT_NAME}-${FT_VER}-linux-arm64-portable.zip";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-x64-portable.zip
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-arm64-portable.zip
    local SRC_URL="${FT_ROOT_URL}/v${FT_VER}-beta/${FNAME}";
    # --------------------------------------------------------------------------

    # 2) ZIP_PATH --------------------------------------------------------------
    if [[ ! -e "${TMP_DIR}" ]]; then
        # /tmp/freetube
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi
      
    # /tmp/freetube/freetube-0.23.5-linux-x64-portable.zip
    # /tmp/freetube/freetube-0.23.5-linux-arm64-portable.zip
    local ZIP_PATH="${TMP_DIR}/${FNAME}";
    
    if [[ ! -e "${ZIP_PATH}" ]]; then
        wget "${SRC_URL}" -O "${ZIP_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 3) FT_DIR ----------------------------------------------------------------   
    # unzip /core/linux/src/freetube/freetube-0.23.5-linux-x64-portable.zip -d /opt/freetube;
    unzip "${ZIP_PATH}" -d ${FT_DIR};
    rm -f "${ZIP_PATH}";
    
    # /opt/freetube
    if [[ ! -d "${FT_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 4) DESKTOP_PATH ----------------------------------------------------------
    # /opt/freetube/freetube
    local EXEC_PATH="${FT_DIR}/${FT_NAME}"

    # /opt/freetube/freetube-icon.png
    local ICON_PATH="${FT_DIR}/${FT_ICON_NAME}";

    set_desktop ${EXEC_PATH} ${ICON_PATH};
    # --------------------------------------------------------------------------
}


function install_freetube_for_appimg()
{
    # appimage for only x86_64 -------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi

    # /opt/freetube
    if [[ -e "${FT_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then
        # FreeTube-0.23.5-amd64.AppImage
        local FNAME="FreeTube-${FT_VER}-amd64.AppImage";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # FreeTube-0.23.5-arm64.AppImage
        local FNAME="FreeTube-${FT_VER}-arm64.AppImage";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-amd64.AppImage
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-arm64.AppImage
    local SRC_URL="${FT_ROOT_URL}/v${FT_VER}-beta/${FNAME}";

    # 2) EXEC_PATH -------------------------------------------------------------
    # /opt/freetube/FreeTube-0.23.5-amd64.AppImage
    # /opt/freetube/FreeTube-0.23.5-arm64.AppImage
    local EXEC_PATH="${FT_DIR}/${FNAME}";

    # /opt/freetube
    mkdir -p ${FT_DIR};

    wget ${SRC_URL} -O ${EXEC_PATH};
    chmod +x ${EXEC_PATH};
    # --------------------------------------------------------------------------

    # 3) ICON_PATH -------------------------------------------------------------
    # /opt/freetube/freetube-icon.png
    local ICON_PATH="${FT_DIR}/${FT_ICON_NAME}";
    # --------------------------------------------------------------------------

    # 4) DESKTOP_PATH ----------------------------------------------------------    
    set_desktop ${EXEC_PATH} ${ICON_PATH};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# ==============================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_freetube_for_deb;
    # install_freetube_for_flatpak;
    # install_freetube_for_portable;
    # install_freetube_for_appimg;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_freetube_for_rpm;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0