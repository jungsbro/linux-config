#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_ibus.sh ${CUR_USER};
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
APP_NAME="ibus"

# com.github.ibus.ibus
APP_UNIQUE_NAME="com.github.ibus.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false";

IME_ENV_CMD='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
# ------------------------------------------------------------------------------
'
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
# function set_ibus_env()
# {
#     # args ---------------------------------------------------------------------
#     # ${ENV_CONF_PATH}
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     # local ENV_CONF_PATH="${HOME_DIR}/.xprofile";
#     # local ENV_CONF_PATH="${HOME_DIR}/.xsession";
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     local CONF_CMD='#!/bin/bash
# export GTK_IM_MODULE=ibus
# export QT_IM_MODULE=ibus
# export XMODIFIERS="@im=ibus"
# '
#     # GNOME,KDE는 ~/.config/environment.d/*.conf 에서 잘된다.
#     # 전통/경량 DE는 ~/.xprofile(x11,rhel), ~/.xsession(x11,debian), ~/.profile(wayland)에서 잘된다.
#     if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then

#         if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then                                         # lxde
#             CONF_CMD="${CONF_CMD}exec startlxde"

#         elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then                                            # lxqt
#             CONF_CMD="${CONF_CMD}exec startlxqt"

#         elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                            # xfce4
#             CONF_CMD="${CONF_CMD}exec startxfce4"

#         elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                             # mate
#             CONF_CMD="${CONF_CMD}exec mate-session"

#         elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then  # gnome
#             CONF_CMD="${CONF_CMD}exec gnome-session"

#         elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                        # cinnamon
#             CONF_CMD="${CONF_CMD}exec cinnamon-session"

#         elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then                                          # kde
#             CONF_CMD="${CONF_CMD}exec startplasma-x11"
#         fi
#     fi
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     su - ${CUR_USER} -c "[[ -f ${ENV_CONF_PATH} ]] || echo \"${CONF_CMD}\" > ${ENV_CONF_PATH}";

#     if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then
#         su - ${CUR_USER} -c "chmod +x ${ENV_CONF_PATH}";
#     fi
#     # --------------------------------------------------------------------------
# }

# function set_desktop()
# {
#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     local DESKTOP_CMD="[Desktop Entry]
# Type=Application
# Name=${APP_NAME}
# Exec=${EXEC_PATH}
# Icon=${ICON_PATH}
# Categories=${APP_CAT}
# Terminal=false
# Hidden=false
# NoDisplay=false
# X-GNOME-Autostart-enabled=true"

#     if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
#         # ~/.local/share/applications/ibus.desktop
#         su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
#     else
#         # /usr/share/applications/ibus.desktop
#         echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
#     fi
# }

function set_ibus_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="sh -c 'ibus-daemon -drx'"

    # local icon_path="/usr/share/icons/hicolor/scalable/apps/${APP_NAME}.png"
    local icon_path="${APP_NAME}"

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for gnome, cinnamon, mate, xfce, lxde
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^ibus) ]] || pacman -S --needed --noconfirm ibus ibus-hangul;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ibus) ]] || apt install -y ibus ibus-hangul;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ibus-hangul has a problem when using google-docs
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^ibus) ]] || dnf install -y ibus ibus-hangul;
        # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
        #     [[ -n $(dnf list --installed | grep -i ^im-chooser) ]] || dnf install -y im-chooser;
        # fi
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    # set_ibus_env;
    source ${CORE_BIN_DIR}/ime/install_ime_funcs.sh && set_ime-env "${APP_NAME}" "${IME_ENV_CMD}" "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_ibus_autostart;
    # --------------------------------------------------------------------------

fi
# ==============================================================================
