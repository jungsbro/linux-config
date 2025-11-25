#!/bin/bash

# redshift =====================================================================
# bash /core/linux/bin/system/install_redshift.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function set_redshift_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local AUTOSTART_DIR="${HOME_DIR}/.config/autostart"
    local AUTOSTART_PATH="${AUTOSTART_DIR}/redshift-gtk.desktop"

    local START_CMD="[Desktop Entry]
Version=1.0
Name=Redshift
GenericName=Color temperature adjustment
Comment=Color temperature adjustment tool
Exec=redshift-gtk
Icon=redshift
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
Hidden=false
X-GNOME-Autostart-enabled=true"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ${AUTOSTART_DIR} ]] || mkdir -p ${AUTOSTART_DIR}";
    su - ${CUR_USER} -c "[[ -f ${AUTOSTART_PATH} ]] || echo \"${START_CMD}\" > ${AUTOSTART_PATH}";
    # --------------------------------------------------------------------------
}

function config_redshift()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local CONF_CMD="[redshift]
temp-day=5500
temp-night=3800

location-provider=manual
adjustment-method=randr

[manual]
lat=37.6
lon=127.0"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/redshift.conf
    su - ${CUR_USER} -c "[[ -f ~/.config/redshift.conf ]] || echo \"${CONF_CMD}\" > ~/.config/redshift.conf";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^redshift) ]] || apt install -y redshift-gtk;
    [[ -n $(apt list --installed | grep -i ^geoclue) ]] || apt install -y geoclue-2.0;
    # --------------------------------------------------------------------------
    config_redshift;
    set_redshift_autostart;

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^redshift) ]] || yum install -y redshift-gtk;
    [[ -n $(yum list installed | grep -i ^geoclue) ]] || yum install -y geoclue2;
    # --------------------------------------------------------------------------
    config_redshift;
    set_redshift_autostart;

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^redshift) ]] || dnf install -y redshift-gtk;
    [[ -n $(dnf list installed | grep -i ^geoclue) ]] || dnf install -y geoclue2;
    # --------------------------------------------------------------------------
    config_redshift;
    set_redshift_autostart;
fi
# ==============================================================================

exit 0
