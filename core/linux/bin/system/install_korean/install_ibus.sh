#!/bin/bash

# ibus =========================================================================
# bash /core/linux/bin/system/install_korean/install_ibus.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="ibus"

# com.github.ibus.ibus
APP_UNIQUE_NAME="com.github.ibus.${APP_NAME}"

APP_GRP="Settings;System;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function set_ibus_env()
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
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
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
Terminal=false
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true"

    if [[ *"${DESKTOP_PATH}"* == *"\/home"* ]]; then
        # ~/.local/share/applications/ibus.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/ibus.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}

function set_ibus_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local EXEC_PATH="sh -c 'ibus-daemon -drx'"
    local ICON_PATH="/usr/share/icons/hicolor/scalable/apps/${APP_NAME}.png"

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
# for gnome, cinnamon, mate, xfce, lxde

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^ibus) ]] || apt install -y ibus;
    [[ -n $(apt list --installed | grep -i ^ibus-hangul) ]] || apt install -y ibus-hangul;
    # --------------------------------------------------------------------------
    ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    set_ibus_env;
    # --------------------------------------------------------------------------
    set_ibus_autostart;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # ibus-hangul has a problem at google-docs
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^ibus) ]] || yum install -y ibus;
    [[ -n $(yum list installed | grep -i ^ibus-hangul) ]] || yum install -y ibus-hangul;
    # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
    #     [[ -n $(yum list installed | grep -i ^im-chooser) ]] || yum install -y im-chooser;
    # fi
    # --------------------------------------------------------------------------
    ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    set_ibus_env;
    # --------------------------------------------------------------------------
    set_ibus_autostart;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # ibus-hangul has a problem at google-docs
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^ibus) ]] || dnf install -y ibus;
    [[ -n $(dnf list installed | grep -i ^ibus-hangul) ]] || dnf install -y ibus-hangul;
    # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
    #     [[ -n $(dnf list installed | grep -i ^im-chooser) ]] || dnf install -y im-chooser;
    # fi
    # --------------------------------------------------------------------------
    ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    set_ibus_env;
    # --------------------------------------------------------------------------
    set_ibus_autostart;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0
