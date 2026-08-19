#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/wm/openbox/install_openbox.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/wm/openbox
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

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="openbox"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    # /etc/xrdp/openbox/

    # ./config/openbox
    local src_dir="${CUR_DIR}/config/openbox";

    # ~/.config/openbox/*
    local dst_dir="${HOME_DIR}/.config/openbox";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${dst_dir}" ]]; then
        return 0
    fi

    su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${src_dir}" ]]; then
        # cp -rf ./config/openbox/* ~/.config/openbox
        su - ${CUR_USER} -c "cp -rf ${src_dir}/* ${dst_dir}/";
    fi
    # --------------------------------------------------------------------------
}


function set_hotkeys()
{
    bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_hotkey_app_for_ob.sh ${CUR_USER};
    bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_hotkey_window_for_ob.sh ${CUR_USER};
    bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_hotkey_workspace_for_ob.sh ${CUR_USER};
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="openbox"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="lxappearance-obconf"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="obconf-qt"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="openbox"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="obconf"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # local app_name="obconf-qt"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="openbox"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="obconf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # local app_name="obconf-qt"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] || dnf install -y openbox;

        local app_name="openbox"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # 방법1)
    copy_config_to_home;

    # 방법2)
    # set_hotkeys;
    # bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_system_for_ob.sh ${CUR_USER};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================