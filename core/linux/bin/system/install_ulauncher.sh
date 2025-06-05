#!/bin/bash

# ulauncher ====================================================================
# bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
# ==============================================================================

# ==============================================================================
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# ulauncher ====================================================================
function autostart_ulauncher()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------
    
    # --------------------------------------------------------------------------
    local START_DIR='${HOME}/.config/autostart'
    local START_PATH="${START_DIR}/ulauncher.desktop"
    
    local START_CMD="[Desktop Entry]
Name=Ulauncher
Comment=Application launcher for Linux
GenericName=Launcher
Categories=GNOME;GTK;Utility;
TryExec=/usr/bin/ulauncher
Exec=env GDK_BACKEND=x11 /usr/bin/ulauncher --hide-window --hide-window
Icon=ulauncher
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ${START_DIR} ]] || mkdir -p ${START_DIR}";
    su - ${CUR_USER} -c "[[ -f ${START_PATH} ]] || echo '${START_CMD}' > ${START_PATH}";
    # --------------------------------------------------------------------------
}

function install_ulauncher_for_deb()
{
    local GPG_PATH="/usr/share/keyrings/ulauncher-archive-keyring.gpg"
    
    # --------------------------------------------------------------------------
    if [[ -f ${GPG_PATH} ]]; then
        return
    fi
    # --------------------------------------------------------------------------
    
    # --------------------------------------------------------------------------
    apt update;
    [[ -n $(apt list --installed | grep -i ^gnupg) ]] || apt install -y gnupg;    
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176;
    gpg --export 0xfaf1020699503176 | tee ${GPG_PATH} > /dev/null;

    echo "deb [signed-by=${GPG_PATH}] \
              http://ppa.launchpad.net/agornostal/ulauncher/ubuntu jammy main" \
              | tee /etc/apt/sources.list.d/ulauncher-jammy.list;
    # --------------------------------------------------------------------------
    
    # --------------------------------------------------------------------------
    apt update;
    [[ -n $(apt list --installed | grep -i ^ulauncher) ]] || apt install -y ulauncher;   
    # --------------------------------------------------------------------------
    
    autostart_ulauncher;
}


if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_ulauncher_for_deb;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "ulauncher is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^ulauncher) ]] || yum install -y ulauncher;
    
    # autostart_ulauncher;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    echo "ulauncher is not supported for rocky"
    # [[ -n $(dnf list installed | grep -i ^ulauncher) ]] || dnf install -y ulauncher;
    
    # autostart_ulauncher;
    # --------------------------------------------------------------------------
fi
# ==============================================================================




exit 0