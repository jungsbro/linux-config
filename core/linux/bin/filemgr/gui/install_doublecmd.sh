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

APP_CAT="System;FileTools;Utility;Core;GTK;FileManager;Development"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================



# file-manager : x86_64, aarch64, i686 (portable, appimage) ====================
# function set_desktop()
# {
#     # args ---------------------------------------------------------------------
#     # ${APP_NAME}
#     # ${EXEC_PATH}
#     # ${ICON_PATH}
#     # ${APP_CAT}
#     # ${DESKTOP_PATH}
#     # --------------------------------------------------------------------------
#     local DESKTOP_CMD="[Desktop Entry]
# Type=Application
# Name=${APP_NAME}
# Exec=${EXEC_PATH}
# Icon=${ICON_PATH}
# Categories=${APP_CAT}
# Terminal=false
# Encoding=UTF-8
# Comment=${APP_NAME}";

#     echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
# }

function install_dc_for_portable()
{
    # --------------------------------------------------------------------------
    # /opt/doublecmd
    if [[ -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) src_url ---------------------------------------------------------------
    # "https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz"
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        # ----------------------------------------------------------------------
        local fname="doublecmd-${APP_VER}.gtk2.aarch64.tar.xz";
        local src_url="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    elif [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        # ----------------------------------------------------------------------
        local fname="doublecmd-${APP_VER}.gtk2.i386.tar.xz";
        local src_url="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2032%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        local fname="doublecmd-${APP_VER}.gtk2.x86_64.tar.xz";
        local src_url="https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%20${APP_VER}/${FNAME}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 2) zip_path --------------------------------------------------------------
    if [[ ! -e "${TMP_DIR}" ]]; then
        # /tmp/doublecmd
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz
    zip_path="${TMP_DIR}/${fname}"

    if [[ ! -e "${zip_path}" ]]; then
        wget "${src_url}" -O "${zip_path}";
    fi
    # --------------------------------------------------------------------------

    # 3) APP_DIR ----------------------------------------------------------------
    # tar -Jxvf /tmp/doublecmd/doublecmd-1.1.16.gtk2.x86_64.tar.xz -C /opt;
    tar -Jxvf "${zip_path}" -C ${OPT_DIR};
    rm -f "${zip_path}";

    # /opt/doublecmd
    if [[ ! -d "${APP_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 4) exec_path -------------------------------------------------------------
    # /opt/doublecmd/doublecmd
    local exec_path="${APP_DIR}/${APP_NAME}"
    # --------------------------------------------------------------------------

    # 5) icon_path -------------------------------------------------------------
    # 5-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/doublecmd/doublecmd.png
    # local icon_path="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${icon_path};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 5-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/doublecmd.svg
    # local icon_path="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    local icon_path="${APP_UNIQUE_NAME}";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 6) desktop_path ----------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    local desktop_path="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
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

    # 1) src_url ---------------------------------------------------------------
    local fname="doublecmd-gtk-latest-x86_64.AppImage";

    # https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/doublecmd-gtk-latest-x86_64.AppImage
    local src_url="https://download.opensuse.org/repositories/home:/Alexx2000/AppImage/${FNAME}";
    # --------------------------------------------------------------------------

    # 2) exec_path -------------------------------------------------------------
    # /opt/doublecmd/doublecmd-gtk-latest-x86_64.AppImage
    local exec_path="${APP_DIR}/${fname}"

    # /opt/doublecmd
    mkdir -p ${APP_DIR};

    wget ${src_url} -O ${exec_path};
    chmod +x ${exec_path};
    # --------------------------------------------------------------------------

    # 3) icon_path -------------------------------------------------------------
    # 3-1) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /opt/doublecmd/doublecmd.png
    # local icon_path="${APP_DIR}/${APP_ICON_NAME}";
    # wget ${APP_ICON_URL} -O ${icon_path};
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # 3-2) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/icons/Papirus/48x48/apps/doublecmd.svg
    # local icon_path="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
    local icon_path="${APP_UNIQUE_NAME}";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # --------------------------------------------------------------------------

    # 4) desktop_path ----------------------------------------------------------
    # /usr/share/applications/doublecmd.deskop
    local desktop_path="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}


# function install_doublecmd_for_nix()
# {
#     # for x86_64 / i686 / aarch64
#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     # 1) env-vars settings -----------------------------------------------------
#     local APP_NAME="doublecmd"

#     local mod=${1}  # multi / single

#     if [[ *"${mod}"* == *"multi"* ]]; then
#         # multi-user
#         local nix_env_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
#     else
#         # single-user
#         local nix_env_path="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
#     fi
#     # --------------------------------------------------------------------------

#     # 2) install nix -----------------------------------------------------------
#     bash ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix.sh ${CUR_USER};
#     # --------------------------------------------------------------------------

#     # 3) install_doublecmd -----------------------------------------------------
#     # https://search.nixos.org/packages
#     # nix-env -iA nixpkgs.doublecmd
#     # nix profile add nixpkgs#doublecmd
#     su - ${CUR_USER} -c "source ${nix_env_path} && \
#     nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
#     nix profile add nixpkgs#${APP_NAME}"
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     if [[ *"${mod}"* == *"multi"* ]]; then
#         return
#     fi
#     return
#     # --------------------------------------------------------------------------

#     # 4) bins settings ---------------------------------------------------------
#     local cur_fname="";

#     local FNAME_LIST=(\
#     "doublecmd" \
#     )

#     local src_dir="${HOME_DIR}/.nix-profile/bin"

#     local dst_dir="${HOME_DIR}/.local/bin"
#     if [[ ! -d ${dst_dir} ]]; then
#         su - ${CUR_USER} -c "mkdir -p ${dst_dir}"
#     fi

#     for cur_fname in "${FNAME_LIST[@]}";
#     do
#         src_path="${src_dir}/${cur_fname}";
#         if [[ ! -f ${src_path} ]]; then
#             continue
#         fi

#         dst_path="${dst_dir}/${cur_fname}";
#         if [[ -f ${dst_path} ]]; then
#             continue
#         fi

#         ln -s ${src_path} ${dst_path};
#     done
#     # --------------------------------------------------------------------------

#     # 5) icon settngs1 ---------------------------------------------------------
#     local src_dir="${HOME_DIR}/.nix-profile/share/icons"
#     local dst_dir="/usr/share/icons"

#     if [[ -d ${src_dir} ]]; then
#         mkdir -p "${dst_dir}"
#         # -r : recursive
#         # -u : update
#         cp -ru ${src_dir}/* "${dst_dir}/"

#         gtk-update-icon-cache "${dst_dir}" 2>/dev/null
#     fi
#     # --------------------------------------------------------------------------

#     # 5) icon settngs2 ---------------------------------------------------------
#     local src_dir="${HOME_DIR}/.nix-profile/share/pixmaps"
#     local dst_dir="/usr/share/pixmaps"

#     if [[ -d ${src_dir} ]]; then
#         mkdir -p "${dst_dir}"
#         # -r : recursive
#         # -u : update
#         cp -ru ${src_dir}/* "${dst_dir}/"

#         gtk-update-icon-cache "${dst_dir}" 2>/dev/null
#     fi
#     # --------------------------------------------------------------------------

#     # 6) desktop settings ------------------------------------------------------
#     local src_dir="${HOME_DIR}/.nix-profile/share/applications"
#     local dst_dir="${HOME_DIR}/.local/share/applications"

#     if [[ -d ${src_dir} ]]; then
#         su - ${CUR_USER} -c "mkdir -p \"${dst_dir}\""

#         # ----------------------------------------------------------------------
#         # -u : update
#         # -L : dereference
#         cp -u -L ${src_dir}/*.desktop "${dst_dir}/"
#         chown -R ${CUR_USER}:${CUR_USER} "${dst_dir}"
#         chmod -R 744 ${dst_dir}
#         # ----------------------------------------------------------------------

#         update-desktop-database "${dst_dir}"
#     fi
#     # --------------------------------------------------------------------------

#     # 7) etc -------------------------------------------------------------------
#     # ~/.nix-profile/share/doublecmd
#     # --------------------------------------------------------------------------
# }
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

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "doublecmd is not supported for RHEL"

        # install_doublecmd_for_nix "single";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
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
    fi

fi
# ==============================================================================


