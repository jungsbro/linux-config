#!/bin/bash

# usage ========================================================================
# sudo bash ./install_gpkg.sh jungs;
# ==============================================================================


# setting the current user =====================================================
# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER=$1;
while [[ -z ${CUR_USER} ]]
do
    echo "${CUR_USER} not found";
    read -p "Please input username : " CUR_USER;
done
# echo "your name : ${CUR_USER}";

# ------------------------------------------------------------------------------

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# update =======================================================================
function add_nux_dextop_repo()
{
    if [[ -n $(yum list installed | grep -i ^nux-dextop) ]]; then
        return
    fi
    rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    apt update;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || yum install -y epel-release;
    add_nux_dextop_repo;
    yum check-update;
fi
# ==============================================================================


# flatpak ======================================================================
function add_flathub()
{
    if [[ *"$(flatpak remotes)"* == *"flathub"* ]]; then
        return
    fi
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^flatpak) ]] || apt install -y flatpak;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^flatpak) ]] || yum install -y flatpak
fi

add_flathub;
# ==============================================================================


# snap =========================================================================
function install_snapd_deb()
{
    if [[ -n $(apt list --installed | grep -i ^snapd) ]]; then
        return
    fi

    # linuxmint ----------------------------------------------------------------
    local SRC_PATH="/etc/apt/preferences.d/nosnap.pref"
    local DST_DIR="~/Documents"
    local DST_PATH="${DST_DIR}/nosnap.backup"
    
    if [[ -e ${SRC_PATH} ]]; then
        [[ -e ${DST_DIR} ]] || mkdir -p ${DST_DIR};
        mv ${SRC_PATH} ${DST_DIR};
        apt update;
    fi
    # --------------------------------------------------------------------------

    apt install -y snapd;
    
    init 6;
}

function install_snapd_rpm()
{
    if [[ -n $(yum list installed | grep -i ^snapd) ]]; then
        return
    fi
    #yum install -y epel-release && \
    yum install -y snapd;
    
    systemctl enable --now snapd.socket;
    #systemctl enable snapd;
    
    ln -s /var/lib/snapd/snap /snap;
    
    init 6;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    install_snapd_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    install_snapd_rpm;
fi

[[ -n $(snap list | grep -i ^core) ]] || snap install core;
# ==============================================================================


# graphic driver ===============================================================
function install_nvidia_deb()
{
    if [[ -n $(apt list --installed | grep -i ^nvidia-detect) ]]; then
        return
    fi
    apt install -y nvidia-detect;
    nvidia-detect;
    apt install -y nvidia-driver;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    echo "";
    #install_nvidia_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    echo "";
    #yum update;
    #yum install kernel-devel kernel-headers gcc make;
    #echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist.conf
    #dracut /boot/initramfs-$(uname -r).img $(uname -r) --force
    #reboot

    #/sbin/init 3
    #alt + ctrl + F1
    #cd /core/utils/drivers/NVIDIA-Linux/
    #sh NVIDIA-Linux-x86_64-440.59.run

    #/sbin/init 5
    #alt + ctrl + F7
fi
# ==============================================================================


# korean =======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^fontconfig) ]] || apt install -y fontconfig;
    [[ -n $(apt list --installed | grep -i ^fonts-nanum) ]] || apt install -y fonts-nanum fonts-nanum-coding fonts-nanum-extra;
    [[ -n $(apt list --installed | grep -i ^uim) ]] || apt install -y uim uim-byeoru;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^fontconfig) ]] || yum install -y fontconfig;
    # yum search fonts | grep -i korean
    # yum install -y fonts-nanum*
fi
#fc-cache -f -v;
# ==============================================================================


# bottles ======================================================================
#if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#    # ~/.local/share/applications/KakaoTalk.desktop
#    [[ -n $(flatpak list --app | grep -i bottles) ]] || flatpak install -y flathub com.usebottles.bottles;
#elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#    echo "";
#fi
# ==============================================================================


# theme ========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^papirus-icon) ]] || apt install -y papirus-icon-theme;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    echo ""
    [[ -n $(snap list | grep -i ^icon-theme-papirus) ]] || snap install icon-theme-papirus;
fi
# ==============================================================================


