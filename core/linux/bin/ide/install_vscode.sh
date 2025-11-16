#!/bin/bash

# vscode =======================================================================
# bash /core/linux/bin/ide/install_vscode.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================



# method 1) x86_64, aarch64 ====================================================
function install_vscode_for_deb()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^code) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

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
    # apt install -y software-properties-common apt-transport-https curl;
    # curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
    # add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main";
    # apt update;
    # apt install -y code;
    # --------------------------------------------------------------------------
}

function install_vscode_for_rocky()
{
    # --------------------------------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(dnf list installed | grep -i ^code) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    dnf install -y code
    # --------------------------------------------------------------------------
}

function fix_vscode()
{
    old_str="/usr/share/code/code"
    new_str="/usr/bin/code"

    tmp_path="./code.desktop"
    dst_path="/usr/share/applications/code.desktop"

    grep "${old_str}" "${dst_path}" > /dev/null

    if [[ ${?} == 0 ]]; then
        sed "s|${old_str}|${new_str}|g" ${dst_path} > ${tmp_path}
        mv -f ${tmp_path} ${dst_path}
    fi
}

# ------------------------------------------------------------------------------
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_vscode_for_deb;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "CentOS not support vscode "
    # bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
        #
    # su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    # nix-env -q | grep -iq ^vscode || \
    # nix-env -iA nixpkgs.vscode"
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_vscode_for_rocky;
    # --------------------------------------------------------------------------
fi

fix_vscode;
# ==============================================================================


# method 2) x86_64, aarch64 ====================================================
# if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#     # --------------------------------------------------------------------------
#     [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
#     # --------------------------------------------------------------------------

# elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
#     # --------------------------------------------------------------------------
#     [[ -n $(yum list installed  | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
#     # --------------------------------------------------------------------------
# fi
#
# [[ -n $(flatpak list --app | grep -i code) ]] || flatpak install -y flathub com.visualstudio.code;
# ==============================================================================

exit 0
