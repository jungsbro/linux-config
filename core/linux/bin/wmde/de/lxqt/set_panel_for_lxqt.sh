#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_panel_for_lxqt.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_workspace()
{
    # --------------------------------------------------------------------------
    echo ""
    # --------------------------------------------------------------------------
}


function set_panel_size()
{
    # --------------------------------------------------------------------------
    # Panel Size : 32 >> 40
    # crudini --set ~/.config/lxqt/panel.conf panel1 panelSize 32;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" panel1 panelSize 32
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Icon size : 22 >> 36
    # crudini --set ~/.config/lxqt/panel.conf panel1 iconSize 22;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" panel1 iconSize 22
    # --------------------------------------------------------------------------

}


function set_panel_grouping()
{
    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf taskbar groupingEnabled true;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" taskbar groupingEnabled true
    # --------------------------------------------------------------------------
}


function set_panel_clock()
{
    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock alignment Right;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock alignment Right
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock autoRotate true;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock autoRotate true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock customFormat "\"'<b>'hh:mm A'</b><br/><font size=\"-1\">'yy-MM-d (ddd)'<br/></font>'\"";
    # customFormat="'<b>'hh:mm A'</b><br/><font size=\"-1\">'yy-MM-d (ddd)'<br/></font>'"
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock customFormat '"'\''<b>'\''hh:mm A'\''</b><br/><font size=\"-1\">'\''yy-MM-d (ddd)'\''<br/></font>'\''"'

#     su - "${CUR_USER}" <<EOF
# crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock customFormat '"'\''<b>'\''hh:mm A'\''</b><br/><font size=\"-1\">'\''yy-MM-d (ddd)'\''<br/></font>'\''"'
# EOF
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock dateFormatType custom;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock dateFormatType custom
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock dateLongNames false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock dateLongNames false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock datePadDay false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock datePadDay false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock datePosition below;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock datePosition below
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock dateShowDoW false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock dateShowDoW false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock dateShowYear false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock dateShowYear false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock defaultTimeZone "";
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock defaultTimeZone ""
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock formatType custom-timeonly;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock formatType custom-timeonly
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock showDate false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock showDate false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock showTimezone false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock showTimezone false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock showTooltip false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock showTooltip false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock showWeekNumber true;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock showWeekNumber true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock timeAMPM false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock timeAMPM false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock timePadHour false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock timePadHour false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock timeShowSeconds false;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock timeShowSeconds false
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock "timeZones\size" 0;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock "timeZones\size" 0
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock timezoneFormatType iana;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock timezoneFormatType iana
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock timezonePosition below;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock timezonePosition below
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock type worldclock;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock type worldclock
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/lxqt/panel.conf worldclock useAdvancedManualFormat true;
    crudini --set "${HOME_DIR}/.config/lxqt/panel.conf" worldclock useAdvancedManualFormat true
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    # set_workspace;
    set_panel_size;
    set_panel_grouping;
    set_panel_clock;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================