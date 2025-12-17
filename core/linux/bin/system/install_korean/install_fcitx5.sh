#!/bin/bash

# fcitx5 =======================================================================
# bash /core/linux/bin/system/install_korean/install_fcitx5.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
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
    if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then

        if [[ *"${CUR_WMDE}"* != *"gnome"* ]] && [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then     # lxde
            CONF_CMD="${CONF_CMD}exec startlxde"

        elif [[ *"${CUR_WMDE}" == *"xfce4"* ]]; then                                            # xfce4
            CONF_CMD="${CONF_CMD}exec startxfce4"

        elif [[ *"${CUR_WMDE}" == *"mate"* ]]; then                                             # mate
            CONF_CMD="${CONF_CMD}exec mate-session"

        elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then  # gnome
            CONF_CMD="${CONF_CMD}exec gnome-session"

        elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                        # cinnamon
            CONF_CMD="${CONF_CMD}exec cinnamon-session"
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
# for cinnamon, mate, xfce, lxde

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^fcitx5) ]] || apt install -y fcitx5;
    [[ -n $(apt list --installed | grep -i ^fcitx5-hangul) ]] || apt install -y fcitx5-hangul;
    [[ -n $(apt list --installed | grep -i ^fcitx5-config-qt) ]] || apt install -y fcitx5-config-qt;
    [[ -n $(apt list --installed | grep -i ^fcitx5-frontend-gtk) ]] || apt install -y fcitx5-frontend-gtk*;
    [[ -n $(apt list --installed | grep -i ^fcitx5-frontend-qt) ]] || apt install -y fcitx5-frontend-qt*;
    [[ -n $(apt list --installed | grep -i ^fcitx5-module-dbus) ]] || apt install -y fcitx5-module-dbus;
    # --------------------------------------------------------------------------
    ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    set_fcitx5_env;
    # --------------------------------------------------------------------------
    set_fcitx5_autostart;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    echo "rhel is not supported for fcitx5"

fi
# ==============================================================================

exit 0
