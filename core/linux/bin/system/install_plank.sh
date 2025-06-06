#!/bin/bash

# plank ========================================================================
# bash /core/linux/bin/system/plank.sh ${CUR_USER};
# ==============================================================================

# ==============================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# plank ========================================================================
function autostart_plank()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local START_DIR='${HOME}/.config/autostart'
    local START_PATH="${START_DIR}/plank.desktop"

    local START_CMD="[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=plank
Comment=Dock
Exec=plank
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ${START_DIR} ]] || mkdir -p ${START_DIR}";
    su - ${CUR_USER} -c "[[ -f ${START_PATH} ]] || echo '${START_CMD}' > ${START_PATH}";
    # --------------------------------------------------------------------------
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^plank) ]] || apt install -y plank;

    # autostart_plank;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "font-manager is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^plank) ]] || yum install -y plank;

    # autostart_plank;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    echo "font-manager is not supported for rocky"
    # [[ -n $(dnf list installed | grep -i ^plank) ]] || dnf install -y plank;

    # autostart_plank;
    # --------------------------------------------------------------------------
fi
# ==============================================================================


exit 0