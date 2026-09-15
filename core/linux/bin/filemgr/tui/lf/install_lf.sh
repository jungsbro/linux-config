#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/lf/install_lf.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/tui/lf
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
APP_NAME="lf";

# /tmp/lf
TMP_DIR="/tmp/${APP_NAME}";

# /usr/local/bin
LOCAL_BIN_DIR="/usr/local/bin"

# https://github.com/gokcehan/lf/releases/download/r41/lf-linux-amd64.tar.gz
APP_VER="r41";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_deps_for_lf()
{
    # --------------------------------------------------------------------------
    # 압축관리
    bash ${CORE_BIN_DIR}/archive/cli/install_7zip.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_atool.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 데이터관리
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_jq.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 코드 문법강조
    bash ${CORE_BIN_DIR}/ide/cli/install_highlight.sh;

    # thumbnail생성
    bash ${CORE_BIN_DIR}/multimedia/cli/install_ffmpegthumbnailer.sh;

    # 이미지 가공/포맷 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_imagemagick.sh;

    # pdf를 이미지로 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_poppler.sh;

    # 스캔문서 가공 도구
    bash ${CORE_BIN_DIR}/multimedia/cli/install_djvulibre.sh;

    # 메타데이터 분석
    bash ${CORE_BIN_DIR}/multimedia/cli/install_mediainfo.sh;

    # 터미널 이미지
    bash ${CORE_BIN_DIR}/multimedia/cli/install_chafa.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fzf, ripgrep, fd-find, zoxide, fasd, plocate
    bash ${CORE_BIN_DIR}/filemgr/tools/install_find-tools.sh "${CUR_USER}";

    # bat, eza, lsd, tree
    bash ${CORE_BIN_DIR}/filemgr/tools/install_ls-tools.sh "${CUR_USER}";

    # 휴지통
    bash ${CORE_BIN_DIR}/system/cli/install_trash-cli.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # tmux
    bash ${CORE_BIN_DIR}/system/cli/install_tmux.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function install_lf_for_portable()
{
    if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
        return 0
    fi

    # 1) portable_url ----------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-arm64.tar.gz
        local portable_fname="lf-linux-arm64.tar.gz";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-386.tar.gz
        local portable_fname="lf-linux-386.tar.gz";

    else
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-amd64.tar.gz
        local portable_fname="lf-linux-amd64.tar.gz";
    fi

    local portable_url="https://github.com/gokcehan/lf/releases/download/${APP_VER}/${portable_fname}"
    # --------------------------------------------------------------------------

    # 2) ZIP_PATH --------------------------------------------------------------
    # /tmp/lf
    if [[ ! -d "${TMP_DIR}" ]]; then
        mkdir -p "${TMP_DIR}";
        chmod 777 "${TMP_DIR}";
    fi

    # /tmp/lf/lf-linux-amd64.tar.gz
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

    # tar -xzvf /tmp/lf/lf-1.1.16.gtk2.x86_64.tar.xz -C /usr/local/bin;
    # /usr/local/bin/lf
    tar -xzvf "${tmp_path}" -C "${LOCAL_BIN_DIR}";
    rm -f "${tmp_path}";
    # --------------------------------------------------------------------------
}


function install_lf()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^lf) ]] || pacman -S --noconfirm --needed lf;

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^lf) ]] || apt install -y lf;

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        install_lf_for_portable;

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        install_lf_for_portable;
    fi
}

function copy_lfrc()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/lf/config/lfrc"
    if [[ ! -f "${src_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/lf
    local dst_dir="${HOME_DIR}/.config/lf";
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/lf/lfrc
    local dst_path="${dst_dir}/lfrc"

    if [[ ! -f "${dst_path}" ]]; then
        su - "${CUR_USER}" -c "cp ${src_path} ${dst_path}";
        chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
        chmod 664 "${dst_path}"
    fi
    # --------------------------------------------------------------------------
}

function set_color_icon_settings()
{
    # --------------------------------------------------------------------------
    # ~/.config/lf
    local dst_dir="${HOME_DIR}/.config/lf";
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) ~/.config/lf/lfrc
    # set icons true
    local cmd="set icons true"

    # ~/.config/lf/lfrc
    local dst_path="${dst_dir}/lfrc";
    if [[ -f "${dst_path}" ]]; then
        if [[ ! $(cat "${dst_path}" | grep -i "${cmd}") ]]; then
            echo "${cmd}" >> "${dst_path}";
            chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
            chmod 644 "${dst_path}"
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/lf/colors
    local dst_url="https://raw.githubusercontent.com/gokcehan/lf/master/etc/colors.example"

    # ~/.config/lf/colors
    local dst_path="${dst_dir}/colors"

    if [[ ! -f "${dst_path}" ]]; then
        su - "${CUR_USER}" -c "curl ${dst_url} -o ${dst_path}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/lf/icons
    local dst_url="https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example"

    # ~/.config/lf/icons
    local dst_path="${dst_dir}/icons"

    if [[ ! -f "${dst_path}" ]]; then
        su - "${CUR_USER}" -c "curl ${dst_url} -o ${dst_path}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) HackNerdFont
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-hacknerdfont.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function execute_main()
{
    install_deps_for_lf;
    install_lf;
    copy_lfrc;
    set_color_icon_settings;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================