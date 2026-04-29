#!/bin/bash

# usage ========================================================================
# bash ./install_ubu-extra.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/ubu/install_ubu-extra.sh
# /.config/distrobox/ubu
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="ubu-extra"

# ubuntu24.04에서 애러가 난다. >> Setting up existing user... Error: An error occurred
# IMAGE="docker.io/library/ubuntu:latest"
IMAGE="docker.io/library/ubuntu:22.04"

# distrobox create --name "ubu-extra" --image "docker.io/library/debian:latest"
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

# hw-acceleration
PRE_INIT_HOOKS+=" && \
    sudo bash ${CORE_BIN_DIR}/gpu/install_hwaccel.sh"

# vfx-dcc-dependencies for rocky8 or rocky9
# PRE_INIT_HOOKS+=" && \
#     sudo bash ${CORE_BIN_DIR}/gpu/install_vfxdeps.sh"

# gputop
PRE_INIT_HOOKS+=" && \
    sudo bash ${CORE_BIN_DIR}/gpu/install_gputop.sh"

# puslseAudio 사용을 위해
PRE_INIT_HOOKS+=" && \
    sudo apt install -y libpulse0"

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

    # xcape --------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y xcape

    # bin
    distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/xcape
    # --------------------------------------------------------------------------

    # synapse ------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo apt install -y synapse

    # # bin
    # distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/synapse
    # --------------------------------------------------------------------------

    # skippy-xd ----------------------------------------------------------------
    # # 존재하지 않는다.
    # --------------------------------------------------------------------------

    # freefilesync -------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y freefilesync

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app FreeFileSync

    # fix desktop
    # host에 생성된 desktop에서 Path=/usr/share/freefilesync를 삭제해야 한다.
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/utilities/install_freefilesync.sh $(whoami) && \
        fix_freefilesync_desktop ${CTR_NAME}"
    # --------------------------------------------------------------------------

fi
# ==============================================================================
