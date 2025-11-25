#!/bin/bash

# freetube ======================================================================
# bash /core/linux/bin/multimedia/install_freetube.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="freetube";

# freetube
APP_UNIQUE_NAME="${APP_NAME}"

# /tmp/freetube
TMP_DIR="/tmp/${APP_NAME}";

# /opt/freetube
APP_DIR="/opt/${APP_NAME}";

APP_VER="0.23.5"

APP_ROOT_URL="https://github.com/FreeTubeApp/FreeTube/releases/download"

APP_ICON_URL="https://freetubeapp.io/images/iconWhite.png";

# freetube-icon.png
APP_ICON_NAME="${APP_UNIQUE_NAME}-icon.png";

APP_GRP="AudioVideo;Player"
# ------------------------------------------------------------------------------
# ==============================================================================



# func =========================================================================
function install_freetube_for_deb()
{
    # --------------------------------------------------------------------------
    # for x86_64, aarch64
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
        local FNAME="${APP_NAME}_${APP_VER}_amd64.deb";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # freetube_0.23.5_arm64.deb
        local FNAME="${APP_NAME}_${APP_VER}_arm64.deb";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube_0.23.5_amd64.deb
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube_0.23.5_arm64.deb
    local SRC_URL="${APP_ROOT_URL}/v${APP_VER}-beta/${FNAME}"
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
    # for x86_64, aarch64
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
        local FNAME="${APP_NAME}-${APP_VER}.amd64.rpm";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # freetube-0.23.5_arm64.rpm
        local FNAME="${APP_NAME}-${APP_VER}.arm64.rpm";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5.amd64.rpm
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5.arm64.rpm
    local SRC_URL="${APP_ROOT_URL}/v${APP_VER}-beta/${FNAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/freetube/freetube-0.23.5.amd64.rpm
    # /tmp/freetube/freetube-0.23.5.arm64.rpm
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


function install_freetube_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="freetube"
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_freetube --------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.freetube
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -q | grep -iq ^${APP_NAME} || \
    nix-env -iA nixpkgs.${APP_NAME}"
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "freetube" \
    )

    local src_dir="${HOME_DIR}/.nix-profile/bin"
    local dst_dir="/usr/local/bin"

    for cur_fname in "${FNAME_LIST[@]}";
    do
        src_path="${src_dir}/${cur_fname}";
        if [[ ! -f ${src_path} ]]; then
            continue
        fi

        dst_path="${dst_dir}/${cur_fname}";
        if [[ -f ${dst_path} ]]; then
            continue
        fi

        ln -s ${src_path} ${dst_path};
    done
    # --------------------------------------------------------------------------

    # 5) desktop settings ------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/applications"
    local dst_dir="/usr/local/share/applications"

    mkdir -p "${dst_dir}"
    # -u : update
    # -L : dereference
    cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

    update-desktop-database "${dst_dir}"
    # --------------------------------------------------------------------------

    # 6) icon settngs ----------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/icons"
    local dst_dir="/usr/share/icons"

    mkdir -p "${dst_dir}"
    # -r : recursive
    # -u : update
    cp -ru ${src_dir}/* "${dst_dir}/"

    gtk-update-icon-cache "${dst_dir}" 2>/dev/null
    # --------------------------------------------------------------------------
}


function install_freetube_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(yum list installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # flatpak run io.freetubeapp.FreeTube
    [[ -n $(flatpak list --app | grep -i FreeTube) ]] || flatpak install -y flathub io.freetubeapp.FreeTube
    # --------------------------------------------------------------------------
}
# ==============================================================================



# appimage, portable-zip : x86_64, aarch64 =====================================
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
Comment=Watch YouTube videos without ads and tracking";

    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
}


function install_freetube_for_portable()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi

    # /opt/freetube
    if [[ -e ${APP_DIR} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then
        # freetube-0.23.5-linux-x64-portable.zip
        local FNAME="${APP_NAME}-${APP_VER}-linux-x64-portable.zip";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # freetube-0.23.5-linux-arm64-portable.zip
        local FNAME="${APP_NAME}-${APP_VER}-linux-arm64-portable.zip";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-x64-portable.zip
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-arm64-portable.zip
    local SRC_URL="${APP_ROOT_URL}/v${APP_VER}-beta/${FNAME}";
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

    # 3) APP_DIR ----------------------------------------------------------------
    # unzip /core/linux/src/freetube/freetube-0.23.5-linux-x64-portable.zip -d /opt/freetube;
    unzip "${ZIP_PATH}" -d ${APP_DIR};
    rm -f "${ZIP_PATH}";

    # /opt/freetube
    if [[ ! -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 4) EXEC_PATH -------------------------------------------------------------
    # /opt/freetube/freetube
    local EXEC_PATH="${APP_DIR}/${APP_NAME}"
    # --------------------------------------------------------------------------

    # 5) ICON_PATH -------------------------------------------------------------
    # 5-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/freetube/freetube-icon.png
    # local ICON_PATH="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${ICON_PATH};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 5-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/freetube.svg
    local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 6) DESKTOP_PATH ----------------------------------------------------------
    # /usr/share/applications/freetube.deskop
    local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    set_desktop;
    # --------------------------------------------------------------------------
}


function install_freetube_for_appimg()
{
    # appimage for only x86_64 -------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi

    # /opt/freetube
    if [[ -e "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then
        # FreeTube-0.23.5-amd64.AppImage
        local FNAME="FreeTube-${APP_VER}-amd64.AppImage";

    elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # FreeTube-0.23.5-arm64.AppImage
        local FNAME="FreeTube-${APP_VER}-arm64.AppImage";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-amd64.AppImage
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-arm64.AppImage
    local SRC_URL="${APP_ROOT_URL}/v${APP_VER}-beta/${FNAME}";

    # 2) EXEC_PATH -------------------------------------------------------------
    # /opt/freetube/FreeTube-0.23.5-amd64.AppImage
    # /opt/freetube/FreeTube-0.23.5-arm64.AppImage
    local EXEC_PATH="${APP_DIR}/${FNAME}";

    # /opt/freetube
    mkdir -p ${APP_DIR};

    wget ${SRC_URL} -O ${EXEC_PATH};
    chmod +x ${EXEC_PATH};
    # --------------------------------------------------------------------------

    # 3) ICON_PATH -------------------------------------------------------------
    # 3-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/freetube/freetube-icon.png
    # local ICON_PATH="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${ICON_PATH};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 3-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/freetube.svg
    local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 4) DESKTOP_PATH ----------------------------------------------------------
    # /usr/share/applications/freetube.deskop
    local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    set_desktop;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then  # i686
        install_freetube_for_nix
    else                                        # x86_64, aarch64
        install_freetube_for_deb;
    fi
    # --------------------------------------------------------------------------
    # install_freetube_for_flatpak;
    # --------------------------------------------------------------------------
    # install_freetube_for_portable;
    # --------------------------------------------------------------------------
    # install_freetube_for_appimg;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then  # i686
        install_freetube_for_nix
    else                                        # x86_64, aarch64
        install_freetube_for_rpm;
    fi
fi
# ==============================================================================

exit 0
