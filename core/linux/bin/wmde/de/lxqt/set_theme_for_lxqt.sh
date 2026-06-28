#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_theme_for_lxqt.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/lxqt
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

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

# ------------------------------------------------------------------------------
ICON_THEME_NAME="Papirus-Dark";
GTK2_THEME_NAME="Adwaita-dark";
GTK3_THEME_NAME="Adwaita-dark";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ~
GTKRC2_DIR="${HOME_DIR}";

# ~/.gtkrc-2.0
GTKRC2_PATH="${GTKRC2_DIR}/.gtkrc-2.0";

GTKRC2_CMD='# Created by lxqt-config-appearance (DO NOT EDIT!)
gtk-theme-name = "Adwaita"
gtk-icon-theme-name = "Papirus"
gtk-font-name = "Sans 11"
gtk-button-images = 1
gtk-menu-images = 1
gtk-toolbar-style = GTK_TOOLBAR_BOTH_HORIZ
gtk-cursor-theme-name = whiteglass
gtk-cursor-theme-size = 18'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ~/.config/gtk-3.0
GTKRC3_DIR="${HOME_DIR}/.config/gtk-3.0";

# ~/.config/gtk-3.0/settings.ini
GTKRC3_PATH="${GTKRC3_DIR}/settings.ini";

GTKRC3_CMD='
# Created by lxqt-config-appearance (DO NOT EDIT!)
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = Papirus
# GTK3 ignores bold or italic attributes.
gtk-font-name = Sans 11
gtk-menu-images = 1
gtk-button-images = 1
gtk-toolbar-style = GTK_TOOLBAR_BOTH_HORIZ
gtk-cursor-theme-name = whiteglass
gtk-cursor-theme-size = 18'
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_gtkrc()
{
    # --------------------------------------------------------------------------
    # 1) GTK2-setting
    if [[ ! -d ${GTKRC2_DIR} ]]; then
        mkdir -p "${GTKRC2_DIR}";
    fi
    if [[ ! -f ${GTKRC2_PATH} ]]; then
        echo "${GTKRC2_CMD}" > "${GTKRC2_PATH}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) GTK3-setting
    if [[ ! -d ${GTKRC3_DIR} ]]; then
        mkdir -p "${GTKRC3_DIR}";
    fi
    if [[ ! -f ${GTKRC3_PATH} ]]; then
        echo "${GTKRC3_CMD}" > "${GTKRC3_PATH}";
    fi
    # --------------------------------------------------------------------------
}


function set_icons_theme()
{
    # --------------------------------------------------------------------------
    if [[ ! -e "/usr/share/icons/Papirus" ]]; then
        return
    fi

    create_gtkrc;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) Icon Theme
    # crudini --set ~/.config/lxqt/lxqt.conf General icon_theme Papirus-Dark
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" General icon_theme ${ICON_THEME_NAME}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) GTK2 Theme
    # sed -i 's|\"Papirus\"|\"Papirus-Dark\}\"|g' ~/.gtkrc-2.0
    sed -i "s|\"Papirus\"|\"${ICON_THEME_NAME}\"|g" ${GTKRC2_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) GTK3 Theme
    # crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-icon-theme-name Papirus-Dark
    crudini --set "${GTKRC3_PATH}" Settings gtk-icon-theme-name ${ICON_THEME_NAME}
    # --------------------------------------------------------------------------
}


function set_lxqt_theme()
{
    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf General theme dark;
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" General theme dark
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette base_color "#282828";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette base_color "#282828"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette highlight_color "#640b0c";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette highlight_color "#640b0c"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette highlighted_text_color "#ebfdff";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette highlighted_text_color "#ebfdff"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette link_color "#8c9bff";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette link_color "#8c9bff"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette link_visited_color "#ffb3f7";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette link_visited_color "#ffb3f7"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette text_color "#b8b8b8";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette text_color "#b8b8b8"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette tooltip_base_color "#232323";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette tooltip_base_color "#232323"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette tooltip_text_color "#b8b8b8";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette tooltip_text_color "#b8b8b8"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette window_color "#232323";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette window_color "#232323"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/lxqt.conf Palette window_text_color "#e1e6e6";
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt.conf" Palette window_text_color "#e1e6e6"
    # --------------------------------------------------------------------------
}


function set_gtk_theme()
{
    # --------------------------------------------------------------------------
    create_gtkrc;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) Set GTK themes (GTK configuration files will be overwritten!)
    # crudini --set ~/.config/lxqt/lxqt-config-appearance.conf General ControlGTKThemeEnabled true
    crudini --set "${HOME_DIR}/.config/lxqt/lxqt-config-appearance.conf" General ControlGTKThemeEnabled true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) GTK 2 Theme
    # sed -i 's|\"Adwaita\"|\"Adwaita-dark\"|g' ~/.gtkrc-2.0
    sed -i "s|\"Adwaita\"|\"${GTK2_THEME_NAME}\"|g" ${GTKRC2_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) GTK 3 Theme

    # crudini --set ~/.config/gtk-3.0/settings.ini Settings gtk-theme-name Adwaita-dark
    crudini --set "${GTKRC3_PATH}" Settings gtk-theme-name ${GTK3_THEME_NAME}
    # --------------------------------------------------------------------------
}


function set_desktop()
{
    # --------------------------------------------------------------------------
    echo ""
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    set_icons_theme;
    set_lxqt_theme;
    set_gtk_theme;
    # set_desktop;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


