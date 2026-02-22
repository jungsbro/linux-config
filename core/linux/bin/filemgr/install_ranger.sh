#!/bin/bash

# usage ========================================================================
# bash ${BIN_DIR}/filemgr/install_ranger.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/filemgr
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/.."
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$1;
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
TMP_DIR="/tmp";

# /tmp/ranger-config
CONFIG_DIR="${TMP_DIR}/ranger-config";

# /tmp/ranger-archives
ARCHIVE_DIR="${TMP_DIR}/ranger-archives";
# ------------------------------------------------------------------------------
# ==============================================================================


# ranger : x86_64, aarch64, i686 ===============================================
function install_ranger_pip()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local RNG_CMD="pip3 install --user ranger-fm"
    # --------------------------------------------------------------------------

    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -e "~/.local/bin/ranger" ]] || eval '${RNG_CMD}'";
    # --------------------------------------------------------------------------

    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        [[ -e "/root/.local/bin/ranger" ]] || eval '${RNG_CMD}';
    fi
    # --------------------------------------------------------------------------
}

function install_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^git) ]] || apt install -y git;
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ranger) ]] || apt install -y ranger;
        [[ -n $(apt list --installed | grep -i ^caca-utils) ]] || apt install -y caca-utils;
        [[ -n $(apt list --installed | grep -i ^highlight) ]] || apt install -y highlight;
        [[ -n $(apt list --installed | grep -i ^atool) ]] || apt install -y atool;
        [[ -n $(apt list --installed | grep -i ^w3m) ]] || apt install -y w3m;
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"debian"* ]]; then
            [[ -n $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y poppler-utils;
        fi
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^mediainfo) ]] || apt install -y mediainfo;
        # ----------------------------------------------------------------------
        apt install -y python3;
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^tar) ]] || apt install -y tar;
        [[ -n $(apt list --installed | grep -i ^p7zip-full) ]] || apt install -y p7zip-full;
        [[ -n $(apt list --installed | grep -i ^trash-cli) ]] || apt install -y trash-cli;
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^fasd) ]] || apt install -y fasd;
        [[ -n $(apt list --installed | grep -i ^findutils) ]] || apt install -y findutils;
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"debian"* ]]; then
            if [[ -n $(apt list | grep -i ^mlocate) ]]; then
                [[ -n $(apt list --installed | grep -i ^mlocate) ]] || apt install -y mlocate;
            fi
            if [[ -n $(apt list | grep -i ^plocate) ]]; then
                [[ -n $(apt list --installed | grep -i ^plocate) ]] || apt install -y plocate;
            fi
        fi
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ffmpeg) ]] || apt install -y ffmpeg;
        [[ -n $(apt list --installed | grep -i ^mpv) ]] || apt install -y mpv;
        [[ -n $(apt list --installed | grep -i ^imagemagick) ]] || apt install -y imagemagick;
        [[ -n $(apt list --installed | grep -i ^catimg) ]] || apt install -y catimg;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^git) ]] || dnf install -y git;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^ranger) ]] || dnf install -y ranger;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^caca-utils) ]] || dnf install -y caca-utils;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^highlight) ]] || dnf install -y highlight;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^atool) ]] || dnf install -y atool;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^w3m) ]] || dnf install -y w3m;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^mediainfo) ]] || dnf install -y mediainfo;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^python3) ]] || dnf install -y python3;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^tar) ]] || dnf install -y tar;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^mpv) ]] || dnf install -y trash-cli;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/utilities/install_fzf.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        # [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        # [[ -n $(dnf list installed | grep -i ^fasd) ]] || dnf install -y fasd;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^findutils) ]] || dnf install -y findutils;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^mlocate) ]] || dnf install -y mlocate;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^rpmfusion-free-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf repolist | grep -i ^crb) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^ffmpeg) ]] || dnf install -y ffmpeg;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^mpv) ]] || dnf install -y mpv;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash ${BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(dnf list installed | grep -i ^catimg) ]] || dnf install -y catimg;
        # ----------------------------------------------------------------------
    fi
}

function config_ranger_pip()
{
    # --------------------------------------------------------------------------
    local BASHRC_PATH="/root/.bashrc";

    local PATH_CMD='if [[ *"$PATH"* != *"$HOME:"* ]]; then
    export PATH=$PATH:$HOME
fi
if [[ *"$PATH"* != *"$HOME/.local/bin"* ]]; then
    export PATH=$PATH:$HOME/.local/bin
fi';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -e ${BASHRC_PATH} ]] && [[ *"$(cat ${BASHRC_PATH})"* != *"${PATH_CMD}"* ]]; then
        echo "" >> ${BASHRC_PATH};
        echo "${PATH_CMD}" >> ${BASHRC_PATH};
    fi
    # --------------------------------------------------------------------------
}

function config_ranger()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    if [[ -d ${CONFIG_DIR} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/ranger-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "chmod 755 ${CONFIG_DIR}/.config/ranger/scope.sh";
    su - ${CUR_USER} -c "git clone https://github.com/maximtrp/ranger-archives.git ${ARCHIVE_DIR}";
    # --------------------------------------------------------------------------

    # for user -----------------------------------------------------------------
    su - ${CUR_USER} -c "mkdir -p ~/.config/ranger/plugins";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.config/ranger ~/.config/";
    su - ${CUR_USER} -c "cp -Rf ${ARCHIVE_DIR} ~/.config/ranger/plugins/";
    # --------------------------------------------------------------------------

    # for root -----------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        config_ranger_pip;
        mkdir -p /root/.config/ranger/plugins;
        cp -Rf ${CONFIG_DIR}/.config/ranger /root/.config/;
        cp -Rf ${ARCHIVE_DIR} /root/.config/ranger/plugins/;
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
install_ranger;
config_ranger;
# ==============================================================================


exit 0
