#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/fedo/install_fedobox.sh;
# ==============================================================================



# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/deb
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
CTR_NAME="fedobox"

IMAGE="docker.io/library/fedora:latest"

# distrobox create --name "fedobox" --image "docker.io/library/fedora:latest"
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
PRE_INIT_HOOKS+="sudo dnf upgrade -y"

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

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-autostart"

# bash 사용
# chsh: your shell is not in /etc/shells, shell change denied: Permission denied
# sudo를 사용하면 애러가 나지 않는다.
PRE_INIT_HOOKS+=" && \
    sudo chsh -s /bin/bash ${CUR_USER}"
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
# container --------------------------------------------------------------------
# checking container
if [[ "$(distrobox list)" == *"${CTR_NAME}"* ]]; then
    exit 0;
fi

# creating container
distrobox create ${CTR_ARGS};

# pre_init_hooks
if [[ -n "${PRE_INIT_HOOKS}" ]]; then
    distrobox enter ${CTR_NAME} -- bash -c "${PRE_INIT_HOOKS}";
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
distrobox enter ${CTR_NAME} -- sudo dnf install -y autokey-gtk

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app autokey-gtk

# config
distrobox enter ${CTR_NAME} -- sudo bash -c "\
    source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
    config_autokey ${CUR_USER} && \
    set_autokey_autostart ${CUR_USER}"
# ------------------------------------------------------------------------------

# redshift ---------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y redshift-gtk geoclue2

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app redshift

# config
distrobox enter ${CTR_NAME} -- bash -c "\
    source ${CORE_BIN_DIR}/system/redshift/install_redshift_funcs.sh && \
    config_redshift ${CUR_USER} && \
    set_redshift_autostart ${CUR_USER}"
# ------------------------------------------------------------------------------

# firejail ---------------------------------------------------------------------
# # installation
# distrobox enter ${CTR_NAME} -- sudo dnf install -y firejail
# ------------------------------------------------------------------------------

# timeshift --------------------------------------------------------------------
# # distrobox에서 작동을 안한다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo dnf install -y timeshift

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app timeshift
# ------------------------------------------------------------------------------

# gnome-disk-utility -----------------------------------------------------------
# # distrobox에서 작동을 안한다.
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo dnf install -y gnome-disk-utility

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app gnome-disks
# ------------------------------------------------------------------------------

# gnome-keyring ----------------------------------------------------------------
# vscode, remmina에서 사용된다.

# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y gnome-keyring
# ------------------------------------------------------------------------------

# vscode -----------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- bash -c "\
    sudo bash ${CORE_BIN_DIR}/ide/install_vscode.sh ${CUR_USER}"

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app code
# ------------------------------------------------------------------------------

# doublecmd --------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y doublecmd-gtk

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app doublecmd
# ------------------------------------------------------------------------------

# google-chrome ----------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- bash -c "\
    sudo bash ${CORE_BIN_DIR}/internet/install_google-chrome.sh ${CUR_USER}"

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app google-chrome-stable
# ------------------------------------------------------------------------------

# firefox ----------------------------------------------------------------------
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo dnf install -y firefox

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app firefox
# ------------------------------------------------------------------------------

# remmina ----------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y remmina

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app remmina
# ------------------------------------------------------------------------------

# libreoffice ------------------------------------------------------------------
# # 배포판에 이미 설치되어 있다.

# # installation
# distrobox enter ${CTR_NAME} -- sudo dnf install -y libreoffice

# # desktop
# distrobox enter ${CTR_NAME} -- distrobox-export --app libreoffice
# ------------------------------------------------------------------------------

# qpdf -------------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y qpdfview qpdfview-common qpdfview-qt5 qpdfview-qt6

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app qpdfview
# ------------------------------------------------------------------------------

# gimp -------------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y gimp

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app gimp

# config : photogimp
distrobox enter ${CTR_NAME} -- sudo bash -c "\
    source ${CORE_BIN_DIR}/graphics/gimp/install_gimp_funcs.sh && \
    install_photogimp ${CUR_USER}"
# ------------------------------------------------------------------------------

# drawing ----------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y drawing

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app drawing
# ------------------------------------------------------------------------------

# vlc --------------------------------------------------------------------------
# installation
distrobox enter ${CTR_NAME} -- sudo dnf install -y vlc

# desktop
distrobox enter ${CTR_NAME} -- distrobox-export --app vlc
# ------------------------------------------------------------------------------

# freefilesync -----------------------------------------------------------------
# debbox(ububox)의 freefilesync를 사용한다.

# installation >> not used
# https://copr.fedorainfracloud.org/coprs/bgstack15/FreeFileSync/
# sudo dnf install -y 'dnf-command(copr)'
# sudo dnf copr enable bgstack15/FreeFileSync
# ------------------------------------------------------------------------------
# ==============================================================================



