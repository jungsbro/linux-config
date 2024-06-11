#!/bin/bash

# usage ========================================================================
# sudo bash ./install_gimp.sh jungs;
# ==============================================================================

# ==============================================================================
CUR_USER=$1;
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# gimp =========================================================================
# method 1) x86_64, aarch64 ----------------------------------------------------
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed gimp | grep -i ^gimp) ]] || apt install -y gimp;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #[[ -n $(yum list installed | grep -i ^gimp) ]] || yum install -y gimp;
    [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
    [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
fi
# ------------------------------------------------------------------------------

# method 2) x86_64, aarch64 ----------------------------------------------------
# if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#     [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
# elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#     [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
# fi
#
# [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
# ------------------------------------------------------------------------------
# ==============================================================================


# photogimp ====================================================================
function install_photogimp()
{
    if [[ -z ${CUR_USER} ]]; then
        return
    fi

    local NAME="PhotoGIMP";
    local URL="https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip";
    local TMP_DIR="/core/linux/src/${NAME}";
    local ZIP_PATH="${TMP_DIR}/${NAME}.zip"

    # for flatpak --------------------------------------------------------------
    # /core/linux/src/PhotoGIMP/PhotoGIMP-master/.local
    # /core/linux/src/PhotoGIMP/PhotoGIMP-master/.var
    local LOCAL_DIR="${TMP_DIR}/${NAME}-master/.local";
    local VAR_DIR="${TMP_DIR}/${NAME}-master/.var";
    # ------------------------------------------------------------------------------

    # for the other pkgs -------------------------------------------------------
    # /core/linux/src/PhotoGIMP/PhotoGIMP-master/.var/app/org.gimp.GIMP/config/GIMP
    local GIMP_DIR="${TMP_DIR}/${NAME}-master/.var/app/org.gimp.GIMP/config/GIMP";
    # --------------------------------------------------------------------------

    if [[ -e "${TMP_DIR}" ]]; then
        return
    fi

    if [[ ! -e "${ZIP_PATH}" ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget "${URL}" -O "${ZIP_PATH}";
    fi
    unzip "${ZIP_PATH}" -d ${TMP_DIR};

    if [[ -e "${LOCAL_DIR}" ]]; then
        if [[ -n $(flatpak list --app | grep -i gimp) ]]; then
            su - ${CUR_USER} -c "cp -Rf ${LOCAL_DIR} ~/";
            su - ${CUR_USER} -c "cp -Rf ${VAR_DIR} ~/";
        else
            su - ${CUR_USER} -c "cp -Rf ${GIMP_DIR} ~/.config/";
        fi
    fi
}

install_photogimp;
# ==============================================================================

exit 0