#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/audio/install_pavucontrol.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="pavucontrol";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_pavucontrol_enable()
{
    if systemctl is-system-running >/dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files pipewire.service &>/dev/null; then
            su - "${CUR_USER}" -c "systemctl --user enable --now pipewire";
            su - "${CUR_USER}" -c "systemctl --user enable --now pipewire-pulse";
            su - "${CUR_USER}" -c "systemctl --user enable --now wireplumber";
        fi
    fi
}


function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="pipewire"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="pipewire-alsa"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="pipewire-pulse"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        if [[ "${CUR_SESSION}" == *"lxqt"* ]] || [[ "${CUR_SESSION}" == *"plasma"* ]]; then
            local app_name="pavucontrol-qt"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        else
            local app_name="pavucontrol"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        fi
        # ----------------------------------------------------------------------
        local app_name="wireplumber"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="pipewire"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="pipewire-alsa"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="pipewire-pulse"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="pipewire-audio-client-libraries"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        if [[ "${CUR_SESSION}" == *"lxqt"* ]] || [[ "${CUR_SESSION}" == *"plasma"* ]]; then
            local app_name="pavucontrol-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            local app_name="pavucontrol"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # ----------------------------------------------------------------------
        local app_name="wireplumber"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="pipewire"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="pipewire-alsa"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="pipewire-pulseaudio"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        if [[ "${CUR_SESSION}" == *"lxqt"* ]] || [[ "${CUR_SESSION}" == *"plasma"* ]]; then
            local app_name="pavucontrol-qt"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            local app_name="pavucontrol"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        fi
        # ----------------------------------------------------------------------
        local app_name="wireplumber"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
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
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================