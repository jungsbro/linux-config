#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/install_gnome-tweaks.sh;
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^gnome-tweaks) ]] || pacman -S --needed --noconfirm gnome-tweaks;
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^gnome-shell-extensions) ]] || pacman -S --needed --noconfirm gnome-shell-extensions;
        # drive-menu
        # window-list
        # user-theme
        # horizontal-workspace
        [[ -n $(pacman -Q | grep -i ^extension-manager) ]] || pacman -S --needed --noconfirm extension-manager;
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^gnome-shell) ]] || pacman -S --needed --noconfirm gnome-shell;
        [[ -n $(pacman -Q | grep -i ^gnome-browser-connector) ]] || pacman -S --needed --noconfirm gnome-browser-connector;
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^gnome-shell-extension-appindicator) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-appindicator";
        [[ -n $(yay -Q | grep -i ^gnome-shell-extension-caffeine) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-caffeine";
        [[ -n $(yay -Q | grep -i ^gnome-shell-extension-desktop-icons-ng) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-desktop-icons-ng";
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-do-not-disturb-button";
        # ----------------------------------------------------------------------
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-drive-menu) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-drive-menu";
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-window-list) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-window-list";
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-user-theme-x-git) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-user-theme-x-git";
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-horizontal-workspaces";
        # ----------------------------------------------------------------------
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-panel-favorites) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-panel-favorites";
        [[ -n $(yay -Q | grep -i ^gnome-shell-extension-topicons-plus) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-topicons-plus";
        # [[ -n $(yay -Q | grep -i ^gnome-shell-extension-top-icons) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-top-icons";
        [[ -n $(yay -Q | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm gnome-shell-extension-windowoverlay-icons";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^gnome-tweaks) ]] || apt install -y gnome-tweaks;
        [[ -n $(apt list --installed | grep -i ^gnome-shell-extensions) ]] || apt install -y gnome-shell-extensions;
        # drive-menu
        # window-list
        # user-theme
        # horizontal-workspace
        # ----------------------------------------------------------------------
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extensions-prefs) ]] || apt install -y gnome-shell-extensions-prefs;
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then    # deb12
            [[ -n $(apt list --installed | grep -i ^gnome-shell) ]] || apt install -y gnome-shell;
            [[ -n $(apt list --installed | grep -i ^chrome-gnome-shell) ]] || apt install -y chrome-gnome-shell;
            # ------------------------------------------------------------------
            [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-appindicator) ]] || apt install -y gnome-shell-extension-appindicator;
            [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-caffeine) ]] || apt install -y gnome-shell-extension-caffeine;
            [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-desktop-icons-ng) ]] || apt install -y gnome-shell-extension-desktop-icons-ng;
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || apt install -y gnome-shell-extension-do-not-disturb-button;
            # ------------------------------------------------------------------
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-drive-menu) ]] || apt install -y gnome-shell-extension-drive-menu;
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-window-list) ]] || apt install -y gnome-shell-extension-window-list;
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-user-theme) ]] || apt install -y gnome-shell-extension-user-theme;
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || apt install -y gnome-shell-extension-horizontal-workspaces;
            # ------------------------------------------------------------------
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || apt install -y gnome-shell-extension-panel-favorites;
            [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-top-icons-plus) ]] || apt install -y gnome-shell-extension-top-icons-plus;
            # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || apt install -y gnome-shell-extension-windowoverlay-icons;
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-tweaks) ]] || dnf install -y gnome-tweaks;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-extensions-app) ]] || dnf install -y gnome-extensions-app;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-shell) ]] || dnf install -y gnome-shell;
        [[ -n $(dnf list --installed | grep -i ^gnome-browser-connector) ]] || dnf install -y gnome-browser-connector;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-appindicator) ]] || dnf install -y gnome-shell-extension-appindicator;
        [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-caffeine) ]] || dnf install -y gnome-shell-extension-caffeine;
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-desktop-icons) ]] || dnf install -y gnome-shell-extension-desktop-icons;
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || dnf install -y gnome-shell-extension-do-not-disturb-button;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-drive-menu) ]] || dnf install -y gnome-shell-extension-drive-menu;
        [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-window-list) ]] || dnf install -y gnome-shell-extension-window-list;
        [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-user-theme) ]] || dnf install -y gnome-shell-extension-user-theme;
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || dnf install -y gnome-shell-extension-horizontal-workspaces;
        # ----------------------------------------------------------------------
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || dnf install -y gnome-shell-extension-panel-favorites;
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-topicons-plus) ]] || dnf install -y gnome-shell-extension-topicons-plus;
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-top-icons) ]] || dnf install -y gnome-shell-extension-top-icons;
        # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || dnf install -y gnome-shell-extension-windowoverlay-icons;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^gnome-tweaks) ]] || dnf install -y gnome-tweaks;
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            echo "";
        else                                                    # rocky9, ...
            [[ -n $(dnf list --installed | grep -i ^gnome-extensions-app) ]] || dnf install -y gnome-extensions-app;
        fi
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            [[ -n $(dnf list --installed | grep -i ^gnome-shell) ]] || dnf install -y gnome-shell;
            [[ -n $(dnf list --installed | grep -i ^chrome-gnome-shell) ]] || dnf install -y chrome-gnome-shell;
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-appindicator) ]] || dnf install -y gnome-shell-extension-appindicator;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-caffeine) ]] || dnf install -y gnome-shell-extension-caffeine;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-desktop-icons) ]] || dnf install -y gnome-shell-extension-desktop-icons;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || dnf install -y gnome-shell-extension-do-not-disturb-button;
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-drive-menu) ]] || dnf install -y gnome-shell-extension-drive-menu;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-window-list) ]] || dnf install -y gnome-shell-extension-window-list;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-user-theme) ]] || dnf install -y gnome-shell-extension-user-theme;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || dnf install -y gnome-shell-extension-horizontal-workspaces;
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || dnf install -y gnome-shell-extension-panel-favorites;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-topicons-plus) ]] || dnf install -y gnome-shell-extension-topicons-plus;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || dnf install -y gnome-shell-extension-windowoverlay-icons;
            # ------------------------------------------------------------------

        elif  [[ "${CUR_VER}" == *"VERSION_ID=\"9"* ]]; then  # rocky9
            [[ -n $(dnf list --installed | grep -i ^gnome-shell) ]] || dnf install -y gnome-shell;
            [[ -n $(dnf list --installed | grep -i ^chrome-gnome-shell) ]] || dnf install -y chrome-gnome-shell;
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-appindicator) ]] || dnf install -y gnome-shell-extension-appindicator;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-caffeine) ]] || dnf install -y gnome-shell-extension-caffeine;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-desktop-icons) ]] || dnf install -y gnome-shell-extension-desktop-icons;
            # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || dnf install -y gnome-shell-extension-do-not-disturb-button;
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-drive-menu) ]] || dnf install -y gnome-shell-extension-drive-menu;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-window-list) ]] || dnf install -y gnome-shell-extension-window-list;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-user-theme) ]] || dnf install -y gnome-shell-extension-user-theme;
            # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || dnf install -y gnome-shell-extension-horizontal-workspaces;
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || dnf install -y gnome-shell-extension-panel-favorites;
            [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-top-icons) ]] || dnf install -y gnome-shell-extension-top-icons;
            # [[ -n $(dnf list --installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || dnf install -y gnome-shell-extension-windowoverlay-icons;
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

