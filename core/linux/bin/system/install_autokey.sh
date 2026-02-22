#!/bin/bash

# autokey ======================================================================
# bash ${BIN_DIR}/system/install_autokey.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/system
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/.."
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
# for x86_64, aarch64, i686

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^autokey) ]] || apt install -y autokey-gtk;
    # --------------------------------------------------------------------------
    config_autokey;
    set_autokey_autostart;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
        echo "autokey not working on rocky8";
    else
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^autokey) ]] || dnf install -y autokey-gtk;
        # ----------------------------------------------------------------------
        config_autokey;
        set_autokey_autostart;
        # ----------------------------------------------------------------------
    fi
fi
# ==============================================================================

exit 0
