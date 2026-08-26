#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/xfce4/config_xfce4.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/xfce4
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_prop_value()
{
    # env ----------------------------------------------------------------------
    local ch="${1}"
    local prop="${2}"
    local typ="${3}"
    local val="${4}"

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up"
    # -c : --chanel
    # -p : --property
    local cmd="xfconf-query -c ${ch} -p ${prop}"
    # --------------------------------------------------------------------------

    # reset property (remove property) -----------------------------------------
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -r
    # -r : --reset
    `${cmd} -r`
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z "${val}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # set property value (create and set) --------------------------------------
    # -n : --create
    # -t : type
    # -s : --set
    `${cmd} -n -t "${typ}" -s "${val}"`
    echo "${cmd} -n -t \"${typ}\" -s \"${val}\""
    # --------------------------------------------------------------------------
}
# ==============================================================================


function set_shortcuts()
{
    # whiskermenu --------------------------------------------------------------
    if [[ "${CUR_VER}" != *"ID=MX"* ]]; then  # not mxlinux
        # ctrl+esc
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>Escape" "string" "";
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>Escape"" -t "string" -s "xfce4-popup-whiskermenu"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>Escape" "string" "xfce4-popup-whiskermenu";
    fi
    # --------------------------------------------------------------------------

    # window tile (not used) ---------------------------------------------------
    # local tog_fs_path="${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"

    # win+keypad_up >> win+up
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";
    # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "";

    # if [[ -f "${tog_fs_path}" ]]; then
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "${CORE_BIN_DIR}/tiling/toggle_fullscreen.sh"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Up" "string" "${tog_fs_path}";
    # else
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "fill_window_key"
        # set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "fill_window_key";
    # fi
    # --------------------------------------------------------------------------

    # window tile (up) ---------------------------------------------------------
    # win+keypad_up >> win+up
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Up" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Up" -t "string" -s "fill_window_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Up" "string" "fill_window_key";

    # shift+win+up
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Up" -t "string" -s "tile_up_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Up" "string" "tile_up_key";
    # --------------------------------------------------------------------------

    # window tile (down, left, right) ------------------------------------------
    # win+keypad_down >> win+down
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Down" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Down" -t "stringv -s "tile_down_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Down" "string" "tile_down_key";

    # win+keypad_left >> win+left
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Left" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Left" -t "string" -s "tile_left_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Left" "string" "tile_left_key";

    # win+keypad_right >> win+right
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>KP_Right" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>Right" -t "string" -s "tile_right_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Right" "string" "tile_right_key";
    # --------------------------------------------------------------------------

    # window to left/right screen ----------------------------------------------
    if [[ "${CUR_VER}" != *"ID=MX"* ]]; then  # not mxlinux
        # ----------------------------------------------------------------------
        # shift+win+left
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "";
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Left" -t "string" -s "move_window_to_monitor_left_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Left" "string" "move_window_to_monitor_left_key";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Left" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Left" "string" "bash ${CORE_BIN_DIR}/tiling/move_l_screen.sh";
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # shift+win+right
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "";
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Right" "string" "";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>Right" -t "string" -s "move_window_to_monitor_right_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>Right" "string" "move_window_to_monitor_right_key";

        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Shift><Super>Right" -t "string" -s "bash ${CORE_BIN_DIR}/tiling/move_r_screen.sh"
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Shift><Super>Right" "string" "bash ${CORE_BIN_DIR}/tiling/move_r_screen.sh";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # maximize window ----------------------------------------------------------
    # alt+f10 (for mxlinux)
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Alt>F10 -t string" -s "maximize_window_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Alt>F10" "string" "maximize_window_key";
    # --------------------------------------------------------------------------

    # show desktop -------------------------------------------------------------
    # ctrl+alt+d >> win+d
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>d" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>d" -t "string" -s "show_desktop_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>d" "string" "show_desktop_key";
    # --------------------------------------------------------------------------

    # expose -------------------------------------------------------------------
    # win+tab
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>Tab" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "rofi -show window -show-icons"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "rofi -show window -show-icons";

    # if [[ -f "skippy-xd" ]]; then
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "skippy-xd"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "skippy-xd";
    # elif [[ -f "/usr/local/bin/skippy-xd" ]]; then
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/usr/local/bin/skippy-xd"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "/usr/local/bin/skippy-xd";
    # else
    #     # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Tab" -t "string" -s "/home/jungs/.nix-profile/bin/skippy-xd"
    #     set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Tab" "string" "${HOME}/.nix-profile/bin/skippy-xd";
    # fi
    # --------------------------------------------------------------------------

    # settings -----------------------------------------------------------------
    # win+i
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>i" -t "string" -s "xfce4-settings-manager"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>i" "string" "xfce4-settings-manager";
    # --------------------------------------------------------------------------

    # spotlight ----------------------------------------------------------------
    # alt+f2 >> ctrl+space (removed)
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary>space" -t "string" -s "xfce4-appfinder"
    # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary>space" "string" "xfce4-appfinder --collapsed";

    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F2" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F2" "string" "xfce4-appfinder";

    # alt+f3
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Alt>F3" -t "string" -s "xfce4-appfinder"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F3" "string" "xfce4-appfinder";
    # --------------------------------------------------------------------------

    # appmenu ------------------------------------------------------------------
    # alt+f1 >> win+esc
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Alt>F1" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>Escape" -t "string" -s "xfce4-popup-applicationsmenu"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>Escape" "string" "xfce4-popup-applicationsmenu";
    # --------------------------------------------------------------------------

    # taskmanager --------------------------------------------------------------
    # ctrl+shift+esc (for mxlinux)
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Primary><Shift>Escape" -t "string" -s "xfce4-taskmanager"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Shift>Escape" "string" "xfce4-taskmanager";
    # --------------------------------------------------------------------------

    # xkill --------------------------------------------------------------------
    # ctrl+alt+esc >> win+x
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>Escape" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>x" -t "string" -s "/bin/xkill"
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>x" "string" "/bin/xkill";
    # --------------------------------------------------------------------------

    # screensaver --------------------------------------------------------------
    # ctrl+alt+l >> win+l
    set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Primary><Alt>l" "string" "";

    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xfce4-screensaver-command --activate"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "xfce4-screensaver-command --activate";
        # set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "xfce4-screensaver-command --lock";
    else
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/commands/custom/<Super>l" -t "string" -s "xscreensaver-command -lock"
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/<Super>l" "string" "xscreensaver-command -lock";
    fi
    # --------------------------------------------------------------------------

    # terminal dropdown --------------------------------------------------------
    # f4 >> removed
    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
        #       <property name="F4" type="string" value="xfce4-terminal --drop-down"/>
        set_prop_value "xfce4-keyboard-shortcuts" "/commands/custom/F4" "string" "";
    fi
    # --------------------------------------------------------------------------

    # workspace : jump to workspace-number (with arrow-keys)--------------------
    # ctrl+alt+up >> ctrl+win+up
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Up" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Up" -t "string" -s "up_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Up" "string" "up_workspace_key";

    # ctrl+alt+down >> ctrl+win+down
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Down" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Down" -t "string" -s "down_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Down" "string" "down_workspace_key";

    # ctrl+alt+left >> ctrl+win+left
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Left" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Left" -t "string" -s "left_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Left" "string" "left_workspace_key";

    # ctrl+alt+right >> ctrl+win+right
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>Right" "string" "";
    # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Primary><Super>Right" -t "string" -s "right_workspace_key"
    set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Super>Right" "string" "right_workspace_key";
    # --------------------------------------------------------------------------

    # workspace : jump to workspace-number -------------------------------------
    local cur_num="";
    local nums="1 2 3 4 5 6 7 8 9 10 11 12"

    for cur_num in ${nums};
    do
        # workspace : jump to worksapce-number (with f-keys) -------------------
        # ctrl+f1 >> win+f1
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary>F${cur_num}" "string" "";
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Super>F1" -t "stringv -s "workspace_1_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Super>F${cur_num}" "string" "workspace_${cur_num}_key";
        # ----------------------------------------------------------------------

        # workspace : move window to worksapce-number --------------------------
        # ctrl+alt+kp1 >> shift+win+f1
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Primary><Alt>KP_${cur_num}" "string" "";
        # xfconf-query -c "xfce4-keyboard-shortcuts" -p "/xfwm4/custom/<Shift><Super>F1" -t "string" -s "move_window_workspace_1_key"
        set_prop_value "xfce4-keyboard-shortcuts" "/xfwm4/custom/<Shift><Super>F${cur_num}" "string" "move_window_workspace_${cur_num}_key";
        # ----------------------------------------------------------------------
    done
    # --------------------------------------------------------------------------
}

