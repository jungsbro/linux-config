#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

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
APP_NAME="fcitx5"

# org.fcitx.Fcitx5
APP_UNIQUE_NAME="org.fcitx.${APP_NAME}"

APP_GRP="Settings;System;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function set_fcitx5_env()
{
    # args ---------------------------------------------------------------------
    # ${ENV_CONF_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # local ENV_CONF_PATH="${HOME_DIR}/.xprofile";
    # local ENV_CONF_PATH="${HOME_DIR}/.xsession";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local CONF_CMD='#!/bin/bash
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
'
    # GNOME,KDE는 ~/.config/environment.d/*.conf 에서 잘된다.
    # 전통/경량 DE는 ~/.xprofile(x11), ~/.xsession(x11), ~/.profile(wayland)에서 잘된다.
    if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then

        if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then                                         # lxde
            CONF_CMD="${CONF_CMD}exec startlxde"

        elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then                                            # lxqt
            CONF_CMD="${CONF_CMD}exec startlxqt"

        elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                            # xfce4
            CONF_CMD="${CONF_CMD}exec startxfce4"

        elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                             # mate
            CONF_CMD="${CONF_CMD}exec mate-session"

        elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then  # gnome
            CONF_CMD="${CONF_CMD}exec gnome-session"

        elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                        # cinnamon
            CONF_CMD="${CONF_CMD}exec cinnamon-session"

        elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then                                          # kde
            CONF_CMD="${CONF_CMD}exec startplasma-x11"
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -f ${ENV_CONF_PATH} ]] || echo \"${CONF_CMD}\" > ${ENV_CONF_PATH}";

    if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then
        su - ${CUR_USER} -c "chmod +x ${ENV_CONF_PATH}";
    fi
    # --------------------------------------------------------------------------
}

function set_desktop()
{
    # args ---------------------------------------------------------------------
    # ${CUR_USER}
    # ${APP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}
Terminal=false"

    if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
        # ~/.local/share/applications/fcitx5.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/fcitx5.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}

function set_fcitx5_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local EXEC_PATH="${APP_NAME}"
    local ICON_PATH="/usr/share/icons/hicolor/128x128/apps/${APP_UNIQUE_NAME}.png"

    local DESKTOP_DIR="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${DESKTOP_DIR} ]] || mkdir -p ${DESKTOP_DIR}";

    local DESKTOP_PATH="${DESKTOP_DIR}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_desktop;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for cinnamon, mate, xfce, lxde
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-qt;
        else
            [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-gtk;
        fi

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm fcitx5-gtk;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y --install-recommends \
        # fcitx5 fcitx5-hangul fcitx5-configtool fcitx5-config-qt ;

        # 방법2)
        # [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y \
        # fcitx5-frontend-gtk3 fcitx5-frontend-qt5 libfcitx5utils2;

        # 방법3)
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-qt* fcitx5-module-dbus;
        else
            [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-frontend-gtk* fcitx5-module-dbus;
        fi

        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "fcitx5 is not supported for RHEL"
        return 0
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^fcitx5) ]] || dnf install -y fcitx5 \
        fcitx5-hangul fcitx5-configtool fcitx5-autostart ;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    set_fcitx5_env;
    # --------------------------------------------------------------------------
    set_fcitx5_autostart;
    # --------------------------------------------------------------------------

fi
# ==============================================================================