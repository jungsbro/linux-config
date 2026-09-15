#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/cli/install_zsh.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/cli
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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

# /tmp/zsh-config
CONFIG_DIR="${TMP_DIR}/zsh-config";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="zsh";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_deps_for_zsh()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 버전관리
    bash ${CORE_BIN_DIR}/develop/cli/install_git.sh;

    # git 대체
    bash ${CORE_BIN_DIR}/develop/cli/install_mercurial.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fzf, ripgrep, fd-find, zoxide, fasd, plocate
    bash ${CORE_BIN_DIR}/filemgr/tools/install_find-tools.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 데이터전송
    bash ${CORE_BIN_DIR}/network/cli/install_curl.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fonts
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-powerline.sh;
    bash ${CORE_BIN_DIR}/fonts/cli/install_fonts-d2coding.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_zsh()
{
    # --------------------------------------------------------------------------
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function config_zsh()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi

    # /etc/passwd
    chsh -s /bin/zsh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${CONFIG_DIR}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d "${TMP_DIR}" ]] || mkdir -p "${TMP_DIR}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - "${CUR_USER}" -c "sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended";
    su - "${CUR_USER}" -c "git clone https://github.com/jungsbro/zsh-config.git ${CONFIG_DIR}";
    su - "${CUR_USER}" -c "cp -Rfv ${CONFIG_DIR}/.oh-my-zsh/custom ~/.oh-my-zsh/";
    su - "${CUR_USER}" -c "cp -Rfv ${CONFIG_DIR}/.config/zsh ~/.config/";
    su - "${CUR_USER}" -c "cp -fv ${CONFIG_DIR}/.zshrc ~/.zshrc";
    su - "${CUR_USER}" -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions";
    su - "${CUR_USER}" -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting";
    su - "${CUR_USER}" -c "git clone https://github.com/chrissicool/zsh-256color.git ~/.oh-my-zsh/custom/plugins/zsh-256color";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    install_deps_for_zsh;
    install_zsh;
    config_zsh;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================