#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/yazi/install_yazi.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/tui/yazi
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
APP_NAME="yazi";
APP_NAME2="ya";

# /tmp/yazi
TMP_DIR="/tmp/${APP_NAME}";

# /usr/local/bin
LOCAL_BIN_DIR="/usr/local/bin"

APP_REPO_NAME="sxyazi/yazi";
# https://api.github.com/repos/sxyazi/yazi/releases/latest
API_URL="https://api.github.com/repos/${APP_REPO_NAME}/releases/latest";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_deps_for_yazi()
{
    # --------------------------------------------------------------------------
    # 압축관리
    bash ${CORE_BIN_DIR}/archive/cli/install_7zip.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 데이터관리
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_jq.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 영상코덱
    bash ${CORE_BIN_DIR}/multimedia/cli/install_ffmpeg.sh;

    # thumbnail생성
    bash ${CORE_BIN_DIR}/multimedia/cli/install_ffmpegthumbnailer.sh;

    # 이미지 가공/포맷 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_imagemagick.sh;

    # pdf를 이미지로 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_poppler.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fzf, ripgrep, fd-find, zoxide, fasd, plocate
    bash ${CORE_BIN_DIR}/filemgr/tools/install_find-tools.sh "${CUR_USER}";

    # bat, eza, lsd, tree
    bash ${CORE_BIN_DIR}/filemgr/tools/install_ls-tools.sh "${CUR_USER}";

    # 휴지통
    bash ${CORE_BIN_DIR}/system/cli/install_trash-cli.sh;
    # --------------------------------------------------------------------------
}


function install_yazi_for_deb()
{
    # --------------------------------------------------------------------------
    # curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.deb
        local cur_arch="x86_64-unknown-linux-gnu.deb";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-i686-unknown-linux-gnu.deb
        local cur_arch="i686-unknown-linux-gnu.deb";
        # yazi not found for i686_deb
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-gnu.deb
        local cur_arch="aarch64-unknown-linux-gnu.deb";
    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.deb
    # curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu.deb")) | .browser_download_url'
    local deb_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${deb_url}"
    if [[ -z "${deb_url}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    # local deb_url="${DEB_URL}";

    source ${CORE_BIN_DIR}/pkgmgmt/deb/install_deb_funcs.sh && \
    install_debpkg "${app_name}" "${deb_url}";
    # --------------------------------------------------------------------------
}


function install_yazi_for_portable()
{
    # --------------------------------------------------------------------------
    # tui용이라서 install_portablepkg를 사용하지 않았다.
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # 1) portable_url ----------------------------------------------------------
    # curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r '.assets[].browser_download_url'

    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip
        local portable_name="yazi-x86_64-unknown-linux-gnu";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-i686-unknown-linux-gnu.zip
        local portable_name="yazi-i686-unknown-linux-gnu";

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-gnu.zip
        local portable_name="yazi-aarch64-unknown-linux-gnu";
    else
        return 0
    fi
    local cur_arch="${portable_name}.zip";


    # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip
    # curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu.zip")) | .browser_download_url'
    local portable_url=$(curl -s "${API_URL}" | jq -r ".assets[] | select(.name | test(\"${cur_arch}\")) | .browser_download_url")
    # echo "${portable_url}"
    if [[ -z "${portable_url}" ]]; then
        return 0
    fi

    # yazi-x86_64-unknown-linux-gnu.zip
    # yazi-i686-unknown-linux-gnu.zip
    # yazi-aarch64-unknown-linux-gnu.zip
    local portable_fname=$(basename ${portable_url});
    # echo "${portable_fname}"
    # --------------------------------------------------------------------------

    # 2) tmp_path --------------------------------------------------------------
    # /tmp/yazi
    if [[ ! -d "${TMP_DIR}" ]]; then
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
    fi

    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu.zip
    local tmp_path="${TMP_DIR}/${portable_fname}"

    if [[ ! -e "${tmp_path}" ]]; then
        wget "${portable_url}" -O "${tmp_path}";
    fi
    # --------------------------------------------------------------------------

    # 3) LOCAL_BIN_DIR ---------------------------------------------------------
    # /usr/local/bin
    if [[ ! -d "${LOCAL_BIN_DIR}" ]]; then
        return 0
    fi

    # unzip /tmp/yazi/yazi-x86_64-unknown-linux-gnu.zip -d /tmp/yazi
    unzip "${tmp_path}" -d "${TMP_DIR}";

    # 3-1) yazi
    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi
    local src_path="${TMP_DIR}/${portable_name}/${APP_NAME}"

    # /usr/local/bin/yazi
    local dst_path="${LOCAL_BIN_DIR}/${APP_NAME}"

    if [[ -f "${src_path}" ]] && [[ ! -f "${dst_path}" ]]; then
        cp "${src_path}" "${LOCAL_BIN_DIR}"
    fi


    # 3-2) ya
    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya
    local src_path="${TMP_DIR}/${portable_name}/${APP_NAME2}"

    # /usr/local/bin/ya
    local dst_path="${LOCAL_BIN_DIR}/${APP_NAME}"

    if [[ -f "${src_path}" ]] && [[ ! -f "${dst_path}" ]]; then
        cp "${src_path}" "${LOCAL_BIN_DIR}"
    fi


    rm -f "${tmp_path}";
    # --------------------------------------------------------------------------
}


function install_yazi()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^yazi) ]] || pacman -S --noconfirm --needed yazi;

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then
            install_yazi_for_portable;
        else
            install_yazi_for_deb;
        fi

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        install_yazi_for_portable;

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        install_yazi_for_portable;
    fi
}

function copy_yazirc()
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/config"
    if [[ ! -f "${src_dir}/yazi.toml" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/yazi
    local dst_dir="${HOME_DIR}/.config/yazi";
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local cur_name="";
    local name_list="flavors/ plugins/ init.lua keymap.toml package.toml theme.toml yazi.toml"
    local src_path="";
    local dst_path="";

    for cur_name in ${name_list};
    do
        src_path="${src_dir}/${cur_name}"

        # ~/.config/yazi/yazi.toml
        dst_path="${dst_dir}/${cur_name}"

        if [[ -e "${src_path}" ]] && [[ ! -e "${dst_path}" ]]; then
            su - "${CUR_USER}" -c "cp -Rf ${src_path} ${dst_path}";
            chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
            # chmod 664 "${dst_path}"
        fi
    done
    # --------------------------------------------------------------------------
}

function install_nerd_font()
{
    # --------------------------------------------------------------------------
    # HackNerdFont
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-hacknerdfont.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    install_deps_for_yazi;
    install_yazi;
    copy_yazirc;
    install_nerd_font;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================