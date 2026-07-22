#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_system_for_ob.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/wm/openbox
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

OB_NS="http://openbox.org/3.4/rc";

OBRC_PATH="${HOME_DIR}/.config/openbox/rc.xml";
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
    crudini --set "${HOME_DIR}/.config/mimeapps.list" "Default Applications" "text/plain" "org.xfce.mousepad.desktop";
    crudini --set "${HOME_DIR}/.config/mimeapps.list" "Added Associations" "text/plain" "org.xfce.mousepad.desktop";
    # --------------------------------------------------------------------------
}


function set_mouse_double_click()
{
    # --------------------------------------------------------------------------
    if [[ ! -f ${OBRC_PATH} ]]; then
        return;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # mouse-double-click-time을 500 >> 750으로 수정

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
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -u "//x:mouse/x:doubleClickTime" -v "750" ~/.config/openbox/rc.xml
    xmlstarlet ed -L -N x="${OB_NS}" -u "${xml_path}" -v "${value}" "${OBRC_PATH}"
    # --------------------------------------------------------------------------
}


function set_mouse_alt_drag()
{
    # --------------------------------------------------------------------------
    if [[ ! -f ${OBRC_PATH} ]]; then
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
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -u "///x:context[@name='Frame']/x:mousebind[@button='A-Left' and @action='Drag']/@button" -v "W-Left" ~/.config/openbox/rc.xml
    xmlstarlet ed -L -N x="${OB_NS}" -u "${xml_path}" -v "${value}" "${OBRC_PATH}";
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

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================