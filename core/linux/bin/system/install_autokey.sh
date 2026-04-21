#!/bin/bash

# autokey ======================================================================
# bash ${CORE_BIN_DIR}/system/install_autokey.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$1;
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
TMP_DIR="/tmp";

# /tmp/autohotkey-config
CONFIG_DIR="${TMP_DIR}/autohotkey-config";
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function set_autokey_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local AUTOSTART_DIR="${HOME_DIR}/.config/autostart"
    local AUTOSTART_PATH="${AUTOSTART_DIR}/autokey.desktop"

    local AUTOSTART_CMD="[Desktop Entry]
Name=AutoKey
GenericName=Keyboard Automation
Comment=Program keyboard shortcuts
Keywords=macros keyboard auto key autokey ak automation shortcut bind
Exec=autokey-gtk
Terminal=false
Type=Application
Icon=autokey
Categories=GNOME;GTK;Utility;"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ${AUTOSTART_DIR} ]] || mkdir -p ${AUTOSTART_DIR}";
    su - ${CUR_USER} -c "[[ -f ${AUTOSTART_PATH} ]] || echo \"${AUTOSTART_CMD}\" > ${AUTOSTART_PATH}";
    # --------------------------------------------------------------------------
}


function config_autokey()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    if [[ -d ${CONFIG_DIR} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/autohotkey-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.config/autokey ~/.config/";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for x86_64, aarch64, i686
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^autokey-gtk) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm autokey-gtk";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^autokey) ]] || apt install -y autokey-gtk;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
            echo "autokey not working on rocky8";
            return 0
        fi
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^autokey) ]] || dnf install -y autokey-gtk;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^autokey) ]] || dnf install -y autokey-gtk;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    config_autokey;
    set_autokey_autostart;
    # --------------------------------------------------------------------------

fi
# ==============================================================================
