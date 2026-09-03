#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_theme_for_cinnamon.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/cinnamon
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
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
    # Settings >> Apperance >> Themes

    # gsettings set "org.cinnamon.desktop.interface" "gtk-theme" "BlackMATE"
    local attr_path="org.cinnamon.desktop.interface";
    local attr_name="gtk-theme";
    local val="BlackMATE";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.gnome.desktop.interface" "gtk-theme" "BlackMATE"
    local attr_path="org.gnome.desktop.interface";
    local attr_name="gtk-theme";
    local val="BlackMATE";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # gsettings set "org.x.apps.portal" "color-scheme" "prefer-dark"
    local attr_path="org.x.apps.portal";
    local attr_name="color-scheme";
    local val="prefer-dark";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_icon_theme()
{
    # --------------------------------------------------------------------------
    # Settings >> Apperance >> Themes

    # gsettings set "org.cinnamon.desktop.interface" "icon-theme" "Papirus"
    local attr_path="org.cinnamon.desktop.interface";
    local attr_name="icon-theme";
    local val="Papirus";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_terminal_theme()
{
    # --------------------------------------------------------------------------
    # 1) Terminal >> Preferences >> Unmamed >> Colors >> Usecolors from system theme : off
    # /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors false
    # gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/" "use-theme-colors" "false"
    local attr_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/";
    local attr_name="use-theme-colors";
    local val="false";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # 2) Terminal >> Preferences >> Unmamed >> Colors >> Built-in schemes: Tango dark
    # /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/foreground-color 'rgb(211,215,207)'
    # gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/" "foreground-color" 'rgb(211,215,207)'
    local attr_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/";
    local attr_name="foreground-color";
    local val="rgb(211,215,207)";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color 'rgb(46,52,54)'
    # gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/" "background-color" 'rgb(46,52,54)'
    local attr_path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/";
    local attr_name="background-color";
    local val="rgb(46,52,54)";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # /org/gnome/software/check-timestamp "int64 1787538840"
    # gsettings set "org.gnome.software" "check-timestamp" "int64 1787538840"
    local attr_path="org.gnome.software";
    local attr_name="check-timestamp";
    local val="int64 1787538840";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # /org/gnome/software/update-notification-timestamp "int64 1787538848"
    # gsettings set "org.gnome.software" "update-notification-timestamp" "int64 1787538848"
    local attr_path="org.gnome.software";
    local attr_name="update-notification-timestamp";
    local val="int64 1787538848";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_font_large()
{
    # --------------------------------------------------------------------------
    # Settings >> Appearance >> Font Selection >> Text scaling factor: 1 >> 1.3

    # gsettings set "org.cinnamon.desktop.interface" "text-scaling-factor" "1.3"
    local attr_path="org.cinnamon.desktop.interface";
    local attr_name="text-scaling-factor";
    local val="1.3";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";

    # gsettings set "org.gnome.desktop.interface" "text-scaling-factor" "1.3"
    local attr_path="org.gnome.desktop.interface";
    local attr_name="text-scaling-factor";
    local val="1.3";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function set_effects_enabled()
{
    # --------------------------------------------------------------------------
    # Settings >> Effects >> Desktop and window effects : off

    # gsettings set "org.cinnamon" "desktop-effects-workspace" "false"
    local attr_path="org.cinnamon";
    local attr_name="desktop-effects-workspace";
    local val="false";
    set_attr_value "${attr_path}" "${attr_name}" "${val}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_theme;
    set_icon_theme;
    set_terminal_theme;
    set_font_large;
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


