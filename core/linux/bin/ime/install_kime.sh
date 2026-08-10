#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_kime.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime
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

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="kime"

# com.github.riey.kime
APP_UNIQUE_NAME="com.github.riey.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false";

APP_VER="v3.1.1"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_kime_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    local cmd='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS="@im=kime"
# ------------------------------------------------------------------------------
'
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${APP_NAME}" "${cmd}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function set_kime_autostart()
{
    # args ---------------------------------------------------------------------
    # ${ICON_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="sh -c 'kime-xdg-autostart'"

    # local icon_path="/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    # local icon_path="/usr/local/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    local icon_path="kime-hangul-black";

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function set_kime_hotkey()
{
    # args ---------------------------------------------------------------------
    # ${SRC_HOTKEY_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # local SRC_HOTKEY_PATH="/usr/share/doc/kime/default_config.yaml";
    # local SRC_HOTKEY_PATH="~/.nix-profile/share/doc/kime/default_config.yaml";

    # ~/.config/kime/config.yaml
    local dst_hotkey_dir="${HOME_DIR}/.config/kime";
    local dst_hotkey_path="${dst_hotkey_dir}/config.yaml";
    local tmp_hotkey_path="${dst_hotkey_dir}/tmp.yaml";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f ${SRC_HOTKEY_PATH} ]]; then
        return 0
    fi

    su - ${CUR_USER} -c "[[ -d ${dst_hotkey_dir} ]] || mkdir -p ${dst_hotkey_dir}";
    su - ${CUR_USER} -c "[[ -f ${dst_hotkey_path} ]] || cp -f ${SRC_HOTKEY_PATH} ${dst_hotkey_path}";

    su - ${CUR_USER} -c "sed 's/Super-Space/S-Space/g' ${dst_hotkey_path} > ${tmp_hotkey_path}";
    su - ${CUR_USER} -c "mv -f ${tmp_hotkey_path} ${dst_hotkey_path}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for gnome, cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        [[ -n $(yay -Q | grep -i ^kime) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm kime-bin";
        # [[ -n $(yay -Q | grep -i ^kime) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm kime-git";
        # [[ -n $(yay -Q | grep -i ^kime) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm kime";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^kime) ]]; then
            # ------------------------------------------------------------------
            # https://github.com/Riey/kime/releases/download/v3.1.1/kime_debian-buster_v3.1.1_amd64.deb
            TMP_URL="https://github.com/Riey/kime/releases/download/${APP_VER}/kime_debian-buster_${APP_VER}_amd64.deb"
            TMP_PATH="/tmp/kime.deb"
            wget "${TMP_URL}" -O "${TMP_PATH}";
            apt install -y ${TMP_PATH};
            # ------------------------------------------------------------------
            set_kime_env
            # ------------------------------------------------------------------
            # ICON_PATH="/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
            # ICON_PATH="kime-hangul-black.png";
            set_kime_autostart;
            # ------------------------------------------------------------------
            SRC_HOTKEY_PATH="/usr/share/doc/kime/default_config.yaml";
            set_kime_hotkey;
            # ------------------------------------------------------------------
        fi

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^kime) ]]; then
            # ------------------------------------------------------------------
            # https://github.com/Riey/kime/releases/download/v3.1.1/kime_ubuntu-22.04_v3.1.1_amd64.deb
            TMP_URL="https://github.com/Riey/kime/releases/download/${APP_VER}/kime_ubuntu-22.04_${APP_VER}_amd64.deb"
            TMP_PATH="/tmp/kime.deb"
            wget "${TMP_URL}" -O "${TMP_PATH}";
            apt install -y ${TMP_PATH};
            # ------------------------------------------------------------------
            set_kime_env
            # ------------------------------------------------------------------
            # ICON_PATH="/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
            # ICON_PATH="kime-hangul-black.png";
            set_kime_autostart;
            # ------------------------------------------------------------------
            SRC_HOTKEY_PATH="/usr/share/doc/kime/default_config.yaml";
            set_kime_hotkey;
            # ------------------------------------------------------------------
        fi

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        if [[ -z $(nix-env -q | grep -i ^${APP_NAME}) ]]; then
            # ------------------------------------------------------------------
            source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
            install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
            # ------------------------------------------------------------------
            set_kime_env
            # ------------------------------------------------------------------
            # ICON_PATH="/usr/local/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
            # ICON_PATH="kime-hangul-black.png";
            set_kime_autostart;
            # ------------------------------------------------------------------
            SRC_HOTKEY_PATH="${HOME_DIR}/.nix-profile/share/doc/kime/default_config.yaml";
            set_kime_hotkey;
            # ------------------------------------------------------------------
        fi
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================
