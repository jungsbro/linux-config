#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/hotkey/sxhkd/create_sxhkdrc.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/hotkey/sxhkd
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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

# ------------------------------------------------------------------------------
DST_SXHKDRC_DIR="${HOME_DIR}/.config/sxhkd";
DST_SXHKDRC_PATH="${DST_SXHKDRC_DIR}/sxhkdrc";

# super, alt, ctrl, shift, Escape, Tab, F2, Delete, Print
SXHKDRC_CMD=""
NEWLINE_CMD1="\n\t";
NEWLINE_CMD2="\n\n";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_hotkey_for_restartwm()
{
    # 3) cmd for WM ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="super + shift + r"
        SXHKDRC_CMD+="${NEWLINE_CMD1}"

        SXHKDRC_CMD+="openbox --reconfigure"
        SXHKDRC_CMD+="${NEWLINE_CMD2}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="super + shift + r"
        SXHKDRC_CMD+="${NEWLINE_CMD1}"

        SXHKDRC_CMD+="icewm --restart"
        SXHKDRC_CMD+="${NEWLINE_CMD2}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="super + shift + r"
        SXHKDRC_CMD+="${NEWLINE_CMD1}"

        SXHKDRC_CMD+="fluxbox-remote restart"
        SXHKDRC_CMD+="${NEWLINE_CMD2}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function set_hotkey_for_restartsxhkd()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + ctrl + r"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd -------------------------------------------------------------------
    SXHKDRC_CMD+="pkill -usr1 -x sxhkd"

    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hoteky_for_expose()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + Tab"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # local expose_cmd="rofi -show window -show-icons";
    # local expose_cmd="rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'";
    # local expose_cmd="skippy-xd --expose --desktop -1"
    local expose_cmd="skippy-xd --desktop -1"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # expose cmd를 찾지 못했다.
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # expose
        SXHKDRC_CMD+="cinnamon-dbus-command ShowOverview"

        # overview (expose + workspace switch)
        # SXHKDRC_CMD+="cinnamon-dbus-command ShowExpo"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # expose
        # 방법1)
        # SXHKDRC_CMD+="qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut 'Expose'"
        # 방법2)
        # SXHKDRC_CMD+="gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut 'Expose'"

        # overview (expose + workspace switch)
        # 방법1)
        SXHKDRC_CMD+="qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut 'Overview'"
        # 방법2)
        # SXHKDRC_CMD+="gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut 'Overview'"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_startmenu()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="ctrl + Escape"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxpanelctl menu"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # fancy-menu cmd를 찾지 못했다.
        # 방법1)
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # 방법2)
        # SXHKDRC_CMD+="xdotool key alt+F1"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-popup-whiskermenu"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # start-menu cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # start-menu cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.activateLauncherMenu"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_spotlight()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="alt + F2"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxqt-runner"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-appfinder"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # old
        # SXHKDRC_CMD+="gdbus call --session --dest org.kde.krunner --object-path /App --method org.kde.krunner.App.display"

        # new
        SXHKDRC_CMD+="krunner"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_rundialog()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + r"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxpanelctl run"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxqt-runner"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-appfinder"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # old
        # SXHKDRC_CMD+="gdbus call --session --dest org.kde.krunner --object-path /App --method org.kde.krunner.App.display"

        # new
        SXHKDRC_CMD+="krunner"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_searchdialog()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + s"
    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxqt-runner"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-appfinder"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # old
        # SXHKDRC_CMD+="gdbus call --session --dest org.kde.krunner --object-path /App --method org.kde.krunner.App.display"

        # new
        SXHKDRC_CMD+="krunner"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}



