#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/utilities/freefilesync/install_freefilesync.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/utilities/freefilesync
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="freefilesync"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_freefilesync()
{
    # for x86_64
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
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


function install_freefilesync_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(flatpak list --app | grep -i freefilesync) ]] || flatpak install -y flathub org.freefilesync.FreeFileSync;
    # --------------------------------------------------------------------------
}

function fix_freefilesync_desktop()
{
    local ctr="${1}"
    local dst_path="${HOME_DIR}/.local/share/applications/${ctr}-FreeFileSync.desktop"

    if [[ ! -f ${dst_path} ]]; then
        return
    fi

    # Path=/usr/share/freefilesync
    sed -i '/Path=/d' "${dst_path}"
    chown ${CUR_USER}:${CUR_USER} "${dst_path}"
}
# ==============================================================================


# main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        # [[ -n $(yay -Q | grep -i ^freefilesync) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm freefilesync-bin";

        # 방법2) build하는데 20분 걸린다
        [[ -n $(yay -Q | grep -i ^freefilesync) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm freefilesync";

        # 방법3) distrobox를 사용한다.
        # echo "freefilesync takes too long time to install."
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^freefilesync) ]] || apt install -y freefilesync;

        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        # install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "freefilesync is not supported in RHEL and Fedora"

        if [[ *"${cur_arch}"* == *"i686"* ]]; then
            return
        fi

        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================

