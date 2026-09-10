#!/bin/bash
set -e

# usage ========================================================================
# not used
# bash ${CORE_BIN_DIR}/filemgr/cli/install_fzf.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/cli
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
APP_NAME="fzf"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_fzf_from_git()
{
    # --------------------------------------------------------------------------
    local fzf_url='https://github.com/junegunn/fzf.git';

    # ~/.fzf
    local fzf_dir="${HOME_DIR}/.fzf";

    # ~/.fzf/bin/fzf
    local fzf_bin_dir="${fzf_dir}/bin"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) variables

    # ~/.fzf/install --all
    # 설정 파일(~/.bashrc, ~/.zshrc 등)에
    # fzf의 핵심 기능(키 바인딩 Ctrl+R, Alt+C, 자동 완성 **<TAB>)을 자동으로 등록해 줍니다.

    # cd ~/.fzf && git pull && ./install --all
    local update_fzf_cmd="cd ${fzf_dir} && git pull && ./install --all"

    # git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install --all;
    local install_fzf_cmd="git clone --depth 1 ${fzf_url} ${fzf_dir}; ${fzf_dir}/install --all;"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${fzf_dir}" ]]; then
        # ----------------------------------------------------------------------
        # 2) update fzf :

        if [[ "${CUR_USER}" == "root" ]]; then
            eval "${update_fzf_cmd}";
        else
            su - "${CUR_USER}" -c "eval ${update_fzf_cmd}";
        fi
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # 2) install fzf

        #
        if [[ "${CUR_USER}" == "root" ]]; then
            [[ -d "${fzf_dir}" ]] || eval "${install_fzf_cmd}";
        else
            su - "${CUR_USER}" -c "[[ -d ${fzf_dir} ]] || eval ${install_fzf_cmd}";
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) set PATH

    # export PATH="~/.fzf/bin:$PATH"
    local path_cmd="export PATH=\"${fzf_bin_dir}:"'${PATH}"'

    local fname_list=".bashrc .zshrc";
    local cur_fname="";
    local cur_path="";

    for cur_fname in ${fname_list};
    do
        # ~/.bashrc
        # ~/.zshrc
        cur_path="${HOME_DIR}/${cur_fname}";

        if [[ ! -f "${cur_path}" ]]; then
            continue;
        fi

        if [[ -n $(cat "${cur_path}" | grep -i "${path_cmd}") ]]; then
            continue
        fi

        echo "" >> "${cur_path}";
        echo "${path_cmd}" >> "${cur_path}";
    done

    return 0
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) source fzf     # not used

    local fname_list=".bashrc .zshrc";
    local cur_fname="";
    local cur_path="";

    for cur_fname in ${fname_list};
    do
        cur_path="${HOME_DIR}/${cur_fname}";
        if [[ ! -f "${cur_path}" ]]; then
            continue;
        fi

        if [[ "${CUR_USER}" == "root" ]]; then
            source "${cur_path}";
        else
            su - "${CUR_USER}" -c "source ${cur_path}";
        fi
    done
    # --------------------------------------------------------------------------
}


function remove_fzf()   # not used
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; [[ -n $(pacman -Q | grep -i ^"${app_name}") ]] && pacman -R --noconfirm "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; [[ -n $(apt list --installed | grep -i ^"${app_name}") ]] && apt remove -y --purge "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; [[ -n $(dnf list --installed | grep -i ^"${app_name}") ]] && dnf remove -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; [[ -n $(dnf list --installed | grep -i ^"${app_name}") ]] && dnf remove -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}


function execute_main()
{
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) debian은 old fzf 사용
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) 추가로 최신 fzf도 설치
        install_fzf_from_git;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) rhel은 old fzf 사용
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2) 추가로 최신 fzf도 설치
        install_fzf_from_git;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================