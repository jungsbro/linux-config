#!/bin/bash

# usage ========================================================================
# bash ./install_archbox.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/distro/install_archbox.sh
# /.config/distrobox/distro
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="archbox"

IMAGE="docker.io/library/archlinux:latest"

# distrobox create --name "archbox" --image "docker.io/library/archlinux:latest"
CTR_ARGS=""

# container 이름
CTR_ARGS+="--name ${CTR_NAME} "

# container image주소
CTR_ARGS+="--image ${IMAGE} "

# nvidia gpu를 사용할때, --nvidia 가 필요하다.
# CTR_ARGS+="--nvidia "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# update
PRE_INIT_HOOKS+="sudo pacman -Syu --noconfirm"
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm base-devel"

# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm vim xclip xsel"

# container에서 사용하는 ranger
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm ranger"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다. (fcitx5-gtk만 설치하면 된다.)
# PRE_INIT_HOOKS+=" && \
#     sudo pacman -S --noconfirm fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-gtk fcitx5-qt"
PRE_INIT_HOOKS+=" && \
    sudo pacman -S --noconfirm fcitx5-gtk"

# aur 설치
PRE_INIT_HOOKS+=" && \
    git clone https://aur.archlinux.org/yay.git /tmp/yay"
PRE_INIT_HOOKS+=" && \
    bash -c 'cd /tmp/yay && makepkg -si --noconfirm'"
PRE_INIT_HOOKS+=" && \
    rm -rf /tmp/yay"

# bash 사용
# chsh: your shell is not in /etc/shells, shell change denied: Permission denied
# sudo를 사용하면 애러가 나지 않는다.
PRE_INIT_HOOKS+=" && \
    sudo chsh -s /bin/bash $(whoami)"
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
# container --------------------------------------------------------------------
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
# ------------------------------------------------------------------------------


# xcape ------------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm xcape

# bin
distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/xcape
# ------------------------------------------------------------------------------

# skippy-xd --------------------------------------------------------------------
# installation (aur)
distrobox enter ${CTR_NAME} -- yay -S --noconfirm skippy-xd-git

# bin
distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/skippy-xd
# ------------------------------------------------------------------------------

# autokey ----------------------------------------------------------------------
# installation (aur)
distrobox enter ${CTR_NAME} -- yay -S --noconfirm autokey-gtk

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app autokey-gtk

# config (sudo로 실행하면 password를 묻지 않는다.)
distrobox enter ${CTR_NAME} -- sudo bash -c "\
    source ${CORE_BIN_DIR}/system/install_autokey.sh $(whoami) && \
    config_autokey && \
    set_autokey_autostart"
# ------------------------------------------------------------------------------

# redshift ---------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm redshift geoclue

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app redshift

# config (sudo로 실행하면 password를 묻지 않는다.)
distrobox enter ${CTR_NAME} -- bash -c "\
    source ${CORE_BIN_DIR}/system/install_redshift.sh $(whoami) && \
    config_redshift && \
    set_redshift_autostart"
# ------------------------------------------------------------------------------

# firejail ---------------------------------------------------------------------
# # sandbox안에서 권한문제가 있다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm firejail firetools

# # bin
# distrobox enter ${CTR_NAME} -- distrobox-export --bin /usr/bin/firejail

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app firetools
# ------------------------------------------------------------------------------

# timeshift --------------------------------------------------------------------
# # distrobox에서 작동을 안한다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm timeshift

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app timeshift
# ------------------------------------------------------------------------------

# gnome-disk-utility -----------------------------------------------------------
# # distrobox에서 작동을 안한다.
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm gnome-disk-utility

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app gnome-disks
# ------------------------------------------------------------------------------

# gnome-keyring ----------------------------------------------------------------
# vscode, remmina에서 사용된다.

# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm gnome-keyring
# ------------------------------------------------------------------------------

# vscode -----------------------------------------------------------------------
# installation
# 1) opensource (without telemetry)
# distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm code

# 2) official microsoft
distrobox enter ${CTR_NAME} -- yay -S --noconfirm visual-studio-code-bin

# 3) opensource (disable telemetry)
# distrobox enter ${CTR_NAME} -- yay -S --noconfirm vscodium-bin
# distrobox enter ${CTR_NAME} -- yay -S --noconfirm vscodium-bin-marketplace

# 4)
# distrobox enter ${CTR_NAME} -- bash -c "\
#     sudo bash ${CORE_BIN_DIR}/ide/install_vscode.sh $(whoami)"

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app code
# ------------------------------------------------------------------------------

# doublecmd --------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm doublecmd-qt5

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app doublecmd
# ------------------------------------------------------------------------------

# google-chrome ----------------------------------------------------------------
# # installation (aur)
distrobox enter ${CTR_NAME} -- yay -S --noconfirm google-chrome

# # desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app google-chrome-stable
# ------------------------------------------------------------------------------

# firefox ----------------------------------------------------------------------
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm firefox

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app firefox
# ------------------------------------------------------------------------------

# remmina ----------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm remmina freerdp

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app remmina
# ------------------------------------------------------------------------------

# libreoffice ------------------------------------------------------------------
# # 배포판에 이미 설치되어 있다.

# # installation
# # distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm libreoffice-fresh
# distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm libreoffice-still

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app libreoffice
# ------------------------------------------------------------------------------

# qpdf -------------------------------------------------------------------------
# installation (aur)
distrobox enter ${CTR_NAME} -- yay -S --noconfirm qpdfview

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app qpdfview
# ------------------------------------------------------------------------------

# gimp -------------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm gimp

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app gimp

# config (sudo로 실행하면 password를 묻지 않는다.) : photogimp
distrobox enter ${CTR_NAME} -- sudo bash -c "\
    source ${CORE_BIN_DIR}/graphics/install_gimp.sh $(whoami) && \
    install_photogimp"
# ------------------------------------------------------------------------------

# drawing ----------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm drawing

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app drawing
# ------------------------------------------------------------------------------

# vlc --------------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo pacman -S --noconfirm vlc

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app vlc
# ------------------------------------------------------------------------------

# freefilesync -----------------------------------------------------------------
# # build하는데 20분 걸린다
# # installation (aur)
# # 방법1)
# # distrobox enter ${CTR_NAME} -- yay -S --noconfirm freefilesync-bin
# # 방법2)
# distrobox enter ${CTR_NAME} -- yay -S --noconfirm freefilesync

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app FreeFileSync
# ------------------------------------------------------------------------------
# ==============================================================================

