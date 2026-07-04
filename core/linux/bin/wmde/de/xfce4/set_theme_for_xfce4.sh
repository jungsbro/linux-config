#!/bin/bash

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_theme_for_xfce4.sh && set_theme;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/xfce4/set_theme_for_xfce4.sh && set_desktop;
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
function set_theme()
{
    if [[ -e "/usr/share/icons/Papirus" ]]; then
        # xfconf-query -c "xsettings" -p "/Net/IconThemeName" -t "string" -s "Papirus"
        set_prop_value "xsettings" "/Net/IconThemeName" "string" "Papirus";

    elif [[ -e "/usr/share/icons/Adwaita" ]]; then
        # xfconf-query -c "xsettings" -p "/Net/IconThemeName" -t "string" -s "Adwaita"
        set_prop_value "xsettings" "/Net/IconThemeName" "string" "Adwaita";

    else
        # xfconf-query -c "xsettings" -p "/Net/IconThemeName" -t "string" -s "Tango"
        set_prop_value "xsettings" "/Net/IconThemeName" "string" "Tango";
    fi
}


function set_desktop()
{
    # apply to all workspaces:off ----------------------------------------------
    # xfconf-query -c xfce4-desktop -p /backdrop/single-workspace-mode -t "bool" -s "false"
    set_prop_value "xfce4-desktop" "/backdrop/single-workspace-mode" "bool" "false";
    # --------------------------------------------------------------------------

    # desktop icon size:32 -----------------------------------------------------
    # xfconf-query -c "xfce4-desktop" -p "/desktop-icons/icon-size" -t "uint" -s "32"
    set_prop_value "xfce4-desktop" "/desktop-icons/icon-size" "uint" "32";
    # --------------------------------------------------------------------------

    # show home in desktop:on --------------------------------------------------
    # xfconf-query -c "xfce4-desktop" -p "/desktop-icons/file-icons/show-home" -t "bool" -s "true"
    set_prop_value "xfce4-desktop" "/desktop-icons/file-icons/show-home" "bool" "true";
    # --------------------------------------------------------------------------

    # show filesystem in desktop:on --------------------------------------------
    # xfconf-query -c "xfce4-desktop" -p "/desktop-icons/file-icons/show-filesystem" -t "bool" -s "true"
    set_prop_value "xfce4-desktop" "/desktop-icons/file-icons/show-filesystem" "bool" "true";
    # --------------------------------------------------------------------------

    # show trash in desktop:on -------------------------------------------------
    # xfconf-query -c "xfce4-desktop" -p "/desktop-icons/file-icons/show-trash" -t "bool" -s "true"
    set_prop_value "xfce4-desktop" "/desktop-icons/file-icons/show-trash" "bool" "true";
    # --------------------------------------------------------------------------

    # show removable in desktop:on ---------------------------------------------
    # xfconf-query -c "xfce4-desktop" -p "/desktop-icons/file-icons/show-removable" -t "bool" -s "true"
    set_prop_value "xfce4-desktop" "/desktop-icons/file-icons/show-removable" "bool" "true";
    # --------------------------------------------------------------------------

    # single_click:off (double_click:on) ---------------------------------------
    # xfconf-query -c "xfce4-desktop" -p "/desktop-icons/single-click" -t "bool" -s "false"
    set_prop_value "xfce4-desktop" "/desktop-icons/single-click" "bool" "false";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================

# ==============================================================================
