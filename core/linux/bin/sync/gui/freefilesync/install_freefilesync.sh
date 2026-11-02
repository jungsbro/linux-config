#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/sync/gui/freefilesync/install_freefilesync.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/sync/gui/freefilesync
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="freefilesync"

# /tmp/freefilesync
TMP_DIR="/tmp/${APP_NAME}";

# /opt/freefilesync
OPT_DIR="/opt"
APP_DIR="${OPT_DIR}/${APP_NAME}";


APP_REPO_NAME="hkneptune/FreeFileSync";
# https://api.github.com/repos/hkneptune/FreeFileSync/releases/latest
API_URL="https://api.github.com/repos/${APP_REPO_NAME}/releases/latest";


APP_ICON_URL="https://freefilesync.org/images/FreeFileSync.png";
APP_ICON_PATH="${HOME_DIR}/.local/share/icons/${APP_NAME}.png";

APP_CAT="System;FileTools;Utility;Core;GTK;Development"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_freefilesync_for_portable()    # not working
{
    # --------------------------------------------------------------------------
    # 14.13에서 argument가 인식을 하지 않는다.
    # nixpkgs를 사용하면 된다.
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/hkneptune/FreeFileSync/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/hkneptune/FreeFileSync/releases/download/v14.13/FreeFileSync_14.13_Linux_x86_64.tar.gz
        local cur_arch="Linux_x86_64.tar.gz";
    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/hkneptune/FreeFileSync/releases/download/v14.13/FreeFileSync_14.13_Linux_x86_64.tar.gz
    # curl -s "https://api.github.com/repos/hkneptune/FreeFileSync/releases/latest" | jq -r '.assets[] | select(.name | test("Linux_x86_64.tar.gz")) | .browser_download_url'
    local ffs_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${ffs_url}"
    if [[ -z "${ffs_url}" ]]; then
        return 0
    fi

    # FreeFileSync_14.13_Linux_x86_64.tar.gz
    local ffs_fname="$(basename "${ffs_url}")";

    # FreeFileSync_14.13_Install.run
    local ffs_run_fanme=$(echo "${ffs_fname}" | cut -d "_" -f 1)_$(echo "${ffs_fname}" | cut -d "_" -f 2)_Install.run;
    # --------------------------------------------------------------------------

    # 1) Setting env-vars ------------------------------------------------------
    local app_name="FreeFileSync"

    # /tmp/FreeFileSync
    local tmp_dir="/tmp/${app_name}";

    # /opt/FreeFileSync
    local opt_dir="/opt"
    local app_dir="${opt_dir}/${app_name}";

    # /tmp/FreeFileSync/FreeFileSync_14.13_Linux_x86_64.tar.gz
    local tmp_path="${tmp_dir}/${ffs_fname}";

    # 14.13에서 argument가 인식을 하지 않는다.
    # /tmp/FreeFileSync/FreeFileSync_14.13_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    local exec_cmd="${tmp_dir}/${ffs_run_fanme} --accept-license --for-all-users true --create-shortcuts false --skip-overview";
    # --------------------------------------------------------------------------

    # 2) Downloading and Extracting --------------------------------------------
    # /opt/FreeFileSync
    if [[ -d "${app_dir}" ]]; then
        return 0
    fi

    # /tmp/FreeFileSync/FreeFileSync_14.13_Linux_x86_64.tar.gz
    if [[ ! -f "${tmp_path}" ]]; then
        # ----------------------------------------------------------------------
        # /tmp/FreeFileSync
        mkdir -p "${tmp_dir}";
        chmod 755 "${tmp_dir}";
        # ----------------------------------------------------------------------
        # /tmp/FreeFileSync/FreeFileSync_14.13_Linux_x86_64.tar.gz
        wget "${ffs_url}" -O "${tmp_path}";
        # ----------------------------------------------------------------------
    fi

    # tar -zxvf /tmp/FreeFileSync/FreeFileSync_*_Linux_x86_64.tar.gz -C /tmp/FreeFileSync;
    tar -xvf "${tmp_path}" -C "${tmp_dir}";
    # --------------------------------------------------------------------------

    # 3) Installation ----------------------------------------------------------
    # /tmp/FreeFileSync/FreeFileSync_14.13_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    eval "${exec_cmd}";

    #rm -rf "${TMP_DIR}";
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

    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        # install_freefilesync_for_portable

        # 방법2)
        # local app_name="freefilesync-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법3) build하는데 20분 걸린다
        local app_name="${APP_NAME}"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # install_freefilesync_for_portable

        # 방법2) nixpkg
        # local app_name="${APP_NAME}";
        # local user_type="multi";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # 방법3)
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # install_freefilesync_for_portable

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

