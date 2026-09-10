#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# bash ${CORE_BIN_DIR}/multimedia/install_yt-dlp.sh "${CUR_USER}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# update

# yt-dlp -U;
# ------------------------------------------------------------------------------
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="yt-dlp"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_yt-dlp_with_curl()
{
    # --------------------------------------------------------------------------
    local src_url='https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp';

    # 방법1) ~/.local/bin
    # local dst_dir="${HOME_DIR}/.local/bin";

    # 방법2) /usr/local/bin
    local dst_dir="/usr/local/bin";

    # ~/.local/bin/yt-dlp
    # /usr/local/bin/yt-dlp
    local dst_path="${dst_dir}/yt-dlp";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${dst_dir}" ]] || mkdir -p "${dst_dir}";

    if [[ -f "${dst_path}" ]]; then
        # ----------------------------------------------------------------------
        # update yt-dlp

        # ~/.local/bin/yt-dlp -U
        # /usr/local/bin/yt-dlp -U
        "${dst_dir}/yt-dlp" -U;
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # install yt-dlp

        # curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
        # curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
        if [[ ${dst_dir} == *".local"* ]]; then
            su - "${CUR_USER}" -c "curl -L ${src_url} -o ${dst_path}";
            su - "${CUR_USER}" -c "chmod +x ${dst_path}";
        else
            curl -L "${src_url}" -o "${dst_path}";
            chmod a+rx "${dst_path}";
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}

function install_yt-dlp()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) 늘 최신버전을 사용해야하는데, debian계열은 옛날버전을 사용한다.
        # local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2)
        [[ -n $(apt list --installed | grep -i ^"${APP_NAME}") ]] && apt remove -y --purge "${APP_NAME}" || true
        install_yt-dlp_with_curl;

        # 방법3) nixpkg
        # local app_name="${APP_NAME}";
        # local user_type="multi";
        # local cur_user="${CUR_USER}";
        # source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # yt-dlp is not supported on RHEL

        # 방법1) python version is too old to install yt-dlp >> 사용불가
        # install_yt-dlp_with_curl;

        # 방법2) nixpkg
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------
    fi
}

function execute_main()
{
    install_yt-dlp;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================