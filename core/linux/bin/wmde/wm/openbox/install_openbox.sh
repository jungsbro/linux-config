#!/bin/bash

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

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    # /etc/xrdp/openbox/

    local src_dir="${CUR_DIR}/config";

    local dst_dir="${HOME_DIR}/.config/openbox";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${dst_dir}" ]]; then
        return;
    fi

    su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${src_dir}" ]]; then
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


function fix_xrdp-startwm_for_ob()
{
    # --------------------------------------------------------------------------
    local dst_path="/usr/libexec/xrdp/startwm-bash.sh"

    local search_str='#!/usr/bin/bash -l'
    local append_str='exec /usr/bin/openbox-session'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f "${dst_path}" ]]; then
        return
    fi
    if [[ -z $(grep -i "${search_str}" "${dst_path}") ]]; then
        return
    fi
    if [[ -n $(grep -i "${append_str}" "${dst_path}") ]]; then
        return
    fi

    sed -i "\|${search_str}|a ${append_str}" ${dst_path};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files | grep -iq xrdp; then
            systemctl restart xrdp
        fi
    else    # sysVinit
        return
    fi
    # --------------------------------------------------------------------------
}

# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^openbox) ]] || pacman -S --needed --noconfirm openbox;
        [[ -n $(pacman -Q | grep -i ^lxappearance-obconf) ]] || pacman -S --needed --noconfirm lxappearance-obconf;
        # [[ -n $(pacman -Q | grep -i ^obconf-qt) ]] || pacman -S --needed --noconfirm obconf-qt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^openbox) ]] || apt install -y openbox;
        [[ -n $(apt list --installed | grep -i ^obconf) ]] || apt install -y obconf;
        # [[ -n $(apt list --installed | grep -i ^obconf-qt) ]] || apt install -y obconf-qt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] || dnf install -y openbox;
        [[ -n $(dnf list --installed | grep -i ^obconf) ]] || dnf install -y obconf;
        # [[ -n $(dnf list --installed | grep -i ^obconf-qt) ]] || dnf install -y obconf-qt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^openbox) ]] || dnf install -y openbox;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # 방법1)
    copy_config_to_home;

    # 방법2)
    # set_hotkeys;
    # bash ${CORE_BIN_DIR}/wmde/wm/openbox/set_system_for_ob.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xrdp for openbox
    fix_xrdp-startwm_for_ob;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================



