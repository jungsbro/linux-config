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
        # gnome-shell (gnome)
        local app_name="gnome-shell"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-tweaks (gnome)
        local app_name="gnome-tweaks"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        # 방법1)
        # extension-web-manager (gnome)
        # local app_name="gnome-browser-connector"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # extension-gui-manager (gnome)
        # gnome 구조변경에 따른 gnome-shell에 통합 추정

        # 방법2)
        # extension-gui-manager (community)
        local app_name="extension-manager"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-shell-extensions (패키지 모음)
        local app_name="gnome-shell-extensions"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="gnome-shell-extension-appindicator"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="gnome-shell-extension-caffeine"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="gnome-shell-extension-desktop-icons-ng"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # gnome-shell (gnome)
        local app_name="gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-tweaks (gnome)
        local app_name="gnome-tweaks"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # 방법1)
        # extension-web-manager (gnome)
        # if [[ "${CUR_VER}" == *"VERSION_ID=\"12"* ]]; then  # debian 12
        #     local app_name="chrome-gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # else
        #     local app_name="gnome-browser-connector"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # fi

        # extension-gui-manager (gnome)
        # local app_name="gnome-shell-extension-prefs"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2)
        # extension-gui-manager (community)
        local app_name="gnome-shell-extension-manager"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-shell-extensions (패키지 모음)
        local app_name="gnome-shell-extensions"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-app-menu"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-drive-menu"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-places-menu"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-window-list"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-auto-move-windows"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-launch-new-instance"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-native-window-placement"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-widndows-navigator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-workspace-indicator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-user-theme"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-light-style"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-system-monitor"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-screenshot-window-sizer"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-common"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extension-caffeine"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extension-desktop-icons-ng"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # gnome-shell (gnome)
        local app_name="gnome-shell"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-tweaks (gnome)
        local app_name="gnome-tweaks"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # 방법1)
        # extension-web-manager (gnome)
        # local app_name="gnome-browser-connector"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # extension-gui-manager (gnome)
        # local app_name="gnome-shell-extensions-prefs"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2)
        # extension-gui-manager (community)
        local app_name="gnome-shell-extension-manager"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-shell-extensions (패키지 모음)
        local app_name="gnome-shell-extensions"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="gnome-shell-extension-caffeine"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="gnome-shell-extension-desktop-icons-ng"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # gnome-shell (gnome)
        local app_name="gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-tweaks (gnome)
        local app_name="gnome-tweaks"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # 방법1)
        # extension-web-manager (gnome)
        # local app_name="gnome-browser-connector"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # extension-gui-manager (gnome)
        # local app_name="gnome-extensions-app"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2)
        # extension-gui-manager (community)
        local app_fullname="com.mattjakeman.ExtensionManager";
        source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}"
        # ----------------------------------------------------------------------
        # gnome-shell-extensions (패키지 모음)
        local app_name="gnome-shell-extension-apps-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-drive-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-places-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-window-list"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-auto-move-windows"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-launch-new-instance"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-native-window-placement"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-windowsNavigator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-workspace-indicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-user-theme"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-light-style"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-system-monitor"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-screenshot-window-sizer"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-common"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-caffeine"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-desktop-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-frippery-panel-favorites"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # gnome-shell (gnome)
        local app_name="gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # gnome-tweaks (gnome)
        local app_name="gnome-tweaks"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # 방법1)
        # extension-web-manager (gnome)
        # local app_name="chrome-gnome-shell"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # extension-gui-manager (gnome)
        # if [[ "${CUR_VER}" == *"VERSION_ID=\"8"* ]]; then     # rocky8
        #     # gnome-extensions-app을 rhel8이 지원하지 않는다.
        #     echo ""
        # else
        #     local app_name="gnome-extensions-app"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # fi

        # 방법2)
        # extension-gui-manager (community)
        local app_fullname="com.mattjakeman.ExtensionManager";
        source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}"
        # ----------------------------------------------------------------------
        # gnome-shell-extensions (패키지 모음)
        local app_name="gnome-shell-extension-apps-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-drive-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-places-menu"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-window-list"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-auto-move-windows"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-launch-new-instance"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-native-window-placement"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-windowsNavigator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-workspace-indicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-user-theme"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="gnome-shell-extension-light-style"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-systemMonitor"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-screenshot-window-sizer"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-common"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        local app_name="gnome-shell-extension-appindicator"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-caffeine"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gnome-shell-extension-desktop-icons"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
        # rhel 전용
        local app_name="gnome-shell-extension-panel-favorites"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}


function execute_main()
{
    install_gnome-tweaks;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================