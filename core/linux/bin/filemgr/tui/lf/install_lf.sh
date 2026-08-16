#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/lf/install_lf.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
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
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="zoxide"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="fd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="ripgrep"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 폴더/파일
        local app_name="eza"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="tree"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="bat"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="lsd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 이미지/문서
        local app_name="highlight"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="imagemagick"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="djvulibre"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="poppler"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="chafa"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="mediainfo"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 압축/데이터
        local app_name="atool"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="7zip"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="jq"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 휴지통
        local app_name="trash-cli"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="zoxide"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="fd-find"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="ripgrep"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 폴더/파일
        local app_name="eza"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="tree"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="bat"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        su - ${CUR_USER} -c "mkdir -p ${HOME_DIR}/.local/bin";
        su - ${CUR_USER} -c "ln -s /usr/bin/batcat ${HOME_DIR}/.local/bin/bat";
        # ----------------------------------------------------------------------
        local app_name="lsd"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 이미지/문서
        local app_name="highlight"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="imagemagick"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="djvulibre-bin"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="poppler-utils"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="chafa"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="mediainfo"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 압축/데이터
        local app_name="atool"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="7zip"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="jq"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 휴지통
        local app_name="trash-cli"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ripgrep"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 폴더/파일
        local app_name="tree"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="bat"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="lsd"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 이미지/문서
        local app_name="highlight"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ImageMagick"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="djvulibre"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="poppler-utils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="chafa"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="mediainfo"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 압축/데이터
        local app_name="atool"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="p7zip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="jq"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 휴지통
        local app_name="trash-cli"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ripgrep"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 폴더/파일
        local app_name="tree"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="bat"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 이미지/문서
        local app_name="highlight"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ImageMagick"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="djvulibre"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="poppler-utils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="chafa"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="mediainfo"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 압축/데이터
        local app_name="atool"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="p7zip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="jq"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 휴지통
        local app_name="trash-cli"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}

function install_lf_for_portable()
{
    if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
        return 0
    fi

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/gokcehan/lf/releases/download/r41/lf-linux-arm64.tar.gz
        local FNAME="lf-linux-arm64.tar.gz";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
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
        return 0
    fi

    # tar -xzvf /tmp/lf/lf-1.1.16.gtk2.x86_64.tar.xz -C /usr/local/bin;
    # /usr/local/bin/lf
    tar -xzvf "${ZIP_PATH}" -C ${LOCAL_BIN_DIR};
    rm -f "${ZIP_PATH}";
    # --------------------------------------------------------------------------
}


function install_lf()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^lf) ]] || pacman -S --noconfirm --needed lf;

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^lf) ]] || apt install -y lf;

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        install_lf_for_portable;

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        install_lf_for_portable;
    fi
}

function copy_lfrc()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/lf/config/lfrc"
    if [[ ! -f ${src_path} ]]; then
        return 0
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

function execute_main()
{
    install_dependency_for_lf;
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