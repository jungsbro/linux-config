#!/bin/bash

# paint ========================================================================
# bash ${BIN_DIR}/graphics/install_gimp.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/graphics
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/.."
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$1;
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="PhotoGIMP";

# /tmp/PhotoGIMP
TMP_DIR="/tmp/${NAME}";
# ------------------------------------------------------------------------------
# ==============================================================================


# func =========================================================================
function install_gimp_for_flatpak()
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
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash ${BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^flatpak) ]] || bash ${BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
    # --------------------------------------------------------------------------
}


function install_photogimp()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    if [[ -e "${TMP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    if [[ -n $(flatpak list --app | grep -i gimp) ]]; then  # for flatpak
        # for flatpak ----------------------------------------------------------
        # https://github.com/Diolinux/PhotoGIMP/releases/download/3.0/PhotoGIMP-linux.zip
        local URL="https://github.com/Diolinux/${NAME}/releases/download/3.0/${NAME}-linux.zip";

        # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
        local ZIP_PATH="${TMP_DIR}/${NAME}-linux.zip"
        # ----------------------------------------------------------------------
    else
        # for "deb, rpm" -------------------------------------------------------
        # https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip
        local URL="https://github.com/Diolinux/${NAME}/releases/download/1.1/${NAME}.zip";

        # /tmp/PhotoGIMP/PhotoGIMP.zip
        local ZIP_PATH="${TMP_DIR}/${NAME}.zip"
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
    # /tmp/PhotoGIMP/PhotoGIMP.zip
    if [[ ! -e "${ZIP_PATH}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
        # /tmp/PhotoGIMP/PhotoGIMP.zip
        wget "${URL}" -O "${ZIP_PATH}";
        # ----------------------------------------------------------------------
    fi

    # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
    # /tmp/PhotoGIMP/PhotoGIMP.zip
    unzip "${ZIP_PATH}" -d ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(flatpak list --app | grep -i gimp) ]]; then  # for flatpak
        # ----------------------------------------------------------------------
        # /tmp/PhotoGIMP/PhotoGIMP-linux/.config
        local CONF_DIR="${TMP_DIR}/${NAME}-linux/.config";

        # /tmp/PhotoGIMP/PhotoGIMP-linux/.local
        local LOCAL_DIR="${TMP_DIR}/${NAME}-linux/.local";

        su - ${CUR_USER} -c "cp -Rf ${CONF_DIR} ~/";
        su - ${CUR_USER} -c "cp -Rf ${LOCAL_DIR} ~/";
        # ----------------------------------------------------------------------
    else                                                    # for "deb, rpm"
        # ----------------------------------------------------------------------
        # /tmp/PhotoGIMP/PhotoGIMP-master/.var/app/org.gimp.GIMP/config/GIMP
        local GIMP_DIR="${TMP_DIR}/${NAME}-master/.var/app/org.gimp.GIMP/config/GIMP";

        su - ${CUR_USER} -c "cp -Rf ${GIMP_DIR} ~/.config/";
        # ----------------------------------------------------------------------
    fi

    # if [[ -e "${LOCAL_DIR}" ]]; then
    # fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # x86_64, i686, aarch64 ----------------------------------------------------
    [[ -n $(apt list --installed gimp | grep -i ^gimp) ]] || apt install -y gimp;
    install_photogimp;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # [[ -n $(dnf list installed | grep -i ^gimp) ]] || dnf install -y gimp;
    install_gimp_for_flatpak;
    install_photogimp;
fi
# ==============================================================================


exit 0
