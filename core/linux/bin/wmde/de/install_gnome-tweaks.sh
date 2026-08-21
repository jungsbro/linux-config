#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/install_gnome-tweaks.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extensions"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # drive-menu
        # window-list
        # user-theme
        # horizontal-workspace
        local app_name="extension-manager"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="gnome-browser-connector"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="gnome-shell-extension-appindicator"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="gnome-shell-extension-caffeine"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="gnome-shell-extension-desktop-icons-ng"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # local app_name="gnome-shell-extension-do-not-disturb-button"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------
        # local app_name="gnome-shell-extension-drive-menu"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # local app_name="gnome-shell-extension-window-list"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # local app_name="gnome-shell-extension-user-theme-x-git"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # local app_name="gnome-shell-extension-horizontal-workspaces"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------
        # local app_name="gnome-shell-extension-panel-favorites"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="gnome-shell-extension-topicons-plus"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # local app_name="gnome-shell-extension-top-icons"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="gnome-shell-extension-windowoverlay-icons"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extensions"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # drive-menu
        # window-list
        # user-theme
        # horizontal-workspace
        # ----------------------------------------------------------------------
        # local app_name="gnome-shell-extensions-prefs"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then    # deb12
            local app_name="gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="chrome-gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-appindicator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="gnome-shell-extension-caffeine"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="gnome-shell-extension-desktop-icons-ng"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # local app_name="gnome-shell-extension-do-not-disturb-button"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # ------------------------------------------------------------------
            # local app_name="gnome-shell-extension-drive-menu"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # local app_name="gnome-shell-extension-window-list"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # local app_name="gnome-shell-extension-user-theme"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # local app_name="gnome-shell-extension-horizontal-workspaces"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # ------------------------------------------------------------------
            # local app_name="gnome-shell-extension-panel-favorites"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="gnome-shell-extension-top-icons-plus"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            # local app_name="gnome-shell-extension-windowoverlay-icons"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-extensions-app"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-browser-connector"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-caffeine"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-desktop-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-do-not-disturb-button"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-drive-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-window-list"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-user-theme"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-horizontal-workspaces"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # local app_name="gnome-shell-extension-panel-favorites"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-topicons-plus"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-top-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-windowoverlay-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-extensions-app은 rhel8을 지원하지 않는다.
        local app_name="gnome-extensions-app"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            # ------------------------------------------------------------------
            local app_name="gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="chrome-gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-appindicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-caffeine"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-desktop-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-do-not-disturb-button"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-drive-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-window-list"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-user-theme"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-horizontal-workspaces"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-panel-favorites"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-topicons-plus"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-windowoverlay-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------

        elif  [[ "${CUR_VER}" == *"VERSION_ID=\"9"* ]]; then  # rocky9
            local app_name="gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="chrome-gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-appindicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-caffeine"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-desktop-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # local app_name="gnome-shell-extension-do-not-disturb-button"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-drive-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-window-list"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-user-theme"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # local app_name="gnome-shell-extension-horizontal-workspaces"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            local app_name="gnome-shell-extension-panel-favorites"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gnome-shell-extension-topicons-plus"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # local app_name="gnome-shell-extension-windowoverlay-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================