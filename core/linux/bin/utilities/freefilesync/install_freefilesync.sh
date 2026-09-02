#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/utilities/freefilesync/install_freefilesync.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="freefilesync"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_freefilesync_for_portable()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        echo "";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        return 0

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # 1) Setting env-vars ------------------------------------------------------
    local app_name="FreeFileSync"

    local ver="14.11"

    # /tmp/FreeFileSync
    local tmp_dir="/tmp/${app_name}";

    # /opt/FreeFileSync
    local ffs_dir="/opt/${app_name}";

    # FreeFileSync_14.11_Linux_x86_64.tar.gz
    local ffs_fname="${app_name}_${ver}_Linux_${CUR_ARCH}.tar.gz";

    # https://freefilesync.org/download/FreeFileSync_14.11_Linux_x86_64.tar.gz
    local ffs_url="https://freefilesync.org/download/${ffs_fname}";

    # /tmp/FreeFileSync/FreeFileSync_14.11_Linux_x86_64.tar.gz
    local tmp_path="${tmp_dir}/${ffs_fname}";

    # /tmp/FreeFileSync/FreeFileSync_14.11_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    local exec_cmd="${tmp_dir}/${app_name}_${ver}_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview";
    # --------------------------------------------------------------------------

    # 2) Downloading and Extracting --------------------------------------------
    # /opt/FreeFileSync
    if [[ -d "${ffs_dir}" ]]; then
        return 0
    fi

    # /tmp/FreeFileSync/FreeFileSync_14.5_Linux_x86_64.tar.gz
    if [[ ! -f "${tmp_path}" ]]; then
        # ----------------------------------------------------------------------
        # /tmp/FreeFileSync
        mkdir -p "${tmp_dir}";
        chmod 777 "${tmp_dir}";
        # ----------------------------------------------------------------------
        # /tmp/FreeFileSync/FreeFileSync_14.5_Linux_x86_64.tar.gz
        wget "${ffs_url}" -O "${tmp_path}";
        # ----------------------------------------------------------------------
    fi

    # tar -zxvf /tmp/FreeFileSync/FreeFileSync_*_Linux_x86_64.tar.gz -C /tmp/FreeFileSync;
    tar -xvf "${tmp_path}" -C "${tmp_dir}";
    # --------------------------------------------------------------------------

    # 3) Installation ----------------------------------------------------------
    # /tmp/FreeFileSync/FreeFileSync_14.5_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    eval "${exec_cmd}";

    #rm -rf "${tmp_dir}";
    # --------------------------------------------------------------------------
}


function fix_freefilesync_desktop()
{
    local ctr="${1}"
    local dst_path="${HOME_DIR}/.local/share/applications/${ctr}-FreeFileSync.desktop"

    if [[ ! -f "${dst_path}" ]]; then
        return 0
    fi

    # Path=/usr/share/freefilesync
    sed -i '/Path=/d' "${dst_path}"
    chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
}


function execute_main()
{

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        # local app_name="freefilesync-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2) build하는데 20분 걸린다
        local app_name="${APP_NAME}"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법3) distrobox를 사용한다.
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) nixpkg
        # local app_name="${APP_NAME}";
        # local user_type="multi";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) distrobox를 사용한다.
        # echo "freefilesync is not avialable on RHEL and Fedora"

        # 방법2)
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then
            return 0
        fi
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================