# ide ==========================================================================
function install_vscode_deb()
{
    if [[ -n $(apt list --installed | grep -i ^code) ]]; then
        return
    fi
    
    # method 1 -----------------------------------------------------------------
    apt install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    apt install apt-transport-https
    apt update
    apt install -y code
    # --------------------------------------------------------------------------

    # method 2 -----------------------------------------------------------------
    #apt install -y software-properties-common apt-transport-https curl;
    #curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
    #add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main";
    #apt update;
    #apt install -y code;
    # --------------------------------------------------------------------------
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^geany) ]] || apt install -y geany geany-plugins;
    install_vscode_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ -n $(yum list installed | grep -i ^geany) ]] || yum install -y geany geany-plugins-addons;
    [[ -n $(snap list | grep -i ^code) ]] || snap install code --classic;
fi

#[[ -n $(flatpak list --app | grep -i code) ]] || flatpak install -y flathub com.visualstudio.code;
# ==============================================================================


# file-manager =================================================================
function install_dc_appimg()
{
    local APP_NAME="doublecmd";

    local APP_IMG_URL="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage";
    local APP_IMG_DIR="/opt/${APP_NAME}";
    local APP_IMG_NAME="doublecmd-gtk-latest-x86_64.AppImage";

    local ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";
    local ICON_NAME="${APP_NAME}.png";

    local DESKTOP_PATH="/usr/share/applications/${APP_NAME}.desktop";
    local DESKTOP_CMD="[Desktop Entry]
Name=${APP_NAME}
Comment=${APP_NAME}
Exec=${APP_IMG_DIR}/${APP_IMG_NAME}
Icon=${APP_IMG_DIR}/${ICON_NAME}
Terminal=false
Type=Application
Categories=Development";

    if [[ -e "${APP_IMG_DIR}" ]]; then
        return
    fi
    
    # appimage dir
    mkdir -p ${APP_IMG_DIR};
    
    # appimage path
    wget ${APP_IMG_URL} -O ${APP_IMG_DIR}/${APP_IMG_NAME};
    chmod +x ${APP_IMG_DIR}/${APP_IMG_NAME};
    
    # icon path
    wget ${ICON_URL} -O ${APP_IMG_DIR}/${ICON_NAME};
    
    # desktop path
    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^doublecmd) ]] || apt install -y doublecmd-gtk;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    install_dc_appimg;
fi
# ==============================================================================


# web browser ==================================================================
function install_chrome_deb()
{
    if [[ -n $(apt list --installed | grep -i ^google-chrome) ]]; then
        return
    fi

    local NAME="google-chrome";
    local TMP_DIR= "/tmp/${NAME}";

    local URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb";
    local FNAME="google-chrome-stable_current_amd64.deb";

    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    apt install -y ${TMP_DIR}/${FNAME};
}

function install_chrome_rpm()
{
    if [[ -n $(yum list installed | grep -i ^google-chrome) ]]; then
        return
    fi
    
    local NAME="google-chrome";
    local TMP_DIR= "/tmp/${NAME}";

    local URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm";
    local FNAME="google-chrome-stable_current_x86_64.rpm";

    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    yum localinstall -y ${TMP_DIR}/${FNAME};
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^chromium) ]] || apt install -y chromium;
    
    [[ -n $(apt list --installed | grep -i ^firefox) ]] || apt install -y firefox;
    
    install_chrome_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ -n $(yum list installed | grep -i ^chromium) ]] || yum install -y chromium;
    
    [[ -n $(yum list installed | grep -i ^firefox) ]] || yum install -y firefox;
    
    install_chrome_rpm;
fi
# ==============================================================================


# ftp ==========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^filezilla) ]] || apt install -y filezilla;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ -n $(yum list installed | grep -i ^filezilla) ]] || yum install -y filezilla;
fi
# ==============================================================================


