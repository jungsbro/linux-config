#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxde/set_system_for_lxde.sh ${CUR_USER};
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

CUR_WMDE=$(ls /usr/bin/*session);
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
function set_defualt_applications()
{
    # --------------------------------------------------------------------------
    # [Default Applications]
    # text/plain=org.xfce.mousepad.desktop

    # [Added Associations]
    # text/plain=org.xfce.mousepad.desktop;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} <<"EOF"
crudini --set ~/.config/mimeapps.list "Default Applications" "text/plain" "org.xfce.mousepad.desktop";
crudini --set ~/.config/mimeapps.list "Added Associations" "text/plain" "org.xfce.mousepad.desktop";
EOF
    # --------------------------------------------------------------------------
}


function set_mouse_double_click()
{
    # --------------------------------------------------------------------------
    if [[ ! -f ${LXDERC_PATH} ]]; then
        return;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # mouse-double-click-time을 200 >> 750으로 수정

    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #    <mouse>
    #        <doubleClickTime>200</doubleClickTime>
    #    </mouse>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local xml_path="//x:mouse/x:doubleClickTime";
    local value="750";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -u "//x:mouse/x:doubleClickTime" -v "750" ~/.config/openbox/lxde-rc.xml
    xmlstarlet ed -L -N x="${LXDE_NS}" -u "${xml_path}" -v "${value}" "${LXDERC_PATH}"
    # --------------------------------------------------------------------------
}


function set_mouse_alt_drag()
{
    # --------------------------------------------------------------------------
    if [[ ! -f ${LXDERC_PATH} ]]; then
        return;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # mousebind button을 A-Left >> W-Left 로 수정

    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <mouse>
    #         <context name="Frame">
    #             <mousebind button="A-Left" action="Drag">
    #                 <action name="Move"/>
    #             </mousebind>
    #         </context>
    #     </mouse>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local xml_path="///x:context[@name='Frame']/x:mousebind[@button='A-Left' and @action='Drag']/@button";
    local value="W-Left";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -u "///x:context[@name='Frame']/x:mousebind[@button='A-Left' and @action='Drag']/@button" -v "W-Left" ~/.config/openbox/lxde-rc.xml
    xmlstarlet ed -L -N x="${LXDE_NS}" -u "${xml_path}" -v "${value}" "${LXDERC_PATH}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    set_defualt_applications;
    set_mouse_double_click;
    set_mouse_alt_drag;
    # --------------------------------------------------------------------------
fi
# ==============================================================================
