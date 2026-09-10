#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# bash ${CORE_BIN_DIR}/multimedia/yt-x/install_yt-x.sh "${CUR_USER}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 설명보기 / thumbnail보기 / xfce 검색
# yt-x --preview --preview-images -s "xfce"
# ------------------------------------------------------------------------------
# ==============================================================================

# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/multimedia/yt-x
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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
APP_NAME="yt-x"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_deps_for_yt-x()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 데이터전송
        local app_name="curl"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 데이터
        local app_name="jq"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 데이터전송
        local app_name="curl"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 데이터
        local app_name="jq"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 데이터전송
        local app_name="curl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 데이터
        local app_name="jq"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 데이터전송
        local app_name="curl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 데이터
        local app_name="jq"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh "${CUR_USER}";

    bash ${CORE_BIN_DIR}/multimedia/mpv/install_mpv.sh "${CUR_USER}";

    # yt-dlp 최신을 요함
    bash ${CORE_BIN_DIR}/multimedia/install_yt-dlp.sh "${CUR_USER}";

    # yt-x에서 fzf 최신을 요함
    bash ${CORE_BIN_DIR}/filemgr/cli/install_fzf.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function install_yt-x_with_curl()
{
    # --------------------------------------------------------------------------
    local src_url='https://raw.githubusercontent.com/Benexl/yt-x/main/yt-x';

    # 방법1) ~/.local/bin
    # local dst_dir="${HOME_DIR}/.local/bin";

    # 방법2) /usr/local/bin
    local dst_dir="/usr/local/bin";

    # ~/.local/bin/yt-x
    # /usr/local/bin/yt-x
    local dst_path="${dst_dir}/yt-x";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${dst_dir}" ]] || mkdir -p "${dst_dir}";

    if [[ -f "${dst_path}" ]]; then
        rm -f "${dst_path}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # install yt-x

    # curl -sSL https://raw.githubusercontent.com/Benexl/yt-x/main/yt-x -o ~/.local/bin/yt-x
    # curl -sSL https://raw.githubusercontent.com/Benexl/yt-x/main/yt-x -o /usr/local/bin/yt-x;
    if [[ ${dst_dir} == *".local"* ]]; then
        su - "${CUR_USER}" -c "curl -sSL ${src_url} -o ${dst_path}";
        su - "${CUR_USER}" -c "chmod +x ${dst_path}";
    else
        curl -sSL "${src_url}" -o "${dst_path}";
        chmod +x "${dst_path}";
    fi
    # --------------------------------------------------------------------------
}

function install_yt-x()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_yt-x_with_curl;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_yt-x_with_curl;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_yt-x_with_curl;
        # ----------------------------------------------------------------------
    fi
}


function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/config";

    local dst_dir="${HOME_DIR}/.config/yt-x";
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
    install_deps_for_yt-x;

    install_yt-x;

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
