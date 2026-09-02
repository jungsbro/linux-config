#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_kime.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="kime"

APP_CAT="Settings;System;"

APP_HIDDEN="false";

APP_VER="v3.1.1"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_kime_env()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
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
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="sh -c 'kime-xdg-autostart'"

    # "/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    # "/usr/local/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    local icon_path="kime-hangul-black";

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - "${CUR_USER}" -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function set_kime_hotkey()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # "/usr/share/doc/kime/default_config.yaml";
    # "~/.nix-profile/share/doc/kime/default_config.yaml";
    local src_hotkey_path="{1}";

    # ~/.config/kime/config.yaml
    local dst_hotkey_dir="${HOME_DIR}/.config/kime";
    local dst_hotkey_path="${dst_hotkey_dir}/config.yaml";
    local tmp_hotkey_path="${dst_hotkey_dir}/tmp.yaml";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f "${src_hotkey_path}" ]]; then
        return 0
    fi

    su - "${CUR_USER}" -c "[[ -d ${dst_hotkey_dir} ]] || mkdir -p ${dst_hotkey_dir}";
    su - "${CUR_USER}" -c "[[ -f ${dst_hotkey_path} ]] || cp -f ${SRC_HOTKEY_PATH} ${dst_hotkey_path}";

    su - "${CUR_USER}" -c "sed 's/Super-Space/S-Space/g' ${dst_hotkey_path} > ${tmp_hotkey_path}";
    su - "${CUR_USER}" -c "mv -f ${tmp_hotkey_path} ${dst_hotkey_path}";
    # --------------------------------------------------------------------------
}


function install_kime_for_arch()
{
    # --------------------------------------------------------------------------
    [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

    # 방법1)
    local app_name="kime-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

    # 방법2)
    # local app_name="kime-git"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

    # 방법3)
    # local app_name="kime"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
    # --------------------------------------------------------------------------
}


function install_kime_for_debian()
{
    # --------------------------------------------------------------------------
    if [[ -n $(apt list --installed | grep -i ^"${APP_NAME}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/Riey/kime/releases/download/v3.1.1/kime_debian-buster_v3.1.1_amd64.deb
    local tmp_url="https://github.com/Riey/kime/releases/download/${APP_VER}/kime_debian-buster_${APP_VER}_amd64.deb"
    local tmp_path="/tmp/kime.deb"
    wget "${tmp_url}" -O "${tmp_path}";
    apt install -y "${tmp_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_kime_env
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # "/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    # "kime-hangul-black.png";
    set_kime_autostart;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local src_hotkey_path="/usr/share/doc/kime/default_config.yaml";
    set_kime_hotkey "${src_hotkey_path}";
    # --------------------------------------------------------------------------
}


function install_kime_for_ubuntu()
{
    # --------------------------------------------------------------------------
    if [[ -n $(apt list --installed | grep -i ^"${APP_NAME}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # https://github.com/Riey/kime/releases/download/v3.1.1/kime_ubuntu-22.04_v3.1.1_amd64.deb
    local tmp_url="https://github.com/Riey/kime/releases/download/${APP_VER}/kime_ubuntu-22.04_${APP_VER}_amd64.deb"
    local tmp_path="/tmp/kime.deb"
    wget "${tmp_url}" -O "${tmp_path}";
    apt install -y "${tmp_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_kime_env
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # "/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    # "kime-hangul-black.png";
    set_kime_autostart;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local src_hotkey_path="/usr/share/doc/kime/default_config.yaml";
    set_kime_hotkey "${src_hotkey_path}";
    # --------------------------------------------------------------------------
}


function install_kime_for_rhel()
{
    # --------------------------------------------------------------------------
    if [[ -n $(nix-env -q | grep -i ^"${APP_NAME}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME}";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_kime_env
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # "/usr/local/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    # "kime-hangul-black.png";
    set_kime_autostart;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local src_hotkey_path="${HOME_DIR}/.nix-profile/share/doc/kime/default_config.yaml";
    set_kime_hotkey "${src_hotkey_path}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # for gnome, cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        install_kime_for_arch;

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        install_kime_for_debian;

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        install_kime_for_ubuntu;

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        install_kime_for_rhel;
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
