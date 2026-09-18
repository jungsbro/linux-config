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

# https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip
APP_VER="v26.1.22";
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
    if [[ "${CUR_ARCH}" == *"x86_64"* ]]; then
        local cur_arch="x86_64";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        local cur_arch="i686";
        # yazi not found for i686_deb
        return 0

    elif [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        local cur_arch="aarch64";

    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # yazi-x86_64-unknown-linux-gnu.deb
    # yazi-i686-unknown-linux-gnu.deb
    # yazi-aarch64-unknown-linux-gnu.deb
    local deb_fname="yazi-${cur_arch}-unknown-linux-gnu.deb"

    # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.deb
    # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-i686-unknown-linux-gnu.deb
    # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-gnu.deb
    local deb_url="https://github.com/sxyazi/yazi/releases/download/${APP_VER}/${deb_fname}"
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
    if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
        return 0
    fi


    # 1) portable_url ----------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-musl.zip
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-gnu.zip

        if [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
            local portable_name="yazi-aarch64-unknown-linux-musl";

        else
            local portable_name="yazi-aarch64-unknown-linux-gnu";
        fi

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-i686-unknown-linux-gnu.zip

        local portable_name="yazi-i686-unknown-linux-gnu";

    else
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-musl.zip
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip

        if [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
            local portable_name="yazi-x86_64-unknown-linux-musl";
        else
            local portable_name="yazi-x86_64-unknown-linux-gnu";
        fi

    fi

    local portable_fname="${portable_name}.zip"

    local portable_url="https://github.com/sxyazi/yazi/releases/download/${APP_VER}/${portable_fname}"
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