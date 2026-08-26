#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/install_gnome-tweaks.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/gnome
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================

function install_gnome-tweaks()
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

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extensions"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # drive-menu
        # window-list
        # user-theme
        # horizontal-workspace
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then  # debian 12
            local app_name="gnome-shell-extensions-prefs"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            # gnome-shell-extensions-prefs을 rhe13+이 지원하지 않는다.
            echo "";
        fi
        # ----------------------------------------------------------------------
        local app_name="gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then  # debian 12
            local app_name="chrome-gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            local app_name="gnome-browser-connector"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # ------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extension-caffeine"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extension-desktop-icons-ng"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-do-not-disturb-button"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then  # debian 12
            echo "";
        else
            local app_name="gnome-shell-extension-drive-menu"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="gnome-shell-extension-window-list"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
            local app_name="gnome-shell-extension-user-theme"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        fi
        # local app_name="gnome-shell-extension-horizontal-workspaces"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ------------------------------------------------------------------
        # local app_name="gnome-shell-extension-panel-favorites"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then  # debian 12
            local app_name="gnome-shell-extension-top-icons-plus"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        else
            # gnome-shell-extension-top-icons-plus을 rhe13+이 지원하지 않는다.
            echo "";
        fi
        # local app_name="gnome-shell-extension-windowoverlay-icons"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extensions"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # drive-menu
        # window-list
        # user-theme
        # horizontal-workspace
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extensions-prefs"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-browser-connector"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-caffeine"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extension-desktop-icons-ng"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-do-not-disturb-button"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ------------------------------------------------------------------
        # local app_name="gnome-shell-extension-drive-menu"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-window-list"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-user-theme"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-horizontal-workspaces"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ------------------------------------------------------------------
        # local app_name="gnome-shell-extension-panel-favorites"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-top-icons-plus"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-windowoverlay-icons"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
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
        local app_name="gnome-shell-extension-frippery-panel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-topicons-plus"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-top-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-windowoverlay-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="gnome-tweaks"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            # gnome-extensions-app을 rhel8이 지원하지 않는다.
            echo ""
        else
            local app_name="gnome-extensions-app"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        fi
        # ----------------------------------------------------------------------
        local app_name="gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="chrome-gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-caffeine"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-desktop-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            local app_name="gnome-shell-extension-do-not-disturb-button"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            # gnome-shell-extension-do-not-disturb-button을 rhel9+이 지원하지 않는다.
            echo "";
        fi
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-drive-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-window-list"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-user-theme"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            local app_name="gnome-shell-extension-horizontal-workspaces"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            # gnome-shell-extension-horizontal-workspaces을 rhel9+이 지원하지 않는다.
            echo "";
        fi
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-panel-favorites"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-topicons-plus"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
            local app_name="gnome-shell-extension-windowoverlay-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        else
            # gnome-shell-extension-windowoverlay-icons을 rhel9+이 지원하지 않는다.
            echo "";
        fi
        # ----------------------------------------------------------------------
    fi
}


function set_extension_enable()
{
    # gnome-extensions list
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        echo "";

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ubuntu-appindicators@ubuntu.com
        # caffeine@patapon.info
        # ding@rastersoft.com
        # apps-menu@gnome-shell-extensions.gcampax.github.com
        # places-menu@gnome-shell-extensions.gcampax.github.com
        # launch-new-instance@gnome-shell-extensions.gcampax.github.com
        # window-list@gnome-shell-extensions.gcampax.github.com
        # auto-move-windows@gnome-shell-extensions.gcampax.github.com
        # drive-menu@gnome-shell-extensions.gcampax.github.com
        # light-style@gnome-shell-extensions.gcampax.github.com
        # native-window-placement@gnome-shell-extensions.gcampax.github.com
        # screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com
        # system-monitor@gnome-shell-extensions.gcampax.github.com
        # user-theme@gnome-shell-extensions.gcampax.github.com
        # windowsNavigator@gnome-shell-extensions.gcampax.github.com
        # workspace-indicator@gnome-shell-extensions.gcampax.github.com
        su - "${CUR_USER}" -c "gnome-extensions enable window-list@gnome-shell-extensions.gcampax.github.com" 2>/dev/null || true;
        su - "${CUR_USER}" -c "gnome-extensions enable ubuntu-appindicators@ubuntu.com" 2>/dev/null || true;

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ding@rastersoft.com
        # snapd-prompting@canonical.com
        # snapd-search-provider@canonical.com
        # tiling-assistant@ubuntu.com
        # ubuntu-appindicators@ubuntu.com
        # ubuntu-dock@ubuntu.com
        # web-search-provider@ubuntu.com
        # apps-menu@gnome-shell-extensions.gcampax.github.com
        # launch-new-instance@gnome-shell-extensions.gcampax.github.com
        # places-menu@gnome-shell-extensions.gcampax.github.com
        # window-list@gnome-shell-extensions.gcampax.github.com
        # auto-move-windows@gnome-shell-extensions.gcampax.github.com
        # drive-menu@gnome-shell-extensions.gcampax.github.com
        # light-style@gnome-shell-extensions.gcampax.github.com
        # native-window-placement@gnome-shell-extensions.gcampax.github.com
        # screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com
        # status-icons@gnome-shell-extensions.gcampax.github.com
        # system-monitor@gnome-shell-extensions.gcampax.github.com
        # user-theme@gnome-shell-extensions.gcampax.github.com
        # windowsNavigator@gnome-shell-extensions.gcampax.github.com
        # workspace-indicator@gnome-shell-extensions.gcampax.github.com
        su - "${CUR_USER}" -c "gnome-extensions enable ubuntu-appindicators@ubuntu.com" 2>/dev/null || true;
        echo "";

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # apps-menu@gnome-shell-extensions.gcampax.github.com
        # drive-menu@gnome-shell-extensions.gcampax.github.com
        # launch-new-instance@gnome-shell-extensions.gcampax.github.com
        # places-menu@gnome-shell-extensions.gcampax.github.com
        # window-list@gnome-shell-extensions.gcampax.github.com
        # user-theme@gnome-shell-extensions.gcampax.github.com
        # caffeine@patapon.info
        # appindicatorsupport@rgcjonas.gmail.com
        su - "${CUR_USER}" -c "gnome-extensions enable window-list@gnome-shell-extensions.gcampax.github.com" 2>/dev/null || true;
        su - "${CUR_USER}" -c "gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com" 2>/dev/null || true;

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # desktop-icons@gnome-shell-extensions.gcampax.github.com
        # caffeine@patapon.info
        # panel-favorites@gnome-shell-extensions.gcampax.github.com
        # appindicatorsupport@rgcjonas.gmail.com
        # launch-new-instance@gnome-shell-extensions.gcampax.github.com
        # background-logo@fedorahosted.org
        # places-menu@gnome-shell-extensions.gcampax.github.com
        # user-theme@gnome-shell-extensions.gcampax.github.com
        # apps-menu@gnome-shell-extensions.gcampax.github.com
        # window-list@gnome-shell-extensions.gcampax.github.com
        # drive-menu@gnome-shell-extensions.gcampax.github.com
        su - "${CUR_USER}" -c "gnome-extensions enable window-list@gnome-shell-extensions.gcampax.github.com" 2>/dev/null || true;
        su - "${CUR_USER}" -c "gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com" 2>/dev/null || true;
    fi
}


function execute_main()
{
    install_gnome-tweaks;
    # set_extension_enable;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================