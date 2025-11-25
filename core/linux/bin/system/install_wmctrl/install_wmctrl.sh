#!/bin/bash

# install_wmctrl ================================================================
# bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh ${CUR_USER}; # not used

# bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function cp_toggle_fullscreen()     # not used
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local SRC_DIR=$(dirname "$0");
    local DST_DIR="${HOME_DIR}/.local/bin";
    local SCRIPT_NAME='toggle_fullscreen.sh';

    # su - ${CUR_USER} -c "echo \"${DST_DIR}\"";
    # su - ${CUR_USER} -c "echo ${SRC_DIR}/${SCRIPT_NAME}";
    # su - ${CUR_USER} -c "echo ${DST_DIR}/${SCRIPT_NAME}";

    su - ${CUR_USER} -c "[[ -d ${DST_DIR} ]] || mkdir -p ${DST_DIR}";
    su - ${CUR_USER} -c "[[ -f '${DST_DIR}/${SCRIPT_NAME}' ]] || cp -f ${SRC_DIR}/${SCRIPT_NAME} ${DST_DIR}/${SCRIPT_NAME}";
    su - ${CUR_USER} -c "chmod 755 ${DST_DIR}/${SCRIPT_NAME}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^wmctrl) ]] || apt install -y wmctrl;
    [[ -n $(apt list --installed | grep -i ^xdotool) ]] || apt install -y xdotool;
    # --------------------------------------------------------------------------
    # cp_toggle_fullscreen;

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^wmctrl) ]] || yum install -y wmctrl;
    [[ -n $(yum list installed | grep -i ^xdotool) ]] || yum install -y xdotool;
    # --------------------------------------------------------------------------
    # cp_toggle_fullscreen;

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^wmctrl) ]] || dnf install -y wmctrl;
    [[ -n $(dnf list installed | grep -i ^xdotool) ]] || dnf install -y xdotool;
    # --------------------------------------------------------------------------
    # cp_toggle_fullscreen;
fi
# ==============================================================================

exit 0
