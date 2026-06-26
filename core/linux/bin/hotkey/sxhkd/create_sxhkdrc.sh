#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/hotkey/sxhkd/create_sxhkdrc.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
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


# Func =========================================================================
function set_hotkey_for_restartsxhkd()
{
    # 1) hotkey ----------------------------------------------------------------
    SXHKDRC_CMD+="super + ctrl + r"

    SXHKDRC_CMD+="${NEWLINE_CMD1}"
    # --------------------------------------------------------------------------

    # 2) cmd -------------------------------------------------------------------
    SXHKDRC_CMD+="/usr/bin/pkill -usr1 -x sxhkd"

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
    # local expose_cmd="/usr/bin/rofi -show window -show-icons";
    local expose_cmd="/usr/bin/rofi -show window -theme '~/.config/rofi/config.rasi'";
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # expose cmd를 찾지 못했다.
        SXHKDRC_CMD+="${expose_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # expose
        SXHKDRC_CMD+="/usr/bin/cinnamon-dbus-command ShowOverview"

        # overview (expose + workspace switch)
        # SXHKDRC_CMD+="/usr/bin/cinnamon-dbus-command ShowExpo"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # expose
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut 'Expose'"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut 'Expose'"

        # overview (expose + workspace switch)
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut 'Overview'"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut 'Overview'"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxpanelctl menu"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # fancy-menu cmd를 찾지 못했다.
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xdotool key alt+F1"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-popup-whiskermenu"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # start-menu cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # start-menu cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.activateLauncherMenu"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxqt-runner"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-appfinder"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # old
        # SXHKDRC_CMD+="/usr/bin/gdbus call --session --dest org.kde.krunner --object-path /App --method org.kde.krunner.App.display"

        # new
        SXHKDRC_CMD+="/usr/bin/krunner"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxpanelctl run"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxqt-runner"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-appfinder"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # old
        # SXHKDRC_CMD+="/usr/bin/gdbus call --session --dest org.kde.krunner --object-path /App --method org.kde.krunner.App.display"

        # new
        SXHKDRC_CMD+="/usr/bin/krunner"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxqt-runner"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-appfinder"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # launcher cmd를 찾지 못했다.
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # old
        # SXHKDRC_CMD+="/usr/bin/gdbus call --session --dest org.kde.krunner --object-path /App --method org.kde.krunner.App.display"

        # new
        SXHKDRC_CMD+="/usr/bin/krunner"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/rofi -show drun -theme '~/.config/rofi/config.rasi'"
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
    # 문자열 그대로 보존하기 위해서 ''를 사용했다.
    local logout_cmd='[ "$(echo -e "No\\nYes" | /usr/bin/rofi -dmenu -p "logout 할까요?" -i)" = "Yes" ] && '

    # \'을 사용하기 위해 $''를 사용했다.
    local logout_cmd+=$'/usr/bin/loginctl terminate-session $(/usr/bin/loginctl list-sessions | grep $USER | awk \'\{print $1\}\')'
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/lxde-logout"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/lxsession-logout"

        # 확인없이 바로 logout
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # multi 창
        # SXHKDRC_CMD+="/usr/bin/lxqt-leave"

        # logout 확인창
        SXHKDRC_CMD+="/usr/bin/lxqt-leave --logout"

        # 확인없이 바로 logout
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="/usr/bin/xfce4-session-logout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/xfce4-session-logout --logout"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="/usr/bin/mate-session-save --logout-dialog"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/mate-session-save --logout"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="/usr/bin/gnome-session-quit --logout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/gnome-session-quit --logout --no-prompt"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="/usr/bin/cinnamon-session-quit --logout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/cinnamon-session-quit --logout --no-prompt"
        # 방법2)
        # SXHKDRC_CMD+="${logout_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # logout 확인창
        SXHKDRC_CMD+="/usr/bin/qdbus6 org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout"

        # 확인없이 바로 logout
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout"
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
    # local lock_cmd='[ "$(echo -e "No\nYes" | /usr/bin/rofi -dmenu -p "lock 할까요?" -i)" = "Yes" ] && '
    # local lock_cmd+='/usr/bin/loginctl lock-session'

    # 방법2) 확인없이 lock
    local lock_cmd="/usr/bin/loginctl lock-session"
    # --------------------------------------------------------------------------

    # 2) cmd for DE ------------------------------------------------------------
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/lxlock"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
        # 방법3)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/lxqt-leave --lockscreen"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
        # 방법3)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # lock 확인창
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/xfce4-session-logout"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xfce4-session-logout --lock"

        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/xflock4"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xfce4-screensaver-command --activate"
        # 방법3)
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
        # 방법4)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/mate-screensaver-command --lock"
        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
        # 방법3)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/xdg-screensaver lock"
        # 방법2)
        # SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # lock 확인창
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/cinnamon-screensaver-lock-dialog"

        # 확인없이 lock
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/cinnamon-screensaver-command --lock"
        # 방법2)
        # SXHKDRC_CMD+="${lock_cmd}"

        # 화면잠금 + 화면끄지 동시 실행
        # SXHKDRC_CMD+="/usr/bin/cinnamon-screensaver-command --lock && /usr/bin/xset dpms force off"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock

        # 시스템 어딘가 숨어있는 kscreenlocker_greet의 진짜 좌표 탐색
        # find /usr -name "kscreenlocker_greet" 2>/dev/null
        if [[ *"${CUR_VER}"* == *"archlinux"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
            # 방법1)
            # SXHKDRC_CMD+="/usr/libexec/kscreenlocker_greet"

            # 방법2)
            SXHKDRC_CMD+="/usr/libexec/kscreenlocker_greet --testing"

        elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
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
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
        # 방법2)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
        # 방법2)
        SXHKDRC_CMD+="${lock_cmd}"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        # 확인없이 lock
        # 방법1)
        # SXHKDRC_CMD+="/usr/bin/xscreensaver-command -lock"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # sudo apt install -y scrot
        # -s: select, -q: quality, 100: 100%
        SXHKDRC_CMD+="/usr/bin/scrot -s -q 100 ~/Pictures/Screenshot_$(date +%Y%m%d_%H%M%S).png"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) gui창이 뜬다.
        SXHKDRC_CMD+="/usr/bin/screengrab"

        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/lximage-qt --screenshot"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # gui창이 뜬다.
        SXHKDRC_CMD+="/usr/bin/xfce4-screenshooter"

        # -f --fullscreen
        # SXHKDRC_CMD+="/usr/bin/xfce4-screenshooter -f"

        # -w --window
        # SXHKDRC_CMD+="/usr/bin/xfce4-screenshooter -w"

        # -r --region
        # SXHKDRC_CMD+="/usr/bin/xfce4-screenshooter -r"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        # gui창이 뜬다.
        # -i --interactive
        SXHKDRC_CMD+="/usr/bin/mate-screenshot --interactive"

        # fullscreen
        # SXHKDRC_CMD+="/usr/bin/mate-screenshot"

        # -w --window
        # SXHKDRC_CMD+="/usr/bin/mate-screenshot -w"

        # -a --area
        # SXHKDRC_CMD+="/usr/bin/mate-screenshot -a"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # gnome-screenshot을 폐기했다.
        SXHKDRC_CMD+="/usr/bin/"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # -i --interactive
        SXHKDRC_CMD+="/usr/bin/gnome-screenshot -i"

        # fullscreen
        # SXHKDRC_CMD+="/usr/bin/gnome-screenshot"

        # -w --window
        # SXHKDRC_CMD+="/usr/bin/gnome-screenshot -w"

        # 마우스 영역 지정 후 저장 창 띄우기
        # -a --area
        # SXHKDRC_CMD+="/usr/bin/gnome-screenshot -a"

        # 마우스 영역 지정 후 클립보드로 다이렉트 복사
        # -a --area / -c --clipboard
        # SXHKDRC_CMD+="/usr/bin/gnome-screenshot -a -c"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # gui창이 뜬다.
        SXHKDRC_CMD+="/usr/bin/spectacle"

        # -f --fullscreen
        # SXHKDRC_CMD+="/usr/bin/spectacle -f"

        # -w --onclick
        # SXHKDRC_CMD+="/usr/bin/spectacle -w"

        # -a --activewindow
        # SXHKDRC_CMD+="/usr/bin/spectacle -a"

        # -r --region
        # SXHKDRC_CMD+="/usr/bin/spectacle -r"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # sudo apt install -y flameshot
        SXHKDRC_CMD+="/usr/bin/flameshot"

        # full
        # SXHKDRC_CMD+="/usr/bin/flameshot full"

        # gui
        # SXHKDRC_CMD+="/usr/bin/flameshot gui"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/flameshot"

        # full
        # SXHKDRC_CMD+="/usr/bin/flameshot full"

        # gui
        # SXHKDRC_CMD+="/usr/bin/flameshot gui"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/flameshot"

        # full
        # SXHKDRC_CMD+="/usr/bin/flameshot full"

        # gui
        # SXHKDRC_CMD+="/usr/bin/flameshot gui"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="/usr/bin/lxrandr"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="/usr/bin/lxqt-config-monitor"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        # SXHKDRC_CMD+="/usr/bin/xfce4-display-settings"

        # single / mirror / extend 설정창
        # -m --minimal
        SXHKDRC_CMD+="/usr/bin/xfce4-display-settings -m"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # display resolution 설정 창
        SXHKDRC_CMD+="/usr/bin/mate-display-properties"

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="/usr/bin/gnome-control-center display"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="/usr/bin/cinnamon-settings display"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        # display resolution 설정 창
        SXHKDRC_CMD+="/usr/bin/systemsettings kcm_kscreen"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # sudo apt install -y arandr
        SXHKDRC_CMD+="/usr/bin/arandr"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/arandr"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/arandr"

        # 1) PC 화면만 보기 : eDP-1
        # SXHKDRC_CMD+="/usr/bin/xrandr --output eDP-1 --auto --output HDMI-1 --off"

        # 2) 화면 복제 (Mirror) : eDP-1/HDMI-1
        # SXHKDRC_CMD+="/usr/bin/xrandr --output eDP-1 --auto --output HDMI-1 --auto --same-as eDP-1"

        # 3) 화면 확장 (Extend) : eDP-1/HDMI-1
        # SXHKDRC_CMD+="/usr/bin/xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxtask"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/qps"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-taskmanager"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/mate-system-monitor"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/gnome-system-monitor"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/gnome-system-monitor"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/plasma-systemmonitor"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal -e htop"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal -e htop"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal -e htop"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/pcmanfm"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/pcmanfm-qt"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/thunar"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/caja"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/nautilus"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/nemo"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/dolphin"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/pcmanfm"

        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xfce4-terminal -e ranger"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/pcmanfm"

        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xfce4-terminal -e ranger"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        SXHKDRC_CMD+="/usr/bin/pcmanfm"

        # 방법2)
        # SXHKDRC_CMD+="/usr/bin/xfce4-terminal -e ranger"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        # startmenu
        SXHKDRC_CMD+="/usr/bin/lxpanelctl menu"

        # rundialog
        # SXHKDRC_CMD+="/usr/bin/lxpanelctl run"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxqt-config"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-settings-manager"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/mate-control-center"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/gnome-control-center"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/cinnamon-settings"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/systemsettings"
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
        SXHKDRC_CMD+="/usr/bin/custom-toolbox /etc/custom-toolbox/mxfb-settings.list"
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/"
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
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/lxterminal"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        # ----------------------------------------------------------------------
        # SXHKDRC_CMD+="/usr/bin/qterminal"
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/mate-terminal"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        # ----------------------------------------------------------------------
        # gnome이 gnome-terminal cmd를 막았다.
        # Error creating terminal: Object does not exist at path “/org/gnome/Terminal/Factory0”
        SXHKDRC_CMD+="/usr/bin/gnome-terminal"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/gnome-terminal"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/konsole"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) cmd for WM ------------------------------------------------------------
    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal"
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        # ----------------------------------------------------------------------
        SXHKDRC_CMD+="/usr/bin/xfce4-terminal"

        # with gpu (img:x)
        # SXHKDRC_CMD+="/usr/bin/alacritty"

        # with gpu (img:o)
        # SXHKDRC_CMD+="/usr/bin/kitty"
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
    SXHKDRC_CMD+="/usr/bin/xkill"

    SXHKDRC_CMD+="${NEWLINE_CMD2}"
    # --------------------------------------------------------------------------
}


function create_sxhkdrc()
{
    # --------------------------------------------------------------------------
    if [[ -f ${DST_SXHKDRC_PATH} ]]; then
        return
    fi
    if [[ ! -d ${DST_SXHKDRC_DIR} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${DST_SXHKDRC_DIR}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
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
    echo -e ${SXHKDRC_CMD};

    # 방법1)
    # su - ${CUR_USER} -c "echo -e ${SXHKDRC_CMD} > ${DST_SXHKDRC_PATH};"

    # 방법2)
    # sudo -u ${CUR_USER} tee ${DST_SXHKDRC_PATH} <(printf '%b' "${SXHKDRC_CMD}") > /dev/null

    # 방법3)
    printf '%b\n' "${SXHKDRC_CMD}" | sudo -u ${CUR_USER} tee ${DST_SXHKDRC_PATH} > /dev/null
    # --------------------------------------------------------------------------
}

# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    create_sxhkdrc;
    # --------------------------------------------------------------------------

fi
# ==============================================================================

