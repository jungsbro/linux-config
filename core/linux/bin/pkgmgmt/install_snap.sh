#!/bin/bash

# snap =========================================================================
# bash ${BIN_DIR}/pkgmgmt/install_snap.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function install_snapd_for_apt()
{
    # --------------------------------------------------------------------------
    if [[ -n $(apt list --installed | grep -i ^snapd) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # for linuxmint ------------------------------------------------------------
    local SRC_PATH="/etc/apt/preferences.d/nosnap.pref"

    local DST_DIR="~/Documents"

    # ~/Documents/nosnap.backup
    local DST_PATH="${DST_DIR}/nosnap.backup"

    # /etc/apt/preferences.d/nosnap.pref
    if [[ -e ${SRC_PATH} ]]; then

        # ~/Documents/nosnap.backup
        [[ -e ${DST_DIR} ]] || mkdir -p ${DST_DIR};

        mv ${SRC_PATH} ${DST_DIR};
        apt update;
    fi
    # --------------------------------------------------------------------------

    apt install -y snapd;

    init 6;
}


function install_snapd_for_dnf()
{
    # --------------------------------------------------------------------------
    if [[ -n $(dnf list --installed | grep -i ^snapd) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
    dnf install -y snapd;

    systemctl enable --now snapd.socket;

    ln -s /var/lib/snapd/snap /snap;

    init 6;
    # --------------------------------------------------------------------------
}


function install_snapd_for_pacman()
{
    # --------------------------------------------------------------------------
    if [[ -n $(pacman -Q | grep -i ^snapd) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 방법1) --------------------------------------------------------------------
    # 1) base-devel / git
    [[ -n $(pacman -Q | grep -i ^base-devel) ]] || pacman -S --noconfirm base-devel;
    [[ -n $(pacman -Q | grep -i ^git) ]] || pacman -S --noconfirm git;

    # 2) snapd for aur
    git clone https://aur.archlinux.org/snapd.git /tmp/snapd

    # -s : 의존성 패키지를 자동으로 설치
    # -i : 빌드 완료 후 패키지를 설치
    bash -c 'cd /tmp/snapd && makepkg -si --noconfirm'
    rm -rf /tmp/snapd

    # 3) snapd.socket >> important
    systemctl enable --now snapd.socket;

    # 4) for classic sanp
    ln -s /var/lib/snapd/snap /snap;
    # --------------------------------------------------------------------------

    # 방법2) --------------------------------------------------------------------
    # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
    # [[ -n $(yay -Q | grep -i ^snapd) ]] || su - ${CUR_USER} -c "yay -S --noconfirm snapd";

    # sudo systemctl enable --now snapd.socket
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    init 6;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_snapd_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_snapd_for_dnf;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_snapd_for_pacman;
        # ----------------------------------------------------------------------
    fi

    # [[ -n $(snap list | grep -i ^core) ]] || snap install core;

fi
# ==============================================================================
