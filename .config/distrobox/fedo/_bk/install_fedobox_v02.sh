#!/bin/bash

# usage ========================================================================
# bash ./install_fedobox.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/distro/install_fedobox.sh
# /.config/distrobox/distro
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ctr="fedobox"

image="docker.io/library/fedora:latest"

# distrobox create --name "fedobox" --image "docker.io/library/fedora:latest"
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
# container --------------------------------------------------------------------
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
# ------------------------------------------------------------------------------

# xcape ------------------------------------------------------------------------
# 존재하지 않는다.
# ------------------------------------------------------------------------------

# skippy-xd --------------------------------------------------------------------
# 존재하지 않는다.
# ------------------------------------------------------------------------------

# autokey ----------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y autokey-gtk

# desktop
distrobox enter ${ctr} -- distrobox-export --app autokey-gtk

# config
distrobox enter ${ctr} -- sudo bash -c "\
    source ${BIN_DIR}/system/install_autokey.sh $(whoami) && \
    config_autokey && \
    set_autokey_autostart"
# ------------------------------------------------------------------------------

# redshift ---------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y redshift-gtk geoclue2

# desktop
distrobox enter ${ctr} -- distrobox-export --app redshift

# config
distrobox enter ${ctr} -- sudo bash -c "\
    source ${BIN_DIR}/system/install_redshift.sh $(whoami) && \
    config_redshift && \
    set_redshift_autostart"
# ------------------------------------------------------------------------------

# firejail ---------------------------------------------------------------------
# # installation
# distrobox enter ${ctr} -- sudo dnf install -y firejail
# ------------------------------------------------------------------------------

# timeshift --------------------------------------------------------------------
# # distrobox에서 작동을 안한다.

# # installation
# distrobox enter ${ctr} -- sudo dnf install -y timeshift

# # desktop
# distrobox enter ${ctr} -- distrobox-export --app timeshift
# ------------------------------------------------------------------------------

# gnome-disk-utility -----------------------------------------------------------
# # distrobox에서 작동을 안한다.
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${ctr} -- sudo dnf install -y gnome-disk-utility

# # desktop
# distrobox enter ${ctr} -- distrobox-export --app gnome-disks
# ------------------------------------------------------------------------------

# gnome-keyring ----------------------------------------------------------------
# vscode, remmina에서 사용된다.

# installation
distrobox enter ${ctr} -- sudo dnf install -y gnome-keyring
# ------------------------------------------------------------------------------

# vscode -----------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- bash -c "\
    sudo bash ${BIN_DIR}/ide/install_vscode.sh $(whoami)"

# desktop
distrobox enter ${ctr} -- distrobox-export --app code
# ------------------------------------------------------------------------------

# doublecmd --------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y doublecmd-gtk

# desktop
distrobox enter ${ctr} -- distrobox-export --app doublecmd
# ------------------------------------------------------------------------------

# google-chrome ----------------------------------------------------------------
# installation
distrobox enter ${ctr} -- bash -c "\
    sudo bash ${BIN_DIR}/internet/install_google-chrome.sh $(whoami)"

# desktop
distrobox enter ${ctr} -- distrobox-export --app google-chrome-stable
# ------------------------------------------------------------------------------

# firefox ----------------------------------------------------------------------
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${ctr} -- sudo dnf install -y firefox

# # desktop
# distrobox enter ${ctr} -- distrobox-export --app firefox
# ------------------------------------------------------------------------------

# remmina ----------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y remmina

# desktop
distrobox enter ${ctr} -- distrobox-export --app remmina
# ------------------------------------------------------------------------------

# libreoffice ------------------------------------------------------------------
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${ctr} -- sudo dnf install -y libreoffice

# # desktop
# distrobox enter ${ctr} -- distrobox-export --app libreoffice
# ------------------------------------------------------------------------------

# qpdf -------------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y qpdfview qpdfview-common qpdfview-qt5 qpdfview-qt6

# desktop
distrobox enter ${ctr} -- distrobox-export --app qpdfview
# ------------------------------------------------------------------------------

# gimp -------------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y gimp

# desktop
distrobox enter ${ctr} -- distrobox-export --app gimp

# config : photogimp
distrobox enter ${ctr} -- sudo bash -c "\
    source ${BIN_DIR}/graphics/install_gimp.sh $(whoami) && \
    install_photogimp"
# ------------------------------------------------------------------------------

# drawing ----------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y drawing

# desktop
distrobox enter ${ctr} -- distrobox-export --app drawing
# ------------------------------------------------------------------------------

# vlc --------------------------------------------------------------------------
# installation
distrobox enter ${ctr} -- sudo dnf install -y vlc

# desktop
distrobox enter ${ctr} -- distrobox-export --app vlc
# ------------------------------------------------------------------------------

# freefilesync -----------------------------------------------------------------
# debbox(ububox)의 freefilesync를 사용한다.

# installation >> not used
# https://copr.fedorainfracloud.org/coprs/bgstack15/FreeFileSync/
# sudo dnf install -y 'dnf-command(copr)'
# sudo dnf copr enable bgstack15/FreeFileSync
# ------------------------------------------------------------------------------
# ==============================================================================



