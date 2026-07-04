#!/bin/bash

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_default_app ${CUR_USER};
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_thunar;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_terminal;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_noti;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && set_screensaver_lock;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_system_for_xfce4.sh && fix_sound_disabled;
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
function get_core_bin_dir_from_xfce4()
{
    # /core/linux/bin/wmde/de/xfce4
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}

core_bin_dir=$(get_core_bin_dir_from_xfce4);

# set_prop_value ${ch} ${prop} ${typ} ${val};
source ${core_bin_dir}/wmde/de/xfce4/set_funcs_for_xfce4.sh
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_default_app()
{
    # --------------------------------------------------------------------------
    local cur_user=${1};
    local home_dir=$(eval echo ~${cur_user});

    # rocky8 needs password
    local dst_path='${home_dir}/.config/xfce4/helpers.rc'
    local cur_cmd="echo \"TerminalEmulator=xfce4-terminal\" > ${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${cur_user} -c "[[ -e "${dst_path}" ]] || eval ${cur_cmd}";
    # --------------------------------------------------------------------------
}


function set_thunar()
{
    # View new folder using:ListView -------------------------------------------
    # View > ListView
    # xfconf-query -c "thunar" -p "/last-view" -t "string" -s "ThunarDetailsView"
    set_prop_value "thunar" "/last-view" "string" "ThunarDetailsView";

    # View new folder using:ListView
    # xfconf-query -c "thunar" -p "/default-view" -t "string" -s "ThunarDetailsView"
    set_prop_value "thunar" "/default-view" "string" "ThunarDetailsView";
    # --------------------------------------------------------------------------

    # Remember view settings for each folder:on --------------------------------
    # xfconf-query -c "thunar" -p "/misc-directory-specific-settings" -t "bool" -s "true"
    set_prop_value "thunar" "/misc-directory-specific-settings" "bool" "true";
    # --------------------------------------------------------------------------

    # View > LocationSelector > ButtonsStyle -----------------------------------
    # xfconf-query -c "thunar" -p "/last-location-bar" -t "string" -s "ThunarLocationButtons"
    set_prop_value "thunar" "/last-location-bar" "string" "ThunarLocationButtons";
    # --------------------------------------------------------------------------

    # single_click:off (double_click:on) ---------------------------------------
    # xfconf-query -c "thunar" -p "/misc-single-click" -t "bool" -s "false"
    set_prop_value "thunar" "/misc-single-click" "bool" "false";
    # --------------------------------------------------------------------------
}


function set_terminal()
{
    # cursor shape : I-Beam ----------------------------------------------------
    # xfconf-query -c "xfce4-terminal" -p "/misc-cursor-shape" -t "string" -s "TERMINAL_CURSOR_SHAPE_IBEAM"
    set_prop_value "xfce4-terminal" "/misc-cursor-shape" "string" "TERMINAL_CURSOR_SHAPE_IBEAM";
    # --------------------------------------------------------------------------

    # cursor blinks : on -------------------------------------------------------
    # xfconf-query -c "xfce4-terminal" -p "/misc-cursor-blinks" -t "bool" -s "true"
    set_prop_value "xfce4-terminal" "/misc-cursor-blinks" "bool" "true";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Font : Liberation Mono 13
    # xfconf-query -c "xfce4-terminal" -p "/font-name" -t "string" -s "Liberation Mono 13"
    set_prop_value "xfce4-terminal" "/font-name" "string" "Liberation Mono 13";
    # --------------------------------------------------------------------------

    # background : none (use solid color) --------------------------------------
    # xfconf-query -c "xfce4-terminal" -p "/background-mode" -t "string" -s "TERMINAL_BACKGROUND_SOLID"
    set_prop_value "xfce4-terminal" "/background-mode" "string" "TERMINAL_BACKGROUND_SOLID";
    # --------------------------------------------------------------------------
}


function set_noti()
{
    # --------------------------------------------------------------------------
    # xfconf-query -c xfce4-notifyd -p /do-fadeout -t "bool" -s "true"
    set_prop_value "xfce4-notifyd" "/do-fadeout" "bool" "true";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xfconf-query -c xfce4-notifyd -p /notify-location -t "string" -s "bottom-right"
    set_prop_value "xfce4-notifyd" "/notify-location" "string" "bottom-right";
    # --------------------------------------------------------------------------
}


function set_screensaver_lock()
{
    # --------------------------------------------------------------------------
    # xfconf-query -c xfce4-screensaver -p /lock/enabled -t "bool" -s "true"
    set_prop_value "xfce4-screensaver" "/lock/enabled" "bool" "true";
    # --------------------------------------------------------------------------
}


function fix_sound_disabled()
{
    # --------------------------------------------------------------------------
    # root permission
    local AUDIO_PATH="/etc/modprobe.d/audio.conf";
    local AUDIO_CMD="options snd_hda_intel power_save=0";

    if [[ ! -f "${AUDIO_PATH}" ]]; then
        echo "${AUDIO_CMD}" > ${AUDIO_PATH}
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # user permission
    systemctl --user enable pipewire;
    systemctl --user enable pipewire-pulse;
    systemctl --user enable wireplumber;
    systemctl --user restart pipewire;
    systemctl --user restart pipewire-pulse;
    systemctl --user restart wireplumber;

    # su - ${CUR_USER} -c "systemctl --user enable pipewire";
    # sudo -u ${CUR_USER} bash -c "systemctl --user enable pipewire";
    # sudo -u ${CUR_USER} bash -c "systemctl --user enable pipewire-pulse";
    # sudo -u ${CUR_USER} bash -c "systemctl --user enable wireplumber";
    # sudo -u ${CUR_USER} bash -c "systemctl --user restart pipewire";
    # sudo -u ${CUR_USER} bash -c "systemctl --user restart pipewire-pulse";
    # sudo -u ${CUR_USER} bash -c "systemctl --user restart wireplumber";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================

# ==============================================================================
