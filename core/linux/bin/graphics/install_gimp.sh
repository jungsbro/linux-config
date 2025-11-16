#!/bin/bash

# paint ========================================================================
# bash /core/linux/bin/graphics/install_gimp.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=$1;
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
NAME="PhotoGIMP";

# /core/linux/src/PhotoGIMP
TMP_DIR="/core/linux/src/${NAME}";
# ------------------------------------------------------------------------------
# ==============================================================================


# gimp =========================================================================
# method 1) x86_64, i686, aarch64 ----------------------------------------------
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed gimp | grep -i ^gimp) ]] || apt install -y gimp;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    #[[ -n $(yum list installed | grep -i ^gimp) ]] || yum install -y gimp;
    [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
    [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    # [[ -n $(dnf list installed | grep -i ^gimp) ]] || dnf install -y gimp;
    [[ -n $(dnf list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
    [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
    # --------------------------------------------------------------------------
fi
# ------------------------------------------------------------------------------

# method 2) x86_64, aarch64 ----------------------------------------------------
# if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#     # --------------------------------------------------------------------------
#     [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
#     # --------------------------------------------------------------------------
# elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
#     # --------------------------------------------------------------------------
#     [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
#     # --------------------------------------------------------------------------
# elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
#     # --------------------------------------------------------------------------
#     [[ -n $(dnf list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
#     # --------------------------------------------------------------------------
# fi
#
# [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
# ------------------------------------------------------------------------------
# ==============================================================================


# photogimp ====================================================================
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

        # /core/linux/src/PhotoGIMP/PhotoGIMP-linux.zip
        local ZIP_PATH="${TMP_DIR}/${NAME}-linux.zip"
        # ----------------------------------------------------------------------
    else
        # for "deb, rpm" -------------------------------------------------------
        # https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip
        local URL="https://github.com/Diolinux/${NAME}/releases/download/1.1/${NAME}.zip";

        # /core/linux/src/PhotoGIMP/PhotoGIMP.zip
        local ZIP_PATH="${TMP_DIR}/${NAME}.zip"
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # /core/linux/src/PhotoGIMP/PhotoGIMP-linux.zip
    # /core/linux/src/PhotoGIMP/PhotoGIMP.zip
    if [[ ! -e "${ZIP_PATH}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /core/linux/src/PhotoGIMP/PhotoGIMP-linux.zip
        # /core/linux/src/PhotoGIMP/PhotoGIMP.zip
        wget "${URL}" -O "${ZIP_PATH}";
        # ----------------------------------------------------------------------
    fi

    # /core/linux/src/PhotoGIMP/PhotoGIMP-linux.zip
    # /core/linux/src/PhotoGIMP/PhotoGIMP.zip
    unzip "${ZIP_PATH}" -d ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(flatpak list --app | grep -i gimp) ]]; then  # for flatpak
        # ----------------------------------------------------------------------
        # /core/linux/src/PhotoGIMP/PhotoGIMP-linux/.config
        local CONF_DIR="${TMP_DIR}/${NAME}-linux/.config";

        # /core/linux/src/PhotoGIMP/PhotoGIMP-linux/.local
        local LOCAL_DIR="${TMP_DIR}/${NAME}-linux/.local";

        su - ${CUR_USER} -c "cp -Rf ${CONF_DIR} ~/";
        su - ${CUR_USER} -c "cp -Rf ${LOCAL_DIR} ~/";
        # ----------------------------------------------------------------------
    else                                                    # for "deb, rpm"
        # ----------------------------------------------------------------------
        # /core/linux/src/PhotoGIMP/PhotoGIMP-master/.var/app/org.gimp.GIMP/config/GIMP
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
install_photogimp;
# ==============================================================================

exit 0
