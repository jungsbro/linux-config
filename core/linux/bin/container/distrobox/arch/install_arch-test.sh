#!/bin/bash
set -e

# usage ========================================================================
# bash ./install_arch-test.sh;
# bash ${CORE_BIN_DIR}/container/distrobox/arch/install_arch-test.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/arch
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
CTR_NAME="arch-test"

IMAGE="docker.io/library/archlinux:latest"

# distrobox create --name "arch-test" --image "docker.io/library/archlinux:latest"
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
PRE_INIT_HOOKS+="sudo pacman -Syu --noconfirm --needed"
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm --needed base-devel"

# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm --needed git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm --needed vim xclip xsel"

# container에서 사용하는 fm
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm --needed ranger"
# PRE_INIT_HOOKS+=" && \
#     sudo pacman -S --noconfirm --needed nnn"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다. (fcitx5-gtk만 설치하면 된다.)
# PRE_INIT_HOOKS+=" && \
#     sudo pacman -S --noconfirm --needed fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-gtk fcitx5-qt"
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm --needed fcitx5-gtk"

# aur 설치
# PRE_INIT_HOOKS+=" && \
#     git clone https://aur.archlinux.org/yay.git /tmp/yay"
# PRE_INIT_HOOKS+=" && \
#     bash -c 'cd /tmp/yay && makepkg -si --noconfirm'"
# PRE_INIT_HOOKS+=" && \
#     rm -rf /tmp/yay"
PRE_INIT_HOOKS+=" && \
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh"

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
    sudo pacman -S --noconfirm --needed libpulse"

# bash 사용
# chsh: your shell is not in /etc/shells, shell change denied: Permission denied
# sudo를 사용하면 애러가 나지 않는다.
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

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------

    # chromium -----------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed chromium

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app chromium

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} chromium"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
