#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/gui/install_doublecmd.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/gui
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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
APP_NAME="doublecmd";

# doublecmd
APP_UNIQUE_NAME="${APP_NAME}"

# /tmp/doublecmd
TMP_DIR="/tmp/${APP_NAME}";

# /opt/doublecmd
OPT_DIR="/opt"
APP_DIR="${OPT_DIR}/${APP_NAME}";

# https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz/download
APP_VER="1.1.26";

APP_ICON_URL="https://doublecmd.sourceforge.io/site/images/logo.png";

# doublecmd.png
APP_ICON_NAME="${APP_UNIQUE_NAME}.png";

APP_GRP="System;FileTools;Utility;Core;GTK;FileManager;Development"
# ------------------------------------------------------------------------------
# ==============================================================================



# file-manager : x86_64, aarch64, i686 (portable, appimage) ====================
function set_desktop()
{
    # args ---------------------------------------------------------------------
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
Categories=${APP_GRP}
Terminal=false
Encoding=UTF-8
Comment=${APP_NAME}";

    echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
}

function install_dc_for_portable()
{
    # --------------------------------------------------------------------------
    # /opt/doublecmd
    if [[ -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    # "https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz"
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${APP_VER}.gtk2.aarch64.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${APP_VER}.gtk2.i386.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2032%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        local FNAME="doublecmd-${APP_VER}.gtk2.x86_64.tar.xz";
        local SRC_URL="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 2) ZIP_PATH --------------------------------------------------------------
    if [[ ! -e "${TMP_DIR}" ]]; then
        # /tmp/doublecmd
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz
    ZIP_PATH="${TMP_DIR}/${FNAME}"

    if [[ ! -e "${ZIP_PATH}" ]]; then
        wget "${SRC_URL}" -O "${ZIP_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 3) APP_DIR ----------------------------------------------------------------
    # tar -Jxvf /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz -C /opt;
    tar -Jxvf "${ZIP_PATH}" -C ${OPT_DIR};
    rm -f "${ZIP_PATH}";

    # /opt/doublecmd
    if [[ ! -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 4) EXEC_PATH -------------------------------------------------------------
    # /opt/doublecmd/doublecmd
    local EXEC_PATH="${APP_DIR}/${APP_NAME}"
    # --------------------------------------------------------------------------

    # 5) ICON_PATH -------------------------------------------------------------
    # 5-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/doublecmd/doublecmd.png
    # local ICON_PATH="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${ICON_PATH};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 5-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/doublecmd.svg
    local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 6) DESKTOP_PATH ----------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    set_desktop;
    # --------------------------------------------------------------------------
}


function install_dc_for_appimg()
{
    # appimage for only x86_64 -------------------------------------------------
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # /opt/doublecmd
    if [[ -e "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) SRC_URL ---------------------------------------------------------------
    local FNAME="doublecmd-gtk-latest-x86_64.AppImage";

    # https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage
    local SRC_URL="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/${FNAME}";
    # --------------------------------------------------------------------------

    # 2) EXEC_PATH -------------------------------------------------------------
    # /opt/doublecmd/doublecmd-gtk-latest-x86_64.AppImage
    local EXEC_PATH="${APP_DIR}/${FNAME}"

    # /opt/doublecmd
    mkdir -p ${APP_DIR};

    wget ${SRC_URL} -O ${EXEC_PATH};
    chmod +x ${EXEC_PATH};
    # --------------------------------------------------------------------------

    # 3) ICON_PATH -------------------------------------------------------------
    # 3-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/doublecmd/doublecmd.png
    # local ICON_PATH="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${ICON_PATH};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 3-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/doublecmd.svg
    local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 4) DESKTOP_PATH ----------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    set_desktop;
    # --------------------------------------------------------------------------
}


function install_doublecmd_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="doublecmd"

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

    # 3) install_doublecmd -----------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.doublecmd
    # nix profile add nixpkgs#doublecmd
    su - ${CUR_USER} -c "source ${DST_PATH} && \
    nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
    nix profile add nixpkgs#${APP_NAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${mod}"* == *"multi"* ]]; then
        return
    fi
    # return
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "doublecmd" \
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

    # 5) icon settngs1 ---------------------------------------------------------
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

    # 5) icon settngs2 ---------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/pixmaps"
    local dst_dir="/usr/share/pixmaps"

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
    # ~/.nix-profile/share/doublecmd
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^doublecmd-qt5) ]] || pacman -S --needed --noconfirm doublecmd-qt5;
        # [[ -n $(pacman -Q | grep -i ^doublecmd-qt6) ]] || pacman -S --needed --noconfirm doublecmd-qt6;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^doublecmd-qt) ]] || apt install -y doublecmd-qt;
        else
            [[ -n $(apt list --installed | grep -i ^doublecmd-gtk) ]] || apt install -y doublecmd-gtk;
        fi
        # ----------------------------------------------------------------------
        # install_doublecmd_for_nix "multi";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "doublecmd is not supported for RHEL"

        install_doublecmd_for_nix "single";
        # ----------------------------------------------------------------------
        # if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        #     install_dc_for_portable;
        # elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        #     install_dc_for_portable;
        # else                        # x86_64
        #     install_dc_for_portable;
        #     # install_dc_for_appimg;
        # fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            # qt5
            [[ -n $(dnf list --installed | grep -i ^doublecmd-qt) ]] || dnf install -y doublecmd-qt;

            # qt6
            # [[ -n $(dnf list --installed | grep -i ^doublecmd-qt6) ]] || dnf install -y doublecmd-qt6;
        else
            [[ -n $(dnf list --installed | grep -i ^doublecmd-gtk) ]] || dnf install -y doublecmd-gtk;
        fi
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================


