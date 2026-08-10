#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/hotkey/autokey/install_autokey_funcs.sh && \
# config_autokey ${CUR_USER} && \
# set_autokey_autostart ${CUR_USER}
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function set_autokey_autostart()
{
    # --------------------------------------------------------------------------
    # jungs
    local cur_user=${1}

    if [[ -z ${cur_user} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /home/jungs
    local home_dir=$(eval echo ~${cur_user});
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local autostart_dir="${home_dir}/.config/autostart"
    local autostart_path="${autostart_dir}/autokey.desktop"

    local autostart_cmd="[Desktop Entry]
Name=AutoKey
GenericName=Keyboard Automation
Comment=Program keyboard shortcuts
Keywords=macros keyboard auto key autokey ak automation shortcut bind
Exec=autokey-gtk
Terminal=false
Type=Application
Icon=autokey
Categories=GNOME;GTK;Utility;"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${cur_user} -c "[[ -d ${autostart_dir} ]] || mkdir -p ${autostart_dir}";
    su - ${cur_user} -c "[[ -f ${autostart_path} ]] || echo \"${autostart_cmd}\" > ${autostart_path}";
    # --------------------------------------------------------------------------
}


function config_autokey()
{
    # --------------------------------------------------------------------------
    # jungs
    local cur_user=${1}

    if [[ -z ${cur_user} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local tmp_dir="/tmp";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/autohotkey-config
    local config_dir="${tmp_dir}/autohotkey-config";

    if [[ -d ${config_dir} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${cur_user} -c "git clone https://github.com/jungsbro/autohotkey-config.git ${config_dir}";
    su - ${cur_user} -c "cp -Rf ${config_dir}/.config/autokey ~/.config/";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================

# ==============================================================================
