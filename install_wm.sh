#!/bin/bash

# usage ========================================================================
# sudo bash ./install_wm.sh "${CUR_WM}" "${CUR_USER}";
# ==============================================================================

# ENV ==========================================================================
# ------------------------------------------------------------------------------
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# CUR_WM -----------------------------------------------------------------------
# CUR_WM="openbox";
CUR_WM=${1};

if [[ *"${CUR_WM}"* != *"icewm"* ]] && [[ *"${CUR_WM}"* != *"fluxbox"* ]] && \
[[ *"${CUR_WM}"* != *"openbox"* ]] && [[ *"${CUR_WM}"* != *"i3"* ]]; then

    echo "# ------------------------------------------------------------------------------";
    echo "Usage: bash ${BASH_SOURCE[0]} 'openbox' 'jungs'"
    echo "# ------------------------------------------------------------------------------";
    exit 1
fi
# ------------------------------------------------------------------------------

# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER=${2};

if [[ -z "${CUR_USER}" ]]; then

    echo "# ------------------------------------------------------------------------------";
    echo "Usage: bash ${BASH_SOURCE[0]} 'openbox' 'jungs'"
    echo "# ------------------------------------------------------------------------------";
    exit 1
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================

function install_utils()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

    bash ${CORE_BIN_DIR}/develop/install_crudini.sh;
    bash ${CORE_BIN_DIR}/develop/install_xmlstarlet.sh;

    bash ${CORE_BIN_DIR}/develop/install_glib2.sh;
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;

    bash ${CORE_BIN_DIR}/develop/install_yad.sh;
    bash ${CORE_BIN_DIR}/fonts/install_fonts-emoji.sh;
    bash ${CORE_BIN_DIR}/fonts/install_gnome-characters.sh;
    # --------------------------------------------------------------------------
}


function install_display-server()
{
    if [[ *"${CUR_WM}"* == *"icewm"* ]] || [[ *"${CUR_WM}"* == *"fluxbox"* ]] || \
    [[ *"${CUR_WM}"* == *"openbox"* ]] || [[ *"${CUR_WM}"* == *"i3"* ]]; then
        bash ${CORE_BIN_DIR}/gpu/install_x11.sh;

    else
        echo "wayland"
    fi
}


function install_wm()
{
    # --------------------------------------------------------------------------
    # wm
    if [[ *"${CUR_WM}"* == *"icewm"* ]]; then
        bash ${CORE_BIN_DIR}/wmde/wm/icewm/install_icewm.sh "${CUR_USER}"

    elif [[ *"${CUR_WM}"* == *"fluxbox"* ]]; then
        bash ${CORE_BIN_DIR}/wmde/wm/fluxbox/fb/install_fluxbox.sh "${CUR_USER}"

    elif [[ *"${CUR_WM}"* == *"openbox"* ]]; then
        bash ${CORE_BIN_DIR}/wmde/wm/openbox/install_openbox.sh "${CUR_USER}"

    elif [[ *"${CUR_WM}"* == *"i3"* ]]; then
        bash ${CORE_BIN_DIR}/wmde/wm/i3/install_i3.sh "${CUR_USER}"

    else
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # for autostart (~/.config/autostart/*.desktop)
    bash ${CORE_BIN_DIR}/system/install_dex.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fix xrdp-settings for wm

    # /usr/libexec/xrdp/startwm-bash.sh
    source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && fix_startwm_for_xsession;

    # ~/.xsession, ~/.Xclients
    source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "${CUR_WM}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function install_dm()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
    # --------------------------------------------------------------------------
}


function install_panel()
{
    # --------------------------------------------------------------------------
    # if [[ -d "${HOME_DIR}/.icewm" ]]; then
    # if [[ -d "${HOME_DIR}/.config/i3" ]]; then
    # if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
    # if [[ -d "${HOME_DIR}/.config/openbox" ]]; then

    if [[ *"${CUR_WM}"* == *"icewm"* ]]; then
        echo "";

    elif [[ *"${CUR_WM}"* == *"fluxbox"* ]] || [[ *"${CUR_WM}"* == *"openbox"* ]]; then
        bash ${CORE_BIN_DIR}/panel/tint2/install_tint2.sh "${CUR_USER}";
        bash ${CORE_BIN_DIR}/panel/install_jgmenu.sh "${CUR_USER}";

    elif [[ *"${CUR_WM}"* == *"i3"* ]]; then
        bash ${CORE_BIN_DIR}/panel/install_i3blocks.sh "${CUR_USER}";

    else
        return
    fi
    # --------------------------------------------------------------------------
}


function install_terminal()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/terminal/xfce4-terminal/install_xfce4-terminal.sh "${CUR_USER}";
    # bash ${CORE_BIN_DIR}/terminal/install_alacritty.sh;
    # bash ${CORE_BIN_DIR}/terminal/install_foot.sh;
    # bash ${CORE_BIN_DIR}/terminal/install_wezterm.sh;
    # --------------------------------------------------------------------------
}


