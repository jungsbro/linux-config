#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/pkgmgmt/install_snap.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="snapd";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_snapd_for_pacman()
{
    # --------------------------------------------------------------------------
    if [[ -n $(pacman -Q | grep -i ^snapd) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # 방법1) --------------------------------------------------------------------
    # 1) base-devel / git
    local app_name="base-devel"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    local app_name="git"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    # 2) snapd for aur
    git clone https://aur.archlinux.org/snapd.git /tmp/snapd

    # -s : 의존성 패키지를 자동으로 설치
    # -i : 빌드 완료 후 패키지를 설치
    bash -c 'cd /tmp/snapd && makepkg -si --noconfirm --needed'
    rm -rf /tmp/snapd

    # 3) snapd.socket >> important
    systemctl enable --now snapd.socket;

    # 4) for classic sanp
    ln -s /var/lib/snapd/snap /snap;
    # --------------------------------------------------------------------------

    # 방법2) --------------------------------------------------------------------
    # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # [[ -n $(yay -Q | grep -i ^snapd) ]] || su - "${CUR_USER}" -c "yay -S --noconfirm --needed snapd";

    # sudo systemctl enable --now snapd.socket
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    init 6;
    # --------------------------------------------------------------------------
}


function install_snapd_for_apt()
{
    # --------------------------------------------------------------------------
    if [[ -n $(apt list --installed | grep -i ^snapd) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # for linuxmint ------------------------------------------------------------
    local SRC_PATH="/etc/apt/preferences.d/nosnap.pref"

    local DST_DIR="~/Documents"

    # ~/Documents/nosnap.backup
    local DST_PATH="${DST_DIR}/nosnap.backup"

    # /etc/apt/preferences.d/nosnap.pref
    if [[ -e "${SRC_PATH}" ]]; then

        # ~/Documents/nosnap.backup
        [[ -e "${DST_DIR}" ]] || mkdir -p "${DST_DIR}";

        mv "${SRC_PATH}" "${DST_DIR}";
        apt update;
    fi
    # --------------------------------------------------------------------------

    local app_name="snapd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    init 6;
}


function install_snapd_for_dnf()
{
    # --------------------------------------------------------------------------
    if [[ -n $(dnf list --installed | grep -i ^snapd) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    local app_name="snapd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    systemctl enable --now snapd.socket;

    ln -s /var/lib/snapd/snap /snap;

    init 6;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_snapd_for_pacman;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_snapd_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_snapd_for_dnf;
        # ----------------------------------------------------------------------
    fi

    # [[ -n $(snap list | grep -i ^core) ]] || snap install core;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================