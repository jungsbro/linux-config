#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxde/set_theme_for_lxde.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/lxde
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
source ${CORE_BIN_DIR}/wmde/de/lxde/set_funcs_for_lxde.sh

LXDE_NS="http://openbox.org/3.4/rc";

LXDERC_PATH="${HOME_DIR}/.config/openbox/lxde-rc.xml";

SRC_LXDE_PANEL_PATH="/etc/xdg/lxpanel/LXDE/panels/panel";

if is_rpios; then
    DST_LXDE_PANEL_PATH="${HOME_DIR}/.config/lxpanel/LXDE-pi/panels/panel";
    LXSESSION_CONF_PATH="${HOME_DIR}/.config/lxsession/LXDE-pi/desktop.conf";
    PCMANFM_ITEMS_PATH="${HOME_DIR}/.config/pcmanfm/LXDE-pi/desktop-items-0.conf";
else
    DST_LXDE_PANEL_PATH="${HOME_DIR}/.config/lxpanel/LXDE/panels/panel";
    LXSESSION_CONF_PATH="${HOME_DIR}/.config/lxsession/LXDE/desktop.conf";
    PCMANFM_ITEMS_PATH="${HOME_DIR}/.config/pcmanfm/LXDE/desktop-items-0.conf";
fi
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_desktop_icons()
{
    # --------------------------------------------------------------------------
    if [[ ! -f "${PCMANFM_ITEMS_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # trash : on ---------------------------------------------------------------
    # show_trash=0 >> show_trash=1

    # crudini --set ~/.config/pcmanfm/LXDE/desktop-items-0.conf "*" show_trash 1;
    crudini --set "${PCMANFM_ITEMS_PATH}" "*" show_trash 1
    # --------------------------------------------------------------------------

    # mounts : on --------------------------------------------------------------
    # show_documents=0 >> show_documents=1

    # crudini --set ~/.config/pcmanfm/LXDE/desktop-items-0.conf "*" show_documents 1;
    crudini --set "${PCMANFM_ITEMS_PATH}" "*" show_documents 1
    # --------------------------------------------------------------------------
}


function set_theme()
{
    # --------------------------------------------------------------------------
    if [[ ! -f "${LXSESSION_CONF_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sNet/ThemeName=Adwaita >> sNet/ThemeName=Adwaita-dark

    # crudini --set ~/.config/lxsession/LXDE/desktop.conf "GTK" sNet/IconThemeName Adwaita-dark;
    crudini --set "${LXSESSION_CONF_PATH}" "GTK" sNet/ThemeName Adwaita-dark
    # --------------------------------------------------------------------------
}


function set_icon_theme()
{
    # --------------------------------------------------------------------------
    if [[ ! -f "${LXSESSION_CONF_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sNet/IconThemeName=nuoveXT2 >> sNet/IconThemeName=Papirus

    if [[ -d "/usr/share/icons/Papirus" ]]; then
        # crudini --set ~/.config/lxsession/LXDE/desktop.conf "GTK" sNet/IconThemeName Papirus;
        crudini --set "${LXSESSION_CONF_PATH}" "GTK" sNet/IconThemeName Papirus

    elif [[ -d "/usr/share/icons/Adwaita" ]]; then
        # crudini --set ~/.config/lxsession/LXDE/desktop.conf "GTK" sNet/IconThemeName Adwaita;
        crudini --set "${LXSESSION_CONF_PATH}" "GTK" sNet/IconThemeName Adwaita

    else
        # crudini --set ~/.config/lxsession/LXDE/desktop.conf "GTK" sNet/IconThemeName nuoveXT2;
        crudini --set "${LXSESSION_CONF_PATH}" "GTK" sNet/IconThemeName nuoveXT2
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    set_desktop_icons;
    set_theme;
    set_icon_theme;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================