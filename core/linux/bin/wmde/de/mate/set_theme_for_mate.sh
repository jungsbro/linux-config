#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/mate/set_theme_for_mate.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/mate
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

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
function set_theme()
{
    # --------------------------------------------------------------------------
    # Settings >> Look and Feel >> Apperance >> Theme >> Customize >> Controls

    # /org/mate/desktop/interface/gtk-theme
    #   'Adwaita'
    #   'Adwaita-dark'
    gsettings set "org.mate.interface" "gtk-theme" 'Adwaita-dark';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Settings >> Look and Feel >> Apperance >> Theme >> Customize >> Window Border

    # /org/mate/marco/general/theme
    #   'ClearlooksRe'
    gsettings set "org.mate.Marco.general" "theme" 'ClearlooksRe';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Settings >> Look and Feel >> Apperance >> Theme >> Customize >> Icons

    # /org/gnome/desktop/interface/icon-theme
    #   'Papirus'
    gsettings set "org.mate.interface" "icon-theme" 'Papirus';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Settings >> Look and Feel >> Apperance >> Theme >> Customize >> Pinter

    # /org/mate/desktop/peripherals/mouse/cursor-theme
    #   'mate'
    #   'mate-black'
    gsettings set "org.mate.peripherals-mouse" "cursor-theme" 'mate';

    # /org/mate/desktop/peripherals/mouse/cursor-size
    #   24
    #   32
    #   48
    gsettings set "org.mate.peripherals-mouse" "cursor-size" '32';
    # --------------------------------------------------------------------------
}

function set_notification_theme()
{
    # --------------------------------------------------------------------------
    # Settings >> Look and Feel >> Popup Notifications

    # /org/mate/notification-daemon/theme
    #   'slider'
    gsettings set "org.mate.NotificationDaemon" "theme" 'slider';

    # /org/mate/notification-daemon/popup-location
    #   'top_right'
    #   'bottom_right'
    gsettings set "org.mate.NotificationDaemon" "popup-location" 'bottom_right';
    # --------------------------------------------------------------------------
}


function set_font()
{
    # --------------------------------------------------------------------------
    local font_name="Cantarell";
    # local font_name="Sans";

    local font_size="13";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Settings >> Appearance >> Fonts

    # /org/mate/desktop/interface/font-name
    #   'Cantarell 13'
    #   'Sans 13'
    # gsettings set "org.mate.interface" "font-name" "Sans 13";
    gsettings set "org.mate.interface" "font-name" "${font_name} ${font_size}";


    # /org/mate/desktop/interface/document-font-name
    #   'Cantarell 13'
    # gsettings set "org.mate.interface" "font-name" "Sans 13";
    gsettings set "org.mate.interface" "font-name" "${font_name} ${font_size}";


    # /org/mate/caja/desktop/font
    #   'Cantarell 13'
    # gsettings set "org.mate.caja.desktop" "font" "Sans 13"
    gsettings set "org.mate.caja.desktop" "font" "${font_name} ${font_size}"


    # /org/mate/marco/general/titlebar-font
    #   'Cantarell Bold 13'
    # gsettings set "org.mate.Marco.general" "titlebar-font" "Sans Bold 13"
    gsettings set "org.mate.Marco.general" "titlebar-font" "${font_name} Bold ${font_size}"


    # /org/mate/desktop/interface/monospace-font-name
    #   'Monospace 13'
    # gsettings set "org.mate.interface" "monospace-font-name" "Monospace 13";
    gsettings set "org.mate.interface" "monospace-font-name" "Monospace ${font_size}";
    # --------------------------------------------------------------------------
}


function set_effects_enabled()
{
    # --------------------------------------------------------------------------
    # Settings >> Effects >> Desktop and window effects : off

    # gsettings set "org.mate" "desktop-effects-workspace" "false"
    local attr_path="org.mate";
    local attr_name="desktop-effects-workspace";
    local val="false";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_theme;
    set_notification_theme;
    set_font;
    set_effects_enabled;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


