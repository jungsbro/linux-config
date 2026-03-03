#!/bin/bash

# usage ========================================================================
# bash ./install_deb-systemd.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/deb/install_deb-systemd.sh
# /.config/distrobox/deb
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ctr="deb-systemd"

image="docker.io/library/debian:latest"

# distrobox create --name "deb-systemd" --image "docker.io/library/debian:latest"
ctr_args=""

# container 이름
ctr_args+="--name ${ctr} "

# container image주소
ctr_args+="--image ${image} "

# nvidia gpu를 사용할때, --nvidia 가 필요하다.
# ctr_args+="--nvidia "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
pre_init_hooks=""

# update
pre_init_hooks+="sudo sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources"
pre_init_hooks+=" && \
    sudo apt update && sudo apt upgrade -y"

# container에서 사용하는 git wget curl
pre_init_hooks+=" && \
    sudo apt install -y git wget curl"

# container에서 사용하는 vim
pre_init_hooks+=" && \
    sudo apt install -y vim-gtk3 xclip xsel"

# container에서 사용하는 ranger
pre_init_hooks+=" && \
    sudo apt install -y ranger"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
pre_init_hooks+=" && \
    sudo apt install -y --install-recommends fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-config-qt"
# pre_init_hooks+=" && \
#     sudo apt install -y fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2"
# pre_init_hooks+=" && \
#     sudo apt install -y fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-gtk* fcitx5-frontend-qt* fcitx5-module-dbus"

# bash 사용
pre_init_hooks+=" && \
    sudo chsh -s /bin/bash $(whoami)"
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # container ----------------------------------------------------------------
    # checking container
    if [[ *"$(distrobox list)"* == *"${ctr}"* ]]; then
        return 0;
    fi

    # creating container
    distrobox create ${ctr_args};

    # pre_init_hooks
    if [[ -n "${pre_init_hooks}" ]]; then
        distrobox enter ${ctr} -- bash -c "${pre_init_hooks}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------

fi
# ==============================================================================
