#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/multimedia/install_freetube.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/multimedia
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
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

APP_CAT="AudioVideo;Player"

APP_HIDDEN="false";
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_freetube_for_apt()
{
    # --------------------------------------------------------------------------
    # for x86_64, aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^freetube) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # freetube_0.23.5_amd64.deb
        local FNAME="${APP_NAME}_${APP_VER}_amd64.deb";

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
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
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^freetube) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # freetube-0.23.5.amd64.rpm
        local FNAME="${APP_NAME}-${APP_VER}.amd64.rpm";

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
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


function install_freetube_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # flatpak run io.freetubeapp.FreeTube
    [[ -n $(flatpak list --app | grep -i freetube) ]] || flatpak install -y flathub io.freetubeapp.FreeTube
    # --------------------------------------------------------------------------
}


function install_freetube_for_portable()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi

    # /opt/freetube
    if [[ -e ${APP_DIR} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # 1) src_url ---------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # freetube-0.23.5-linux-x64-portable.zip
        local fname="${APP_NAME}-${APP_VER}-linux-x64-portable.zip";

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # freetube-0.23.5-linux-arm64-portable.zip
        local fname="${APP_NAME}-${APP_VER}-linux-arm64-portable.zip";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-x64-portable.zip
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-arm64-portable.zip
    local src_url="${APP_ROOT_URL}/v${APP_VER}-beta/${fname}";
    # --------------------------------------------------------------------------

    # 2) zip_path --------------------------------------------------------------
    if [[ ! -e "${TMP_DIR}" ]]; then
        # /tmp/freetube
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # /tmp/freetube/freetube-0.23.5-linux-x64-portable.zip
    # /tmp/freetube/freetube-0.23.5-linux-arm64-portable.zip
    local zip_path="${TMP_DIR}/${fname}";

    if [[ ! -e "${zip_path}" ]]; then
        wget "${src_url}" -O "${zip_path}";
    fi
    # --------------------------------------------------------------------------

    # 3) APP_DIR ----------------------------------------------------------------
    # unzip /core/linux/src/freetube/freetube-0.23.5-linux-x64-portable.zip -d /opt/freetube;
    unzip "${zip_path}" -d ${APP_DIR};
    rm -f "${zip_path}";

    # /opt/freetube
    if [[ ! -d "${APP_DIR}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # 4) exec_path -------------------------------------------------------------
    # /opt/freetube/freetube
    local exec_path="${APP_DIR}/${APP_NAME}"
    # --------------------------------------------------------------------------

    # 5) icon_path -------------------------------------------------------------
    # 5-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/freetube/freetube-icon.png
    # local icon_path="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${icon_path};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 5-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/freetube.svg
    # local icon_path="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    local icon_path="${APP_UNIQUE_NAME}";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 6) desktop_path ----------------------------------------------------------
    # /usr/share/applications/freetube.deskop
    local desktop_path="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}



function install_freetube_for_appimg()
{
    # appimage for only x86_64 -------------------------------------------------
    # for x86_64 / aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi

    # /opt/freetube
    if [[ -e "${APP_DIR}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # 1) src_url ---------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # FreeTube-0.23.5-amd64.AppImage
        local fname="FreeTube-${APP_VER}-amd64.AppImage";

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # FreeTube-0.23.5-arm64.AppImage
        local fname="FreeTube-${APP_VER}-arm64.AppImage";
    fi

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-amd64.AppImage
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-arm64.AppImage
    local src_url="${APP_ROOT_URL}/v${APP_VER}-beta/${fname}";

    # 2) exec_path -------------------------------------------------------------
    # /opt/freetube/FreeTube-0.23.5-amd64.AppImage
    # /opt/freetube/FreeTube-0.23.5-arm64.AppImage
    local exec_path="${APP_DIR}/${fname}";

    # /opt/freetube
    mkdir -p ${APP_DIR};

    wget ${src_url} -O ${exec_path};
    chmod +x ${exec_path};
    # --------------------------------------------------------------------------

    # 3) icon_path -------------------------------------------------------------
    # 3-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/freetube/freetube-icon.png
    # local icon_path="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${icon_path};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 3-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/freetube.svg
    local icon_path="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 4) desktop_path ----------------------------------------------------------
    # /usr/share/applications/freetube.deskop
    local desktop_path="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop ${APP_NAME} ${exec_path} ${icon_path} ${APP_CAT} ${APP_HIDDEN} ${desktop_path} ${CUR_USER};
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # [[ -n $(yay -Q | grep -i ^freetube) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm freetube";
        [[ -n $(yay -Q | grep -i ^freetube) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm freetube-bin";
        # [[ -n $(yay -Q | grep -i ^freetube) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm freetube-git";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then  # i686
            echo "freetube-i686 is not supported for Debian/Ubuntu"
            # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
            # install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
        else                                        # x86_64, aarch64
            install_freetube_for_apt;
        fi
        # ----------------------------------------------------------------------
        # install_freetube_for_flatpak;
        # ----------------------------------------------------------------------
        # install_freetube_for_portable;
        # ----------------------------------------------------------------------
        # install_freetube_for_appimg;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then  # i686
            echo "freetube-i686 is not supported for RHEL"
            # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
            # install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        else                                        # x86_64, aarch64
            install_freetube_for_rpm;
        fi
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================