# filesync =====================================================================
function install_freefilesync()
{
    local NAME="FreeFileSync";
    local VER="13.6"
    # FreeFileSync_13.6_Linux.tar.gz
    local FNAME="${NAME}_${VER}_Linux.tar.gz";
    # https://freefilesync.org/download/FreeFileSync_13.6_Linux.tar.gz
    local URL="https://freefilesync.org/download/${FNAME}";
    local TMP_DIR="/tmp/${NAME}";
    local FFS_DIR="/opt/${NAME}";
    local TGZ_PATH="${TMP_DIR}/${FNAME}";
    local EXEC_CMD="${TMP_DIR}/${NAME}_${VER}_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview";

    # /opt/FreeFileSync
    if [[ -d ${FFS_DIR} ]]; then
        return
    fi
    
    if [[ ! -e "${TGZ_PATH}" ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget "${URL}" -O "${TGZ_PATH}";
    fi
    
    # tar -zxvf /tmp/FreeFileSync/FreeFileSync_*_Linux.tar.gz -C /tmp/FreeFileSync;
    tar -zxvf "${TGZ_PATH}" -C ${TMP_DIR};

    # /tmp/FreeFileSync/FreeFileSync_13.6_Install.run --accept-license --for-all-users true --create-shortcuts false --skip-overview
    ${EXEC_CMD};
    
    #rm -rf ${TMP_DIR};
}

install_freefilesync;
#[[ -n $(flatpak list --app | grep -i freefilesync) ]] || flatpak install -y flathub org.freefilesync.FreeFileSync;
# ==============================================================================


# snapshot =====================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^timeshift) ]] || apt install -y timeshift;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ -n $(yum list installed | grep -i ^timeshift) ]] || yum install -y timeshift;
fi
# ==============================================================================


# monitoring ===================================================================
#if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#    [[ -n $(apt list --installed | grep -i ^conky) ]] || apt install -y conky;
#elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#    #yum install -y epel-release && \
#    [[ -n $(yum list installed | grep -i ^conky) ]] || yum install -y conky;
#fi
# ==============================================================================


# bluelight ====================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^redshift) ]] || apt install -y redshift-gtk;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ -n $(yum list installed | grep -i ^redshift) ]] || yum install -y redshift-gtk; 
fi
# ==============================================================================


# rdp ==========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^remmina) ]] || apt install -y remmina;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ -n $(yum list installed | grep -i ^remmina) ]] || yum install -y remmina;
fi
#[[ -n $(flatpak list --app | grep -i remmina) ]] || flatpak install -y flathub org.remmina.Remmina;
# ==============================================================================


# libreoffice ==================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^libreoffice) ]] || apt install -y libreoffice;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^libreoffice) ]] || yum install -y libreoffice;
fi
# ==============================================================================


# gimp =========================================================================
function install_photogimp()
{
    local NAME="PhotoGIMP";
    local URL="https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip";
    local TMP_DIR="/tmp/${NAME}";
    local ZIP_PATH="${TMP_DIR}/${NAME}.zip"
    # for flatpak --------------------------------------------------------------
    local LOCAL_DIR="${TMP_DIR}/${NAME}-master/.local";
    local VAR_DIR="${TMP_DIR}/${NAME}-master/.var";
    # for the other pkgs -------------------------------------------------------
    local GIMP_DIR="${TMP_DIR}/${NAME}-master/.var/app/org.gimp.GIMP/config/GIMP";
    # --------------------------------------------------------------------------

    if [[ -e "${TMP_DIR}" ]]; then
        return
    fi
    
    if [[ ! -e "${ZIP_PATH}" ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget "${URL}" -O "${ZIP_PATH}";
    fi
    unzip "${ZIP_PATH}" -d ${TMP_DIR};
    
    if [[ -e "${LOCAL_DIR}" ]]; then
        if [[ -n $(flatpak list --app | grep -i gimp) ]]; then
            su - ${CUR_USER} -c "cp -Rf ${LOCAL_DIR} ~/";
            su - ${CUR_USER} -c "cp -Rf ${VAR_DIR} ~/";        
        else
            su - ${CUR_USER} -c "cp -Rf ${GIMP_DIR} ~/.config/";
        fi
    fi
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^gimp) ]] || apt install -y gimp;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #[[ -n $(yum list installed | grep -i ^gimp) ]] || yum install -y gimp;
    [[ -n $(flatpak list --app | grep -i gimp) ]] || flatpak install -y flathub org.gimp.GIMP;
fi

install_photogimp;
# ==============================================================================


# kolourpaint ==================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^kolurpaint4) ]] || apt install -y kolourpaint4;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^kolourpaint) ]] || yum install -y kolourpaint;
fi
# ==============================================================================


# drawing ======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^drawing) ]] || apt install -y drawing;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    echo ""
fi
# ==============================================================================


# simplescreenrecorder =========================================================
function install_ssr_rpm()
{
    if [[ -n $(yum list installed | grep -i ^simplescreenrecorder) ]]; then
        return
    fi
    #yum install -y epel-release && \
    #rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    #rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
    yum install -y simplescreenrecorder;
}

#if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#    [[ -n $(apt list --installed | grep -i ^simplescreenrecorder) ]] || apt install -y simplescreenrecorder;
#elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#    install_ssr_rpm;
#fi
# ==============================================================================


# vlc ==========================================================================
function install_vlc_rpm()
{
    if [[ -n $(yum list installed | grep -i ^vlc) ]]; then
        return
    fi    
    #yum install -y epel-release && \
    #rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    #rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
    yum install -y vlc;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^vlc) ]] || apt install -y vlc;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    install_vlc_rpm;
