#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ide/install_vim.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ide
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
TMP_DIR="/tmp";

# /tmp/vim-config
CONFIG_DIR="/${TMP_DIR}/vim-config";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_vim()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="vim"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xclip"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="xsel"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="vim-gtk3"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="xclip"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="xsel"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # apt install -y ctags;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="vim-X11"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="vim-enhanced"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xclip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xsel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="vim-X11"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xclip"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xsel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}

function config_vim()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    if [[ -d "${CONFIG_DIR}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local SEL_EDIT_PATH="/${TMP_DIR}/.selected_editor";

    local SEL_EDIT_CMD="# Generated by /usr/bin/select-editor
SELECTED_EDITOR="/usr/bin/vim"";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${TMP_DIR}" ]] || mkdir -p "${TMP_DIR}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - "${CUR_USER}" -c "git clone https://github.com/jungsbro/vim-config.git ${CONFIG_DIR}";
    su - "${CUR_USER}" -c "echo \"${SEL_EDIT_CMD}\" > ${SEL_EDIT_PATH}";
    # --------------------------------------------------------------------------

    # for user -----------------------------------------------------------------
    su - "${CUR_USER}" -c "cp -Rf ${CONFIG_DIR}/.vim ~/";
    su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.vimrc ~/.vimrc_full";
    su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.vimrc_simple ~/.vimrc_simple";
    su - "${CUR_USER}" -c "cp -f ${CONFIG_DIR}/.vimrc ~/.vimrc";
    su - "${CUR_USER}" -c "cp -f ${SEL_EDIT_PATH} ~/.selected_editor";
    # --------------------------------------------------------------------------

    # for root -----------------------------------------------------------------
    if [[ "${CUR_USER}" != "root" ]]; then
        cp -Rf "${CONFIG_DIR}/.vim" "/root/";
        cp -f "${CONFIG_DIR}/.vimrc" "/root/.vimrc_full";
        cp -f "${CONFIG_DIR}/.vimrc_simple" "/root/.vimrc_simple";
        cp -f "${CONFIG_DIR}/.vimrc_simple" "/root/.vimrc";
        cp -f "${SEL_EDIT_PATH}" "/root/.selected_editor";
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    install_vim;
    config_vim;
    # --------------------------------------------------------------------------
    # :PlugInstall
    # plugin error on centos7 : nathanaelkane/vim-indent-guides
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
