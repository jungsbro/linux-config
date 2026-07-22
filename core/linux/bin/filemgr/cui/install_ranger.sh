#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/cui/install_ranger.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/cui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

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
TMP_DIR="/tmp";

# /tmp/ranger-config
CONFIG_DIR="${TMP_DIR}/ranger-config";

# /tmp/ranger-archives
ARCHIVE_DIR="${TMP_DIR}/ranger-archives";
# ------------------------------------------------------------------------------
# ==============================================================================


# ranger : x86_64, aarch64, i686 ===============================================
function install_ranger_pip()   # not used
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local RNG_CMD="pip3 install --user ranger-fm"
    # --------------------------------------------------------------------------

    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -e "~/.local/bin/ranger" ]] || eval '${RNG_CMD}'";
    # --------------------------------------------------------------------------

    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        [[ -e "/root/.local/bin/ranger" ]] || eval '${RNG_CMD}';
    fi
    # --------------------------------------------------------------------------
}

function install_dependency_for_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        pacman -S --needed --noconfirm python;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        [[ -n $(pacman -Q | grep -i ^highlight) ]] || pacman -S --needed --noconfirm highlight;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        [[ -n $(pacman -Q | grep -i ^w3m) ]] || pacman -S --needed --noconfirm w3m;
        [[ -n $(pacman -Q | grep -i ^ffmpeg) ]] || pacman -S --needed --noconfirm ffmpeg;
        [[ -n $(pacman -Q | grep -i ^imagemagick) ]] || pacman -S --needed --noconfirm imagemagick;
        [[ -n $(pacman -Q | grep -i ^catimg) ]] || pacman -S --needed --noconfirm catimg;
        [[ -n $(pacman -Q | grep -i ^libcaca) ]] || pacman -S --needed --noconfirm libcaca;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        [[ -n $(pacman -Q | grep -i ^poppler) ]] || pacman -S --needed --noconfirm poppler;
        [[ -n $(pacman -Q | grep -i ^mediainfo) ]] || pacman -S --needed --noconfirm mediainfo;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        [[ -n $(pacman -Q | grep -i ^atool) ]] || pacman -S --needed --noconfirm atool;
        [[ -n $(pacman -Q | grep -i ^tar) ]] || pacman -S --needed --noconfirm tar;
        [[ -n $(pacman -Q | grep -i ^7zip) ]] || pacman -S --needed --noconfirm 7zip;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(pacman -Q | grep -i ^fzf) ]] || pacman -S --needed --noconfirm fzf;
        [[ -n $(pacman -Q | grep -i ^fasd) ]] || pacman -S --needed --noconfirm fasd;
        [[ -n $(pacman -Q | grep -i ^findutils) ]] || pacman -S --needed --noconfirm findutils;
        [[ -n $(pacman -Q | grep -i ^plocate) ]] || pacman -S --needed --noconfirm plocate;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 기타
        [[ -n $(pacman -Q | grep -i ^git) ]] || pacman -S --needed --noconfirm git;
        [[ -n $(pacman -Q | grep -i ^trash-cli) ]] || pacman -S --needed --noconfirm trash-cli;
        [[ -n $(pacman -Q | grep -i ^mpv) ]] || pacman -S --needed --noconfirm mpv;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        apt install -y python3;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        [[ -n $(apt list --installed | grep -i ^highlight) ]] || apt install -y highlight;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        [[ -n $(apt list --installed | grep -i ^w3m) ]] || apt install -y w3m;
        [[ -n $(apt list --installed | grep -i ^ffmpeg) ]] || apt install -y ffmpeg;
        [[ -n $(apt list --installed | grep -i ^imagemagick) ]] || apt install -y imagemagick;
        [[ -n $(apt list --installed | grep -i ^catimg) ]] || apt install -y catimg;
        [[ -n $(apt list --installed | grep -i ^caca-utils) ]] || apt install -y caca-utils;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        [[ -n $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y poppler-utils;
        [[ -n $(apt list --installed | grep -i ^mediainfo) ]] || apt install -y mediainfo;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        [[ -n $(apt list --installed | grep -i ^atool) ]] || apt install -y atool;
        [[ -n $(apt list --installed | grep -i ^tar) ]] || apt install -y tar;
        [[ -n $(apt list --installed | grep -i ^p7zip-full) ]] || apt install -y p7zip-full;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^fasd) ]] || apt install -y fasd;
        [[ -n $(apt list --installed | grep -i ^findutils) ]] || apt install -y findutils;
        # [[ -n $(apt list --installed | grep -i ^mlocate) ]] || apt install -y mlocate;
        [[ -n $(apt list --installed | grep -i ^plocate) ]] || apt install -y plocate;

        # ----------------------------------------------------------------------
        # 기타
        [[ -n $(apt list --installed | grep -i ^git) ]] || apt install -y git;
        [[ -n $(apt list --installed | grep -i ^trash-cli) ]] || apt install -y trash-cli;
        [[ -n $(apt list --installed | grep -i ^mpv) ]] || apt install -y mpv;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        [[ -n $(dnf list --installed | grep -i ^python3) ]] || dnf install -y python3;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        [[ -n $(dnf list --installed | grep -i ^highlight) ]] || dnf install -y highlight;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        [[ -n $(dnf list --installed | grep -i ^w3m) ]] || dnf install -y w3m;

        [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^ffmpeg) ]] || dnf install -y ffmpeg;

        [[ -n $(dnf list --installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;
        [[ -n $(dnf list --installed | grep -i ^catimg) ]] || dnf install -y catimg;
        [[ -n $(dnf list --installed | grep -i ^caca-utils) ]] || dnf install -y caca-utils;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;
        [[ -n $(dnf list --installed | grep -i ^mediainfo) ]] || dnf install -y mediainfo;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;
        [[ -n $(dnf list --installed | grep -i ^tar) ]] || dnf install -y tar;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        # [[ -n $(dnf list --installed | grep -i ^fasd) ]] || dnf install -y fasd;
        [[ -n $(dnf list --installed | grep -i ^findutils) ]] || dnf install -y findutils;
        [[ -n $(dnf list --installed | grep -i ^plocate) ]] || dnf install -y plocate;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 기타
        [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
        [[ -n $(dnf list --installed | grep -i ^mpv) ]] || dnf install -y trash-cli;
        [[ -n $(dnf list --installed | grep -i ^mpv) ]] || dnf install -y mpv;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        [[ -n $(dnf list --installed | grep -i ^python3) ]] || dnf install -y python3;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        [[ -n $(dnf list --installed | grep -i ^highlight) ]] || dnf install -y highlight;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^w3m) ]] || dnf install -y w3m;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf repolist | grep -i ^crb) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^ffmpeg) ]] || dnf install -y ffmpeg;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^caca-utils) ]] || dnf install -y caca-utils;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^catimg) ]] || dnf install -y catimg;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^mediainfo) ]] || dnf install -y mediainfo;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;

        [[ -n $(dnf list --installed | grep -i ^tar) ]] || dnf install -y tar;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # [[ -n $(dnf list --installed | grep -i ^fasd) ]] || dnf install -y fasd;

        [[ -n $(dnf list --installed | grep -i ^findutils) ]] || dnf install -y findutils;

        [[ -n $(dnf list --installed | grep -i ^mlocate) ]] || dnf install -y mlocate;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 기타
        [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^mpv) ]] || dnf install -y trash-cli;

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^mpv) ]] || dnf install -y mpv;
        # ----------------------------------------------------------------------
    fi
}

