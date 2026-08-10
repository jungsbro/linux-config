#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/arch/install_archbox.sh;
# ==============================================================================



# ENV ==========================================================================
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 1) for container ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
CTR_NAME="archbox"

IMAGE="docker.io/library/archlinux:latest"

# distrobox create --name "dccbox" --image "docker.io/library/archlinux:latest"
CTR_ARGS=""
CTR_ARGS+="--name ${CTR_NAME} "
CTR_ARGS+="--image ${IMAGE} "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""
PRE_INIT_HOOKS+="sudo pacman -Syu --needed --noconfirm"
# PRE_INIT_HOOKS+=" && \
#     sudo pacman -Syu --needed --noconfirm"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 2) for apps (pacman) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
pkg_type="pacman"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# gui_apps
gui_apps=""
gui_bins=""

# gui_apps+="redshift geoclue "
# gui_bins+="redshift "

# gui_apps+="firetools "
# gui_bins+=""

# gui_apps+="timeshift "
# gui_bins+="timeshift "

# gui_apps+="gnome-disk-utility "
# gui_bins+="gnome-disks "

# gui_apps+="gnome-keyring "
# gui_bins+=""

# gui_apps+="doublecmd-qt5 "
# gui_bins+="doublecmd "

# gui_apps+="firefox "
# gui_bins+="firefox "

# gui_apps+="remmina "
# gui_bins+="remmina "

# # gui_apps+="libreoffice-fresh "
# gui_apps+="libreoffice-still "
# gui_bins+="libreoffice "

# gui_apps+="gimp "
# gui_bins+="gimp "

gui_apps+="drawing "
gui_bins+="drawing "

# gui_apps+="vlc "
# gui_bins+="vlc "
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

cli_apps+="xcape "
cli_bins+="xcape "
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 3) for apps(yay) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
pkg_type2="yay"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# gui_apps
gui_apps2=""
gui_bins2=""

# gui_apps2+="autokey-gtk "
# gui_bins2+="autokey-gtk "

# gui_apps2+="qpdfview "
# gui_bins2+="qpdfview "

# build하는데 시간이 너무 오래걸려서 nix로 대체
# gui_apps2+="freefilesync "
# gui_bins2+="FreeFileSync "

gui_apps2+="google-chrome "
gui_bins2+="google-chrome-stable "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# cli_apps
cli_apps2=""
cli_bins2=""

# cli_apps2+="skippy-xd-git"
# cli_bins2+="skippy-xd "
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ==============================================================================



# Main =========================================================================
# ------------------------------------------------------------------------------
if [[ "$(distrobox list)" == *"${CTR_NAME}"* ]]; then
    exit 0;
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 1) creaeting container
distrobox create ${CTR_ARGS};

if [[ -n "${PRE_INIT_HOOKS}" ]]; then
    distrobox enter "${CTR_NAME}" -- bash -c "${PRE_INIT_HOOKS}";
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 2) installing apps (pacaman)
# 2) installing apps (yay)
source ${CORE_BIN_DIR}/container/install_distrobox_funcs.sh && \
install_apps "${CTR_NAME}" "${pkg_type}" "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}" && \
install_apps "${CTR_NAME}" "${pkg_type2}" "${gui_apps2}" "${gui_bins2}" "${cli_apps2}" "${cli_bins2}"
# ------------------------------------------------------------------------------
# ==============================================================================
