#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ide/install_mousepad.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ide
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
# ==============================================================================


# Funcs ========================================================================
function set_mousepad_settings()
{
    # --------------------------------------------------------------------------
    # gsettings list-recursively org.xfce.mousepad

    # :0.0
    # echo $DISPLAY

    # unix:path=/run/user/1000/bus
    # echo $DBUS_SESSION_BUS_ADDRESS
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} <<"EOF"
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u ${USER})/bus"

# view
gsettings set org.xfce.mousepad.preferences.view show-line-numbers true;
gsettings set org.xfce.mousepad.preferences.view show-whitespace true;
gsettings set org.xfce.mousepad.preferences.view show-line-endings true;
gsettings set org.xfce.mousepad.preferences.view show-right-margin true
gsettings set org.xfce.mousepad.preferences.view right-margin-position 'uint32 80';
gsettings set org.xfce.mousepad.preferences.view highlight-current-line true;
gsettings set org.xfce.mousepad.preferences.view match-braces true;
gsettings set org.xfce.mousepad.preferences.view word-wrap false;
gsettings set org.xfce.mousepad.preferences.view use-default-monospace-font false;
gsettings set org.xfce.mousepad.preferences.view font-name 'Monospace 14';
gsettings set org.xfce.mousepad.preferences.view color-scheme 'oblivion';

# Editor
gsettings set org.xfce.mousepad.preferences.view tab-width 'uint32 4';
gsettings set org.xfce.mousepad.preferences.view insert-spaces true;
gsettings set org.xfce.mousepad.preferences.view auto-indent true;

# Window
gsettings set org.xfce.mousepad.preferences.window toolbar-visible true;
gsettings set org.xfce.mousepad.preferences.window toolbar-style 'icons';
gsettings set org.xfce.mousepad.preferences.window toolbar-icon-size 'small-toolbar';
EOF
    # --------------------------------------------------------------------------
}

function set_mousepad_association()
{
    # --------------------------------------------------------------------------
    # [Default Applications]
    # text/plain=org.xfce.mousepad.desktop

    # [Added Associations]
    # text/plain=org.xfce.mousepad.desktop;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} <<"EOF"
crudini --set ~/.config/mimeapps.list "Default Applications" "text/plain" "org.xfce.mousepad.desktop";
crudini --set ~/.config/mimeapps.list "Added Associations" "text/plain" "org.xfce.mousepad.desktop";
EOF
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^mousepad) ]] || pacman -S --needed --noconfirm mousepad;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^mousepad) ]] || apt install -y mousepad;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^mousepad) ]] || dnf install -y mousepad;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^mousepad) ]] || dnf install -y mousepad;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    set_mousepad_settings;
    set_mousepad_association;
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================