#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/ubu/install_ububox.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/ubu
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$(whoami);
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="ububox"

IMAGE="docker.io/library/ubuntu:latest"

# distrobox create --name "ububox" --image "docker.io/library/debian:latest"
CTR_ARGS=""

# container 이름
CTR_ARGS+="--name ${CTR_NAME} "

# container image주소
CTR_ARGS+="--image ${IMAGE} "

# nvidia gpu를 사용할때, --nvidia 가 필요하다.
# CTR_ARGS+="--nvidia "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# update
# PRE_INIT_HOOKS+="sudo sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources"
# PRE_INIT_HOOKS+=" && \
#     sudo apt update && sudo apt upgrade -y"
PRE_INIT_HOOKS+="sudo apt update && sudo apt upgrade -y"

# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo apt install -y --no-reinstall git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo apt install -y --no-reinstall vim-gtk3 xclip xsel"

# container에서 사용하는 fm
PRE_INIT_HOOKS+=" && \
    sudo apt install -y --no-reinstall ranger"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y --no-reinstall nnn"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
PRE_INIT_HOOKS+=" && \
    sudo apt install -y --no-reinstall --install-recommends fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-config-qt"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y --no-reinstall fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y --no-reinstall fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-gtk* fcitx5-frontend-qt* fcitx5-module-dbus"

# bash 사용
PRE_INIT_HOOKS+=" && \
    sudo chsh -s /bin/bash ${CUR_USER}"
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function execute_main()
{
    # container ----------------------------------------------------------------
    # checking container
    if [[ "$(distrobox list)" == *"${CTR_NAME}"* ]]; then
        return 0;
    fi

    # creating container
    distrobox create ${CTR_ARGS};

    # pre_init_hooks
    if [[ -n "${PRE_INIT_HOOKS}" ]]; then
        distrobox enter ${CTR_NAME} -- bash -c "${PRE_INIT_HOOKS}";
    fi
    # --------------------------------------------------------------------------


    # xcape --------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall xcape

    # bin
    distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/xcape
    # --------------------------------------------------------------------------

    # skippy-xd ----------------------------------------------------------------
    # 존재하지 않는다.
    # --------------------------------------------------------------------------

    # autokey ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall autokey-gtk

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app autokey

    # config
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
        config_autokey ${CUR_USER} && \
        set_autokey_autostart ${CUR_USER}"
    # --------------------------------------------------------------------------

    # redshift -----------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall redshift-gtk geoclue-2.0

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app redshift

    # config
    distrobox enter ${CTR_NAME} -- bash -c "\
        source ${CORE_BIN_DIR}/system/redshift/install_redshift_funcs.sh && \
        config_redshift ${CUR_USER} && \
        set_redshift_autostart ${CUR_USER}"
    # --------------------------------------------------------------------------

    # firejail -----------------------------------------------------------------
    # # sandbox안에서 권한문제가 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall firejail firejail-profiles firetools

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firetools
    # --------------------------------------------------------------------------

    # timeshift ----------------------------------------------------------------
    # # distrobox에서 작동을 안한다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall timeshift

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app timeshift
    # --------------------------------------------------------------------------

    # gnome-disk-utility -------------------------------------------------------
    # # distrobox에서 작동을 안한다.
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall gnome-disk-utility

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app gnome-disks
    # --------------------------------------------------------------------------

    # gnome-keyring ------------------------------------------------------------
    # vscode, remmina에서 사용된다.

    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall gnome-keyring
    # --------------------------------------------------------------------------

    # vscode -------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- bash -c "\
        sudo bash ${CORE_BIN_DIR}/ide/install_vscode.sh ${CUR_USER}"

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app code
    # --------------------------------------------------------------------------

    # doublecmd ----------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall doublecmd-gtk

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app doublecmd
    # --------------------------------------------------------------------------

    # google-chrome ------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- bash -c "\
        sudo bash ${CORE_BIN_DIR}/internet/install_google-chrome.sh ${CUR_USER}"

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app google-chrome
    # --------------------------------------------------------------------------

    # firefox ------------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall firefox

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firefox
    # --------------------------------------------------------------------------

    # remmina ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall remmina remmina-plugin-rdp

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app remmina
    # --------------------------------------------------------------------------

    # libreoffice --------------------------------------------------------------
    # 배포판에 이미 설치되어 있다.

    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall libreoffice

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app libreoffice
    # --------------------------------------------------------------------------

    # qpdf ---------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall qpdfview qpdfview-djvu-plugin \
    qpdfview-pdf-poppler-plugin qpdfview-ps-plugin qpdfview-translations

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app qpdfview
    # --------------------------------------------------------------------------

    # gimp ---------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall gimp

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app gimp

    # config : photogimp
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/graphics/gimp/install_gimp_funcs.sh && \
        install_photogimp ${CUR_USER}"
    # --------------------------------------------------------------------------

    # drawing ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall drawing

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app drawing
    # --------------------------------------------------------------------------

    # vlc ----------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall vlc

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app vlc
    # --------------------------------------------------------------------------

    # freefilesync -------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y --no-reinstall freefilesync

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app FreeFileSync

    # fix desktop
    # host에 생성된 desktop에서 Path=/usr/share/freefilesync를 삭제해야 한다.
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/utilities/freefilesync/install_freefilesync_funcs.sh && \
        fix_freefilesync_desktop ${CUR_USER} ${CTR_NAME} freefilesync"

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} freefilesync"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================