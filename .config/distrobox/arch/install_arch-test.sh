#!/bin/bash

# usage ========================================================================
# bash ./install_arch-test.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/distro/install_arch-test.sh
# /.config/distrobox/distro
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ctr="arch-test"

image="docker.io/library/archlinux:latest"

# distrobox create --name "arch-test" --image "docker.io/library/archlinux:latest"
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
pre_init_hooks+="sudo pacman -Syu --noconfirm"
pre_init_hooks+=" && \
    sudo pacman -S --noconfirm base-devel"

# container에서 사용하는 git wget curl
pre_init_hooks+=" && \
    sudo pacman -S --noconfirm git wget curl"

# container에서 사용하는 vim
pre_init_hooks+=" && \
    sudo pacman -S --noconfirm vim xclip xsel"

# container에서 사용하는 ranger
pre_init_hooks+=" && \
    sudo pacman -S --noconfirm ranger"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다. (fcitx5-gtk만 설치하면 된다.)
# pre_init_hooks+=" && \
#     sudo pacman -S --noconfirm fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-gtk fcitx5-qt"
pre_init_hooks+=" && \
    sudo pacman -S --noconfirm fcitx5-gtk"

# aur 설치
pre_init_hooks+=" && \
    git clone https://aur.archlinux.org/yay.git /tmp/yay"
pre_init_hooks+=" && \
    bash -c 'cd /tmp/yay && makepkg -si --noconfirm'"
pre_init_hooks+=" && \
    rm -rf /tmp/yay"

# bash 사용
# chsh: your shell is not in /etc/shells, shell change denied: Permission denied
# sudo를 사용하면 애러가 나지 않는다.
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

