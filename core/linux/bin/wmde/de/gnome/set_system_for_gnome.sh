#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_system_for_gnome.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh

# set_attr_value "${attr_path}" "${attr_name}" "${val}";
# set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_desktop_iconsize()
{
    # --------------------------------------------------------------------------
    # Extensions >> Desktop Icons >> Settings >> Size for desktop icons

    # /org/gnome/nautilus/icon-view/default-zoom-level : 'small'
    gsettings set "org.gnome.nautilus.icon-view" "default-zoom-level" 'small'
    # --------------------------------------------------------------------------
}


function set_nightlight()
{
    # --------------------------------------------------------------------------
    # Settings >> Displays >> NightLight

    # Night Light: on
    # /org/gnome/settings-daemon/plugins/color/night-light-enabled
    #   true
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-enabled" 'true';


    # Night Light 시간설정
    # /org/gnome/settings-daemon/plugins/color/night-light-schedule-from
    #  6.0
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-schedule-from" '6.0';

    # /org/gnome/settings-daemon/plugins/color/night-light-schedule-to
    # 6.0
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-schedule-to" '6.0';


    # 색 온도 조절:
    # /org/gnome/settings-daemon/plugins/color/night-light-temperature
    #   uint32 3700
    gsettings set "org.gnome.settings-daemon.plugins.color" "night-light-temperature" 'uint32 3700'

    # --------------------------------------------------------------------------
}


function set_hotkey_for_window-movement()
{
    # --------------------------------------------------------------------------
    # 이미 있음
    # gnome-tweaks >> Windows

    # org/gnome/desktop/wm/preferences/mouse-button-modifier
    #   '<Super>'
    gsettings set "org.gnome.desktop.wm.preferences" "mouse-button-modifier" '<Super>'
    # --------------------------------------------------------------------------
}


function set_extension_enable()     # not used
{
    # --------------------------------------------------------------------------
    # Extensions >> Extensions: on

    # 수정
    # /org/gnome/shell/disable-user-extensions
    #   true
    gsettings set "org.gnome.shell" "disable-user-extensions" "false"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
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
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_desktop_iconsize;
    set_nightlight;
    set_hotkey_for_window-movement;
    # set_extension_enable;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================