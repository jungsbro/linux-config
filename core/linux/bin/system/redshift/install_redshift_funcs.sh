#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/system/redshift/install_redshift_funcs.sh && \
#     config_redshift ${CUR_USER} && \
#     set_redshift_autostart ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function set_redshift_autostart()
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
    local autostart_path="${autostart_dir}/redshift-gtk.desktop"

    local start_cmd="[Desktop Entry]
Version=1.0
Name=Redshift
GenericName=Color temperature adjustment
Comment=Color temperature adjustment tool
Exec=redshift-gtk
Icon=redshift
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
Hidden=false
X-GNOME-Autostart-enabled=true"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${cur_user} -c "[[ -d ${autostart_dir} ]] || mkdir -p ${autostart_dir}";
    su - ${cur_user} -c "[[ -f ${autostart_path} ]] || echo \"${start_cmd}\" > ${autostart_path}";
    # --------------------------------------------------------------------------
}

function config_redshift()
{
    # --------------------------------------------------------------------------
    # jungs
    local cur_user=${1}

    if [[ -z ${cur_user} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local conf_cmd="[redshift]
temp-day=5500
temp-night=3800

location-provider=manual
adjustment-method=randr

[manual]
lat=37.6
lon=127.0"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/redshift.conf
    su - ${cur_user} -c "[[ -f ~/.config/redshift.conf ]] || echo \"${conf_cmd}\" > ~/.config/redshift.conf";
    # --------------------------------------------------------------------------
}
# ==============================================================================