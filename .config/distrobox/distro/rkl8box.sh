#!/bin/bash

# ENV ==========================================================================
# ------------------------------------------------------------------------------
root_dir="$(pwd)"
# ------------------------------------------------------------------------------

# 1) for container -------------------------------------------------------------
ctr="rkl8box"

# rokcy9/glibc가 x86-64-v2 요구 → 구형 CPU에서는 실행 불가
# rokcy8/glibc가 x86-64-v1 기반 → 구형 CPU에서도 문제 없이 실행 가능
image="docker.io/library/rockylinux:8"

# pre_init_hooks="dnf upgrade -y && dnf install -y epel-release"

pre_init_hooks="dnf upgrade -y && \
    dnf install -y epel-release dnf-plugins-core && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y \
    https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm && \
    dnf install -y mesa-libGL libX11 libXi libXcursor libXrandr libXrender \
    libGLU libXext libXfixes libXinerama \
    fontconfig freetype libpng libjpeg \
    gtk3 cairo pango qt5-qtbase qt5-qtx11extras \
    python3 ffmpeg ffmpeg-devel openssl python3-numpy"
# ------------------------------------------------------------------------------

# 2) for apps ------------------------------------------------------------------
pkg_type="dnf"


# gui_apps
gui_apps=""
gui_bins=""

# # not working in Rocky8
# # gui_apps+="autokey-gtk "
# # gui_bins+="autokey-gtk "

# gui_apps+="redshift-gtk geoclue2 "
# gui_bins+="redshift "

# gui_apps+="timeshift "
# gui_bins+="timeshift "

# gui_apps+="gnome-disk-utility "
# gui_bins+="gnome-disks "

# gui_apps+="gnome-keyring libsecret "
# gui_bins+=""

# # doublecmd-gtk is not available in Rocky8
# # gui_apps+="doublecmd-gtk "
# # gui_bins+="doublecmd "

# gui_apps+="firefox "
# gui_bins+="firefox "

# gui_apps+="remmina "
# gui_bins+="remmina "

# gui_apps+="libreoffice "
# gui_bins+="libreoffice "

# gui_apps+="qpdfview-qt5 "
# gui_bins+="qpdfview-qt5 "

# # gimp is too old in Rocky8
# gui_apps+="gimp "
# gui_bins+="gimp "

# gui_apps+="drawing "
# gui_bins+="drawing "

# # vlc is not available in Rocky8
# # gui_apps+="vlc "
# # gui_bins+="vlc "


# cli_apps
cli_apps=""
cli_bins=""

# # not working in Rocky8
# # cli_apps+="btop "
# # cli_bins+="btop "

# cli_apps+="fastfetch "
# cli_bins+="fastfetch "

# # not working in Rocky8
# # cli_apps+="firejail "
# # cli_bins+="firejail "
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

