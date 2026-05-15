#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/cui/install_lf.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/cui
CUR_DIR="$(dirname "$(realpath "$0")")"

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
function install_dependency_for_lf()
{
    # 확장기능을 사용하기 위한 의존성
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(pacman -Q | grep -i ^fzf) ]] || pacman -S --needed --noconfirm fzf;
        [[ -n $(pacman -Q | grep -i ^zoxide) ]] || pacman -S --needed --noconfirm zoxide;
        [[ -n $(pacman -Q | grep -i ^fd) ]] || pacman -S --needed --noconfirm fd;
        [[ -n $(pacman -Q | grep -i ^ripgrep) ]] || pacman -S --needed --noconfirm ripgrep;

        # 폴더/파일
        [[ -n $(pacman -Q | grep -i ^eza) ]] || pacman -S --needed --noconfirm eza;
        [[ -n $(pacman -Q | grep -i ^tree) ]] || pacman -S --needed --noconfirm tree;
        [[ -n $(pacman -Q | grep -i ^bat) ]] || pacman -S --needed --noconfirm bat;
        [[ -n $(pacman -Q | grep -i ^lsd) ]] || pacman -S --needed --noconfirm lsd;

        # 이미지/문서
        [[ -n $(pacman -Q | grep -i ^highlight) ]] || pacman -S --needed --noconfirm highlight;
        [[ -n $(pacman -Q | grep -i ^imagemagick) ]] || pacman -S --needed --noconfirm imagemagick;
        [[ -n $(pacman -Q | grep -i ^djvulibre) ]] || pacman -S --needed --noconfirm djvulibre;
        [[ -n $(pacman -Q | grep -i ^poppler) ]] || pacman -S --needed --noconfirm poppler;
        [[ -n $(pacman -Q | grep -i ^chafa) ]] || pacman -S --needed --noconfirm chafa;

        # 미디어
        [[ -n $(pacman -Q | grep -i ^ffmpegthumbnailer) ]] || pacman -S --needed --noconfirm ffmpegthumbnailer;
        [[ -n $(pacman -Q | grep -i ^mediainfo) ]] || pacman -S --needed --noconfirm mediainfo;

        # 압축/데이터
        [[ -n $(pacman -Q | grep -i ^atool) ]] || pacman -S --needed --noconfirm atool;
        [[ -n $(pacman -Q | grep -i ^7zip) ]] || pacman -S --needed --noconfirm 7zip;
        [[ -n $(pacman -Q | grep -i ^jq) ]] || pacman -S --needed --noconfirm jq;

        # 터미널 ui
        [[ -n $(pacman -Q | grep -i ^tmux) ]] || pacman -S --needed --noconfirm tmux;

        # 휴지통
        [[ -n $(pacman -Q | grep -i ^trash-cli) ]] || pacman -S --needed --noconfirm trash-cli;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^zoxide) ]] || apt install -y zoxide;
        [[ -n $(apt list --installed | grep -i ^fd-find) ]] || apt install -y fd-find;
        [[ -n $(apt list --installed | grep -i ^ripgrep) ]] || apt install -y ripgrep;

        # 폴더/파일
        [[ -n $(apt list --installed | grep -i ^eza) ]] || apt install -y eza;
        [[ -n $(apt list --installed | grep -i ^tree) ]] || apt install -y tree;
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^bat) ]] || apt install -y bat;
        su - ${CUR_USER} -c "mkdir -p ${HOME_DIR}/.local/bin";
        su - ${CUR_USER} -c "ln -s /usr/bin/batcat ${HOME_DIR}/.local/bin/bat";
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^lsd) ]] || apt install -y lsd;

        # 이미지/문서
        [[ -n $(apt list --installed | grep -i ^highlight) ]] || apt install -y highlight;
        [[ -n $(apt list --installed | grep -i ^imagemagick) ]] || apt install -y imagemagick;
        [[ -n $(apt list --installed | grep -i ^djvulibre-bin) ]] || apt install -y djvulibre-bin;
        [[ -n $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y poppler-utils;
        [[ -n $(apt list --installed | grep -i ^chafa) ]] || apt install -y chafa;

        # 미디어
        [[ -n $(apt list --installed | grep -i ^ffmpegthumbnailer) ]] || apt install -y ffmpegthumbnailer;
        [[ -n $(apt list --installed | grep -i ^mediainfo) ]] || apt install -y mediainfo;

        # 압축/데이터
        [[ -n $(apt list --installed | grep -i ^atool) ]] || apt install -y atool;
        [[ -n $(apt list --installed | grep -i ^7zip) ]] || apt install -y 7zip;
        [[ -n $(apt list --installed | grep -i ^jq) ]] || apt install -y jq;

        # 터미널 ui
        [[ -n $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;

        # 휴지통
        [[ -n $(apt list --installed | grep -i ^trash-cli) ]] || apt install -y trash-cli;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^ripgrep) ]] || dnf install -y ripgrep;

        # 폴더/파일
        [[ -n $(dnf list --installed | grep -i ^tree) ]] || dnf install -y tree;
        [[ -n $(dnf list --installed | grep -i ^bat) ]] || dnf install -y bat;

        # 이미지/문서
        [[ -n $(dnf list --installed | grep -i ^highlight) ]] || dnf install -y highlight;
        [[ -n $(dnf list --installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;
        [[ -n $(dnf list --installed | grep -i ^djvulibre) ]] || dnf install -y djvulibre;
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;
        [[ -n $(dnf list --installed | grep -i ^chafa) ]] || dnf install -y chafa;

        # 미디어
        [[ -n $(dnf list --installed | grep -i ^ffmpegthumbnailer) ]] || dnf install -y ffmpegthumbnailer;
        [[ -n $(dnf list --installed | grep -i ^mediainfo) ]] || dnf install -y mediainfo;

        # 압축/데이터
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        [[ -n $(dnf list --installed | grep -i ^jq) ]] || dnf install -y jq;

        # 터미널 ui
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;

        # 휴지통
        [[ -n $(dnf list --installed | grep -i ^trash-cli) ]] || dnf install -y trash-cli;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^ripgrep) ]] || dnf install -y ripgrep;

        # 폴더/파일
        [[ -n $(dnf list --installed | grep -i ^tree) ]] || dnf install -y tree;
        [[ -n $(dnf list --installed | grep -i ^bat) ]] || dnf install -y bat;
        [[ -n $(dnf list --installed | grep -i ^lsd) ]] || dnf install -y lsd;

        # 이미지/문서
        [[ -n $(dnf list --installed | grep -i ^highlight) ]] || dnf install -y highlight;
        [[ -n $(dnf list --installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;
        [[ -n $(dnf list --installed | grep -i ^djvulibre) ]] || dnf install -y djvulibre;
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;
        [[ -n $(dnf list --installed | grep -i ^chafa) ]] || dnf install -y chafa;

        # 미디어
        [[ -n $(dnf list --installed | grep -i ^ffmpegthumbnailer) ]] || dnf install -y ffmpegthumbnailer;
        [[ -n $(dnf list --installed | grep -i ^mediainfo) ]] || dnf install -y mediainfo;

        # 압축/데이터
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        [[ -n $(dnf list --installed | grep -i ^jq) ]] || dnf install -y jq;

        # 터미널 ui
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;

        # 휴지통
        [[ -n $(dnf list --installed | grep -i ^trash-cli) ]] || dnf install -y trash-cli;
        # ----------------------------------------------------------------------
    fi
}

function install_lf_for_portable()
{
    if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
        return
    fi

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-arm64.tar.gz
        local FNAME="lf-linux-arm64.tar.gz";

    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-386.tar.gz
        local FNAME="lf-linux-386.tar.gz";

    else
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-amd64.tar.gz
        local FNAME="lf-linux-amd64.tar.gz";
    fi

    local SRC_URL="https://github.com/gokcehan/lf/releases/download/${APP_VER}/${FNAME}"
    # --------------------------------------------------------------------------

    # 2) ZIP_PATH --------------------------------------------------------------
    # /tmp/lf
    if [[ ! -d "${TMP_DIR}" ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # /tmp/lf/lf-linux-amd64.tar.gz
    ZIP_PATH="${TMP_DIR}/${FNAME}"

    if [[ ! -e "${ZIP_PATH}" ]]; then
        wget "${SRC_URL}" -O "${ZIP_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 3) LOCAL_BIN_DIR ---------------------------------------------------------
    # /usr/local/bin
    if [[ ! -d "${LOCAL_BIN_DIR}" ]]; then
        return
    fi

    # tar -xzvf /tmp/lf/lf-1.1.16.gtk2.x86_64.tar.xz -C /usr/local/bin;
    # /usr/local/bin/lf
    tar -xzvf "${ZIP_PATH}" -C ${LOCAL_BIN_DIR};
    rm -f "${ZIP_PATH}";
    # --------------------------------------------------------------------------
}


function install_lf()
{
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^lf) ]] || pacman -S --needed --noconfirm lf;

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^lf) ]] || apt install -y lf;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        install_lf_for_portable;

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        install_lf_for_portable;
    fi
}

