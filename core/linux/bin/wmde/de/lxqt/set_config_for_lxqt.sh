#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_config_for_lxqt.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/lxqt
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

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
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    local src_conf_dir="${CUR_DIR}/config";
    local dst_conf_dir="${HOME_DIR}/.config/lxqt";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -d ${src_conf_dir} ]]; then
        return
    fi
    if [[ ! -d ${dst_conf_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_conf_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "cp -rf ${src_conf_dir}/* ${dst_conf_dir}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_hotkey_for_xfwm4.sh;
    copy_config_to_home;
    # bash ${CORE_BIN_DIR}/wmde/de/lxqt/set_panel_for_lxqt.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # source ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh && set_terminal;
    # source ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh && set_noti;
    # source ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh && set_screensaver_lock;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then  # mxlinux
    #     source ${CORE_BIN_DIR}/wmde/de/lxqt/set_theme_for_lxqt.sh && set_desktop;
    #     source ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh && set_thunar;
    # else
    #     source ${CORE_BIN_DIR}/wmde/de/lxqt/set_theme_for_lxqt.sh && set_theme;
    #     # source ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh && set_default_app ${CUR_USER};
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ *"${CUR_VER}"* == *"Rocky"* ]]; then  # rocky
    #     # source ${CORE_BIN_DIR}/wmde/de/lxqt/set_system_for_lxqt.sh && fix_sound_disabled;
    #     echo ""
    # fi
    # --------------------------------------------------------------------------
fi
# ==============================================================================

