#!/bin/bash

# usage ========================================================================
# bash ./install_rkl9-test.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/rkl/install_rkl9-test.sh
# /.config/distrobox/rkl
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
CTR_NAME="rkl9-test"

# rokcy9/glibc가 x86-64-v2 요구 >> 구형 CPU에서는 실행 불가
# rokcy8/glibc가 x86-64-v1 기반 >> 구형 CPU에서도 문제 없이 실행 가능
IMAGE="docker.io/library/rockylinux:9.3"

# distrobox create --name "rkl9-test" --image "docker.io/library/rockylinux:9.3"
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

# vfx-dcc를 사용할때, --init 이 필요없다.
# CTR_ARGS+="--init --additional-packages systemd "

# container에서 호스트의 /opt/ayon 디렉토리를 /opt/ayon으로 마운트한다.
# if [[ -d "/opt/ayon" ]]; then
#     CTR_ARGS+="--volume /opt/ayon:/opt/ayon "
# fi

# CTR_ARGS+="--volume /lib64/libOpenGL.so.0:/lib64/libOpenGL.so.0:ro "
# CTR_ARGS+="--volume /lib64/libOpenGL.so:/lib64/libOpenGL.so:ro "
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# "--init --additional-packages systemd" 사용할때는 아래처럼 해야 한다.
# PRE_INIT_HOOKS+="sudo dnf upgrade -y --exclude=filesystem,setup"
PRE_INIT_HOOKS+="sudo dnf upgrade -y"
PRE_INIT_HOOKS+=" && \
    sudo bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh"

# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y vim-X11 xclip xsel"

# container에서 사용하는 fm
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y ranger"
# PRE_INIT_HOOKS+=" && \
#     sudo dnf install -y nnn"

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
    sudo dnf install -y pulseaudio-libs"

# bash 사용
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y util-linux-user"
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

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------

fi
# ==============================================================================
