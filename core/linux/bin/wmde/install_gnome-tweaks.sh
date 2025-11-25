#!/bin/bash

# gnome-tweaks =================================================================
# bash /core/linux/bin/wmde/install_gnome-tweaks.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^gnome-tweaks) ]] || apt install -y gnome-tweaks;
    # --------------------------------------------------------------------------
    # [[ -n $(apt list --installed | grep -i ^gnome-shell-extensions-prefs) ]] || apt install -y gnome-shell-extensions-prefs;
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"VERSION_ID=\"12"* ]]; then    # deb12
        [[ -n $(apt list --installed | grep -i ^gnome-shell) ]] || apt install -y gnome-shell;
        [[ -n $(apt list --installed | grep -i ^chrome-gnome-shell) ]] || apt install -y chrome-gnome-shell;
        [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-appindicator) ]] || apt install -y gnome-shell-extension-appindicator;
        [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-caffeine) ]] || apt install -y gnome-shell-extension-caffeine;
        [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-desktop-icons-ng) ]] || apt install -y gnome-shell-extension-desktop-icons-ng;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || apt install -y gnome-shell-extension-do-not-disturb-button;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-drive-menu) ]] || apt install -y gnome-shell-extension-drive-menu;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || apt install -y gnome-shell-extension-horizontal-workspaces;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || apt install -y gnome-shell-extension-panel-favorites;
        [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-top-icons-plus) ]] || apt install -y gnome-shell-extension-top-icons-plus;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-user-theme) ]] || apt install -y gnome-shell-extension-user-theme;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-window-list) ]] || apt install -y gnome-shell-extension-window-list;
        # [[ -n $(apt list --installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || apt install -y gnome-shell-extension-windowoverlay-icons;
    fi
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^gnome-tweak-tool) ]] || yum install -y gnome-tweak-tool;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^gnome-tweaks) ]] || dnf install -y gnome-tweaks;
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
        echo "";
    else                                                    # rocky9, ...
        [[ -n $(dnf list installed | grep -i ^gnome-extensions-app) ]] || dnf install -y gnome-extensions-app;
    fi
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
        [[ -n $(dnf list installed | grep -i ^gnome-shell) ]] || dnf install -y gnome-shell;
        [[ -n $(dnf list installed | grep -i ^chrome-gnome-shell) ]] || dnf install -y chrome-gnome-shell;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-appindicator) ]] || dnf install -y gnome-shell-extension-appindicator;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-caffeine) ]] || dnf install -y gnome-shell-extension-caffeine;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-desktop-icons) ]] || dnf install -y gnome-shell-extension-desktop-icons;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || dnf install -y gnome-shell-extension-do-not-disturb-button;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-drive-menu) ]] || dnf install -y gnome-shell-extension-drive-menu;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || dnf install -y gnome-shell-extension-horizontal-workspaces;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || dnf install -y gnome-shell-extension-panel-favorites;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-topicons-plus) ]] || dnf install -y gnome-shell-extension-topicons-plus;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-user-theme) ]] || dnf install -y gnome-shell-extension-user-theme;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-window-list) ]] || dnf install -y gnome-shell-extension-window-list;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || dnf install -y gnome-shell-extension-windowoverlay-icons;

    elif  [[ *"${CUR_VER}"* == *"VERSION_ID=\"9"* ]]; then  # rocky9
        [[ -n $(dnf list installed | grep -i ^gnome-shell) ]] || dnf install -y gnome-shell;
        [[ -n $(dnf list installed | grep -i ^chrome-gnome-shell) ]] || dnf install -y chrome-gnome-shell;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-appindicator) ]] || dnf install -y gnome-shell-extension-appindicator;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-caffeine) ]] || dnf install -y gnome-shell-extension-caffeine;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-desktop-icons) ]] || dnf install -y gnome-shell-extension-desktop-icons;
        # [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-do-not-disturb-button) ]] || dnf install -y gnome-shell-extension-do-not-disturb-button;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-drive-menu) ]] || dnf install -y gnome-shell-extension-drive-menu;
        # [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-horizontal-workspaces) ]] || dnf install -y gnome-shell-extension-horizontal-workspaces;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-panel-favorites) ]] || dnf install -y gnome-shell-extension-panel-favorites;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-top-icons) ]] || dnf install -y gnome-shell-extension-top-icons;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-user-theme) ]] || dnf install -y gnome-shell-extension-user-theme;
        [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-window-list) ]] || dnf install -y gnome-shell-extension-window-list;
        # [[ -n $(dnf list installed | grep -i ^gnome-shell-extension-windowoverlay-icons) ]] || dnf install -y gnome-shell-extension-windowoverlay-icons;
    fi
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0

