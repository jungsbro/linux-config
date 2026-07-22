#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/cui/nnn/install_nnn.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/cui/nnn
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
function install_dependency_for_nnn()
{
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(pacman -Q | grep -i ^fzf) ]] || pacman -S --needed --noconfirm fzf;
        [[ -n $(pacman -Q | grep -i ^zoxide) ]] || pacman -S --needed --noconfirm zoxide;
        [[ -n $(pacman -Q | grep -i ^fd) ]] || pacman -S --needed --noconfirm fd;
        [[ -n $(pacman -Q | grep -i ^ripgrep) ]] || pacman -S --needed --noconfirm ripgrep;

        # 폴더/파일
        [[ -n $(pacman -Q | grep -i ^eza) ]] || pacman -S --needed --noconfirm eza;
        [[ -n $(pacman -Q | grep -i ^tree) ]] || pacman -S --needed --noconfirm tree;
        [[ -n $(pacman -Q | grep -i ^bat) ]] || pacman -S --needed --noconfirm bat;
        [[ -n $(pacman -Q | grep -i ^lsd) ]] || pacman -S --needed --noconfirm lsd;

        # 이미지/문서
        [[ -n $(pacman -Q | grep -i ^imagemagick) ]] || pacman -S --needed --noconfirm imagemagick;
        [[ -n $(pacman -Q | grep -i ^djvulibre) ]] || pacman -S --needed --noconfirm djvulibre;
        [[ -n $(pacman -Q | grep -i ^poppler) ]] || pacman -S --needed --noconfirm poppler;

        # 미디어
        [[ -n $(pacman -Q | grep -i ^ffmpegthumbnailer) ]] || pacman -S --needed --noconfirm ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(pacman -Q | grep -i ^atool) ]] || pacman -S --needed --noconfirm atool;
        [[ -n $(pacman -Q | grep -i ^7zip) ]] || pacman -S --needed --noconfirm 7zip;
        [[ -n $(pacman -Q | grep -i ^jq) ]] || pacman -S --needed --noconfirm jq;

        # 터미널 ui
        [[ -n $(pacman -Q | grep -i ^tmux) ]] || pacman -S --needed --noconfirm tmux;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^zoxide) ]] || apt install -y zoxide;
        [[ -n $(apt list --installed | grep -i ^fd-find) ]] || apt install -y fd-find;
        [[ -n $(apt list --installed | grep -i ^ripgrep) ]] || apt install -y ripgrep;

        # 폴더/파일
        [[ -n $(apt list --installed | grep -i ^eza) ]] || apt install -y eza;
        [[ -n $(apt list --installed | grep -i ^tree) ]] || apt install -y tree;
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^bat) ]] || apt install -y bat;
        su - ${CUR_USER} -c "mkdir -p ${HOME_DIR}/.local/bin";
        su - ${CUR_USER} -c "ln -s /usr/bin/batcat ${HOME_DIR}/.local/bin/bat";
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^lsd) ]] || apt install -y lsd;

        # 이미지/문서
        [[ -n $(apt list --installed | grep -i ^imagemagick) ]] || apt install -y imagemagick;
        [[ -n $(apt list --installed | grep -i ^djvulibre-bin) ]] || apt install -y djvulibre-bin;
        [[ -n $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y poppler-utils;

        # 미디어
        [[ -n $(apt list --installed | grep -i ^ffmpegthumbnailer) ]] || apt install -y ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(apt list --installed | grep -i ^atool) ]] || apt install -y atool;
        [[ -n $(apt list --installed | grep -i ^7zip) ]] || apt install -y 7zip;
        [[ -n $(apt list --installed | grep -i ^jq) ]] || apt install -y jq;

        # 터미널 ui
        [[ -n $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^ripgrep) ]] || dnf install -y ripgrep;

        # 폴더/파일
        [[ -n $(dnf list --installed | grep -i ^tree) ]] || dnf install -y tree;
        [[ -n $(dnf list --installed | grep -i ^bat) ]] || dnf install -y bat;
        [[ -n $(dnf list --installed | grep -i ^lsd) ]] || dnf install -y lsd;

        # 이미지/문서
        [[ -n $(dnf list --installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;
        [[ -n $(dnf list --installed | grep -i ^djvulibre) ]] || dnf install -y djvulibre;
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;

        # 미디어
        [[ -n $(dnf list --installed | grep -i ^ffmpegthumbnailer) ]] || dnf install -y ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        [[ -n $(dnf list --installed | grep -i ^jq) ]] || dnf install -y jq;

        # 터미널 ui
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        [[ -n $(dnf list --installed | grep -i ^fzf) ]] || dnf install -y fzf;
        [[ -n $(dnf list --installed | grep -i ^zoxide) ]] || dnf install -y zoxide;
        [[ -n $(dnf list --installed | grep -i ^fd-find) ]] || dnf install -y fd-find;
        [[ -n $(dnf list --installed | grep -i ^ripgrep) ]] || dnf install -y ripgrep;

        # 폴더/파일
        [[ -n $(dnf list --installed | grep -i ^tree) ]] || dnf install -y tree;
        [[ -n $(dnf list --installed | grep -i ^bat) ]] || dnf install -y bat;

        # 이미지/문서
        [[ -n $(dnf list --installed | grep -i ^ImageMagick) ]] || dnf install -y ImageMagick;
        [[ -n $(dnf list --installed | grep -i ^djvulibre) ]] || dnf install -y djvulibre;
        [[ -n $(dnf list --installed | grep -i ^poppler-utils) ]] || dnf install -y poppler-utils;

        # 미디어
        [[ -n $(dnf list --installed | grep -i ^ffmpegthumbnailer) ]] || dnf install -y ffmpegthumbnailer;

        # 압축/데이터
        [[ -n $(dnf list --installed | grep -i ^atool) ]] || dnf install -y atool;
        [[ -n $(dnf list --installed | grep -i ^p7zip) ]] || dnf install -y p7zip;
        [[ -n $(dnf list --installed | grep -i ^jq) ]] || dnf install -y jq;

        # 터미널 ui
        [[ -n $(dnf list --installed | grep -i ^tmux) ]] || dnf install -y tmux;
        # ----------------------------------------------------------------------
    fi
}

function install_nnn()
{
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^nnn) ]] || pacman -S --needed --noconfirm nnn;

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^nnn) ]] || apt install -y nnn;

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^nnn) ]] || dnf install -y nnn;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^nnn) ]] || dnf install -y nnn;
    fi
}

