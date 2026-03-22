#!/bin/bash

# nnn ==========================================================================
# bash ${BIN_DIR}/filemgr/install_.nnnrc ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$1;
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_nnn()
{
        if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^zoxide) ]] || apt install -y zoxide;
        [[ -n $(apt list --installed | grep -i ^fd-find) ]] || apt install -y fd-find;
        [[ -n $(apt list --installed | grep -i ^ripgrep) ]] || apt install -y ripgrep;

        # 이미지/문서
        [[ -n $(apt list --installed | grep -i ^imagemagick) ]] || apt install -y imagemagick;
        [[ -n $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y poppler-utils;
        [[ -n $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y djvulibre-bin;
        [[ -n $(apt list --installed | grep -i ^bat) ]] || apt install -y bat;

        # 미디어
        [[ -n $(apt list --installed | grep -i ^ffmpegthumbnailer) ]] || apt install -y ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(apt list --installed | grep -i ^atool) ]] || apt install -y atool;
        [[ -n $(apt list --installed | grep -i ^7zip) ]] || apt install -y 7zip;
        [[ -n $(apt list --installed | grep -i ^jq) ]] || apt install -y jq;

        # 터미널 ui
        [[ -n $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;

        # nnn
        [[ -n $(apt list --installed | grep -i ^nnn) ]] || apt install -y nnn;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^ripgrep) ]] || dnf install -y ripgrep;

        # 이미지/문서
        [[ -n $(dnf list --installed | grep -i ^imagemagick) ]] || dnf install -y imagemagick;
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y djvulibre;
        [[ -n $(dnf list --installed | grep -i ^bat) ]] || dnf install -y bat;

        # 미디어
        [[ -n $(dnf list --installed | grep -i ^ffmpegthumbnailer) ]] || dnf install -y ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        [[ -n $(dnf list --installed | grep -i ^jq) ]] || dnf install -y jq;

        # 터미널 ui
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;

        # nnn
        [[ -n $(dnf list --installed | grep -i ^nnn) ]] || dnf install -y nnn;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(pacman -Q | grep -i ^fzf) ]] || pacman -S --noconfirm fzf;
        [[ -n $(pacman -Q | grep -i ^zoxide) ]] || pacman -S --noconfirm zoxide;
        [[ -n $(pacman -Q | grep -i ^fd) ]] || pacman -S --noconfirm fd;
        [[ -n $(pacman -Q | grep -i ^ripgrep) ]] || pacman -S --noconfirm ripgrep;

        # 이미지/문서
        [[ -n $(pacman -Q | grep -i ^imagemagick) ]] || pacman -S --noconfirm imagemagick;
        [[ -n $(pacman -Q | grep -i ^poppler) ]] || pacman -S --noconfirm poppler;
        [[ -n $(pacman -Q | grep -i ^poppler) ]] || pacman -S --noconfirm djvulibre;
        [[ -n $(pacman -Q | grep -i ^bat) ]] || pacman -S --noconfirm bat;

        # 미디어
        [[ -n $(pacman -Q | grep -i ^ffmpegthumbnailer) ]] || pacman -S --noconfirm ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(pacman -Q | grep -i ^atool) ]] || pacman -S --noconfirm atool;
        [[ -n $(pacman -Q | grep -i ^7zip) ]] || pacman -S --noconfirm 7zip;
        [[ -n $(pacman -Q | grep -i ^jq) ]] || pacman -S --noconfirm jq;

        # 터미널 ui
        [[ -n $(pacman -Q | grep -i ^tmux) ]] || pacman -S --noconfirm tmux;

        # nnn
        [[ -n $(pacman -Q | grep -i ^nnn) ]] || pacman -S --noconfirm nnn;
        # ----------------------------------------------------------------------
    fi
}


function config_bashrc()
(
    # --------------------------------------------------------------------------
    local kwd="NNN_PATH="
    local cmd='
# nnn ==========================================================================
NNN_PATH="${HOME}/.config/nnn/.nnnrc"

if [[ -f "${NNN_PATH}" ]]; then
    source "${NNN_PATH}"
fi
# ==============================================================================
'
    # ~/.bashrc
    local dst_path="${HOME_DIR}/.bashrc";
    if [[ -f ${dst_path} ]]; then
        if [[ ! $(cat ${dst_path} | grep -i ${kwd}) ]]; then
            # su - ${CUR_USER} -c "echo "${cmd}" >> "${dst_path}"";
            echo "${cmd}" >> "${dst_path}";
            chown ${CUR_USER}:${CUR_USER} "${dst_path}"
            chmod 644 "${dst_path}"
        fi
    fi

    # ~/.zshrc
    local dst_path="${HOME_DIR}/.zshrc";
    if [[ -f ${dst_path} ]]; then
        if [[ ! $(cat ${dst_path} | grep -i ${kwd}) ]]; then
            # su - ${CUR_USER} -c "echo "${cmd}" >> "${dst_path}"";
            echo "${cmd}" >> "${dst_path}";
            chown ${CUR_USER}:${CUR_USER} "${dst_path}"
            chmod 644 "${dst_path}"
        fi
    fi
    # --------------------------------------------------------------------------
)


