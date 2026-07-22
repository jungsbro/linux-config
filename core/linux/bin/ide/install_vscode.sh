#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ide/install_vscode.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ide
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="vscode"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_vscode_for_apt()
{
    # --------------------------------------------------------------------------
    # for x86_64, aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(apt list --installed | grep -i ^code) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # method 1) ----------------------------------------------------------------
    apt install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    apt install -y apt-transport-https
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


function install_vscode_for_dnf()
{
    # --------------------------------------------------------------------------
    # for x86_64, aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    if [[ -n $(dnf list --installed | grep -i ^code.x86) ]]; then   # because of codec2
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # -e : enable interpretation of backslash escapes
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    dnf install -y code
    # --------------------------------------------------------------------------
}


function install_vscode_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(flatpak list --app | grep -i code) ]] || flatpak install -y flathub com.visualstudio.code;
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
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) opensource (without telemetry)
        # [[ -n $(pacman -Q | grep -i ^code) ]] || pacman -S --needed --noconfirm code;

        # 방법2) official microsoft
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^visual-studio-code-bin) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm visual-studio-code-bin";

        # 방법3) opensource (disable telemetry)
        # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # [[ -n $(yay -Q | grep -i ^vscodium-bin) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm vscodium-bin";
        # [[ -n $(yay -Q | grep -i ^vscodium-bin-marketplace) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm vscodium-bin-marketplace";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # vscode needs gnome-keyring
        install_vscode_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # vscode needs gnome-keyring
        install_vscode_for_dnf;
        # ----------------------------------------------------------------------
    fi

    # fix_vscode;
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================