function set_workspace()
{
    # Cycle through windows on all workspaces : on -----------------------------
    # xfconf-query -c "xfwm4" -p "/general/cycle_workspaces" -t "bool" -s "true"
    set_prop_value "xfwm4" "/general/cycle_workspaces" "bool" "true";
    # --------------------------------------------------------------------------

    # Use mouse wheel on title bar to roll up the window : off -----------------
    # xfconf-query -c "xfwm4" -p "/general/mousewheel_rollup" -t "bool" -s "false"
    set_prop_value "xfwm4" "/general/mousewheel_rollup" "bool" "false";
    # --------------------------------------------------------------------------

    # scroll workspace : off ---------------------------------------------------
    # xfconf-query -c "xfwm4" -p "/general/scroll_workspaces" -t "bool" -s "false"
    set_prop_value "xfwm4" "/general/scroll_workspaces" "bool" "false";
    # --------------------------------------------------------------------------

    # workspace count : 2 ------------------------------------------------------
    # xfconf-query -c "xfwm4" -p "/general/workspace_count" -t "int" -s "4"
    set_prop_value "xfwm4" "/general/workspace_count" "int" "4";
    # --------------------------------------------------------------------------
}

function set_panel_clock()
{
    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
        sel_plugin="plugin-1"
    else
        sel_plugin="plugin-12"
    fi

    # digital layout -----------------------------------------------------------
    # xfconf-query -c "xfce4-panel" -p "/plugins/plugin-1/digital-layout" -t "uint" -s "1"
    set_prop_value "xfce4-panel" "/plugins/${sel_plugin}/digital-layout" "uint" "1";
    # --------------------------------------------------------------------------

    # date : 25-12-12 ----------------------------------------------------------
    # xfconf-query -c "xfce4-panel" -p "/plugins/plugin-1/digital-date-format" -t "string" -s "%y-%m-%d (%a)"
    set_prop_value "xfce4-panel" "/plugins/${sel_plugin}/digital-date-format" "string" "%y-%m-%d (%a)";
    # --------------------------------------------------------------------------

    # time : 12:00:AM ----------------------------------------------------------
    # xfconf-query -c "xfce4-panel" -p "/plugins/plugin-1/digital-time-format" -t "string" -s "%I:%M %p"
    set_prop_value "xfce4-panel" "/plugins/${sel_plugin}/digital-time-format" "string" "%I:%M %p";
    # --------------------------------------------------------------------------
}

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

