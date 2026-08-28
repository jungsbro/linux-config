#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/config_de.sh "${CUR_USER}";
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================

function install_tools()
{
    # --------------------------------------------------------------------------
    # nix (이유없이 애러가 날 때가 있다. 그래서 첫 순위에 배치를 했다.)
    bash ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix.sh "${CUR_USER}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/develop/tools/install_crud-tools.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/fonts/tools/install_font-tools.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # launcher
    # 방법1)
    # bash ${CORE_BIN_DIR}/launcher/install_ulauncher.sh "${CUR_USER}";

    # 방법2)
    # bash ${CORE_BIN_DIR}/launcher/install_synapse.sh "${CUR_USER}";

    # 방법3)
    bash ${CORE_BIN_DIR}/launcher/rofi/install_rofi.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_pkgs_for_lxde()
{
    # --------------------------------------------------------------------------
    # screensaver
    bash ${CORE_BIN_DIR}/screensaver/xscreensaver/install_xscreensaver.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # screenshot
    # 방법1)
    # bash ${CORE_BIN_DIR}/screenshot/install_gnome-screenshot.sh;

    # 방법2)
    bash ${CORE_BIN_DIR}/screenshot/install_xfce4-screenshooter.sh;
    bash ${CORE_BIN_DIR}/clipboard/install_xfce4-clipman.sh;
    # --------------------------------------------------------------------------
    # expose
    bash ${CORE_BIN_DIR}/expose/skippy-xd/install_skippy-xd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # hotkey
    bash ${CORE_BIN_DIR}/hotkey/install_xcape.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/hotkey/install_xdotool.sh;
    # bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # terminal
    bash ${CORE_BIN_DIR}/terminal/lxterminal/install_lxterminal.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # control-center
    bash ${CORE_BIN_DIR}/system/wmcc/install_wmcc.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # nightlight
    bash ${CORE_BIN_DIR}/system/redshift/install_redshift.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_pkgs_for_lxqt()
{
    # --------------------------------------------------------------------------
    # screensaver
    bash ${CORE_BIN_DIR}/screensaver/xscreensaver/install_xscreensaver.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # file-editor
    bash ${CORE_BIN_DIR}/ide/featherpad/install_featherpad.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # expose
    bash ${CORE_BIN_DIR}/expose/skippy-xd/install_skippy-xd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # hotkey
    # bash ${CORE_BIN_DIR}/hotkey/install_xcape.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/hotkey/install_xdotool.sh;
    bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # terminal
    bash ${CORE_BIN_DIR}/terminal/qterminal/install_qterminal.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/terminal/xfce4-terminal/install_xfce4-terminal.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # nightlight
    bash ${CORE_BIN_DIR}/system/redshift/install_redshift.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_pkgs_for_xfce4()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then    # mxlinux xfce4
        # ----------------------------------------------------------------------
        # screensaver
        bash ${CORE_BIN_DIR}/screensaver/install_xfce4-screensaver.sh;
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # hotkey
        bash ${CORE_BIN_DIR}/hotkey/install_xcape.sh "${CUR_USER}";
        # ----------------------------------------------------------------------
        # calculator

        # 방법1)
        # bash ${CORE_BIN_DIR}/calculator/install_galculator.sh "${CUR_USER}";

        # 방법2)
        # bash ${CORE_BIN_DIR}/calculator/install_gnome-calculator.sh;

        # 방법3)
        bash ${CORE_BIN_DIR}/calculator/install_mate-calc.sh;
        # ----------------------------------------------------------------------
        # screensaver
        bash ${CORE_BIN_DIR}/screensaver/xscreensaver/install_xscreensaver.sh "${CUR_USER}";
        # ----------------------------------------------------------------------
        # panel
        bash ${CORE_BIN_DIR}/panel/install_xfce4-docklike.sh "${CUR_USER}";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
    # 파일 및 미디어도구
    bash ${CORE_BIN_DIR}/archive/install_file-roller.sh
    bash ${CORE_BIN_DIR}/archive/install_thunar-archive-plugin.sh;
    bash ${CORE_BIN_DIR}/mount/install_thunar-volman.sh;
    # 무거움
    # bash ${CORE_BIN_DIR}/graphics/install_tumbler.sh

    # 하드웨어 및 전원관리
    bash ${CORE_BIN_DIR}/audio/install_xfce4-pulseaudio-plugin.sh;
    # bash ${CORE_BIN_DIR}/audio/install_pavucontrol.sh "${CUR_USER}";
    # bash ${CORE_BIN_DIR}/network/install_nm-connection-editor.sh;

    # 시스템 모니터링
    bash ${CORE_BIN_DIR}/monitoring/install_xfce4-taskmanager.sh;
    bash ${CORE_BIN_DIR}/monitoring/install_xfce4-sensors-plugin.sh;
    bash ${CORE_BIN_DIR}/monitoring/install_xfce4-fsguard-plugin.sh;
    bash ${CORE_BIN_DIR}/monitoring/install_xfce4-mount-plugin.sh;

    # 생산성 및 업무 편의도구
    bash ${CORE_BIN_DIR}/panel/install_xfce4-whiskermenu-plugin.sh;

    # 고급 사용자용 확장 및 자동화
    bash ${CORE_BIN_DIR}/panel/install_xfce4-panel-profiles.sh;
    # --------------------------------------------------------------------------
    # appmenu
    bash ${CORE_BIN_DIR}/panel/install_xfce4-appmenu-plugin.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # file-editor
    bash ${CORE_BIN_DIR}/ide/install_mousepad.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # expose
    bash ${CORE_BIN_DIR}/expose/skippy-xd/install_skippy-xd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # panel
    # bash ${CORE_BIN_DIR}/panel/inatll_plank.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # hotkey
    # bash ${CORE_BIN_DIR}/tiling/install_wmctrl.sh;
    # bash ${CORE_BIN_DIR}/hotkey/install_xcape.sh "${CUR_USER}";
    # bash ${CORE_BIN_DIR}/hotkey/install_xdotool.sh;
    # bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_thunar.sh;
    bash ${CORE_BIN_DIR}/mount/install_gvfs.sh;
    # --------------------------------------------------------------------------
    # terminal
    bash ${CORE_BIN_DIR}/terminal/xfce4-terminal/install_xfce4-terminal.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # nightlight
    bash ${CORE_BIN_DIR}/system/redshift/install_redshift.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_pkgs_for_mate()
{
    # --------------------------------------------------------------------------
    # compositor
    bash ${CORE_BIN_DIR}/gpu/compositor/install_marco.sh
    # --------------------------------------------------------------------------
    # screenshot
    bash ${CORE_BIN_DIR}/screenshot/install_mate-screenshot.sh;
    # --------------------------------------------------------------------------
    # task-manager
    bash ${CORE_BIN_DIR}/monitoring/install_gnome-system-monitor.sh;
    # --------------------------------------------------------------------------
    # expose
    bash ${CORE_BIN_DIR}/expose/skippy-xd/install_skippy-xd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # hotkey
    # bash ${CORE_BIN_DIR}/hotkey/install_xcape.sh "${CUR_USER}";
    # bash ${CORE_BIN_DIR}/hotkey/install_xdotool.sh;
    # bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;
    bash ${CORE_BIN_DIR}/wmde/de/mate/install_mate-menu.sh;
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_caja.sh;
    bash ${CORE_BIN_DIR}/mount/install_gvfs.sh;
    # --------------------------------------------------------------------------
    # nightlight
    bash ${CORE_BIN_DIR}/system/redshift/install_redshift.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_pkgs_for_gnome()
{
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;
    bash ${CORE_BIN_DIR}/wmde/de/gnome/install_gnome-tweaks.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_nautilus.sh;
    bash ${CORE_BIN_DIR}/mount/install_gvfs.sh;
    # --------------------------------------------------------------------------
}


function install_pkgs_for_cinnamon()
{
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/develop/install_dconf.sh;
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_nemo.sh;
    bash ${CORE_BIN_DIR}/mount/install_gvfs.sh;
    # --------------------------------------------------------------------------
}


function install_pkgs_for_kde()
{
    # --------------------------------------------------------------------------
    # theme
    bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
    # --------------------------------------------------------------------------
    # file-manager
    bash ${CORE_BIN_DIR}/filemgr/gui/install_dolphin.sh;
    # --------------------------------------------------------------------------
}


function config_de()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/wmde/dm/install_dm_funcs.sh && set_xprofile_enable;
    # --------------------------------------------------------------------------

    if [[ "${CUR_WMDE}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/lxde/set_config_for_lxde.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_WMDE}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_config_for_lxqt.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_WMDE}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/xfce4/set_config_for_xfce4.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_WMDE}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/mate/set_config_for_mate.sh ${CUR_USER}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_WMDE}" != *"cinnamon"* ]] && [[ "${CUR_WMDE}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/gnome/set_config_for_gnome.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_WMDE}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/cinnamon/set_config_for_cinnamon.sh ${CUR_USER}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_WMDE}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        su - "${CUR_USER}" -c "dbus-run-session bash ${CORE_BIN_DIR}/wmde/de/kde/set_config_for_kde.sh ${CUR_USER}";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    # 1) install packages for de
    install_tools;

    if [[ "${CUR_WMDE}" == *"lxsession"* ]]; then
        install_pkgs_for_lxde;

    elif [[ "${CUR_WMDE}" == *"lxqt"* ]]; then
        install_pkgs_for_lxqt;

    elif [[ "${CUR_WMDE}" == *"xfce4"* ]]; then
        install_pkgs_for_xfce4;

    elif [[ "${CUR_WMDE}" == *"mate"* ]]; then
        install_pkgs_for_mate;

    elif [[ "${CUR_WMDE}" != *"cinnamon"* ]] && [[ "${CUR_WMDE}" == *"gnome"* ]]; then
        install_pkgs_for_gnome;

    elif [[ "${CUR_WMDE}" == *"cinnamon"* ]]; then
        install_pkgs_for_cinnamon;

    elif [[ "${CUR_WMDE}" == *"plasma"* ]]; then
        install_pkgs_for_kde;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) de-settings
    config_de;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


