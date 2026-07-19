#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/launcher/rofi/install_rofi.sh ${CUR_USER};

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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
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
# function install_rofi_for_nix()
# {
#     # for x86_64 / i686 / aarch64
#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     # 1) env-vars_settings -----------------------------------------------------
#     local APP_NAME="rofi"

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

#     # 3) install_rofi ----------------------------------------------------------
#     # https://search.nixos.org/packages
#     # nix-env -iA nixpkgs.rofi
#     # nix profile add nixpkgs#rofi
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
#     "rofi" \
#     "rofi-sensible-terminal" \
#     "rofi-theme-selector" \
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

#     # 5) icon settngs ----------------------------------------------------------
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
#     # ~/.nix-profile/share/rofi
#     # --------------------------------------------------------------------------
# }

function create_scripts_for_obrc()
{
    # --------------------------------------------------------------------------
    local dst_dir="${HOME_DIR}/.local/bin"
    local expose_path="${dst_dir}/expose.sh"
    local launcher_path="${dst_dir}/launcher.sh"

    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}"
    fi
    if [[ -f ${expose_path} ]]; then
        return
    fi
    if [[ -f ${launcher_path} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local expose_cmd='#!/bin/bash
export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive && rofi -show window -theme "~/.config/rofi/themes/j_launcher.rasi"
'
    local launcher_cmd='#!/bin/bash
export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive && rofi -show drun -theme "~/.config/rofi/themes/j_launcher.rasi"
'
    su - ${CUR_USER} -c "echo \"${expose_cmd}\" > ${expose_path}";
    su - ${CUR_USER} -c "echo \"${launcher_cmd}\" > ${launcher_path}";

    chmod +x ${expose_path};
    chmod +x ${launcher_path};
    # --------------------------------------------------------------------------
}


function fix_paths_for_obrc()
{
    # --------------------------------------------------------------------------
    local dst_dir="${HOME_DIR}/.config/openbox"
    local obrc_path="${dst_dir}/rc.xml"

    if [[ ! -f ${obrc_path} ]]; then
        return
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


function create_config()
{
    # --------------------------------------------------------------------------
    if [[ -f ${DST_ROFI_CONF_PATH} ]]; then
        return
    fi
    if [[ ! -d ${DST_ROFI_CONF_DIR} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${DST_ROFI_CONF_DIR}"
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
    # su - ${CUR_USER} -c "echo ${config_cmd} > ${DST_ROFI_CONF_PATH}";
    printf '%b\n' "${config_cmd}" | sudo -u ${CUR_USER} tee ${DST_ROFI_CONF_PATH} > /dev/null;
    # --------------------------------------------------------------------------
}


function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    if [[ ! -d ${SRC_ROFI_CONF_DIR} ]]; then
        return
    fi
    if [[ ! -d ${DST_ROFI_CONF_DIR} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${DST_ROFI_CONF_DIR}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # -r : recursive
    # -u : update
    su - ${CUR_USER} -c "cp -ru ${SRC_ROFI_CONF_DIR}/* ${DST_ROFI_CONF_DIR}/"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^${APP_NAME}) ]] || pacman -S --needed --noconfirm ${APP_NAME};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^${APP_NAME}) ]] || apt install -y ${APP_NAME};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^${APP_NAME}) ]] || dnf install -y ${APP_NAME};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "rofi is not supported for RHEL"

        # install_rofi_for_nix "single";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && \
        install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"

        # rofi_for_nix needs glibc-locales
        # export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive
        bash ${CORE_BIN_DIR}/fonts/install_glibc-locales.sh ${CUR_USER};
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # create_config;
    copy_config_to_home;
    # --------------------------------------------------------------------------

fi
# ==============================================================================
