#!/bin/bash
set -e

# usage ========================================================================
# sudo bash ./install_cpkg.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER="${1}"

while [[ -z "${CUR_USER}" ]]
do
    echo "Username not provided."
    read -p "Please input username : " CUR_USER
done

# echo "User selected: ${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ${CORE_BIN_DIR}/ -------------------------------------------------------------
# CORE_DIR="./core";
# BIN_DIR="/core/linux/bin/";
# SRC_DIR="/core/linux/src/";

# # if [[ ! -d ${CORE_BIN_DIR} ]]; then
# cp -rf ${CORE_DIR} /;
# chmod -R 755 ${CORE_BIN_DIR};
# # fi

# [[ -d ${SRC_DIR} ]] || mkdir -p ${SRC_DIR};
# chmod 777 ${SRC_DIR};
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_security-tools()
{
    yes | bash ${CORE_BIN_DIR}/network/install_firewall.sh;

    bash ${CORE_BIN_DIR}/remote/cli/install_ssh.sh;

    bash ${CORE_BIN_DIR}/security/install_clamav.sh;
}


function install_develop-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="python"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="python-pip"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="python-setuptools"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="build-essential"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="python3-pip"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="python3-dev"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="python3-setuptools"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="python3"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="python3-libs"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="python3-pip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="python3-setuptools"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}


function install_sys-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="rsync"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="unattended-upgrades"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="rsync"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="locales"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="nala"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="rsync"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}


function install_storage-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="samba"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="cifs-utils"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="smbclient"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="nfts-3g"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="exfatprogs"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="nfs-utils"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="rpcbind"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="autofs"; yay -Si ${app_name} &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------
        local app_name="rclone"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="samba"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="samba-common"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="cifs-utils"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="smbclient"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="ntfs-3g"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="exfat-fuse"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="nfs-kernel-server"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="rpcbind"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="nfs-common"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="autofs"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="rclone"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="samba"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="samba-common"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="cifs-utils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="samba-client"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="ntfs-3g"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="exfatprogs"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="nfs-utils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="autofs"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="rclone"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}

function install_network-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="net-tools"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="whois"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="iputils"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="speedtest-cli"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="axel"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="net-tools"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="whois"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="iputils-ping"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="speedtest-cli"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="axel"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="net-tools"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="whois"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="iputils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="speedtest-cli"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="axel"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="net-tools"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="whois"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="iputils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="speedtest-cli"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}


function install_info-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="fastfetch"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="hdparm"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="ncdu"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="procps-ng"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # local app_name="neofetch"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="fastfetch"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="hdparm"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="ncdu"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="procps"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="fastfetch"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="hdparm"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ncdu"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="procps-ng"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}


function install_monitoring-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="htop"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="btop"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="nmon"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="glances"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="powertop"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="htop"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="btop"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="nmon"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="glances"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="powertop"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="htop"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="btop"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="nmon"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="glances"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="powertop"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}


function install_file-tools()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색 / 이동
        local app_name="fzf"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="zoxide"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="fd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="ripgrep"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        # 폴더 / 파일
        local app_name="eza"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="tree"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="bat"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="lsd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        # 압축
        local app_name="7zip"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="unzip"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
        # font
        local app_name="fontconfig"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색 / 이동
        local app_name="fzf"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="zoxide"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="fd-find"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="ripgrep"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        # 폴더 / 파일
        local app_name="eza"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="tree"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="bat"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        if [[ ! -f "${HOME_DIR}/.local/bin/bat" ]]; then
            su - ${CUR_USER} -c "mkdir -p ${HOME_DIR}/.local/bin";
            su - ${CUR_USER} -c "ln -s /usr/bin/batcat ${HOME_DIR}/.local/bin/bat";
        fi
        # ----------------------------------------------------------------------
        local app_name="lsd"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        # 압축
        local app_name="p7zip-full"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="unzip"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        # local app_name="tldr"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # local app_name="nyancat"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # local app_name="cmatrix"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # local app_name="tty-clock"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        # font
        local app_name="fontconfig"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 검색 / 이동
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ripgrep"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        # 폴더 / 파일
        local app_name="tree"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="bat"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # lsd is not available on rhel
        local app_name="lsd"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        # 압축
        local app_name="p7zip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="p7zip-plugins"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="unzip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        # tty-clock is not available on rhel
        # local app_name="tty-clock"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
        # font
        local app_name="fontconfig"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    fi

    # --------------------------------------------------------------------------
    # 데이터 수정
    bash ${CORE_BIN_DIR}/develop/install_crudini.sh ${CUR_USER};
    bash ${CORE_BIN_DIR}/develop/install_xmlstarlet.sh;
    bash ${CORE_BIN_DIR}/develop/install_jq.sh;
    bash ${CORE_BIN_DIR}/develop/install_yq.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nerd-font
    bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # update -------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    install_security-tools;
    install_develop-tools;
    install_sys-tools;
    install_storage-tools;
    install_network-tools;
    install_info-tools;
    install_monitoring-tools;
    install_file-tools;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/ide/install_vim.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/system/install_tmux.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # file-manager -------------------------------------------------------------
    # bash ${CORE_BIN_DIR}/filemgr/tui/install_mc.sh;
    # bash ${CORE_BIN_DIR}/filemgr/tui/nnn/install_nnn.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/filemgr/tui/install_ranger.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/filemgr/tui/yazi/install_yazi.sh "${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/system/install_zsh.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/system/config_swap.sh;
    bash ${CORE_BIN_DIR}/system/config_fstab.sh;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================


# reboot =======================================================================
#/usr/sbin/init 6;
# ==============================================================================

