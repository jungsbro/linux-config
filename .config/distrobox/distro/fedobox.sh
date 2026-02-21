#!/bin/bash

# ENV ==========================================================================
# ------------------------------------------------------------------------------
root_dir="$(pwd)"
# ------------------------------------------------------------------------------

# 1) for container -------------------------------------------------------------
ctr="fedobox"

image="docker.io/library/fedora:latest"

pre_init_hooks="dnf upgrade -y"
# ------------------------------------------------------------------------------

# 2) for apps ------------------------------------------------------------------
pkg_type="dnf"


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
source "$root_dir/../share_funcs.sh" && \
install_apps $ctr $pkg_type "$gui_apps" "$gui_bins" "$cli_apps" "$cli_bins"
# ------------------------------------------------------------------------------
# ==============================================================================

