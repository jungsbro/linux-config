#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/arch/install_arch-main.sh;
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
CTR_NAME="arch-main"

IMAGE="docker.io/library/archlinux:latest"

# distrobox create --name "arch-main" --image "docker.io/library/archlinux:latest"
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

    # terminal -----------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed wezterm

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app wezterm

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} wezterm"
    # --------------------------------------------------------------------------

    # autokey ------------------------------------------------------------------
    # installation (aur)
    distrobox enter ${CTR_NAME} -- yay -S --noconfirm --needed autokey-gtk

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app autokey-gtk

    # config (sudo로 실행하면 password를 묻지 않는다.)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
            source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
            config_autokey ${CUR_USER} && \
            set_autokey_autostart ${CUR_USER}"
    # --------------------------------------------------------------------------

    # redshift -----------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed redshift geoclue

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app redshift

    # config (sudo로 실행하면 password를 묻지 않는다.)
    distrobox enter ${CTR_NAME} -- bash -c "\
        source ${CORE_BIN_DIR}/system/redshift/install_redshift_funcs.sh && \
        config_redshift ${CUR_USER} && \
        set_redshift_autostart ${CUR_USER}"
    # --------------------------------------------------------------------------

    # firejail -----------------------------------------------------------------
    # # sandbox안에서 권한문제가 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed firejail firetools

    # # bin
    # distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/firejail

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firetools
    # --------------------------------------------------------------------------

    # timeshift ----------------------------------------------------------------
    # # distrobox에서 작동을 안한다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed timeshift

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app timeshift
    # --------------------------------------------------------------------------

    # gnome-disk-utility -------------------------------------------------------
    # # distrobox에서 작동을 안한다.
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed gnome-disk-utility

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app gnome-disks
    # --------------------------------------------------------------------------

    # gnome-keyring ------------------------------------------------------------
    # vscode, remmina에서 사용된다.

    # installation
    distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed gnome-keyring
    # --------------------------------------------------------------------------

    # vscode -------------------------------------------------------------------
    # installation
    # 1) opensource (without telemetry)
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed code

    # 2) official microsoft
    distrobox enter ${CTR_NAME} -- yay -S --noconfirm --needed visual-studio-code-bin

    # 3) opensource (disable telemetry)
    # distrobox enter ${CTR_NAME} -- yay -S --noconfirm --needed vscodium-bin
    # distrobox enter ${CTR_NAME} -- yay -S --noconfirm --needed vscodium-bin-marketplace

    # 4)
    # distrobox enter ${CTR_NAME} -- bash -c "\
    #     sudo bash ${CORE_BIN_DIR}/ide/install_vscode.sh ${CUR_USER}"

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app code
    # --------------------------------------------------------------------------

    # doublecmd ----------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed doublecmd-qt5

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app doublecmd
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

    # google-chrome ------------------------------------------------------------
    # installation (aur)
    distrobox enter ${CTR_NAME} -- yay -S --noconfirm --needed google-chrome

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app google-chrome-stable

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} google-chrome"
    # --------------------------------------------------------------------------

    # firefox ------------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed firefox

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app firefox

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} firefox"
    # --------------------------------------------------------------------------

    # remmina ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed remmina freerdp

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app remmina
    # --------------------------------------------------------------------------

    # libreoffice --------------------------------------------------------------
    # # 배포판에 이미 설치되어 있다.

    # # installation
    # # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed libreoffice-fresh
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed libreoffice-still

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app libreoffice
    # --------------------------------------------------------------------------

    # qpdf ---------------------------------------------------------------------
    # installation (aur)
    distrobox enter ${CTR_NAME} -- yay -S --noconfirm --needed qpdfview

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app qpdfview
    # --------------------------------------------------------------------------

    # gimp ---------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed gimp

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app gimp

    # # config (sudo로 실행하면 password를 묻지 않는다.) : photogimp
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/graphics/gimp/install_gimp_funcs.sh && \
    #     install_photogimp ${CUR_USER}"

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} gimp"
    # --------------------------------------------------------------------------

    # drawing ------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed drawing

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app drawing
    # --------------------------------------------------------------------------

    # vlc ----------------------------------------------------------------------
    # installation
    distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed vlc

    # desktop
    distrobox enter ${CTR_NAME} -- distrobox-export --app vlc

    # config (with nvidia)
    distrobox enter ${CTR_NAME} -- sudo bash -c "\
        source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
        set_app_with_nvidia ${CUR_USER} ${CTR_NAME} vlc"
    # --------------------------------------------------------------------------

    # kdenlive -----------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed kdenlive

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app kdenlive

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} kdenlive"
    # --------------------------------------------------------------------------

    # shotcut ------------------------------------------------------------------
    # # installation
    # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm --needed shotcut

    # # desktop
    # distrobox enter ${CTR_NAME} -- distrobox-export --app shotcut

    # # config (with nvidia)
    # distrobox enter ${CTR_NAME} -- sudo bash -c "\
    #     source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && \
    #     set_app_with_nvidia ${CUR_USER} ${CTR_NAME} shotcut"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
