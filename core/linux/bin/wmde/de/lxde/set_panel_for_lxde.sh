#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxde/set_panel_for_lxde.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
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
function set_panel_height()
{
    # --------------------------------------------------------------------------
    # Global{} 블록 안에서, height=26 >> height=40

    # start_ptn : Global {
    # end_ptn : }
    local scope_ptn='/Global {/,/}/';

    # local old_str='height=26';
    local old_str='height=[0-9]*';
    local new_str='height=40';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sed -i '/Global {/,/}/s|height=[0-9]*|height=40|' ~/.config/lxpanel/LXDE/panels/panel;
    sed -i "${scope_ptn}s|${old_str}|${new_str}|" ${DST_LXDE_PANEL_PATH};
    # --------------------------------------------------------------------------
}


function set_panel_style()
{
    # --------------------------------------------------------------------------
    # Global{} 블록 안에서, background=1 >> background=0

    # start_ptn : Global {
    # end_ptn : }
    local scope_ptn='/Global {/,/}/';

    # local old_str='background=1';
    local old_str='background=[0-9]*';
    local new_str='background=0';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sed -i '/Global {/,/}/s|background=[0-9]*|background=0|' ~/.config/lxpanel/LXDE/panels/panel;
    sed -i "${scope_ptn}s|${old_str}|${new_str}|" ${DST_LXDE_PANEL_PATH};
    # --------------------------------------------------------------------------
}


function set_panel_fontcolor()
{
    # --------------------------------------------------------------------------
    # local old_str = "fontcolor=#000000"
    # local new_str = "fontcolor=#ffffff"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Global 블록{} 안에서, usefontcolor=1 >> usefontcolor=0

    # start_ptn : Global {
    # end_ptn : }
    local scope_ptn='/Global {/,/}/';

    # local old_str='usefontcolor=1';
    local old_str='usefontcolor=[0-9]*';
    local new_str='usefontcolor=0';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sed -i '/Global {/,/}/s|usefontcolor=[0-9]*|usefontcolor=0|' ~/.config/lxpanel/LXDE/panels/panel;
    sed -i "${scope_ptn}s|${old_str}|${new_str}|" ${DST_LXDE_PANEL_PATH};
    # --------------------------------------------------------------------------
}


function set_panel_clock()
{
    # --------------------------------------------------------------------------
    # PM 01:00
    # 25-01-01 (Wed)

    # start_ptn : Config {
    # end_ptn : }
    local scope_ptn='/Config {/,/}/';

    local old_str='ClockFmt=%R';
    local new_str='ClockFmt=     %p %I:%M\\n%y-%m-%d (%a)';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sed -i '/Config {/,/}/s|ClockFmt=\%R|ClockFmt=     %p %I:%M\\n%y-%m-%d (%a)|' ~/.config/lxpanel/LXDE/panels/panel;
    sed -i "${scope_ptn}s|${old_str}|${new_str}|" ${DST_LXDE_PANEL_PATH};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    if [[ ! -f ${SRC_LXDE_PANEL_PATH} ]]; then
        exit 0
    fi
    if [[ ! -f ${DST_LXDE_PANEL_PATH} ]]; then
        cp ${SRC_LXDE_PANEL_PATH} ${DST_LXDE_PANEL_PATH};
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_panel_height;
    set_panel_style;
    set_panel_fontcolor;
    set_panel_clock;
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================
