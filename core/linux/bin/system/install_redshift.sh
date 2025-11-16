#!/bin/bash

# redshift =====================================================================
# bash /core/linux/bin/system/install_redshift.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function autostart_redshift()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local START_DIR='${HOME_DIR}/.config/autostart'
    local START_PATH="${START_DIR}/redshift-gtk.desktop"

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
    su - ${CUR_USER} -c "[[ -d ${START_DIR} ]] || mkdir -p ${START_DIR}";
    su - ${CUR_USER} -c "[[ -f ${START_PATH} ]] || echo '${START_CMD}' > ${START_PATH}";
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
    su - ${CUR_USER} -c "[[ -f ~/.config/redshift.conf ]] || echo '${CONF_CMD}' > ~/.config/redshift.conf";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    autostart_redshift;
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

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^redshift) ]] || yum install -y redshift-gtk;
    [[ -n $(yum list installed | grep -i ^geoclue) ]] || yum install -y geoclue2;
    # --------------------------------------------------------------------------
    config_redshift;

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # ----------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^redshift) ]] || dnf install -y redshift-gtk;
    [[ -n $(dnf list installed | grep -i ^geoclue) ]] || dnf install -y geoclue2;
    # ----------------------------------------------------------------------
    config_redshift;
fi
# ==============================================================================

exit 0
