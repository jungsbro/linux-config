#!/bin/bash

# ENV ==========================================================================
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
# /.config/distrobox/distro/install_debbox.sh
# /.config/distrobox/distro
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 1) for container ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
ctr="debbox"

image="docker.io/library/debian:latest"

# distrobox create --name "dccbox" --image "docker.io/library/debian:latest"
ctr_args=""
ctr_args+="--name ${ctr} "
ctr_args+="--image ${image} "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
pre_init_hooks=""

# update
pre_init_hooks+="sudo sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources"
pre_init_hooks+=" && \
    sudo apt update && sudo apt upgrade -y"

# bash 사용
pre_init_hooks+=" && \
    chsh -s /usr/bin/bash ${whoami}"

# container에서 사용하는 git
pre_init_hooks+=" && \
    sudo apt install -y git"

# container에서 사용하는 ranger
pre_init_hooks+=" && \
    sudo apt install -y ranger"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
pre_init_hooks+=" && \
    sudo apt install -y fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 2) for apps ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
pkg_type="apt"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# gui_apps
gui_apps=""
gui_bins=""

gui_apps+="autokey-gtk "
gui_bins+="autokey "

gui_apps+="redshift-gtk geoclue-2.0 "
gui_bins+="redshift "

gui_apps+="firejail-profiles firetools "
gui_bins+="firetools "

# distrobox에서 작동을 안한다.
# gui_apps+="timeshift "
# gui_bins+="timeshift "

# distrobox에서 작동을 안한다.
# gui_apps+="gnome-disk-utility "
# gui_bins+="gnome-disks "

# vscode, remmina에서 사용된다.
gui_apps+="gnome-keyring "
gui_bins+=""

# vscode는 개별설치로
gui_apps+=""
gui_bins+="code "

gui_apps+="doublecmd-gtk "
gui_bins+="doublecmd "

# google-chrome은 개별설치로
gui_apps+=""
gui_bins+="google-chrome "

# 배포판에 이미 설치되어 있다.
# gui_apps+="firefox-esr "
# gui_bins+="firefox "

gui_apps+="remmina remmina-plugin-rdp "
gui_bins+="remmina "

# 배포판에 이미 설치되어 있다.
# gui_apps+="libreoffice "
# gui_bins+="libreoffice "

gui_apps+="qpdfview qpdfview-djvu-plugin qpdfview-pdf-poppler-plugin qpdfview-ps-plugin qpdfview-translations "
gui_bins+="qpdfview "

gui_apps+="gimp "
gui_bins+="gimp "

gui_apps+="drawing "
gui_bins+="drawing "

gui_apps+="vlc "
gui_bins+="vlc "

# archbox의 freefilesync를 사용한다.
# gui_apps+=""
# gui_bins+="freefilesync "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# cli_apps
cli_apps=""
cli_bins=""

# cli_apps+="btop "
# cli_bins+="btop "

# cli_apps+="fastfetch "
# cli_bins+="fastfetch "

# cli_apps+="firejail "
# cli_bins+="firejail "
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ==============================================================================




# Main =========================================================================
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ *"$(distrobox list)"* == *"${ctr}"* ]]; then
    return 0;
fi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1) creaeting container

# ------------------------------------------------------------------------------
distrobox create ${ctr_args};
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ -n "${pre_init_hooks}" ]]; then
    distrobox enter "${ctr}" -- bash -c "${pre_init_hooks}";
fi
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) installing apps

# ------------------------------------------------------------------------------
# vscode

distrobox enter "${ctr}" -- bash -c "\
    sudo bash ${BIN_DIR}/ide/install_vscode.sh $(whoami)"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# google-chrome

distrobox enter "${ctr}" -- bash -c "\
    sudo bash ${BIN_DIR}/internet/install_google-chrome.sh $(whoami)"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# apt-pkgs

source "${DISTOBOX_DIR}/share_funcs.sh" && \
install_apps "${ctr}" "${pkg_type}" "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3) config for apps

# ------------------------------------------------------------------------------
# autokey

distrobox enter "${ctr}" -- bash -c "\
    source ${BIN_DIR}/system/install_autokey.sh $(whoami) && \
    config_autokey && \
    set_autokey_autostart"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# redshift

distrobox enter "${ctr}" -- bash -c "\
    source ${BIN_DIR}/system/install_redshift.sh $(whoami) && \
    config_redshift && \
    set_redshift_autostart"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# gimp

distrobox enter "${ctr}" -- bash -c "\
    source ${BIN_DIR}/graphics/install_gimp.sh $(whoami) && \
    install_photogimp"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ==============================================================================


