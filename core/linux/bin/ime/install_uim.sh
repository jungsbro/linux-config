#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_uim.sh ${CUR_USER};
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
APP_NAME="uim"

# com.github.uim
APP_UNIQUE_NAME="com.github.${APP_NAME}"

APP_GRP="Settings;System;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function set_uim_env()
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
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
export XMODIFIERS="@im=uim"
'
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
        # ~/.local/share/applications/uim.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/uim.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}

function set_uim_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local EXEC_PATH="sh -c 'uim-toolbar-gtk3-systray uim-sh'"
    local ICON_PATH="/usr/share/uim/pixmaps/uim-icon.png"

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
        [[ -n $(pacman -Q | grep -i ^uim) ]] || pacman -S --needed --noconfirm uim uim-byeoru;

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # # [[ -n $(yay -Q | grep -i ^uim-git) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm uim-git";
        # [[ -n $(yay -Q | grep -i ^uim) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm uim";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^uim) ]] || apt install -y uim uim-byeoru;
        # ----------------------------------------------------------------------
        ENV_CONF_PATH="${HOME_DIR}/.xprofile"
        set_uim_env;
        # ----------------------------------------------------------------------
        set_uim_autostart;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo "uim is not supported for RHEL"

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^uim) ]] || dnf install -y uim uim-m17n;

        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^uim-qt) ]] || dnf install -y uim-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^uim-gtk3) ]] || dnf install -y uim-gtk3;
        fi
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
