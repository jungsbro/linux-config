#!/bin/bash

# ==============================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);
CUR_ARCH=$(uname -m);
# ==============================================================================

# vscode =======================================================================
# method 1) x86_64, aarch64 ----------------------------------------------------
function install_vscode_deb()
{
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^code) ]]; then
        return
    fi

    # method 1) ----------------------------------------------------------------
    apt install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    apt install apt-transport-https
    apt update
    apt install -y code
    # --------------------------------------------------------------------------

    # method 2) ----------------------------------------------------------------
    #apt install -y software-properties-common apt-transport-https curl;
    #curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
    #add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main";
    #apt update;
    #apt install -y code;
    # --------------------------------------------------------------------------
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    install_vscode_deb;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ -n $(yum list installed | grep -i ^snapd) ]] || bash /core/linux/bin/pkgmgmt/install_snap.sh;
    [[ -n $(snap list | grep -i ^code) ]] || snap install code --classic;
fi
# ------------------------------------------------------------------------------


# method 2) x86_64, aarch64 ----------------------------------------------------
# if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#     [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
# elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#     [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
# fi
# [[ -n $(flatpak list --app | grep -i code) ]] || flatpak install -y flathub com.visualstudio.code;
# ------------------------------------------------------------------------------
# ==============================================================================

exit 0