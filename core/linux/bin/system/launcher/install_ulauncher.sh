#!/bin/bash

# ulauncher ====================================================================
# bash ${CORE_BIN_DIR}/system/launcher/install_ulauncher.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/launcher
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="ulauncher"

APP_UNIQUE_NAME="${APP_NAME}"

APP_GRP="GNOME;GTK;Utility;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function set_ulauncher_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
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
    su - ${CUR_USER} -c "[[ -d ${AUTOSTART_DIR} ]] || mkdir -p ${AUTOSTART_DIR}";
    su - ${CUR_USER} -c "[[ -f ${AUTOSTART_PATH} ]] || echo \"${AUTOSTART_CMD}\" > ${AUTOSTART_PATH}";
    # --------------------------------------------------------------------------
}


function install_ulauncher_for_apt()
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

    # --------------------------------------------------------------------------
    set_ulauncher_autostart;
    # --------------------------------------------------------------------------
}


function set_desktop()  # not used
{
    # args ---------------------------------------------------------------------
    # ${CUR_USER}
    # ${APP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}";

    if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
        # ~/.local/share/applications/ulauncher.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/ulauncher.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}


function install_ulauncher_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="ulauncher"

    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        # multi-user
        local DST_PATH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
    else
        # single-user
        local DST_PATH="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
    fi
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_ulauncher -----------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.ulauncher
    # nix profile add nixpkgs#ulauncher
    su - ${CUR_USER} -c "source ${DST_PATH} && \
    nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
    nix profile add nixpkgs#${APP_NAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ *"${mod}"* == *"multi"* ]]; then
    #     return
    # fi
    return
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "ulauncher" \
    "ulauncher-toggle" \
    )

    local src_dir="${HOME_DIR}/.nix-profile/bin"
    local dst_dir="${HOME_DIR}/.local/bin"

    for cur_fname in "${FNAME_LIST[@]}";
    do
        src_path="${src_dir}/${cur_fname}";
        if [[ ! -f ${src_path} ]]; then
            continue
        fi

        dst_path="${dst_dir}/${cur_fname}";
        if [[ -f ${dst_path} ]]; then
            continue
        fi

        ln -s ${src_path} ${dst_path};
    done
    # --------------------------------------------------------------------------

    # 5) icon settngs ----------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/icons"
    local dst_dir="/usr/share/icons"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -r : recursive
        # -u : update
        cp -ru ${src_dir}/* "${dst_dir}/"

        gtk-update-icon-cache "${dst_dir}" 2>/dev/null
    fi
    # --------------------------------------------------------------------------

    # 6) desktop settings ------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/applications"
    local dst_dir="${HOME_DIR}/.local/share/applications"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -u : update
        # -L : dereference
        cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

        update-desktop-database "${dst_dir}"
    fi
    # --------------------------------------------------------------------------

    # 7) etc -------------------------------------------------------------------
    # ~/.nix-profile/share/ulauncher
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_ulauncher_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_ulauncher_for_nix "single";
        # ----------------------------------------------------------------------
        #     ** (ulauncher:3579): WARNING **: 23:52:10.794: Binding '<Primary>space' failed!
        # XPCOMGlueLoad error for file /opt/firefox/libmozgtk.so:
        # /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.38' not found (required by /nix/store/pahwl2rq51dmwrn8czks27yy3sa3byg9-libX11-1.8.12/lib/libX11.so.6)
        # Couldn't load XPCOM.
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^ulauncher) ]] || dnf install -y ulauncher;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^ulauncher) ]] || su - ${CUR_USER} -c "yay -S --noconfirm ulauncher";
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
