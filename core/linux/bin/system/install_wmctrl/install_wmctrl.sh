#!/bin/bash

# install_wmctrl ================================================================
# bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh ${CUR_USER}; # not used

# bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh;
# ==============================================================================


# ==============================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# wmctrl, xdotool : x86_64, i686, aarch64 ======================================
function cp_toggle_fullscreen()     # not used
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/my_scripts/ui/toggle_fullscreen.sh
    local DST_SCRIPT_DIR='~/my_scripts/ui';
    local SCRIPT_NAME='toggle_fullscreen.sh';
    
    # ~/my_scripts/ui/toggle_fullscreen.sh
    # su - ${CUR_USER} -c "echo '${DST_SCRIPT_DIR}'";
    # su - ${CUR_USER} -c "echo ${PWD}/${SCRIPT_NAME}";
    # su - ${CUR_USER} -c "echo ${DST_SCRIPT_DIR}/${SCRIPT_NAME}";
    
    su - ${CUR_USER} -c "[[ -d ${DST_SCRIPT_DIR} ]] || mkdir -p ${DST_SCRIPT_DIR}";
    su - ${CUR_USER} -c "[[ -f '${SCRIPT_PATH}' ]] || cp -f ${PWD}/${SCRIPT_NAME} ${DST_SCRIPT_DIR}/${SCRIPT_NAME}";
    su - ${CUR_USER} -c "chmod 755 ${DST_SCRIPT_DIR}/${SCRIPT_NAME}";
    # --------------------------------------------------------------------------
}


if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^wmctrl) ]] || apt install -y wmctrl;
    [[ -n $(apt list --installed | grep -i ^xdotool) ]] || apt install -y xdotool;
    # --------------------------------------------------------------------------
    # cp_toggle_fullscreen;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^wmctrl) ]] || yum install -y wmctrl;
    [[ -n $(yum list installed | grep -i ^xdotool) ]] || yum install -y xdotool;
    # --------------------------------------------------------------------------
    # cp_toggle_fullscreen;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^wmctrl) ]] || dnf install -y wmctrl;
    [[ -n $(dnf list installed | grep -i ^xdotool) ]] || dnf install -y xdotool;
    # --------------------------------------------------------------------------
    # cp_toggle_fullscreen;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0