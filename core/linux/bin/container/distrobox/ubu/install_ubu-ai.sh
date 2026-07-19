#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/ubu/install_ubu-ai.sh;
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

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="ubu-ai"

# ubuntu24.04에서 애러가 난다. >> Setting up existing user... Error: An error occurred
# IMAGE="docker.io/library/ubuntu:latest"
IMAGE="docker.io/library/ubuntu:22.04"

# distrobox create --name "ubu-ai" --image "docker.io/library/debian:latest"
CTR_ARGS=""

# container 이름
CTR_ARGS+="--name ${CTR_NAME} "

# container image주소
CTR_ARGS+="--image ${IMAGE} "

if [[ -n $(lspci | grep -E "VGA|3D" | grep -i nvidia) ]]; then
    # nvidia gpu를 사용할때, --nvidia 가 필요하다.
    CTR_ARGS+="--nvidia "

    # puslseAudio 사용을 위해 (PRE_INIT_HOOKS에서 libpulse0 설치도 필요하다.)
    CTR_ARGS+="--volume /run/user/${UID}/pulse:/run/user/${UID}/pulse "
fi

# PipeWire 사용을 위해 (fedora34 이후 / PRE_INIT_HOOKS에서 libpulse0 설치도 필요하다.)
# CTR_ARGS+="--volume /run/user/${UID}/pipewire-0:/run/user/${UID}/pipewire-0 "

# Alsa장치 사용을 위해
# CTR_ARGS+="--volume /dev/snd:/dev/snd "

# container에서 호스트의 /opt/ayon 디렉토리를 /opt/ayon으로 마운트한다.
# if [[ -d "/opt/ayon" ]]; then
#     CTR_ARGS+="--volume /opt/ayon:/opt/ayon "
# fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# update
# PRE_INIT_HOOKS+="sudo sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources"
# PRE_INIT_HOOKS+=" && \
#     sudo apt update && sudo apt upgrade -y"
PRE_INIT_HOOKS+="sudo apt update && sudo apt upgrade -y"
PRE_INIT_HOOKS+=" && \
    sudo bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh"

# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo apt install -y git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo apt install -y vim-gtk3 xclip xsel"

# container에서 사용하는 fm
PRE_INIT_HOOKS+=" && \
    sudo apt install -y ranger"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y nnn"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
PRE_INIT_HOOKS+=" && \
    sudo apt install -y --install-recommends fcitx5 fcitx5-hangul fcitx5-config-qt"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-gtk* fcitx5-frontend-qt* fcitx5-module-dbus"

# gpu-driver (opengl,vulkan,vaapi,opencl)
PRE_INIT_HOOKS+=" && \
    sudo bash ${CORE_BIN_DIR}/gpu/install_gpu.sh ${CUR_USER}"

# vfx-dcc-dependencies for rocky8 or rocky9
# PRE_INIT_HOOKS+=" && \
#     sudo bash ${CORE_BIN_DIR}/gpu/install_vfxdeps.sh"

# gpu_top
PRE_INIT_HOOKS+=" && \
    sudo bash ${CORE_BIN_DIR}/gpu/install_gpu_top.sh"

# puslseAudio 사용을 위해
PRE_INIT_HOOKS+=" && \
    sudo apt install -y libpulse0"

# bash 사용
PRE_INIT_HOOKS+=" && \
    sudo chsh -s /bin/bash ${CUR_USER}"
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
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y autokey-gtk

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app autokey

    # # config
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
    #     config_autokey ${CUR_USER} && \
    #     set_autokey_autostart ${CUR_USER}"
    # --------------------------------------------------------------------------

    # redshift -----------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y redshift-gtk geoclue-2.0

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app redshift

    # # config
    # distrobox enter ${CTR_NAME} -- bash -c "\
    #     source ${CORE_BIN_DIR}/system/redshift/install_redshift_funcs.sh && \
    #     config_redshift ${CUR_USER} && \
    #     set_redshift_autostart ${CUR_USER}"
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
    # # vscode, remmina에서 사용된다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y gnome-keyring
    # --------------------------------------------------------------------------

    # vscode -------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- bash -c "\
    #     sudo bash ${CORE_BIN_DIR}/ide/install_vscode.sh ${CUR_USER}"

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app code
    # --------------------------------------------------------------------------

    # doublecmd ----------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y doublecmd-gtk

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app doublecmd
    # --------------------------------------------------------------------------

    # chromium -----------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y chromium-browser

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app chromium-browser

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} chromium-browser"
    # --------------------------------------------------------------------------

    # google-chrome ------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- bash -c "\
    #     sudo bash ${CORE_BIN_DIR}/internet/install_google-chrome.sh ${CUR_USER}"

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app google-chrome

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} google-chrome"
    # --------------------------------------------------------------------------

    # firefox ------------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y firefox

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firefox

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} firefox"
    # --------------------------------------------------------------------------

    # remmina ------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y remmina remmina-plugin-rdp

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app remmina
    # --------------------------------------------------------------------------

    # libreoffice --------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y libreoffice

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app libreoffice
    # --------------------------------------------------------------------------

    # qpdf ---------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y qpdfview qpdfview-djvu-plugin \
    # qpdfview-pdf-poppler-plugin qpdfview-ps-plugin qpdfview-translations

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app qpdfview
    # --------------------------------------------------------------------------

    # gimp ---------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y gimp

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app gimp

    # # config : photogimp
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/graphics/gimp/install_gimp_funcs.sh && \
    #     install_photogimp ${CUR_USER}"

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} gimp"
    # --------------------------------------------------------------------------

    # drawing ------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y drawing

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app drawing
    # --------------------------------------------------------------------------

    # vlc ----------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y vlc

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app vlc

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} vlc"
    # --------------------------------------------------------------------------

fi
# ==============================================================================