function set_default_app()
{
    # rocky8 needs password
    dst_path='${HOME_DIR}/.config/xfce4/helpers.rc'
    cur_cmd="echo \"TerminalEmulator=xfce4-terminal\" > ${dst_path}"

    su - "${CUR_USER}" -c "[[ -e "${dst_path}" ]] || eval ${cur_cmd}";
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
        echo "${AUDIO_CMD}" > "${AUDIO_PATH}"
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

    # su - "${CUR_USER}" -c "systemctl --user enable pipewire";
    # sudo -u "${CUR_USER}" bash -c "systemctl --user enable pipewire";
    # sudo -u "${CUR_USER}" bash -c "systemctl --user enable pipewire-pulse";
    # sudo -u "${CUR_USER}" bash -c "systemctl --user enable wireplumber";
    # sudo -u "${CUR_USER}" bash -c "systemctl --user restart pipewire";
    # sudo -u "${CUR_USER}" bash -c "systemctl --user restart pipewire-pulse";
    # sudo -u "${CUR_USER}" bash -c "systemctl --user restart wireplumber";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
function main()
{
    set_shortcuts;
    set_workspace;
    set_panel_clock;
    set_terminal;
    set_noti;
    set_screensaver_lock;

    if [[ "${CUR_VER}" == *"ID=MX"* ]]; then  # mxlinux
        set_desktop;
        set_thunar;
    else
        set_theme;
        # set_default_app;
    fi

    if [[ "${CUR_VER}" == *"Rocky"* ]]; then  # rocky
        # fix_sound_disabled;
        echo ""
    fi
}

main;
# ==============================================================================

