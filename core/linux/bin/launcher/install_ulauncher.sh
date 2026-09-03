#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/launcher/install_ulauncher.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/launcher
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="ulauncher"

APP_CAT="GNOME;GTK;Utility;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_ulauncher_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local AUTOSTART_DIR="${HOME_DIR}/.config/autostart"
    local AUTOSTART_PATH="${AUTOSTART_DIR}/ulauncher.desktop"

    local AUTOSTART_CMD="[Desktop Entry]
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
    su - "${CUR_USER}" -c "[[ -d ${AUTOSTART_DIR} ]] || mkdir -p ${AUTOSTART_DIR}";
    su - "${CUR_USER}" -c "[[ -f ${AUTOSTART_PATH} ]] || echo \"${AUTOSTART_CMD}\" > ${AUTOSTART_PATH}";
    # --------------------------------------------------------------------------
}


function install_ulauncher_for_apt()
{
    local GPG_PATH="/usr/share/keyrings/ulauncher-archive-keyring.gpg"

    # --------------------------------------------------------------------------
    if [[ -f "${GPG_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update;
    [[ -n $(apt list --installed | grep -i ^gnupg) ]] || apt install -y gnupg;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176;
    gpg --export 0xfaf1020699503176 | tee "${GPG_PATH}" >/dev/null;

    echo "deb [signed-by=${GPG_PATH}] \
              http://ppa.launchpad.net/agornostal/ulauncher/ubuntu jammy main" \
              | tee /etc/apt/sources.list.d/ulauncher-jammy.list;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update;
    [[ -n $(apt list --installed | grep -i ^ulauncher) ]] || apt install -y ulauncher;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_ulauncher_autostart;
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_ulauncher_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) distrobox를 사용한다.
        # echo "ulauncher is not avialable on RHEL"

        # 방법2) nixpkg
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------
        #     ** (ulauncher:3579): WARNING **: 23:52:10.794: Binding '<Primary>space' failed!
        # XPCOMGlueLoad error for file /opt/firefox/libmozgtk.so:
        # /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.38' not found (required by /nix/store/pahwl2rq51dmwrn8czks27yy3sa3byg9-libX11-1.8.12/lib/libX11.so.6)
        # Couldn't load XPCOM.
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================