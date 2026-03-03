#!/bin/bash

# usage ========================================================================
# bash ./install_fedo-systemd.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/fedo/install_fedo-systemd.sh
# /.config/distrobox/fedo
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ctr="fedo-systemd"

image="docker.io/library/fedora:latest"

# distrobox create --name "fedo-systemd" --image "docker.io/library/fedora:latest"
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
pre_init_hooks+="sudo dnf upgrade -y"

# container에서 사용하는 git wget curl
pre_init_hooks+=" && \
    sudo dnf install -y git wget curl"

# container에서 사용하는 vim
pre_init_hooks+=" && \
    sudo dnf install -y vim-X11 xclip xsel"

# container에서 사용하는 ranger
pre_init_hooks+=" && \
    sudo dnf install -y ranger"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
pre_init_hooks+=" && \
    sudo dnf install -y fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-autostart"

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
