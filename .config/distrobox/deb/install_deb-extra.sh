#!/bin/bash

# usage ========================================================================
# bash ./install_deb-extra.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/deb/install_deb-extra.sh
# /.config/distrobox/deb
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="deb-extra"

IMAGE="docker.io/library/debian:latest"

# distrobox create --name "deb-extra" --image "docker.io/library/debian:latest"
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

    # xcape --------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y xcape

    # bin
    distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/xcape
    # --------------------------------------------------------------------------

    # synapse ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo apt install -y synapse

    # bin
    distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/synapse
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
        source ${BIN_DIR}/utilities/install_freefilesync.sh $(whoami) && \
        fix_freefilesync_desktop ${CTR_NAME}"
    # --------------------------------------------------------------------------

fi
# ==============================================================================
