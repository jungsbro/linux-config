#!/bin/bash

# skippy-xd ====================================================================
# bash /core/linux/bin/system/install_skippy-xd.sh;
# ==============================================================================

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# skippy-xd : x86_64, aarch64 ==================================================
function install_skippy-xd()
{
    # --------------------------------------------------------------------------
    if [[ -e "/usr/bin/skippy-xd" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # checking "Development Tools" ---------------------------------------------
    if [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        local GRP_LIST=$(dnf grouplist --installed);
        local GRP_NAME="Development Tools";
        
        [[ *"${GRP_LIST}"* == *"${GRP_NAME}"* ]] || dnf groupinstall -y "${GRP_NAME}";
    fi
    # --------------------------------------------------------------------------

    # checking TMP_DIR ---------------------------------------------------------
    local TMP_DIR="/core/linux/src";
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------
    
    # compile skippy-xd --------------------------------------------------------
    cd ${TMP_DIR}
    git clone https://github.com/dreamcat4/skippy-xd.git
    cd skippy-xd

    make
    make install
    # --------------------------------------------------------------------------
}

# ------------------------------------------------------------------------------
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^libimlib2-dev) ]] || apt install -y libimlib2-dev;
    [[ -n $(apt list --installed | grep -i ^libfontconfig1-dev) ]] || apt install -y libfontconfig1-dev;
    [[ -n $(apt list --installed | grep -i ^libfreetype6-dev) ]] || apt install -y libfreetype6-dev;
    [[ -n $(apt list --installed | grep -i ^libx11-dev) ]] || apt install -y libx11-dev;
    [[ -n $(apt list --installed | grep -i ^libxext-dev) ]] || apt install -y libxext-dev;
    [[ -n $(apt list --installed | grep -i ^libxft-dev) ]] || apt install -y libxft-dev;
    [[ -n $(apt list --installed | grep -i ^libxrender-dev) ]] || apt install -y libxrender-dev;
    [[ -n $(apt list --installed | grep -i ^zlib1g-dev) ]] || apt install -y zlib1g-dev;
    [[ -n $(apt list --installed | grep -i ^libxinerama-dev) ]] || apt install -y libxinerama-dev;
    [[ -n $(apt list --installed | grep -i ^libxcomposite-dev) ]] || apt install -y libxcomposite-dev;
    [[ -n $(apt list --installed | grep -i ^libxdamage-dev) ]] || apt install -y libxdamage-dev;
    [[ -n $(apt list --installed | grep -i ^libxfixes-dev) ]] || apt install -y libxfixes-dev;
    [[ -n $(apt list --installed | grep -i ^libxmu-dev) ]] || apt install -y libxmu-dev;
    # --------------------------------------------------------------------------    
    install_skippy-xd;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^nux-dextop) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(yum list installed | grep -i ^skippy-xd) ]] || yum install -y skippy-xd;
    # --------------------------------------------------------------------------
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^imlib2-devel) ]] || dnf install -y imlib2-devel;
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^fontconfig-devel) ]] || dnf install -y fontconfig-devel;
    [[ -n $(dnf list installed | grep -i ^freetype-devel) ]] || dnf install -y freetype-devel;
    [[ -n $(dnf list installed | grep -i ^libX11-devel) ]] || dnf install -y libX11-devel;
    [[ -n $(dnf list installed | grep -i ^libXext-devel) ]] || dnf install -y libXext-devel;
    [[ -n $(dnf list installed | grep -i ^libXft-devel) ]] || dnf install -y libXft-devel;
    [[ -n $(dnf list installed | grep -i ^libXrender-devel) ]] || dnf install -y libXrender-devel;
    [[ -n $(dnf list installed | grep -i ^zlib-devel) ]] || dnf install -y zlib-devel;
    [[ -n $(dnf list installed | grep -i ^libXinerama-devel) ]] || dnf install -y libXinerama-devel;
    [[ -n $(dnf list installed | grep -i ^libXcomposite-devel) ]] || dnf install -y libXcomposite-devel;
    [[ -n $(dnf list installed | grep -i ^libXdamage-devel) ]] || dnf install -y libXdamage-devel;
    [[ -n $(dnf list installed | grep -i ^libXfixes-devel) ]] || dnf install -y libXfixes-devel;
    [[ -n $(dnf list installed | grep -i ^libXmu-devel) ]] || dnf install -y libXmu-devel;
    [[ -n $(dnf list installed | grep -i ^libjpeg-turbo-devel) ]] || dnf install -y libjpeg-turbo-devel;
    # --------------------------------------------------------------------------
    [[ -n $(dnf repolist | grep -i ^crb) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^giflib-devel) ]] || dnf install -y giflib-devel;
    # --------------------------------------------------------------------------
    install_skippy-xd;
    # --------------------------------------------------------------------------
fi
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0