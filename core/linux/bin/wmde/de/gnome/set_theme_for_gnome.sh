#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/gnome/set_theme_for_gnome.sh;
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
    # 방법1) for gnome 40.10
    # gnome-tweaks >> Appearance >> Applications
    # /org/gnome/desktop/interface/gtk-theme
    #   'Adwaita-dark'
    gsettings set "org.gnome.desktop.interface" "gtk-theme" 'Adwaita-dark'


    # 방법2) for gnome 40.10 이상부터 가능
    # Settings >> Appearance >> Style >> Default(Light) >> Dark
    # /org/gnome/desktop/interface/color-scheme
    #   'prefer-dark'
    gsettings set "org.gnome.desktop.interface" "color-scheme" 'prefer-dark' 2>/dev/null || true;
    # --------------------------------------------------------------------------
}

function set_icon_theme()
{
    # --------------------------------------------------------------------------
    # gnome-tweaks >> Appearance >> Icons

    # /org/gnome/desktop/interface/icon-theme
    #   'Papirus'
    gsettings set "org.gnome.desktop.interface" "icon-theme" 'Papirus'
    # --------------------------------------------------------------------------
}


function set_font_large()
{
    # --------------------------------------------------------------------------
    # Settings >> Accessibility

    # /org/gnome/desktop/a11y/always-show-universal-access-status
    #  true
    gsettings set "org.gnome.desktop.a11y" "always-show-universal-access-status" 'true'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Settings >> Accessibility >> Large Text
    # gnome-tweaks >> Fonts >> Scaling Factor : 1.25

    # /org/gnome/desktop/interface/text-scaling-factor
    #   1.25
    gsettings set "org.gnome.desktop.interface" "text-scaling-factor" '1.25';
    # --------------------------------------------------------------------------
}


function set_min-max_btn()
{
    # --------------------------------------------------------------------------
    # gnome-tweaks >> Window Titlebars >> Titlebar Buttons

    # /org/gnome/desktop/wm/preferences/button-layout
    #   'appmenu:minimize,maximize,close'

    gsettings set "org.gnome.desktop.wm.preferences" "button-layout" 'appmenu:minimize,maximize,close'
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_theme;
    set_icon_theme;
    set_font_large;
    set_min-max_btn;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


