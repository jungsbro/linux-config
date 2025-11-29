#!/bin/bash

# filesync =====================================================================
# bash /core/linux/bin/utilities/install_freefilesync.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------
# ==============================================================================



# func =========================================================================
function install_freefilesync()
{
    # for x86_64 / i686
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) Setting env-vars ------------------------------------------------------
    local APP_NAME="FreeFileSync"

    local VER="14.5"

    # /tmp/FreeFileSync
    local TMP_DIR="/tmp/${APP_NAME}";

    # /opt/FreeFileSync
    local FFS_DIR="/opt/${APP_NAME}";


    # FreeFileSync_14.5_Linux_x86_64.tar.gz
    # FreeFileSync_14.5_Linux_i686.tar.gz
    local FNAME="${APP_NAME}_${VER}_Linux_${CUR_ARCH}.tar.gz";

    # https://freefilesync.org/download/FreeFileSync_14.5_Linux_x86_64.tar.gz
    local URL="https://freefilesync.org/download/${FNAME}";

    # /tmp/FreeFileSync/FreeFileSync_14.5_Linux_x86_64.tar.gz
    local TGZ_PATH="${TMP_DIR}/${FNAME}";

    # /tmp/FreeFileSync/FreeFileSync_14.5_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    local EXEC_CMD="${TMP_DIR}/${APP_NAME}_${VER}_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview";
    # --------------------------------------------------------------------------

    # 2) Downloading and Extracting --------------------------------------------
    # /opt/FreeFileSync
    if [[ -d ${FFS_DIR} ]]; then
        return
    fi

    # /tmp/FreeFileSync/FreeFileSync_14.5_Linux_x86_64.tar.gz
    if [[ ! -e "${TGZ_PATH}" ]]; then
        # ----------------------------------------------------------------------
        # /tmp/FreeFileSync
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        # ----------------------------------------------------------------------
        # /tmp/FreeFileSync/FreeFileSync_14.5_Linux_x86_64.tar.gz
        wget "${URL}" -O "${TGZ_PATH}";
        # ----------------------------------------------------------------------
    fi

    # tar -zxvf /tmp/FreeFileSync/FreeFileSync_*_Linux_x86_64.tar.gz -C /tmp/FreeFileSync;
    tar -zxvf "${TGZ_PATH}" -C ${TMP_DIR};
    # --------------------------------------------------------------------------

    # 3) Installation ----------------------------------------------------------
    # /tmp/FreeFileSync/FreeFileSync_14.5_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    ${EXEC_CMD};

    #rm -rf ${TMP_DIR};
    # --------------------------------------------------------------------------
}


function install_freefilesync_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="freefilesync"
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_freefilesync --------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.freefilesync
    # nix profile add nixpkgs#freefilesync
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix profile list 2>/dev/null | grep -iq ^${APP_NAME} || \
    nix profile add nixpkgs#${APP_NAME}"
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "FreeFileSync" \
    "RealTimeSync" \
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

    # 5) icon settngs ----------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/pixmaps"
    local dst_dir="/usr/share/pixmaps"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -r : recursive
        # -u : update
        cp -ru ${src_dir}/* "${dst_dir}/"

        gtk-update-icon-cache "${dst_dir}" 2>/dev/null
    fi
    # --------------------------------------------------------------------------

    # 6) desktop settings ------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/applications"
    local dst_dir="/usr/local/share/applications"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -u : update
        # -L : dereference
        cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

        update-desktop-database "${dst_dir}"
    fi
    # --------------------------------------------------------------------------
}


function install_freefilesync_for_flatpak()
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
    [[ -n $(flatpak list --app | grep -i freefilesync) ]] || flatpak install -y flathub org.freefilesync.FreeFileSync;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_freefilesync_for_nix;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    install_freefilesync_for_nix;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_freefilesync_for_nix;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0
