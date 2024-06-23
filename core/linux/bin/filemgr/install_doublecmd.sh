#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================

# file-manager : x86_64 ========================================================
function install_dc_appimg()
{
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    local APP_NAME="doublecmd";

    local APP_IMG_DIR="/opt/${APP_NAME}";
    local APP_IMG_NAME="doublecmd-gtk-latest-x86_64.AppImage";
    # https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage
    local APP_IMG_URL="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/${APP_IMG_NAME}}";

    local ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";
    local ICON_NAME="${APP_NAME}.png";

    local DESKTOP_PATH="/usr/share/applications/${APP_NAME}.desktop";
    local DESKTOP_CMD="[Desktop Entry]
Name=${APP_NAME}
Comment=${APP_NAME}
Exec=${APP_IMG_DIR}/${APP_IMG_NAME}
Icon=${APP_IMG_DIR}/${ICON_NAME}
Terminal=false
Type=Application
Categories=Development";

    if [[ -e "${APP_IMG_DIR}" ]]; then
        return
    fi

    # appimage dir
    mkdir -p ${APP_IMG_DIR};
    
    # appimage path
    wget ${APP_IMG_URL} -O ${APP_IMG_DIR}/${APP_IMG_NAME};
    chmod +x ${APP_IMG_DIR}/${APP_IMG_NAME};
    
    # icon path
    wget ${ICON_URL} -O ${APP_IMG_DIR}/${ICON_NAME};
    
    # desktop path
    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^doublecmd) ]] || apt install -y doublecmd-gtk;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    # install_dc_appimg;
    echo "";
fi
# ==============================================================================

exit 0