function copy_lfrc()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/lf/lfrc"
    if [[ ! -f ${src_path} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/lf
    local dst_dir="${HOME_DIR}/.config/lf";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/lf/lfrc
    local dst_path="${dst_dir}/lfrc"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "cp ${src_path} ${dst_path}";
        chown ${CUR_USER}:${CUR_USER} "${dst_path}"
        chmod 664 "${dst_path}"
    fi
    # --------------------------------------------------------------------------
}

function set_color_icon_settings()
{
    # --------------------------------------------------------------------------
    # ~/.config/lf
    local dst_dir="${HOME_DIR}/.config/lf";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) ~/.config/lf/lfrc
    # set icons true
    local cmd="set icons true"

    # ~/.config/lf/lfrc
    local dst_path="${dst_dir}/lfrc";
    if [[ -f ${dst_path} ]]; then
        if [[ ! $(cat ${dst_path} | grep -i ${cmd}) ]]; then
            echo "${cmd}" >> "${dst_path}";
            chown ${CUR_USER}:${CUR_USER} "${dst_path}"
            chmod 644 "${dst_path}"
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/lf/colors
    local dst_url="https://raw.githubusercontent.com/gokcehan/lf/master/etc/colors.example"

    # ~/.config/lf/colors
    local dst_path="${dst_dir}/colors"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "curl ${dst_url} -o ${dst_path}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/lf/icons
    local dst_url="https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example"

    # ~/.config/lf/icons
    local dst_path="${dst_dir}/icons"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "curl ${dst_url} -o ${dst_path}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) HackNerdFont
    bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh ${CUR_USER};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main : x86_64, aarch64, i686 =================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dependency_for_lf;
    install_lf;
    copy_lfrc;
    set_color_icon_settings;
fi
# ==============================================================================