#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh ${CUR_USER};
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
# ==============================================================================


# Funcs ========================================================================
function set_autostart()
{
    # --------------------------------------------------------------------------
    local filename="${1}"
    local src_desktop_path="/etc/xdg/autostart/${filename}"

    local dst_autostart_dir="${HOME_DIR}/.config/autostart";
    local dst_autostart_path="${dst_autostart_dir}/${filename}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f ${src_desktop_path} ]]; then
        return
    fi
    if [[ -f ${dst_autostart_path} ]]; then
        return
    fi
    if [[ ! -d ${dst_autostart_dir} ]]; then
        mkdir -p ${dst_autostart_dir}
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    cp -f ${src_desktop_path} ${dst_autostart_dir}/
    # --------------------------------------------------------------------------

    echo "${dst_autostart_path}"
}


# Funcs ========================================================================
function set_global_keyboard_shortcuts_disable()
{
    # --------------------------------------------------------------------------
    local filename="lxqt-globalkeyshortcuts.desktop"

    local dst_autostart_path=$(set_autostart ${filename})

    # echo ${filename}
    # echo ${dst_autostart_path}

    if [[ ! -f ${dst_autostart_path} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/autostart/lxqt-globalkeyshortcuts.desktop "Desktop Entry" X-LXQt-Module true;
    crudini --set "${dst_autostart_path}" "Desktop Entry" X-LXQt-Module true

    # crudini --set ~/.config/autostart/lxqt-globalkeyshortcuts.desktop "Desktop Entry" X-LXQt-X11-Only true;
    crudini --set "${dst_autostart_path}" "Desktop Entry" X-LXQt-X11-Only true

    # crudini --set ~/.config/autostart/lxqt-globalkeyshortcuts.desktop "Desktop Entry" Hidden true;
    crudini --set "${dst_autostart_path}" "Desktop Entry" Hidden true
    # --------------------------------------------------------------------------
}


function set_powermanagement_disable()
{

    # --------------------------------------------------------------------------
    local filename="lxqt-powermanagement.desktop"

    local dst_autostart_path=$(set_autostart ${filename})

    # echo ${filename}
    # echo ${dst_autostart_path}

    if [[ ! -f ${dst_autostart_path} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # crudini --set ~/.config/autostart/lxqt-powermanagement.desktop "Desktop Entry" X-LXQt-Module true;
    crudini --set "${dst_autostart_path}" "Desktop Entry" X-LXQt-Module true

    # crudini --set ~/.config/autostart/lxqt-powermanagement.desktop "Desktop Entry" Hidden true;
    crudini --set "${dst_autostart_path}" "Desktop Entry" Hidden true
    # --------------------------------------------------------------------------
}


function fix_tmux_for_qterminal()
{
    # --------------------------------------------------------------------------
    local tmux_path="/usr/bin/tmux"
    local tmux_conf_path="${HOME_DIR}/.tmux.conf";

    local tmux_conf_kwd='-H 7f';
    local tmux_conf_cmd='bind-key -n C-h send-keys -H 7f';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f ${tmux_conf_path} ]]; then
        return
    fi
    if [[ -n $(cat ${tmux_conf_path} | grep -i ${tmux_conf_kwd}) ]]; then
        return;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    echo "" >> ${tmux_conf_path};
    echo ${tmux_conf_cmd} >> ${tmux_conf_path};

    # if [[ -f ${tmux_path} ]]; then
    #     tmux kill-server;
    # fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    # autostart
    set_global_keyboard_shortcuts_disable;
    set_powermanagement_disable;
    fix_tmux_for_qterminal;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================