#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/deb/install_debbox.sh;
# ==============================================================================



# ENV ==========================================================================
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 1) for container ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
CTR_NAME="debbox"

IMAGE="docker.io/library/debian:latest"

# distrobox create --name "dccbox" --image "docker.io/library/debian:latest"
CTR_ARGS=""
CTR_ARGS+="--name ${CTR_NAME} "
CTR_ARGS+="--image ${IMAGE} "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# update
PRE_INIT_HOOKS+="sudo sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources"
PRE_INIT_HOOKS+=" && \
    sudo apt update && sudo apt upgrade -y"

# bash 사용
PRE_INIT_HOOKS+=" && \
    chsh -s /usr/bin/bash ${CUR_USER}"

# container에서 사용하는 git
PRE_INIT_HOOKS+=" && \
    sudo apt install -y git"

# container에서 사용하는 fm
PRE_INIT_HOOKS+=" && \
    sudo apt install -y ranger"
# PRE_INIT_HOOKS+=" && \
#     sudo apt install -y nnn"

# host와 container에 한글입력기를 설치해야 한글을 사용할 수 있다.
PRE_INIT_HOOKS+=" && \
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
if [[ *"$(distrobox list)"* == *"${CTR_NAME}"* ]]; then
    return 0;
fi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1) creaeting container

# ------------------------------------------------------------------------------
distrobox create ${CTR_ARGS};
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ -n "${PRE_INIT_HOOKS}" ]]; then
    distrobox enter "${CTR_NAME}" -- bash -c "${PRE_INIT_HOOKS}";
fi
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) installing apps

# ------------------------------------------------------------------------------
# vscode

distrobox enter "${CTR_NAME}" -- bash -c "\
    sudo bash ${CORE_BIN_DIR}/ide/install_vscode.sh ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# google-chrome

distrobox enter "${CTR_NAME}" -- bash -c "\
    sudo bash ${CORE_BIN_DIR}/internet/install_google-chrome.sh ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# apt-pkgs

source ${CORE_BIN_DIR}/container/install_distrobox_funcs.sh && \
install_apps "${CTR_NAME}" "${pkg_type}" "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 3) config for apps

# ------------------------------------------------------------------------------
# autokey

distrobox enter ${CTR_NAME} -- sudo bash -c "\
    source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
    config_autokey ${CUR_USER} && \
    set_autokey_autostart ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# redshift

distrobox enter ${CTR_NAME} -- bash -c "\
    source ${CORE_BIN_DIR}/system/redshift/install_redshift_funcs.sh && \
    config_redshift ${CUR_USER} && \
    set_redshift_autostart ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# gimp

distrobox enter ${CTR_NAME} -- sudo bash -c "\
    source ${CORE_BIN_DIR}/graphics/gimp/install_gimp_funcs.sh && \
    install_photogimp ${CUR_USER}"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ==============================================================================


