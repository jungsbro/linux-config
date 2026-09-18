#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/install_ranger.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/tui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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
TMP_DIR="/tmp";

# /tmp/ranger-config
CONFIG_DIR="${TMP_DIR}/ranger-config";

# /tmp/ranger-archives
ARCHIVE_DIR="${TMP_DIR}/ranger-archives";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funs =========================================================================
function install_ranger_pip()   # not used
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local RNG_CMD="pip3 install --user ranger-fm"
    # --------------------------------------------------------------------------

    # user ---------------------------------------------------------------------
    su - "${CUR_USER}" -c "[[ -e "~/.local/bin/ranger" ]] || eval '${RNG_CMD}'";
    # --------------------------------------------------------------------------

    # root ---------------------------------------------------------------------
    if [[ "${CUR_USER}" != "root" ]]; then
        [[ -e "/root/.local/bin/ranger" ]] || eval '${RNG_CMD}';
    fi
    # --------------------------------------------------------------------------
}


function install_deps_for_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # develop-tools
    bash ${CORE_BIN_DIR}/develop/cli/install_git.sh;
    bash ${CORE_BIN_DIR}/develop/cli/install_python.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 압축관리
    bash ${CORE_BIN_DIR}/archive/cli/install_7zip.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_atool.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_tar.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 코드 문법강조
    bash ${CORE_BIN_DIR}/ide/cli/install_highlight.sh;

    # 영상코덱
    bash ${CORE_BIN_DIR}/multimedia/cli/install_ffmpeg.sh;

    # 이미지 가공/포맷 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_imagemagick.sh;

    # pdf를 이미지로 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_poppler.sh;

    # 메타데이터 분석
    bash ${CORE_BIN_DIR}/multimedia/cli/install_mediainfo.sh;

    # 터미널 이미지 (ranger는 구세대를 사용한다.)
    # bash ${CORE_BIN_DIR}/multimedia/cli/install_chafa.sh;       # 신세대
    bash ${CORE_BIN_DIR}/multimedia/cli/install_catimg.sh;    # 중간세대
    bash ${CORE_BIN_DIR}/multimedia/cli/install_libcaca.sh;   # 구세대

    # player
    bash ${CORE_BIN_DIR}/multimedia/gui/mpv/install_mpv.sh "${CUR_USER}";

    # 터미널 브라우저
    bash ${CORE_BIN_DIR}/webbrowser/tui/install_w3m.sh;
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


function install_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        local app_name="ranger"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        local app_name="ranger"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        local app_name="ranger"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="ranger"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    fi
}


function config_ranger_pip()
{
    # --------------------------------------------------------------------------
    local BASHRC_PATH="/root/.bashrc";

    local PATH_CMD='if [[ "${PATH}" != *"$HOME:"* ]]; then
    export PATH=$PATH:$HOME
fi
if [[ "${PATH}" != *"$HOME/.local/bin"* ]]; then
    export PATH=$PATH:$HOME/.local/bin
fi';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -e "${BASHRC_PATH}" ]] && [[ $(cat "${BASHRC_PATH}") != *"${PATH_CMD}"* ]]; then
        echo "" >> "${BASHRC_PATH}";
        echo "${PATH_CMD}" >> "${BASHRC_PATH}";
    fi
    # --------------------------------------------------------------------------
}


function config_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    if [[ -d "${CONFIG_DIR}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${TMP_DIR}" ]] || mkdir -p "${TMP_DIR}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - "${CUR_USER}" -c "git clone https://github.com/jungsbro/ranger-config.git ${CONFIG_DIR}";
    su - "${CUR_USER}" -c "chmod 755 ${CONFIG_DIR}/.config/ranger/scope.sh";
    su - "${CUR_USER}" -c "git clone https://github.com/maximtrp/ranger-archives.git ${ARCHIVE_DIR}";
    # --------------------------------------------------------------------------

    # for user -----------------------------------------------------------------
    su - "${CUR_USER}" -c "mkdir -p ~/.config/ranger/plugins";
    su - "${CUR_USER}" -c "cp -Rf ${CONFIG_DIR}/.config/ranger ~/.config/";
    su - "${CUR_USER}" -c "cp -Rf ${ARCHIVE_DIR} ~/.config/ranger/plugins/";
    # --------------------------------------------------------------------------

    # for root -----------------------------------------------------------------
    if [[ "${CUR_USER}" != "root" ]]; then
        config_ranger_pip;
        mkdir -p /root/.config/ranger/plugins;
        cp -Rf "${CONFIG_DIR}/.config/ranger" "/root/.config/";
        cp -Rf "${ARCHIVE_DIR}" "/root/.config/ranger/plugins/";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    install_deps_for_ranger;
    install_ranger;
    config_ranger;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================