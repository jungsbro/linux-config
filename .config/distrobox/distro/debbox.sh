#!/bin/bash

# ENV ==========================================================================
# ------------------------------------------------------------------------------
ROOT_DIR="$(dirname "$(realpath "$0")")"
# ------------------------------------------------------------------------------

# 1) for container -------------------------------------------------------------
ctr="debbox"

image="docker.io/library/debian:latest"

pre_init_hooks="sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources && \
apt update && apt upgrade -y"
# ------------------------------------------------------------------------------

# 2) for apps ------------------------------------------------------------------
pkg_type="apt"


# gui_apps
gui_apps=""
gui_bins=""

# gui_apps+="autokey-gtk "
# gui_bins+="autokey "

# gui_apps+="redshift-gtk geoclue-2.0 "
# gui_bins+="redshift "

# gui_apps+="firejail-profiles firetools "
# gui_bins+="firetools "

# gui_bins+="timeshift "
# gui_apps+="timeshift "

# gui_apps+="gnome-disk-utility "
# gui_bins+="gnome-disks "

# gui_apps+="gnome-keyring "

# gui_apps+="doublecmd-gtk "
# gui_bins+="doublecmd "

# gui_apps+="firefox-esr "
# gui_bins+="firefox "

# gui_apps+="remmina remmina-plugin-rdp "
# gui_bins+="remmina "

# gui_apps+="libreoffice "
# gui_bins+="libreoffice "

# gui_apps+="qpdfview qpdfview-djvu-plugin qpdfview-pdf-poppler-plugin qpdfview-ps-plugin qpdfview-translations "
# gui_bins+="qpdfview "

# gui_apps+="gimp "
# gui_bins+="gimp "

gui_apps+="drawing "
gui_bins+="drawing "

# gui_apps+="vlc "
# gui_bins+="vlc "


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
# ==============================================================================


# Main =========================================================================
if [[ *"$(distrobox list)"* == *"$ctr"* ]]; then
    exit 0;
fi
# ------------------------------------------------------------------------------
# 1) creaeting container
distrobox create --name "$ctr" --image "$image" --pre-init-hooks "$pre_init_hooks";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 2) installing apps
source "${ROOT_DIR}/../share_funcs.sh" && \
install_apps $ctr $pkg_type "$gui_apps" "$gui_bins" "$cli_apps" "$cli_bins"
# ------------------------------------------------------------------------------
# ==============================================================================


