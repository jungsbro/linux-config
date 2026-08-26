#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/remote/cli/install_ssh.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/remote/cli
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PROTOCOL="tcp";

PORT="2222";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function fix_ssh-port()
{
    local dst_path="/etc/ssh/sshd_config";

    # local search_str='^#?\s*Port\s+[0-9]+'
    local search_str='^#Port 22'

    local replace_str="Port ${PORT}"


    if [[ ! -f "${dst_path}" ]]; then
        return 0
    fi
    if [[ -z $(grep "${search_str}" "${dst_path}") ]]; then
        return 0
    fi

    # sed -i "s|^#Port 22|Port 2222|" "/etc/ssh/sshd_config";
    sed -i "s|${search_str}|${replace_str}|" "${dst_path}";
}


function restart_sshd()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv sshd && restart_sv sshd;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv ssh && restart_sv ssh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv sshd && restart_sv sshd;
        # ----------------------------------------------------------------------
    fi
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="openssh"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="openssh-server"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="openssh-server"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="openssh-server"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # allow ssh-port
    fix_ssh-port;
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_firewall "${PROTOCOL}" "${PORT}";
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_selinux "ssh_port" "${PROTOCOL}" "${PORT}";

    # restart sshd
    restart_sshd;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================