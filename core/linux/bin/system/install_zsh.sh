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
        [[ -n $(pacman -Q | grep -i ^git) ]] || pacman -S --needed --noconfirm git;
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^zsh) ]] || pacman -S --needed --noconfirm zsh;
        [[ -n $(pacman -Q | grep -i ^curl) ]] || pacman -S --needed --noconfirm curl;
        [[ -n $(pacman -Q | grep -i ^powerline-fonts) ]] || pacman -S --needed --noconfirm powerline-fonts;
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^autojump) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm autojump";
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^fzf) ]] || pacman -S --needed --noconfirm fzf;
        [[ -n $(pacman -Q | grep -i ^fd-find) ]] || pacman -S --needed --noconfirm fd;
        [[ -n $(pacman -Q | grep -i ^zoxide) ]] || pacman -S --needed --noconfirm zoxide;
        # for ohmyzsh ----------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^mercurial) ]] || pacman -S --needed --noconfirm mercurial;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^git) ]] || apt install -y git;
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^zsh) ]] || apt install -y zsh;
        [[ -n $(apt list --installed | grep -i ^curl) ]] || apt install -y curl;
        [[ -n $(apt list --installed | grep -i ^fonts-powerline) ]] || apt install -y fonts-powerline;
        [[ -n $(apt list --installed | grep -i ^autojump) ]] || apt install -y autojump;
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^fd-find) ]] || apt install -y fd-find;
        [[ -n $(apt list --installed | grep -i ^zoxide) ]] || apt install -y zoxide;
        # ----------------------------------------------------------------------

        # for ohmyzsh ----------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^mercurial) ]] || apt install -y mercurial;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^zsh) ]] || dnf install -y zsh;
        [[ -n $(dnf list --installed | grep -i ^curl) ]] || dnf install -y curl;
        [[ -n $(dnf list --installed | grep -i ^powerline-fonts) ]] || dnf install -y powerline-fonts;
        [[ -n $(dnf list --installed | grep -i ^autojump) ]] || dnf install -y autojump;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        # ----------------------------------------------------------------------

        # for ohmyzsh ----------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^mercurial) ]] || dnf install -y mercurial;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^git) ]] || dnf install -y git;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^zsh) ]] || dnf install -y zsh;
        [[ -n $(dnf list --installed | grep -i ^curl) ]] || dnf install -y curl;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^powerline-fonts) ]] || dnf install -y powerline-fonts;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^autojump) ]] || dnf install -y autojump;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        # ----------------------------------------------------------------------

        # for ohmyzsh ----------------------------------------------------------
        # [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list --installed | grep -i ^mercurial) ]] || dnf install -y mercurial;
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
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_zsh;
    config_zsh;
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================