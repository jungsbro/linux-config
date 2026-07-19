#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/audio/install_pavucontrol.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/audio
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_pavucontrol_enable()
{
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files | grep -iq pipewire; then
            su - ${CUR_USER} -c "systemctl --user enable --now pipewire";
            su - ${CUR_USER} -c "systemctl --user enable --now pipewire-pulse";
            su - ${CUR_USER} -c "systemctl --user enable --now wireplumber";
        fi
    fi
}
# ==============================================================================


# Main : x86_64, aarch64, i686 =================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^pipewire) ]] || pacman -S --needed --noconfirm pipewire;
        [[ -n $(pacman -Q | grep -i ^pipewire-alsa) ]] || pacman -S --needed --noconfirm pipewire-alsa;
        [[ -n $(pacman -Q | grep -i ^pipewire-pulse) ]] || pacman -S --needed --noconfirm pipewire-pulse;
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(pacman -Q | grep -i ^pavucontrol-qt) ]] || pacman -S --needed --noconfirm pavucontrol-qt;
        else
            [[ -n $(pacman -Q | grep -i ^pavucontrol) ]] || pacman -S --needed --noconfirm pavucontrol;
        fi
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^wireplumber) ]] || pacman -S --needed --noconfirm wireplumber;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^pipewire) ]] || apt install -y pipewire;
        [[ -n $(apt list --installed | grep -i ^pipewire-alsa) ]] || apt install -y pipewire-alsa;
        [[ -n $(apt list --installed | grep -i ^pipewire-pulse) ]] || apt install -y pipewire-pulse;
        [[ -n $(apt list --installed | grep -i ^pipewire-audio-client-libraries) ]] || apt install -y pipewire-audio-client-libraries;
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^pavucontrol-qt) ]] || apt install -y pavucontrol-qt;
        else
            [[ -n $(apt list --installed | grep -i ^pavucontrol) ]] || apt install -y pavucontrol;
        fi
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^wireplumber) ]] || apt install -y wireplumber;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^pipewire) ]] || dnf install -y pipewire;
        [[ -n $(dnf list --installed | grep -i ^pipewire-alsa) ]] || dnf install -y pipewire-alsa;
        [[ -n $(dnf list --installed | grep -i ^pipewire-pulseaudio) ]] || dnf install -y pipewire-pulseaudio;
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^pavucontrol-qt) ]] || dnf install -y pavucontrol-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^pavucontrol) ]] || dnf install -y pavucontrol;
        fi
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^wireplumber) ]] || dnf install -y wireplumber;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^pipewire) ]] || dnf install -y pipewire;
        [[ -n $(dnf list --installed | grep -i ^pipewire-alsa) ]] || dnf install -y pipewire-alsa;
        [[ -n $(dnf list --installed | grep -i ^pipewire-pulseaudio) ]] || dnf install -y pipewire-pulseaudio;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^pavucontrol) ]] || dnf install -y pavucontrol;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^wireplumber) ]] || dnf install -y wireplumber;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    set_pavucontrol_enable;
    # --------------------------------------------------------------------------

fi
# ==============================================================================
