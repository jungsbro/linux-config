#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/fedo/install_fedobox.sh;
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

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 1) for container ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CTR_NAME="fedobox"

IMAGE="docker.io/library/fedora:latest"

# distrobox create --name "dccbox" --image "docker.io/library/fedora:latest"
CTR_ARGS=""
CTR_ARGS+="--name ${CTR_NAME} "
CTR_ARGS+="--image ${IMAGE} "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""
PRE_INIT_HOOKS+="sudo dnf upgrade -y"
# PRE_INIT_HOOKS+=" && \
#     sudo dnf upgrade -y"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 2) for apps ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
pkg_type="dnf"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# gui_apps
gui_apps=""
gui_bins=""

# gui_apps+="autokey-gtk "
# gui_bins+="autokey-gtk "

# gui_apps+="redshift-gtk geoclue2 "
# gui_bins+="redshift "

# gui_apps+="timeshift "
# gui_bins+="timeshift "

# gui_apps+="gnome-disk-utility "
# gui_bins+="gnome-disks "

# gui_apps+="gnome-keyring "
# gui_bins+=""

# gui_apps+="doublecmd-gtk "
# gui_bins+="doublecmd "

# gui_apps+="firefox "
# gui_bins+="firefox "

# gui_apps+="remmina "
# gui_bins+="remmina "

# gui_apps+="libreoffice "
# gui_bins+="libreoffice "

# gui_apps+="qpdfview-common qpdfview-qt5 qpdfview-qt6 "
# gui_bins+="qpdfview-qt5 "

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
# 2) installing apps
source ${CORE_BIN_DIR}/container/install_distrobox_funcs.sh && \
install_apps "${CTR_NAME}" "${pkg_type}" "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
# ------------------------------------------------------------------------------
# ==============================================================================

