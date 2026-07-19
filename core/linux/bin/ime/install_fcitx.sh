#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_fcitx.sh ${CUR_USER};
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
APP_NAME="fcitx"

# com.github.fcitx
APP_UNIQUE_NAME="com.github.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false";

IME_ENV_CMD='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
# ------------------------------------------------------------------------------
'
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
# function set_fcitx_env()
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
# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS="@im=fcitx"
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
#     # args ---------------------------------------------------------------------
#     # ${CUR_USER}
#     # ${APP_NAME}
#     # ${EXEC_PATH}
#     # ${ICON_PATH}
#     # ${APP_CAT}
#     # ${DESKTOP_PATH}
#     # --------------------------------------------------------------------------

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
# Terminal=false"

#     if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
#         # ~/.local/share/applications/fcitx.desktop
#         su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
#     else
#         # /usr/share/applications/fcitx.desktop
#         echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
#     fi
# }

function set_fcitx_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="${APP_NAME}"

    # local icon_path="/usr/share/icons/hicolor/128x128/apps/${APP_NAME}.png"
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

    # for cinnamon, mate, xfce, lxde
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm fcitx5 \
        fcitx5-hangul fcitx5-configtool fcitx5-gtk fcitx5-qt;

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^fcitx5) ]] || pacman -S --needed --noconfirm fcitx5-gtk;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^fcitx) ]] || apt install -y fcitx fcitx-hangul;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^fcitx) ]] || dnf install -y fcitx fcitx-hangul;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # rhel8은 fcitx를 지원한다.
        # rhel9에서 fcitx가 사라졌다.
        echo "fcitx is not supported for RHEL"
        return 0
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # ENV_CONF_PATH="${HOME_DIR}/.xprofile"
    # set_fcitx_env;
    source ${CORE_BIN_DIR}/ime/install_ime_funcs.sh && set_ime-env "${APP_NAME}" "${IME_ENV_CMD}" "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_fcitx_autostart;
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================