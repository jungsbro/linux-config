#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# bash ${CORE_BIN_DIR}/multimedia/tui/ytsurf/install_ytsurf.sh "${CUR_USER}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 해상도 선택 / xfce 검색
# ytsurf --format "xfce"
# ------------------------------------------------------------------------------
# ==============================================================================

# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/multimedia/tui/ytsurf
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

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
APP_NAME="ytsurf"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_deps_for_ytsurf()
{
    # --------------------------------------------------------------------------
    # 데이터관리
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_jq.sh;

    # 데이터전송
    bash ${CORE_BIN_DIR}/network/cli/install_curl.sh;

    # 양방향통신
    bash ${CORE_BIN_DIR}/network/cli/install_socat.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 터미널 이미지
    bash ${CORE_BIN_DIR}/multimedia/cli/install_chafa.sh;

    # 영상코덱
    bash ${CORE_BIN_DIR}/multimedia/cli/install_ffmpeg.sh;

    # youtube downloader : yt-dlp 최신을 요함
    bash ${CORE_BIN_DIR}/multimedia/cli/install_yt-dlp.sh "${CUR_USER}";

    # player
    bash ${CORE_BIN_DIR}/multimedia/gui/mpv/install_mpv.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # file-list : yt-x에서 fzf 최신을 요함
    bash ${CORE_BIN_DIR}/filemgr/cli/install_fzf.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function install_ytsurf_with_curl()
{
    # --------------------------------------------------------------------------
    local src_url='https://raw.githubusercontent.com/Stan-breaks/ytsurf/main/ytsurf.sh';

    # 방법1) ~/.local/bin
    # local dst_dir="${HOME_DIR}/.local/bin";

    # 방법2) /usr/local/bin
    local dst_dir="/usr/local/bin";

    # ~/.local/bin/ytsurf
    # /usr/local/bin/ytsurf
    local dst_path="${dst_dir}/ytsurf";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${dst_dir}" ]] || mkdir -p "${dst_dir}";

    if [[ -f "${dst_path}" ]]; then
        rm -f "${dst_path}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # install ytsurf

    # curl -L https://raw.githubusercontent.com/Stan-breaks/ytsurf/main/ytsurf.sh -o ~/.local/bin/ytsurf;
    # curl -L https://raw.githubusercontent.com/Stan-breaks/ytsurf/main/ytsurf.sh -o /usr/local/bin/ytsurf;
    if [[ ${dst_dir} == *".local"* ]]; then
        su - "${CUR_USER}" -c "curl -L ${src_url} -o ${dst_path}";
        su - "${CUR_USER}" -c "chmod +x ${dst_path}";
    else
        curl -L "${src_url}" -o "${dst_path}";
        chmod +x "${dst_path}";
    fi
    # --------------------------------------------------------------------------
}

function install_ytsurf()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_ytsurf_with_curl;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_ytsurf_with_curl;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_ytsurf_with_curl;
        # ----------------------------------------------------------------------
    fi
}


function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/config";

    local dst_dir="${HOME_DIR}/.config/ytsurf";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${src_dir}" ]]; then
        su - "${CUR_USER}" -c "cp -Rf ${src_dir}/* ${dst_dir}/";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    install_deps_for_ytsurf;

    install_ytsurf;

    copy_config_to_home;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================