function set_hotkey_for_logout()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="ctrl + alt + Delete"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # [ "$(echo -e "No\nYes" | rofi -dmenu -p "logout?" -i)" = "Yes" ] &&
    local logout_cmd='[ "$(echo -e "No\\nYes" | rofi -dmenu -p "logout?" -i)" = "Yes" ] && '

    # loginctl terminate-session $(loginctl list-sessions | grep $USER | awk '\{print $1\}')
    # 방법1)
    local logout_cmd+='loginctl terminate-session $(loginctl list-sessions | grep $USER | awk '\''\{print $1\}'\'')'
    # 방법2)
    # local logout_cmd+=$'loginctl terminate-session $(loginctl list-sessions | grep $USER | awk \'\{print $1\}\')'
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        # 방법1)
        SXHKDRC_CMD+="lxde-logout"
        # 방법2)
        # SXHKDRC_CMD+="lxsession-logout"

        # 확인없이 바로 logout
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # multi 창
        # SXHKDRC_CMD+="lxqt-leave"

        # logout 확인창
        # SXHKDRC_CMD+="lxqt-leave --logout"

        # 확인없이 바로 logout
        SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="xfce4-session-logout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="xfce4-session-logout --logout"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="mate-session-save --logout-dialog"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="mate-session-save --logout"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="gnome-session-quit --logout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="gnome-session-quit --logout --no-prompt"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="cinnamon-session-quit --logout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="cinnamon-session-quit --logout --no-prompt"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="qdbus6 org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_lockscreen()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + l"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법1) lock 확인창
    # local lock_cmd='[ "$(echo -e "No\nYes" | rofi -dmenu -p "lock?" -i)" = "Yes" ] && '
    # local lock_cmd+='loginctl lock-session'

    # 방법2) 확인없이 lock
    local lock_cmd="loginctl lock-session"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="lxlock"
        # 방법2)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법3)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="lxqt-leave --lockscreen"
        # 방법2)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법3)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # lock 확인창
        # 방법1)
        # SXHKDRC_CMD+="xfce4-session-logout"
        # 방법2)
        # SXHKDRC_CMD+="xfce4-session-logout --lock"

        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="xflock4"
        # 방법2)
        # SXHKDRC_CMD+="xfce4-screensaver-command --activate"
        # 방법3)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법4)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="mate-screensaver-command --lock"
        # 방법2)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법3)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="xdg-screensaver lock"
        # 방법2)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # lock 확인창
        # 방법1)
        # SXHKDRC_CMD+="cinnamon-screensaver-lock-dialog"

        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="cinnamon-screensaver-command --lock"
        # 방법2)
        # SXHKDRC_CMD+="${lock_cmd}"

        # 화면잠금 + 화면끄지 동시 실행
        # SXHKDRC_CMD+="cinnamon-screensaver-command --lock && xset dpms force off"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock

        # 시스템 어딘가 숨어있는 kscreenlocker_greet의 진짜 좌표 탐색
        # find /usr -name "kscreenlocker_greet" 2>/dev/null
        if [[ "${CUR_RELEASE}" == *"archlinux"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]] || [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
            # 방법1)
            # SXHKDRC_CMD+="/usr/libexec/kscreenlocker_greet"

            # 방법2)
            SXHKDRC_CMD+="/usr/libexec/kscreenlocker_greet --testing"

        elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
            # 방법1)
            # SXHKDRC_CMD+="/usr/lib/x86_64-linux-gnu/libexec/kscreenlocker_greet"

            # 방법2)
            SXHKDRC_CMD+="/usr/lib/x86_64-linux-gnu/libexec/kscreenlocker_greet --testing"
        fi

        # 방법3)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법2)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법2)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="xscreensaver-command -lock"
        # 방법2)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_screenshot()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="Print"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # sudo apt install -y scrot
        # -s: select, -q: quality, 100: 100%
        SXHKDRC_CMD+="scrot -s -q 100 ~/Pictures/Screenshot_$(date +%Y%m%d_%H%M%S).png"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) gui창이 뜬다.
        SXHKDRC_CMD+="screengrab"

        # 방법2)
        # SXHKDRC_CMD+="lximage-qt --screenshot"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # gui창이 뜬다.
        SXHKDRC_CMD+="xfce4-screenshooter"

        # -f --fullscreen
        # SXHKDRC_CMD+="xfce4-screenshooter -f"

        # -w --window
        # SXHKDRC_CMD+="xfce4-screenshooter -w"

        # -r --region
        # SXHKDRC_CMD+="xfce4-screenshooter -r"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        # gui창이 뜬다.
        # -i --interactive
        SXHKDRC_CMD+="mate-screenshot --interactive"

        # fullscreen
        # SXHKDRC_CMD+="mate-screenshot"

        # -w --window
        # SXHKDRC_CMD+="mate-screenshot -w"

        # -a --area
        # SXHKDRC_CMD+="mate-screenshot -a"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # gnome이 gnome-screenshot을 폐기했다.
        SXHKDRC_CMD+="gnome-screenshot -i"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # -i --interactive
        SXHKDRC_CMD+="gnome-screenshot -i"

        # fullscreen
        # SXHKDRC_CMD+="gnome-screenshot"

        # -w --window
        # SXHKDRC_CMD+="gnome-screenshot -w"

        # 마우스 영역 지정 후 저장 창 띄우기
        # -a --area
        # SXHKDRC_CMD+="gnome-screenshot -a"

        # 마우스 영역 지정 후 클립보드로 다이렉트 복사
        # -a --area / -c --clipboard
        # SXHKDRC_CMD+="gnome-screenshot -a -c"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # gui창이 뜬다.
        SXHKDRC_CMD+="spectacle"

        # -f --fullscreen
        # SXHKDRC_CMD+="spectacle -f"

        # -w --onclick
        # SXHKDRC_CMD+="spectacle -w"

        # -a --activewindow
        # SXHKDRC_CMD+="spectacle -a"

        # -r --region
        # SXHKDRC_CMD+="spectacle -r"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # sudo apt install -y flameshot
        SXHKDRC_CMD+="flameshot"

        # full
        # SXHKDRC_CMD+="flameshot full"

        # gui
        # SXHKDRC_CMD+="flameshot gui"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="flameshot"

        # full
        # SXHKDRC_CMD+="flameshot full"

        # gui
        # SXHKDRC_CMD+="flameshot gui"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="flameshot"

        # full
        # SXHKDRC_CMD+="flameshot full"

        # gui
        # SXHKDRC_CMD+="flameshot gui"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_display()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + p"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="lxrandr"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="lxqt-config-monitor"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        # SXHKDRC_CMD+="xfce4-display-settings"

        # single / mirror / extend 설정창
        # -m --minimal
        SXHKDRC_CMD+="xfce4-display-settings -m"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # display resolution 설정 창
        SXHKDRC_CMD+="mate-display-properties"

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="gnome-control-center display"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="cinnamon-settings display"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="systemsettings kcm_kscreen"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # sudo apt install -y arandr
        SXHKDRC_CMD+="arandr"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="arandr"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="arandr"

        # 1) PC 화면만 보기 : eDP-1
        # SXHKDRC_CMD+="xrandr --output eDP-1 --auto --output HDMI-1 --off"

        # 2) 화면 복제 (Mirror) : eDP-1/HDMI-1
        # SXHKDRC_CMD+="xrandr --output eDP-1 --auto --output HDMI-1 --auto --same-as eDP-1"

        # 3) 화면 확장 (Extend) : eDP-1/HDMI-1
        # SXHKDRC_CMD+="xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_taskmanager()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="ctrl + shift + Escape"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxtask"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="qps"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-taskmanager"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="mate-system-monitor"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="gnome-system-monitor"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="gnome-system-monitor"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="plasma-systemmonitor"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal -e htop"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal -e htop"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal -e htop"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_finder()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + e"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="pcmanfm"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="pcmanfm-qt"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="thunar"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="caja"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="nautilus"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="nemo"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="dolphin"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        SXHKDRC_CMD+="pcmanfm"

        # 방법2)
        # SXHKDRC_CMD+="xfce4-terminal -e ranger"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        SXHKDRC_CMD+="pcmanfm"

        # 방법2)
        # SXHKDRC_CMD+="xfce4-terminal -e ranger"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        SXHKDRC_CMD+="pcmanfm"

        # 방법2)
        # SXHKDRC_CMD+="xfce4-terminal -e ranger"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_controlcenter()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + i"
    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # control center
        SXHKDRC_CMD+="python3 ~/.local/bin/wmcc.py"

        # startmenu
        # SXHKDRC_CMD+="lxpanelctl menu"

        # rundialog
        # SXHKDRC_CMD+="lxpanelctl run"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxqt-config"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-settings-manager"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="mate-control-center"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="gnome-control-center"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="cinnamon-settings"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="systemsettings"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # antix control center
        # SXHKDRC_CMD+="/usr/local/bin/antixcc.sh"

        # antix icewm-manager
        SXHKDRC_CMD+="/usr/local/bin/icewm-manager-gui"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # mxlinux fluxbox control center
        SXHKDRC_CMD+="custom-toolbox /etc/custom-toolbox/mxfb-settings.list"
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+=""
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_terminal()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="ctrl + alt + t"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ "${CUR_SESSION}" == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="lxterminal"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="qterminal"
        # SXHKDRC_CMD+="xfce4-terminal"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="mate-terminal"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" != *"cinnamon"* ]] && [[ "${CUR_SESSION}" == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # gnome이 gnome-terminal cmd를 막았다.
        # Error creating terminal: Object does not exist at path “/org/gnome/Terminal/Factory0”
        SXHKDRC_CMD+="gnome-terminal"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="gnome-terminal"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_SESSION}" == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="konsole"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="xfce4-terminal"

        # with gpu (img:x)
        # SXHKDRC_CMD+="alacritty"

        # with gpu (img:o)
        # SXHKDRC_CMD+="kitty"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 4) endline ---------------------------------------------------------------
    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function set_hotkey_xkill()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + x"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd -------------------------------------------------------------------
    SXHKDRC_CMD+="xkill"

    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function create_sxhkdrc()
{
    # --------------------------------------------------------------------------
    if [[ -f "${DST_SXHKDRC_PATH}" ]]; then
        return 0
    fi
    if [[ ! -d "${DST_SXHKDRC_DIR}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${DST_SXHKDRC_DIR}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_hotkey_for_restartwm;
    set_hotkey_for_restartsxhkd;
    set_hoteky_for_expose;
    set_hotkey_for_startmenu;
    set_hotkey_for_spotlight;
    set_hotkey_for_rundialog;
    set_hotkey_for_searchdialog;
    set_hotkey_for_logout;
    set_hotkey_for_lockscreen;
    set_hotkey_for_screenshot;
    set_hotkey_for_display;
    set_hotkey_for_taskmanager;
    set_hotkey_for_finder;
    set_hotkey_for_controlcenter;
    set_hotkey_for_terminal;
    set_hotkey_xkill;
    # --------------------------------------------------------------------------

    # write sxhkdrc ------------------------------------------------------------
    # -e : enable interpretation of backslash escapes
    echo -e "${SXHKDRC_CMD}";

    # 방법1)
    # su - "${CUR_USER}" -c "echo -e ${SXHKDRC_CMD} > ${DST_SXHKDRC_PATH};"

    # 방법2)
    # sudo -u "${CUR_USER}" tee "${DST_SXHKDRC_PATH}" <(printf '%b' "${SXHKDRC_CMD}") >/dev/null

    # 방법3)
    printf '%b\n' "${SXHKDRC_CMD}" | sudo -u "${CUR_USER}" tee "${DST_SXHKDRC_PATH}" >/dev/null
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    create_sxhkdrc;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================