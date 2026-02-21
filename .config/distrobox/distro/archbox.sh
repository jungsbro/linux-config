#!/bin/bash


# ENV ==========================================================================
# ------------------------------------------------------------------------------
root_dir="$(pwd)"
# ------------------------------------------------------------------------------

# 1) for container -------------------------------------------------------------
ctr="archbox"

image="docker.io/library/archlinux:latest"

pre_init_hooks="pacman -Syu --noconfirm"
# ------------------------------------------------------------------------------

# 2) for apps (pacman) ---------------------------------------------------------
pkg_type="pacman"


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

# gui_apps+="drawing "
# gui_bins+="drawing "

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

cli_apps+="xcape "
cli_bins+="xcape "
# ------------------------------------------------------------------------------

# 3) for apps(yay) -------------------------------------------------------------
pkg_type2="yay"


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


# cli_apps
cli_apps2=""
cli_bins2=""

cli_apps2+="skippy-xd-git"
cli_bins2+="skippy-xd "
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
# 2) installing apps (pacaman)
# 2) installing apps (yay)
source "$root_dir/../share_funcs.sh" && \
install_apps $ctr $pkg_type "$gui_apps" "$gui_bins" "$cli_apps" "$cli_bins" && \
install_apps $ctr $pkg_type2 "$gui_apps2" "$gui_bins2" "$cli_apps2" "$cli_bins2"
# ------------------------------------------------------------------------------
# ==============================================================================
