#!/bin/bash

# filesync =====================================================================
# bash /core/linux/bin/utilities/install_freefilesync.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================



# method 1) x86_64, i686 =======================================================
function install_freefilesync()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local NAME="FreeFileSync";
    
    local VER="14.3"
    
    # FreeFileSync_14.3_Linux.tar.gz
    local FNAME="${NAME}_${VER}_Linux.tar.gz";
    
    # https://freefilesync.org/download/FreeFileSync_14.3_Linux.tar.gz
    local URL="https://freefilesync.org/download/${FNAME}";
    
    # /core/linux/src/FreeFileSync
    local TMP_DIR="/core/linux/src/${NAME}";
    
    # /opt/FreeFileSync
    local FFS_DIR="/opt/${NAME}";
    
    # /core/linux/src/FreeFileSync/FreeFileSync_14.3_Linux.tar.gz
    local TGZ_PATH="${TMP_DIR}/${FNAME}";
    
    # /core/linux/src/FreeFileSync/FreeFileSync_13.7_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    local EXEC_CMD="${TMP_DIR}/${NAME}_${VER}_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /opt/FreeFileSync
    if [[ -d ${FFS_DIR} ]]; then
        return
    fi

    # /core/linux/src/FreeFileSync/FreeFileSync_14.3_Linux.tar.gz
    if [[ ! -e "${TGZ_PATH}" ]]; then
        # ----------------------------------------------------------------------
        # /core/linux/src/FreeFileSync
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /core/linux/src/FreeFileSync/FreeFileSync_14.3_Linux.tar.gz
        wget "${URL}" -O "${TGZ_PATH}";
        # ----------------------------------------------------------------------
    fi

    # tar -zxvf /core/linux/src/FreeFileSync/FreeFileSync_*_Linux.tar.gz -C /core/linux/src/FreeFileSync;
    tar -zxvf "${TGZ_PATH}" -C ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /core/linux/src/FreeFileSync/FreeFileSync_14.3_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    ${EXEC_CMD};

    #rm -rf ${TMP_DIR};
    # --------------------------------------------------------------------------
}

# main -------------------------------------------------------------------------
install_freefilesync;
# ------------------------------------------------------------------------------
# ==============================================================================



# method 2) x86_64, aarch64 ====================================================
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
# [[ -n $(flatpak list --app | grep -i freefilesync) ]] || flatpak install -y flathub org.freefilesync.FreeFileSync;
# ------------------------------------------------------------------------------
# ==============================================================================


exit 0