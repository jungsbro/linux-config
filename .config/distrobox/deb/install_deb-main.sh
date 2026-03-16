#!/bin/bash

# usage ========================================================================
# bash ./install_deb-main.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/deb/install_deb-main.sh
# /.config/distrobox/deb
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="deb-main"

IMAGE="docker.io/library/debian:latest"

# distrobox create --name "deb-main" --image "docker.io/library/debian:latest"
CTR_ARGS=""

# container 이름
CTR_ARGS+="--name ${CTR_NAME} "

# container image주소
CTR_ARGS+="--image ${IMAGE} "

# nvidia gpu를 사용할때, --nvidia 가 필요하다.
# CTR_ARGS+="--nvidia "

# container에서 호스트의 /opt/ayon 디렉토리를 /opt/ayon으로 마운트한다.
# if [[ -d "/opt/ayon" ]]; then
#     CTR_ARGS+="--volume /opt/ayon:/opt/ayon "
# fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# update
PRE_INIT_HOOKS+="sudo sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources"
PRE_INIT_HOOKS+=" && \
    sudo apt update && sudo apt upgrade -y"

# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo apt install -y git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo apt install -y vim-gtk3 xclip xsel"

# container에서 사용하는 ranger
PRE_INIT_HOOKS+=" && \
    sudo apt install -y ranger"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
PRE_INIT_HOOKS+=" && \
    sudo apt install -y --install-recommends fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-config-qt"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-gtk* fcitx5-frontend-qt* fcitx5-module-dbus"

# bash 사용
PRE_INIT_HOOKS+=" && \
    sudo chsh -s /bin/bash $(whoami)"
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # container ----------------------------------------------------------------
    # checking container
    if [[ *"$(distrobox list)"* == *"${CTR_NAME}"* ]]; then
        return 0;
    fi

    # creating container
    distrobox create ${CTR_ARGS};

    # pre_init_hooks
    if [[ -n "${PRE_INIT_HOOKS}" ]]; then
        distrobox enter ${CTR_NAME} -- bash -c "${PRE_INIT_HOOKS}";
    fi
    # --------------------------------------------------------------------------

    # autokey ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y autokey-gtk

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app autokey

    # config
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${BIN_DIR}/system/install_autokey.sh $(whoami) && \
        config_autokey && \
        set_autokey_autostart"
    # --------------------------------------------------------------------------

    # redshift -----------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y redshift-gtk geoclue-2.0

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app redshift

    # config
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${BIN_DIR}/system/install_redshift.sh $(whoami) && \
        config_redshift && \
        set_redshift_autostart"
    # --------------------------------------------------------------------------

    # firejail -----------------------------------------------------------------
    # # sandbox안에서 권한문제가 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y firejail firejail-profiles firetools

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firetools
    # --------------------------------------------------------------------------

    # timeshift ----------------------------------------------------------------
    # # distrobox에서 작동을 안한다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y timeshift

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app timeshift
    # --------------------------------------------------------------------------

    # gnome-disk-utility -------------------------------------------------------
    # # distrobox에서 작동을 안한다.
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y gnome-disk-utility

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app gnome-disks
    # --------------------------------------------------------------------------

    # gnome-keyring ------------------------------------------------------------
    # vscode, remmina에서 사용된다.

    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y gnome-keyring
    # --------------------------------------------------------------------------

    # vscode -------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- bash -c "\
        sudo bash ${BIN_DIR}/ide/install_vscode.sh $(whoami)"

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app code
    # --------------------------------------------------------------------------

    # doublecmd ----------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y doublecmd-gtk

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app doublecmd
    # --------------------------------------------------------------------------

    # google-chrome ------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- bash -c "\
        sudo bash ${BIN_DIR}/internet/install_google-chrome.sh $(whoami)"

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app google-chrome
    # --------------------------------------------------------------------------

    # firefox ------------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y firefox-esr

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firefox
    # --------------------------------------------------------------------------

    # remmina ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y remmina remmina-plugin-rdp

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app remmina
    # --------------------------------------------------------------------------

    # libreoffice --------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y libreoffice

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app libreoffice
    # --------------------------------------------------------------------------

    # qpdf ---------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y qpdfview qpdfview-djvu-plugin qpdfview-pdf-poppler-plugin qpdfview-ps-plugin qpdfview-translations

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app qpdfview
    # --------------------------------------------------------------------------

    # gimp ---------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y gimp

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app gimp

    # config : photogimp
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${BIN_DIR}/graphics/install_gimp.sh $(whoami) && \
        install_photogimp"
    # --------------------------------------------------------------------------

    # drawing ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y drawing

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app drawing
    # --------------------------------------------------------------------------

    # vlc ----------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y vlc

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app vlc
    # --------------------------------------------------------------------------

fi
# ==============================================================================

