#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/yazi/install_yazi.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
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
function install_dependency_for_yazi()
{
    # 확장기능을 사용하기 위한 의존성
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="zoxide"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="fd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="ripgrep"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 이미지/문서
        local app_name="imagemagick"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="poppler"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 미디어
        local app_name="ffmpegthumbnailer"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="ffmpeg"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 압축/데이터
        local app_name="7zip"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="jq"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="zoxide"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="fd-find"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="ripgrep"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 이미지/문서
        local app_name="imagemagick"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="poppler-utils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 미디어
        local app_name="ffmpegthumbnailer"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="ffmpeg"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 압축/데이터
        local app_name="7zip"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="jq"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="zoxide"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="fd-find"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="ripgrep"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 이미지/문서
        local app_name="ImageMagick"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="poppler-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 미디어
        local app_name="ffmpegthumbnailer"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="ffmpeg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 압축/데이터
        local app_name="p7zip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="jq"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="zoxide"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="fd-find"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="ripgrep"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 이미지/문서
        local app_name="ImageMagick"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="poppler-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 미디어
        local app_name="ffmpegthumbnailer"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf repolist | grep -i ^crb) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="ffmpeg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 압축/데이터
        local app_name="p7zip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="jq"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}


function install_yazi_for_apt()
{
    # if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
    #     return 0
    # fi

    # 1) SRC_URL ---------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-gnu.deb
        local FNAME="yazi-aarch64-unknown-linux-gnu";

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        # # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-i686-unknown-linux-gnu.deb
        # local FNAME="yazi-i686-unknown-linux-gnu";
        # yazi not found for i686_deb
        return 0

    else
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.deb
        local FNAME="yazi-x86_64-unknown-linux-gnu";
    fi

    local DEB_FNAME="${FNAME}.deb"
    local SRC_URL="https://github.com/sxyazi/yazi/releases/download/${APP_VER}/${DEB_FNAME}"
    # --------------------------------------------------------------------------

    # 2) DEB_PATH --------------------------------------------------------------
    # /tmp/yazi
    if [[ ! -d "${TMP_DIR}" ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu.deb
    DEB_PATH="${TMP_DIR}/${DEB_FNAME}"

    if [[ ! -f "${DEB_PATH}" ]]; then
        wget "${SRC_URL}" -O "${DEB_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 3) Install DEB_PATH ------------------------------------------------------
    # apt install -y /tmp/yazi/yazi-x86_64-unknown-linux-gnu.deb
    [[ -n $(apt list --installed | grep -i ^${APP_NAME}) ]] || apt install -y "${DEB_PATH}";

    rm -f "${DEB_PATH}";
    # --------------------------------------------------------------------------
}


function install_yazi_for_portable()
{
    if [[ -f "${LOCAL_BIN_DIR}/${APP_NAME}" ]]; then
        return 0
    fi


    # 1) SRC_URL ---------------------------------------------------------------
    if [[ "${CUR_ARCH}" == *"aarch64"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-musl.zip
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-aarch64-unknown-linux-gnu.zip

        if [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
            local FNAME="yazi-aarch64-unknown-linux-musl";

        else
            local FNAME="yazi-aarch64-unknown-linux-gnu";
        fi

    elif [[ "${CUR_ARCH}" == *"i686"* ]]; then
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-i686-unknown-linux-gnu.zip

        local FNAME="yazi-i686-unknown-linux-gnu";

    else
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-musl.zip
        # https://github.com/sxyazi/yazi/releases/download/v26.1.22/yazi-x86_64-unknown-linux-gnu.zip

        if [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
            local FNAME="yazi-x86_64-unknown-linux-musl";
        else
            local FNAME="yazi-x86_64-unknown-linux-gnu";
        fi

    fi

    local ZIP_FNAME="${FNAME}.zip"
    local SRC_URL="https://github.com/sxyazi/yazi/releases/download/${APP_VER}/${ZIP_FNAME}"
    # --------------------------------------------------------------------------

    # 2) ZIP_PATH --------------------------------------------------------------
    # /tmp/yazi
    if [[ ! -d "${TMP_DIR}" ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu.zip
    ZIP_PATH="${TMP_DIR}/${ZIP_FNAME}"

    if [[ ! -e "${ZIP_PATH}" ]]; then
        wget "${SRC_URL}" -O "${ZIP_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 3) LOCAL_BIN_DIR ---------------------------------------------------------
    # /usr/local/bin
    if [[ ! -d "${LOCAL_BIN_DIR}" ]]; then
        return 0
    fi

    # unzip /tmp/yazi/yazi-x86_64-unknown-linux-gnu.zip -d /tmp/yazi
    unzip "${ZIP_PATH}" -d ${TMP_DIR};

    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi
    local SRC_PATH="${TMP_DIR}/${FNAME}/${APP_NAME}"
    # /usr/local/bin/yazi
    local DST_PATH="${LOCAL_BIN_DIR}/${APP_NAME}"
    if [[ -f "${SRC_PATH}" ]] && [[ ! -f "${DST_PATH}" ]]; then
        cp "${SRC_PATH}" "${LOCAL_BIN_DIR}"
    fi

    # /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya
    local SRC_PATH="${TMP_DIR}/${FNAME}/${APP_NAME2}"
    # /usr/local/bin/ya
    local DST_PATH="${LOCAL_BIN_DIR}/${APP_NAME}"
    if [[ -f "${SRC_PATH}" ]] && [[ ! -f "${DST_PATH}" ]]; then
        cp "${SRC_PATH}" "${LOCAL_BIN_DIR}"
    fi

    rm -f "${ZIP_PATH}";
    # --------------------------------------------------------------------------
}


function install_yazi()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^yazi) ]] || pacman -S --noconfirm --needed yazi;

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        if [[ "${CUR_ARCH}" == *"i686"* ]]; then
            install_yazi_for_portable;
        else
            install_yazi_for_apt;
        fi

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        install_yazi_for_portable;

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        install_yazi_for_portable;
    fi
}

function copy_yazirc()
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/yazi/config"
    if [[ ! -f "${src_dir}/yazi.toml" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/yazi
    local dst_dir="${HOME_DIR}/.config/yazi";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
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
            su - ${CUR_USER} -c "cp -Rf ${src_path} ${dst_path}";
            chown ${CUR_USER}:${CUR_USER} "${dst_path}"
            # chmod 664 "${dst_path}"
        fi
    done
    # --------------------------------------------------------------------------
}

function install_nerd_font()
{
    # --------------------------------------------------------------------------
    # HackNerdFont
    bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh ${CUR_USER};
    # --------------------------------------------------------------------------
}


function execute_main()
{
    install_dependency_for_yazi;
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