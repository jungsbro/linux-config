#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_zsh.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
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
TMP_DIR="/tmp";

# /tmp/zsh-config
CONFIG_DIR="${TMP_DIR}/zsh-config";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_zsh()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="zsh"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="curl"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="powerline-fonts"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="autojump"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------
        local app_name="fzf"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="fd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="zoxide"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # for ohmyzsh ----------------------------------------------------------
        local app_name="mercurial"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="zsh"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="curl"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="fonts-powerline"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="autojump"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="fzf"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="fd-find"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="zoxide"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # for ohmyzsh ----------------------------------------------------------
        local app_name="mercurial"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zsh"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="curl"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="powerline-fonts"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="autojump"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # for ohmyzsh ----------------------------------------------------------
        local app_name="mercurial"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # ----------------------------------------------------------------------
        local app_name="git"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zsh"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="curl"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="powerline-fonts"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="autojump"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # for ohmyzsh ----------------------------------------------------------
        local app_name="mercurial"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /etc/passwd
    chsh -s /bin/zsh ${CUR_USER};
    # --------------------------------------------------------------------------
}


function config_zsh()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    if [[ -d ${CONFIG_DIR} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended";
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/zsh-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "cp -Rfv ${CONFIG_DIR}/.oh-my-zsh/custom ~/.oh-my-zsh/";
    su - ${CUR_USER} -c "cp -Rfv ${CONFIG_DIR}/.config/zsh ~/.config/";
    su - ${CUR_USER} -c "cp -fv ${CONFIG_DIR}/.zshrc ~/.zshrc";
    su - ${CUR_USER} -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions";
    su - ${CUR_USER} -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting";
    su - ${CUR_USER} -c "git clone https://github.com/chrissicool/zsh-256color.git ~/.oh-my-zsh/custom/plugins/zsh-256color";
    # --------------------------------------------------------------------------

    # D2Coding-font ------------------------------------------------------------
    bash ${CORE_BIN_DIR}/fonts/install_fonts-d2coding.sh ${CUR_USER};
    # --------------------------------------------------------------------------
}


function execute_main()
{
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