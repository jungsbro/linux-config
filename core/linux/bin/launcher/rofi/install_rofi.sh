#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/launcher/rofi/install_rofi.sh "${CUR_USER}";

# usage ------------------------------------------------------------------------
# rofi -show drun
# rofi -show drun -show-icons
# /usr/bin/rofi -show drun -theme "~/.config/rofi/themes/j_launcher.rasi"

# rofi -show window -show-icons
# rofi -show window -show-icons -window-format '{w} {c} {t}' -theme-str 'window {width: 40%;}'
# rofi -show window -theme "expose"
# rofi -show window -theme "~/.config/rofi/expose.rasi"

# rofi-theme-selector
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/launcher/rofi
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="rofi"
APP_CAT="System;Utility;"

SRC_ROFI_CONF_DIR="${CUR_DIR}/config"

# ~/.config/rofi
DST_ROFI_CONF_DIR="${HOME_DIR}/.config/rofi"
# ~/.config/rofi/config.rasi
DST_ROFI_CONF_PATH="${DST_ROFI_CONF_DIR}/config.rasi"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_scripts_for_obrc()   # not used
{
    # --------------------------------------------------------------------------
    local dst_dir="${HOME_DIR}/.local/bin"
    local expose_path="${dst_dir}/expose.sh"
    local launcher_path="${dst_dir}/launcher.sh"

    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}"
    fi
    if [[ -f "${expose_path}" ]]; then
        return 0
    fi
    if [[ -f "${launcher_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local expose_cmd='#!/bin/bash
export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive && rofi -show window -theme "~/.config/rofi/themes/j_launcher.rasi"
'
    local launcher_cmd='#!/bin/bash
export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive && rofi -show drun -theme "~/.config/rofi/themes/j_launcher.rasi"
'
    su - "${CUR_USER}" -c "echo \"${expose_cmd}\" > ${expose_path}";
    su - "${CUR_USER}" -c "echo \"${launcher_cmd}\" > ${launcher_path}";

    chmod +x "${expose_path}";
    chmod +x "${launcher_path}";
    # --------------------------------------------------------------------------
}


function fix_paths_for_obrc()   # not used
{
    # --------------------------------------------------------------------------
    local dst_dir="${HOME_DIR}/.config/openbox"
    local obrc_path="${dst_dir}/rc.xml"

    if [[ ! -f "${obrc_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local src_expose_cmd="rofi -show window -theme '~/.config/rofi/themes/j_launcher.rasi'"
    # ${HOME_DIR}/.local/bin/expose.sh
    local dst_expose_cmd="expose.sh"

    local src_launcher_cmd="rofi -show drun -theme '~/.config/rofi/themes/j_launcher.rasi'"
    # ${HOME_DIR}/.local/bin/launcher.sh
    local dst_launcher_cmd="launcher.sh"

    sed -i "s|${src_expose_cmd}|${dst_expose_cmd}|g" "${obrc_path}"
    sed -i "s|${src_launcher_cmd}|${dst_launcher_cmd}|g" "${obrc_path}"
    # --------------------------------------------------------------------------
}


function create_rofi-config()
{
    # --------------------------------------------------------------------------
    if [[ -f "${DST_ROFI_CONF_PATH}" ]]; then
        return 0
    fi
    if [[ ! -d "${DST_ROFI_CONF_DIR}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${DST_ROFI_CONF_DIR}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local config_cmd='
/* theme : Arc-Dark.rasi */
@theme "/usr/share/rofi/themes/Arc-Dark.rasi"

configuration {
    modi: "window,drun,run";

    /* 창 옆에 프로그램 아이콘 띄우기 */
    show-icons: true;

    /* 1. 전체 기본 폰트 크기 시원하게 키우기 (원하는 폰트명과 크기 지정) */
    font: "Noto Sans CJK KR 16";

    /* 2. 마우스 싱글 클릭으로 즉시 창 전환되게 만드는 마법의 꼼수 옵션 */
    me-select-entry: "";
    me-accept-entry: "MousePrimary";
}

/* 3. 만약 아이콘만 '독단적으로' 더 거대하게 키우고 싶다면 파일 맨 밑에 추가 */
element-icon {
   size: 1.5em; /* 기본값(보통 1~1.5em)보다 훨씬 큼직하게 아이콘 크기 강제 고정 */
}
'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # su - "${CUR_USER}" -c "echo ${config_cmd} > ${DST_ROFI_CONF_PATH}";
    printf '%b\n' "${config_cmd}" | sudo -u "${CUR_USER}" tee "${DST_ROFI_CONF_PATH}" > /dev/null;
    # --------------------------------------------------------------------------
}


function copy_rofi-config_to_home()
{
    # --------------------------------------------------------------------------
    if [[ ! -d "${SRC_ROFI_CONF_DIR}" ]]; then
        return 0
    fi
    if [[ ! -d "${DST_ROFI_CONF_DIR}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${DST_ROFI_CONF_DIR}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # -r : recursive
    # -u : update
    su - "${CUR_USER}" -c "cp -ru ${SRC_ROFI_CONF_DIR}/* ${DST_ROFI_CONF_DIR}/"
    # --------------------------------------------------------------------------
}


function fix_rofi-themes_for_nix()
{
    # --------------------------------------------------------------------------
    local src_theme_path="/usr/share/rofi/themes/Arc-Dark.rasi"
    local dst_theme_path="${HOME_DIR}/.nix-profile/share/rofi/themes/Arc-Dark.rasi"

    local dst_config_dir="${HOME_DIR}/.config/rofi/themes"
    local dst_config_path="${dst_config_dir}/j_launcher.rasi"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f "${dst_theme_path}" ]]; then
        return 0
    fi
    if [[ ! -f "${dst_config_path}" ]]; then
        return 0
    fi
    # grep "/usr/share/rofi/themes/Arc-Dark.rasi" "${HOME}/.config/rofi/themes/j_launcher.rasi"
    if [[ -z $(grep "${src_theme_path}" "${dst_config_path}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    sed -i "s|${src_theme_path}|${dst_theme_path}|g" "${dst_config_path}";
    chown "${CUR_USER}":"${CUR_USER}" "${dst_config_path}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) distrobox를 사용한다.
        # echo "rofi is not avialable on RHEL"

        # 방법2) nixpkg
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # "rofi for nix" needs glibc-locales
        # export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive
        bash ${CORE_BIN_DIR}/fonts/locale/install_locales_for_nix.sh "${CUR_USER}";
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # 방법1)
    # create_rofi-config;

    # 방법2)
    copy_rofi-config_to_home;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # only working for nix
    fix_rofi-themes_for_nix;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================