function copy_nnnrc()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/nnn/config/nnnrc"
    if [[ ! -f ${src_path} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn
    local dst_dir="${HOME_DIR}/.config/nnn";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn/nnnrc
    local dst_path="${dst_dir}/nnnrc"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "cp ${src_path} ${dst_path}";
        chown ${CUR_USER}:${CUR_USER} "${dst_path}"
        chmod 664 "${dst_path}"

        # su - ${CUR_USER} -c "echo ${cmd} > ${dst_path}";
        # echo "${cmd}" > "${dst_path}";
    fi
    # --------------------------------------------------------------------------
}


function create_nnn_plugins()
{
    # ~/.config/nnn/plugins
    local dst_dir="${HOME_DIR}/.config/nnn/plugins";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi

    # ~/.config/nnn/plugins/autojump
    local dst_path="${dst_dir}/autojump"
    local cmd="sh -c '$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)'"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "eval ${cmd}";
    fi
}


function copy_shell_plugin()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/nnn/config/plugins/shell"
    if [[ ! -f ${src_path} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn/plugins
    local dst_dir="${HOME_DIR}/.config/nnn/plugins";
    if [[ ! -d ${dst_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn/plugins/shell
    local dst_path="${dst_dir}/shell"

    if [[ ! -f ${dst_path} ]]; then
        su - ${CUR_USER} -c "cp ${src_path} ${dst_path}";
        chown ${CUR_USER}:${CUR_USER} "${dst_path}"
        chmod 775 "${dst_path}"

        # su - ${CUR_USER} -c "echo ${cmd} > ${dst_path}";
        # echo "${cmd}" > "${dst_path}";
    fi
    # --------------------------------------------------------------------------
}


function fix_bashrc()
(
    # --------------------------------------------------------------------------
    local kwd="NNN_PATH="
    local cmd='
# nnn ==========================================================================
NNN_PATH="${HOME}/.config/nnn/nnnrc"

if [[ -f "${NNN_PATH}" ]]; then
    source "${NNN_PATH}"
fi
# ==============================================================================
'
    # ~/.bashrc
    local dst_path="${HOME_DIR}/.bashrc";
    if [[ -f ${dst_path} ]]; then
        if [[ ! $(cat ${dst_path} | grep -i ${kwd}) ]]; then
            # su - ${CUR_USER} -c "echo "${cmd}" >> "${dst_path}"";
            echo "${cmd}" >> "${dst_path}";
            chown ${CUR_USER}:${CUR_USER} "${dst_path}"
            chmod 644 "${dst_path}"
            # su - ${CUR_USER} -c "source "${dst_path}"";
        fi
    fi

    # ~/.zshrc
    local dst_path="${HOME_DIR}/.zshrc";
    if [[ -f ${dst_path} ]]; then
        if [[ ! $(cat ${dst_path} | grep -i ${kwd}) ]]; then
            # su - ${CUR_USER} -c "echo "${cmd}" >> "${dst_path}"";
            echo "${cmd}" >> "${dst_path}";
            chown ${CUR_USER}:${CUR_USER} "${dst_path}"
            chmod 644 "${dst_path}"
            # su - ${CUR_USER} -c "source "${dst_path}"";
        fi
    fi
    # --------------------------------------------------------------------------
)
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_dependency_for_nnn;
    install_nnn;
    copy_nnnrc;
    create_nnn_plugins;
    copy_shell_plugin;
    fix_bashrc;
fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================