function config_nnn()
{
    local dst_dir="${HOME_DIR}/.config/nnn";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi

    local dst_path="${dst_dir}/.nnnrc"
    local cmd='#!/bin/bash

# ------------------------------------------------------------------------------
# 시작시 숨김파일 보기
export NNN_OPTS="H"
# export NNN_OPTS="eaEoxH"
# export NNN_OPTS="cEnrx"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# export LC_COLLATE='C'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# context 마다 다른 컬러
# export NNN_COLORS='1234'
export NNN_COLORS='1267'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# l(right)키로 편집기로 열기
export NNN_USE_EDITOR=1
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 삭제했을때 휴지통으로 가기
export NNN_TRASH="1"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# preview-tui는 export NNN_FIFO=/tmp/nnn.fifo 환경변수 설정이 필요
# set --export NNN_FIFO "/tmp/nnn.fifo"
export NNN_FIFO=/tmp/nnn.fifo

# nnn을 사용할때 발생하는 오류를 방지
export PAGER="less -R"
# ------------------------------------------------------------------------------

# bookmarks --------------------------------------------------------------------
# b(bookmark) + "추가"키 사용
export NNN_BMS=""
NNN_BMS+="r:/;"
NNN_BMS+="d:/dev;"
NNN_BMS+="e:/etc;"
NNN_BMS+="m:/media;"
NNN_BMS+="M:/mnt;"
NNN_BMS+="o:/opt;"
NNN_BMS+="s:/srv;"
NNN_BMS+="p:/tmp;"
NNN_BMS+="u:/usr;"
NNN_BMS+="v:/var;"
NNN_BMS+="h:~;"
# ------------------------------------------------------------------------------

# plugins ----------------------------------------------------------------------
# ;(plugins) + "추가"키 사용

# ~/.config/nnn/plugins에 nnn 플러그인 설치
# sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
# cd ~/.config/nnn/plugins

export NNN_PLUG=""
NNN_PLUG+="a:autojump;"
NNN_PLUG+="d:diffs;"
NNN_PLUG+="f:finder;"
NNN_PLUG+="g:fzplug;"
NNN_PLUG+="o:fzopen;"
# NNN_PLUG+="P:preview-tabbed;"
NNN_PLUG+="p:preview-tui;"
NNN_PLUG+="s:shell;"
NNN_PLUG+="t:nmount;"
NNN_PLUG+="v:imgview"
# ------------------------------------------------------------------------------
'

    # ~/.config/nnn/.nnnrc
    if [[ ! -f ${dst_path} ]]; then
        # su - ${CUR_USER} -c "echo ${cmd} > ${dst_path}";
        echo "${cmd}" > "${dst_path}";
        chown ${CUR_USER}:${CUR_USER} "${dst_path}"
        chmod 775 "${dst_path}"
    fi
}


function create_nnn_plugins()
{
    # ~/.config/nnn/plugins
    local dst_dir="${HOME_DIR}/.config/nnn/plugins";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi

    # ~/.config/nnn/plugins/autojump
    local dst_path="${dst_dir}/autojump"
    local cmd="sh -c '$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)'"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "eval ${cmd}";
    fi
}


function create_shell_plugins()
{
    # ~/.config/nnn/plugins
    local dst_dir="${HOME_DIR}/.config/nnn/plugins";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi

    # ~/.config/nnn/plugins/shell
    local dst_path="${dst_dir}/shell"
    local cmd='#!/usr/bin/env sh

# ------------------------------------------------------------------------------
# 1. 환경변수가 선언되지 않았을 경우를 대비한 기본값 설정
# (보통 /tmp/.nnncp 를 관습적으로 많이 사용합니다)
SELECTION="${NNN_SEL:-${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection}"

# 2. Selection 파일이 존재하고(-f), 크기가 0이 아닌지(-s) 확인
if [ -f "${SELECTION}" ] && [ -s "${SELECTION}" ]; then
    # 선택된 파일이 있을 때 (개행으로 구분된 목록)
    files=$(tr '\0' '\n' < "${SELECTION}")
else
    # 선택된 파일이 없을 때 (현재 커서의 파일 $1)
    files="${PWD}/${1}"
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [ ! -p "${NNN_PIPE}" ]; then
    printf "ERROR: NNN_PIPE is not set!"
    read -r _
    exit 2
fi

clear
printf "shell : "
read -r cmd
printf "%s" "0c${cmd}" > "${NNN_PIPE}"

# echo "cmd: ${cmd}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ *"${cmd}" == *'%s'* ]]; then
    echo "${files}" | xargs -I %s $cmd
else
    eval "${cmd}"
fi

clear;
# ------------------------------------------------------------------------------
'

    # ~/.config/nnn/plugins/shell
    if [[ ! -f ${dst_path} ]]; then
        # su - ${CUR_USER} -c "echo ${cmd} > ${dst_path}";
        echo "${cmd}" > "${dst_path}";
        chown ${CUR_USER}:${CUR_USER} "${dst_path}"
        chmod 775 "${dst_path}"
    fi
}
# ==============================================================================


# Main : x86_64, aarch64, i686 =================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nnn;
    config_bashrc;
    config_nnn;
    create_nnn_plugins;
    create_shell_plugins;
fi
# ==============================================================================


