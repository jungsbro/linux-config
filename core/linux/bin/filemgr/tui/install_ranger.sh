#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/install_ranger.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
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
    if [[ -z ${CUR_USER} ]]; then
        return 0
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
        return 0
    fi
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        local app_name="python"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        local app_name="highlight"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        local app_name="w3m"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="ffmpeg"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="imagemagick"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="catimg"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="libcaca"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        local app_name="poppler"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="mediainfo"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        local app_name="atool"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="tar"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="7zip"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="fasd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="findutils"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="plocate"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 기타
        local app_name="git"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="trash-cli"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="mpv"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        local app_name="python3"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        local app_name="highlight"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        local app_name="w3m"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="ffmpeg"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="imagemagick"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="catimg"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="caca-utils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        local app_name="poppler-utils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="mediainfo"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        local app_name="atool"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="tar"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="p7zip-full"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="fasd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="findutils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="mlocate"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="plocate"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # 기타
        local app_name="git"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="trash-cli"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="mpv"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        local app_name="python3"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        local app_name="highlight"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        local app_name="w3m"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="ffmpeg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        local app_name="ImageMagick"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="catimg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="caca-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        local app_name="poppler-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="mediainfo"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        local app_name="atool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="tar"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="p7zip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="fasd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="findutils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="plocate"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 기타
        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="trash-cli"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="mpv"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 필수엔진
        local app_name="python3"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 코드강조
        local app_name="highlight"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 이미지/비디오
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="w3m"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf repolist | grep -i ^crb) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="ffmpeg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        local app_name="ImageMagick"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="catimg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="caca-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 문서/미디어 정보
        local app_name="poppler-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="mediainfo"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 압축관리
        local app_name="atool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="tar"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="p7zip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="fasd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="findutils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="mlocate"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 기타
        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="trash-cli"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="mpv"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}

function install_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local app_name="ranger"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local app_name="ranger"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        local app_name="ranger"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="ranger"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
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
        return 0
    fi
    if [[ -d ${CONFIG_DIR} ]]; then
        return 0
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

function execute_main()
{
    install_dependency_for_ranger;
    install_ranger;
    config_ranger;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================