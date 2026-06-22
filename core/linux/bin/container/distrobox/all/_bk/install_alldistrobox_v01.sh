#!/bin/bash

# Funcs ========================================================================
function install_apps()
{
    # --------------------------------------------------------------------------
    local ctr_name="${1}"
    local pkg_type="${2}"
    local gui_apps="${3}"
    local gui_bins="${4}"
    local cli_apps="${5}"
    local cli_bins="${6}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${pkg_type}" == "apt" ]]; then
        pkg_install="sudo apt install -y"

    elif [[ "${pkg_type}" == "dnf" ]]; then
        pkg_install="sudo dnf install -y"

    elif [[ "${pkg_type}" == "pacman" ]]; then
        pkg_install="sudo pacman -S --needed --noconfirm"

    elif [[ "${pkg_type}" == "yay" ]]; then
        pkg_install="yay -S --needed --noconfirm"

        if ! distrobox enter ${ctr_name} -- yay --version &>/dev/null; then
            if ! distrobox enter ${ctr_name} -- git --version &>/dev/null; then
                distrobox enter ${ctr_name} -- sudo pacman -S --needed --noconfirm base-devel git
            fi
            distrobox enter ${ctr_name} -- git clone https://aur.archlinux.org/yay.git /tmp/yay
            distrobox enter ${ctr_name} -- bash -c "cd /tmp/yay && makepkg -si --noconfirm"
            distrobox enter ${ctr_name} -- rm -rf /tmp/yay
        fi

    else
        echo "지원하지 않는 패키지 관리자입니다: ${pkg_type}"
        return 1
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) distrobox enter debbox -- sudo apt install -y firefox-esr btop
    distrobox enter ${ctr_name} -- ${pkg_install} ${gui_apps} ${cli_apps}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) export gui_bins (.desktop 파일 생성)
    local gui_bin="";

    for gui_bin in ${gui_bins};
    do
        # echo ${gui_bin}
        distrobox enter ${ctr_name} -- distrobox-export --app ${gui_bin}
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) export cli_bins (심볼릭 링크 생성)
    local cli_bin="";

    for cli_bin in ${cli_bins};
    do
        cli_cmd=$(distrobox enter ${ctr_name} -- bash -lc "command -v ${cli_bin}" 2>/dev/null)
        # echo ${cli_cmd}
        distrobox enter ${ctr_name} -- distrobox-export --bin ${cli_cmd}
    done
    # --------------------------------------------------------------------------
}
# ==============================================================================


# ==============================================================================
# 1) Create container
# ------------------------------------------------------------------------------
# Create container from alldistrobox.ini
# distrobox assemble create --file alldistrobox.ini
# distrobox-upgrade --all
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# debbox
# distrobox create --name debbox --image docker.io/library/debian:latest \
# --pre-init-hooks "sed -i 's/deb.debian.org/ftp.kr.debian.org/g' /etc/apt/sources.list.d/debian.sources && \
# apt update && apt upgrade -y"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# fedobox
# distrobox create --name fedobox --image docker.io/library/fedora:latest \
# --pre-init-hooks "dnf update -y"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# archbox
distrobox create --name archbox --image docker.io/library/archlinux:latest \
--pre-init-hooks "pacman -Syu --needed --noconfirm"
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
# 2) Install apps in debbox
# ------------------------------------------------------------------------------
ctr_name="debbox"
pkg_type="apt"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
gui_apps=""
gui_bins=""

gui_apps+="autokey-gtk "
gui_bins+="autokey "

gui_apps+="redshift-gtk geoclue-2.0 "
gui_bins+="redshift "

gui_apps+="firejail firejail-profiles firetools "
gui_bins+="firetools "

gui_bins+="timeshift "
gui_apps+="timeshift "

gui_apps+="gnome-disk-utility "
gui_bins+="gnome-disks "

gui_apps+="gnome-keyring "

gui_apps+="doublecmd-gtk "
gui_bins+="doublecmd "

gui_apps+="firefox-esr "
gui_bins+="firefox "

gui_apps+="remmina remmina-plugin-rdp "
gui_bins+="remmina "

gui_apps+="libreoffice "
gui_bins+="libreoffice "

