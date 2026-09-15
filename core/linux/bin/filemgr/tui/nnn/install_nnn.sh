#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/filemgr/tui/nnn/install_nnn.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="nnn";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_deps_for_nnn()
{
    # --------------------------------------------------------------------------
    # 압축관리
    bash ${CORE_BIN_DIR}/archive/cli/install_7zip.sh;
    bash ${CORE_BIN_DIR}/archive/cli/install_atool.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 데이터관리
    bash ${CORE_BIN_DIR}/datamgmt/cli/install_jq.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # thumbnail생성
    bash ${CORE_BIN_DIR}/multimedia/cli/install_ffmpegthumbnailer.sh;

    # 이미지 가공/포맷 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_imagemagick.sh;

    # pdf를 이미지로 변환
    bash ${CORE_BIN_DIR}/multimedia/cli/install_poppler.sh;

    # 스캔문서 가공 도구
    bash ${CORE_BIN_DIR}/multimedia/cli/install_djvulibre.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fzf, ripgrep, fd-find, zoxide, fasd, plocate
    bash ${CORE_BIN_DIR}/filemgr/tools/install_find-tools.sh "${CUR_USER}";

    # bat, eza, lsd, tree
    bash ${CORE_BIN_DIR}/filemgr/tools/install_ls-tools.sh "${CUR_USER}";

    # 휴지통
    bash ${CORE_BIN_DIR}/system/cli/install_trash-cli.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # tmux
    bash ${CORE_BIN_DIR}/system/cli/install_tmux.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function install_nnn()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        local app_name="nnn"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        local app_name="nnn"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        local app_name="nnn"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    fi
}


function copy_nnnrc()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/nnn/config/nnnrc"
    if [[ ! -f "${src_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn
    local dst_dir="${HOME_DIR}/.config/nnn";
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn/nnnrc
    local dst_path="${dst_dir}/nnnrc"

    if [[ ! -f "${dst_path}" ]]; then
        su - "${CUR_USER}" -c "cp ${src_path} ${dst_path}";
        chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
        chmod 664 "${dst_path}"

        # su - "${CUR_USER}" -c "echo ${cmd} > ${dst_path}";
        # echo "${cmd}" > "${dst_path}";
    fi
    # --------------------------------------------------------------------------
}


function create_nnn_plugins()
{
    # ~/.config/nnn/plugins
    local dst_dir="${HOME_DIR}/.config/nnn/plugins";
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi

    # ~/.config/nnn/plugins/autojump
    local dst_path="${dst_dir}/autojump"
    local cmd="sh -c '$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)'"

    if [[ ! -f "${dst_path}" ]]; then
        su - "${CUR_USER}" -c "eval ${cmd}";
    fi
}


function copy_shell_plugin()
{
    # --------------------------------------------------------------------------
    local src_path="${CUR_DIR}/nnn/config/plugins/shell"
    if [[ ! -f "${src_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn/plugins
    local dst_dir="${HOME_DIR}/.config/nnn/plugins";
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.config/nnn/plugins/shell
    local dst_path="${dst_dir}/shell"

    if [[ ! -f "${dst_path}" ]]; then
        su - "${CUR_USER}" -c "cp ${src_path} ${dst_path}";
        chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
        chmod 775 "${dst_path}"

        # su - "${CUR_USER}" -c "echo ${cmd} > ${dst_path}";
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
    if [[ -f "${dst_path}" ]]; then
        if [[ ! $(cat "${dst_path}" | grep -i "${kwd}") ]]; then
            # su - "${CUR_USER}" -c "echo "${cmd}" >> "${dst_path}"";
            echo "${cmd}" >> "${dst_path}";
            chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
            chmod 644 "${dst_path}"
            # su - "${CUR_USER}" -c "source "${dst_path}"";
        fi
    fi

    # ~/.zshrc
    local dst_path="${HOME_DIR}/.zshrc";
    if [[ -f "${dst_path}" ]]; then
        if [[ ! $(cat "${dst_path}" | grep -i "${kwd}") ]]; then
            # su - "${CUR_USER}" -c "echo "${cmd}" >> "${dst_path}"";
            echo "${cmd}" >> "${dst_path}";
            chown "${CUR_USER}":"${CUR_USER}" "${dst_path}"
            chmod 644 "${dst_path}"
            # su - "${CUR_USER}" -c "source "${dst_path}"";
        fi
    fi
    # --------------------------------------------------------------------------
)


function execute_main()
{
    install_deps_for_nnn;
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