function install_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^ranger) ]] || pacman -S --needed --noconfirm ranger;

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^ranger) ]] || apt install -y ranger;

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^ranger) ]] || dnf install -y ranger;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^ranger) ]] || dnf install -y ranger;
    fi
}

function config_ranger_pip()
{
    # --------------------------------------------------------------------------
    local BASHRC_PATH="/root/.bashrc";

    local PATH_CMD='if [[ *"$PATH"* != *"$HOME:"* ]]; then
    export PATH=$PATH:$HOME
fi
if [[ *"$PATH"* != *"$HOME/.local/bin"* ]]; then
    export PATH=$PATH:$HOME/.local/bin
fi';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -e ${BASHRC_PATH} ]] && [[ *"$(cat ${BASHRC_PATH})"* != *"${PATH_CMD}"* ]]; then
        echo "" >> ${BASHRC_PATH};
        echo "${PATH_CMD}" >> ${BASHRC_PATH};
    fi
    # --------------------------------------------------------------------------
}

function config_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    if [[ -d ${CONFIG_DIR} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/ranger-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "chmod 755 ${CONFIG_DIR}/.config/ranger/scope.sh";
    su - ${CUR_USER} -c "git clone https://github.com/maximtrp/ranger-archives.git ${ARCHIVE_DIR}";
    # --------------------------------------------------------------------------

    # for user -----------------------------------------------------------------
    su - ${CUR_USER} -c "mkdir -p ~/.config/ranger/plugins";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.config/ranger ~/.config/";
    su - ${CUR_USER} -c "cp -Rf ${ARCHIVE_DIR} ~/.config/ranger/plugins/";
    # --------------------------------------------------------------------------

    # for root -----------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        config_ranger_pip;
        mkdir -p /root/.config/ranger/plugins;
        cp -Rf ${CONFIG_DIR}/.config/ranger /root/.config/;
        cp -Rf ${ARCHIVE_DIR} /root/.config/ranger/plugins/;
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dependency_for_ranger;
    install_ranger;
    config_ranger;
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================