function install_launcher()
{
    # --------------------------------------------------------------------------
    # 방법1)
    bash ${CORE_BIN_DIR}/launcher/rofi/install_rofi.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/launcher/install_xfce4-appfinder.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_expose()
{
    # --------------------------------------------------------------------------
    # 방법1)
    # bash ${CORE_BIN_DIR}/launcher/rofi/install_rofi.sh "${CUR_USER}";

    # 방법2)
    bash ${CORE_BIN_DIR}/expose/skippy-xd/install_skippy-xd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_hotkey()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/hotkey/install_xcape.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/hotkey/install_xdotool.sh;
    bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_ime()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/ime/install_korean.sh "${CUR_USER}";
    # bash ${CORE_BIN_DIR}/fonts/install_font-manager.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function install_screen-manager()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/gpu/install_arandr.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_compositor()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/gpu/install_picom.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_power-manager()
{
    # --------------------------------------------------------------------------
    # 방법1)
    bash ${CORE_BIN_DIR}/powermgr/install_xfce4-power-manager.sh;

    # 방법2)
    # bash ${CORE_BIN_DIR}/powermgr/install_lxqt-powermanagement.sh;
    # --------------------------------------------------------------------------
}


function install_audio()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/audio/install_pavucontrol.sh "${CUR_USER}";

    # 방법1)
    bash ${CORE_BIN_DIR}/audio/install_volumeicon.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/audio/install_pasystray.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_network()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/network/install_nm-applet.sh;
    # --------------------------------------------------------------------------
}


function install_file-manager()
{
    # --------------------------------------------------------------------------
    # 방법1)
    bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/filemgr/gui/install_thunar.sh;
    # bash ${CORE_BIN_DIR}/system/install_gvfs.sh;
    # --------------------------------------------------------------------------
}


function install_screenshot()
{
    # --------------------------------------------------------------------------
    # 방법1)
    # bash ${CORE_BIN_DIR}/screenshot/install_gnome-screenshot.sh;

    # 방법2)
    bash ${CORE_BIN_DIR}/screenshot/install_xfce4-screenshooter.sh;
    # --------------------------------------------------------------------------
}


function install_screensaver()
{
    # --------------------------------------------------------------------------
    # 방법1)
    # bash ${CORE_BIN_DIR}/screensaver/xscreensaver/install_xscreensaver.sh "${CUR_USER}";

    # 방법2) xfce4-screensaver & 필요
    bash ${CORE_BIN_DIR}/screensaver/install_xfce4-screensaver.sh;
    # --------------------------------------------------------------------------
}


function install_wallpaper()
{
    # --------------------------------------------------------------------------
    # 방법1)
    bash ${CORE_BIN_DIR}/graphics/install_feh.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/graphics/install_nitrogen.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_task-manager()
{
    # --------------------------------------------------------------------------
    # 방법1) xfce4-terminal -e htop
    bash ${CORE_BIN_DIR}/terminal/xfce4-terminal/install_xfce4-terminal.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/monitoring/install_xfce4-taskmanager.sh;
    # --------------------------------------------------------------------------
}

function install_ide()
{
    # --------------------------------------------------------------------------
    # 방법1)
    bash ${CORE_BIN_DIR}/ide/install_mousepad.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/ide/featherpad/install_featherpad.sh "${CUR_USER}";

    # bash ${CORE_BIN_DIR}/ide/geany/install_geany.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function install_archive-manager()
{
    # --------------------------------------------------------------------------
    # cli)
    bash ${CORE_BIN_DIR}/archive/install_atool.sh;
    # bash ${CORE_BIN_DIR}/archive/install_libarchive.sh;

    # gui)
    # bash ${CORE_BIN_DIR}/archive/install_file-roller.sh;
    bash ${CORE_BIN_DIR}/archive/install_xarchiver.sh;
    # --------------------------------------------------------------------------
}


function install_notification()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/notification/install_libnotify.sh;

    # 방법1)
    bash ${CORE_BIN_DIR}/notification/install_dunst.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/notification/install_xfce4-notifyd.sh;
    # --------------------------------------------------------------------------
}


function install_clipboard()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/clipboard/install_xclip.sh;
    bash ${CORE_BIN_DIR}/clipboard/install_xfce4-clipman.sh;
    # --------------------------------------------------------------------------
}


function install_theme()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/theme/install_lxappearance.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
}


function install_polkit()
{
    # --------------------------------------------------------------------------
    # 방법1)
    bash ${CORE_BIN_DIR}/polkit/install_mate-polkit.sh;

    # 방법2)
    # bash ${CORE_BIN_DIR}/polkit/install_lxqt-policykit.sh;

    # 방법3)
    # bash ${CORE_BIN_DIR}/polkit/install_polkit-kde-agent.sh
    # --------------------------------------------------------------------------
}


function install_calculator()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/calculator/install_mate-calc.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    install_utils;
    install_display-server;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    install_wm;
    install_dm;
    install_panel;
    install_terminal;
    install_launcher;
    install_expose;
    # install_hotkey;
    install_ime;
    install_screen-manager;
    install_compositor;
    install_power-manager;
    install_audio;
    install_network;
    install_file-manager;
    install_screenshot;
    install_screensaver;
    install_wallpaper;
    install_task-manager;
    install_ide;
    install_archive-manager;
    install_notification;
    install_clipboard;
    install_theme;
    install_polkit;
    install_calculator;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================