gui_apps+="qpdfview qpdfview-djvu-plugin qpdfview-pdf-poppler-plugin qpdfview-ps-plugin qpdfview-translations "
gui_bins+="qpdfview "

gui_apps+="gimp "
gui_bins+="gimp "

gui_apps+="drawing "
gui_bins+="drawing "

gui_apps+="vlc "
gui_bins+="vlc "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
cli_apps=""
cli_bins=""

cli_apps+="btop "
cli_bins+="btop "

cli_apps+="fastfetch "
cli_bins+="fastfetch "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ *"$(distrobox list)"* == *"${ctr_name}"* ]]; then
    install_apps ${ctr_name} ${pkg_type} "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
# 3) Install apps in fedobox
# ------------------------------------------------------------------------------
ctr_name="fedobox"
pkg_type="dnf"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
gui_apps=""
gui_bins=""

gui_apps+="autokey-gtk "
gui_bins+="autokey-gtk "

gui_apps+="redshift-gtk geoclue2 "
gui_bins+="redshift "

gui_apps+="firejail "
gui_bins+=""

gui_apps+="timeshift "
gui_bins+="timeshift "

gui_apps+="gnome-disk-utility "
gui_bins+="gnome-disks "

gui_apps+="gnome-keyring "
gui_bins+=""

gui_apps+="doublecmd-gtk "
gui_bins+="doublecmd "

gui_apps+="firefox "
gui_bins+="firefox "

gui_apps+="remmina "
gui_bins+="remmina "

gui_apps+="libreoffice "
gui_bins+="libreoffice "

gui_apps+="qpdfview-common qpdfview-qt5 qpdfview-qt6 "
gui_bins+="qpdfview-qt5 "

gui_apps+="gimp "
gui_bins+="gimp "

gui_apps+="drawing "
gui_bins+="drawing "

gui_apps+="vlc "
gui_bins+="vlc "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
cli_apps=""
cli_bins=""

cli_apps+="btop "
cli_bins+="btop "

cli_apps+="fastfetch "
cli_bins+="fastfetch "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ *"$(distrobox list)"* == *"${ctr_name}"* ]]; then
    install_apps ${ctr_name} ${pkg_type} "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# ==============================================================================
# 4) Install apps in archbox
# ------------------------------------------------------------------------------
ctr_name="archbox"
pkg_type="pacman"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
gui_apps=""
gui_bins=""

gui_apps+="redshift geoclue "
gui_bins+="redshift "

gui_apps+="firejail firetools "
gui_bins+=""

gui_apps+="timeshift "
gui_bins+="timeshift "

gui_apps+="gnome-disk-utility "
gui_bins+="gnome-disks "

gui_apps+="gnome-keyring "
gui_bins+=""

gui_apps+="doublecmd-qt5 "
gui_bins+="doublecmd "

gui_apps+="firefox "
gui_bins+="firefox "

gui_apps+="remmina "
gui_bins+="remmina "

# gui_apps+="libreoffice-fresh "
gui_apps+="libreoffice-still "
gui_bins+="libreoffice "

gui_apps+="gimp "
gui_bins+="gimp "

gui_apps+="drawing "
gui_bins+="drawing "

gui_apps+="vlc "
gui_bins+="vlc "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
cli_apps=""
cli_bins=""

cli_apps+="util-linux "
cli_bins+=""

cli_apps+="btop "
cli_bins+="btop "

cli_apps+="fastfetch "
cli_bins+="fastfetch "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ *"$(distrobox list)"* == *"${ctr_name}"* ]]; then
    install_apps ${ctr_name} ${pkg_type} "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
fi
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
ctr_name="archbox"
pkg_type="yay"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
gui_apps=""
gui_bins=""

gui_apps+="autokey-gtk "
gui_bins+="autokey-gtk "

gui_apps+="qpdfview "
gui_bins+="qpdfview "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
cli_apps=""
cli_bins=""
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
if [[ *"$(distrobox list)"* == *"${ctr_name}"* ]]; then
    install_apps ${ctr_name} ${pkg_type} "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
fi
# ------------------------------------------------------------------------------
# ==============================================================================

