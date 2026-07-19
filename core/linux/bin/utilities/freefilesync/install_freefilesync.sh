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


# function install_freefilesync_for_nix()
# {
#     # --------------------------------------------------------------------------
#     # for x86_64 / aarch64
#     if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
#         return
#     fi

#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     # 1) env-vars settings -----------------------------------------------------
#     local APP_NAME="freefilesync"

#     local mod=${1}  # multi / single

#     if [[ *"${mod}"* == *"multi"* ]]; then
#         # multi-user
#         local nix_env_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
#     else
#         # single-user
#         local nix_env_path="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
#     fi
#     # --------------------------------------------------------------------------

#     # 2) install nix -----------------------------------------------------------
#     bash ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix.sh ${CUR_USER};
#     # --------------------------------------------------------------------------

#     # 3) install_freefilesync --------------------------------------------------
#     # https://search.nixos.org/packages
#     # nix-env -iA nixpkgs.freefilesync
#     # nix profile add nixpkgs#freefilesync
#     su - ${CUR_USER} -c "source ${nix_env_path} && \
#     nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
#     nix profile add nixpkgs#${APP_NAME}"
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     if [[ *"${mod}"* == *"multi"* ]]; then
#         return
#     fi
#     return
#     # --------------------------------------------------------------------------

#     # 4) bins settings ---------------------------------------------------------
#     local cur_name="";

#     local src_dir="${HOME_DIR}/.nix-profile/bin"

#     local dst_dir="${HOME_DIR}/.local/bin"
#     if [[ ! -d ${dst_dir} ]]; then
#         su - ${CUR_USER} -c "mkdir -p ${dst_dir}"
#     fi

#     for cur_name in $(ls ${src_dir});
#     do
#         src_path="${src_dir}/${cur_name}";
#         if [[ ! -f ${src_path} ]]; then
#             continue
#         fi

#         dst_path="${dst_dir}/${cur_name}";
#         if [[ -f ${dst_path} ]]; then
#             continue
#         fi

#         su - ${CUR_USER} -c "ln -s ${src_path} ${dst_path}";
#     done
#     # --------------------------------------------------------------------------

#     # 5) icon settngs ----------------------------------------------------------
#     local name_list="icons pixmaps";
#     local cur_name="";
#     local src_dir="";
#     local dst_dir="";

#     for cur_name in ${name_list};
#     do
#         src_dir="${HOME_DIR}/.nix-profile/share/${cur_name}"
#         dst_dir="${HOME_DIR}/.local/share/${cur_name}"

#         if [[ -d ${src_dir} ]]; then
#             su - ${CUR_USER} -c "mkdir -p \"${dst_dir}\""

#             # ------------------------------------------------------------------
#             # -r : recursive
#             # -u : update
#             cp -ru ${src_dir}/* "${dst_dir}/"
#             chown -R ${CUR_USER}:${CUR_USER} "${dst_dir}"
#             chmod -R 755 ${dst_dir}
#             # ------------------------------------------------------------------

#             gtk-update-icon-cache "${dst_dir}" 2>/dev/null
#         fi
#     done
#     # --------------------------------------------------------------------------

#     # 6) desktop settings ------------------------------------------------------
#     local src_dir="${HOME_DIR}/.nix-profile/share/applications"
#     local dst_dir="${HOME_DIR}/.local/share/applications"

#     if [[ -d ${src_dir} ]]; then
#         su - ${CUR_USER} -c "mkdir -p \"${dst_dir}\""

#         # ----------------------------------------------------------------------
#         # -u : update
#         # -L : dereference
#         cp -u -L ${src_dir}/*.desktop "${dst_dir}/"
#         chown -R ${CUR_USER}:${CUR_USER} "${dst_dir}"
#         chmod -R 744 ${dst_dir}
#         # ----------------------------------------------------------------------

#         update-desktop-database "${dst_dir}"
#     fi
#     # --------------------------------------------------------------------------
# }


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

        # install_freefilesync_for_nix "multi";
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
        # install_freefilesync_for_nix "single";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================


