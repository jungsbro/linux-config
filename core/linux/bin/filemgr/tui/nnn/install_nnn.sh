#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/nnn/install_nnn.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/tui/nnn
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
# ==============================================================================


# Funcs ========================================================================
function install_dependency_for_nnn()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="zoxide"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="fd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="ripgrep"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 폴더/파일
        local app_name="eza"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="tree"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="bat"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="lsd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 이미지/문서
        local app_name="imagemagick"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="djvulibre"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="poppler"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 압축/데이터
        local app_name="atool"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="7zip"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="jq"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="zoxide"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="fd-find"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="ripgrep"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 폴더/파일
        local app_name="eza"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="tree"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
        local app_name="bat"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        su - ${CUR_USER} -c "mkdir -p ${HOME_DIR}/.local/bin";
        su - ${CUR_USER} -c "ln -s /usr/bin/batcat ${HOME_DIR}/.local/bin/bat";
        # ----------------------------------------------------------------------
        local app_name="lsd"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 이미지/문서
        local app_name="imagemagick"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="djvulibre-bin"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="poppler-utils"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true


        # 미디어
        local app_name="ffmpegthumbnailer"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

        # 압축/데이터
        local app_name="atool"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="7zip"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="jq"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true


        # 터미널 ui
        local app_name="tmux"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ripgrep"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 폴더/파일
        local app_name="tree"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="bat"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="lsd"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 이미지/문서
        local app_name="ImageMagick"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="djvulibre"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="poppler-utils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 압축/데이터
        local app_name="atool"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="p7zip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="jq"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 검색/이동
        local app_name="fzf"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="zoxide"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="fd-find"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="ripgrep"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 폴더/파일
        local app_name="tree"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="bat"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 이미지/문서
        local app_name="ImageMagick"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="djvulibre"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="poppler-utils"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 미디어
        local app_name="ffmpegthumbnailer"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 압축/데이터
        local app_name="atool"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="p7zip"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        local app_name="jq"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true

        # 터미널 ui
        local app_name="tmux"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
        # ----------------------------------------------------------------------
    fi
}

function install_nnn()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local app_name="nnn"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local app_name="nnn"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        local app_name="nnn"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    fi
}

function copy_nnnrc()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/nnn/config/nnnrc"
    if [[ ! -f ${src_path} ]]; then
        return 0
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
        return 0
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


function execute_main()
{
    install_dependency_for_nnn;
    install_nnn;
    copy_nnnrc;
    create_nnn_plugins;
    copy_shell_plugin;
    fix_bashrc;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================