fi
# ==============================================================================


# virtualbox ===================================================================
function install_vbox_deb()
{
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return
    fi
    
    local REPO_PATH="/etc/apt/sources.list";
    local REPO_CMD=$(cat ${REPO_PATH});
    local VBOX_REPO_CMD="deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bullseye contrib";

    if [[ -e ${REPO_PATH} ]] && [[ *"${REPO_CMD}"* != *"${VBOX_REPO_CMD}"* ]]; then
        echo "" >> ${REPO_PATH};
        echo "${VBOX_REPO_CMD}" >> ${REPO_PATH};
    fi
    wget -O- "https://www.virtualbox.org/download/oracle_vbox_2016.asc" | gpg --yes --output "/usr/share/keyrings/oracle-virtualbox-2016.gpg" --dearmor;
    apt update;
    apt install -y virtualbox-7.0;
}

function install_vbox_ubu20()
{
    if [[ -n $(apt list --installed | grep -i ^virtualbox) ]]; then
        return
    fi

    local NAME="virtualbox";
    local TMP_DIR= "/tmp/${NAME}";
    
    
    local URL1="https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb";
    local FNAME1="virtualbox-7.0_7.0.18-162988~Ubuntu~focal_amd64.deb";
    
    local URL2="https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack";
    local FNAME2="Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack";
       
    if [[ ! -e ${TMP_DIR}/${FNAME1} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL1} -O ${TMP_DIR}/${FNAME1};
        wget ${URL2} -O ${TMP_DIR}/${FNAME2};
    fi

    apt install -y ${TMP_DIR}/${FNAME1};
}

function install_vbox_rpm()
{
    if [[ -n $(yum list installed | grep -i ^virtualbox) ]]; then
        return
    fi

    local NAME="virtualbox";
    local TMP_DIR= "/tmp/${NAME}";
    
    local URL1="https://download.virtualbox.org/virtualbox/7.0.18/VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm";
    local FNAME1="VirtualBox-7.0-7.0.18_162988_el7-1.x86_64.rpm";
    
    local URL2="https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack";
    local FNAME2="Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack";
       
    if [[ ! -e ${TMP_DIR}/${FNAME1} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL1} -O ${TMP_DIR}/${FNAME1};
        wget ${URL2} -O ${TMP_DIR}/${FNAME2};
    fi

    yum localinstall -y ${TMP_DIR}/${FNAME1};
}

#if [[ *"${CUR_VER}"* == *"debian"* ]]; then
#    install_vbox_deb;
#elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#    install_vbox_ubu20;
#elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#    install_vbox_rpm;
#fi
# ==============================================================================


# anydesk ======================================================================
function install_anydesk_deb()
{
    if [[ -n $(apt list --installed | grep -i ^anydesk) ]]; then
        return
    fi
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -;
    echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list;
    apt update && apt install -y anydesk;
}

function install_anydesk_rpm1()
{
    if [[ -n $(yum list installed | grep -i ^anydesk) ]]; then
        return
    fi
    
    local NAME="anydesk";
    local TMP_DIR= "/tmp/${NAME}";
    
    local URL="https://download.anydesk.com/linux/anydesk-6.3.2-1.el7.x86_64.rpm";
    local FNAME="anydesk-6.3.2-1.el7.x86_64.rpm";
          
    if [[ ! -e ${TMP_DIR}/${FNAME} ]]; then
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
        wget ${URL} -O ${TMP_DIR}/${FNAME};
    fi

    yum localinstall -y ${TMP_DIR}/${FNAME};
}

function install_anydesk_rpm2()
{
    # repo error : not working!!!
    if [[ -n $(yum list installed | grep -i ^anydesk) ]]; then
        return
    fi
    local REPO_CMD="[anydesk]
name=AnyDesk CentOS - stable
baseurl=http://rpm.anydesk.com/centos/$releasever/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY";

    local REPO_PATH="/etc/yum.repos.d/AnyDesk-CentOS.repo";
    
    echo "${REPO_CMD}" > ${REPO_PATH};
    yum install -y anydesk;
}


#if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#    install_anydesk_deb;
#elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#    install_anydesk_rpm1;
#    #install_anydesk_rpm2;
#fi
# ==============================================================================


# xnview =======================================================================
# flatpak run com.xnview.XnViewMP
#[[ -n $(flatpak list --app | grep -i xnview) ]] || flatpak install -y flathub com.xnview.XnViewMP;
# ==============================================================================

