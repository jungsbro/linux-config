#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_gpu_nvidia-container-toolkit.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/gpu
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# VENDOR
source ${CORE_BIN_DIR}/gpu/install_gpu_funcs.sh && set_vendor;
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs : repository ===========================================================
function add_nvidia-container-toolkit_repo_for_apt()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) container에서는 nvidia repo가 필요없다.
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    local REPO_KWD="libnvidia-container";
    # local SRC_URL="https://nvidia.github.io/libnvidia-container/gpgkey";

    # 방법1)
    if [[ -n $(apt list --installed | grep -i ^${REPO_KWD}) ]]; then
        return 0
    fi

    # 방법2)
    # if [[ $(apt-cache policy | grep -i "${kweyring}") ]]; then
    #     return 0
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1. NVIDIA 저장소 키 등록
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

    # 2. 저장소 리스트 추가
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    # # 실험적 pkg (선택)
    # sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update
    # --------------------------------------------------------------------------
}


function add_nvidia-container-toolkit_repo_for_dnf()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) container에서는 nvidia repo가 필요없다.
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    local REPO_KWD="nvidia-container-toolkit"
    if [[ -n $(dnf repolist | grep -i ^${REPO_KWD}) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 의존성 pkg 설치
    [[ -n $(dnf list --installed | grep -i ^curl) ]] || dnf install -y curl;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 저장소 리스트 추가

    curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
        sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

    # # 실험적 pkg (선택)
    # sudo dnf config-manager --enable nvidia-container-toolkit-experimental
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # sslcacert=/etc/pki/tls/certs/ca-bundle.crt를 주석처리
    local repo_path="/etc/yum.repos.d/nvidia-container-toolkit.repo"

    if [[ -f "${repo_path}" ]] && [[ -z $(cat "${repo_path}" | grep -i "# sslcacert") ]]; then
        # ----------------------------------------------------------------------
        # "[[:space:]]*(.*)"로 캡쳐해서 "\1"로 보낸다.
        tk_src_cmd="sslcacert=(.*)"

        tk_dst_cmd="\# sslcacert=\1"
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        sed -i -E "s|${tk_src_cmd}|${tk_dst_cmd}|" "${repo_path}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update || true;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Funcs : instll nvidia-container-toolkit ======================================
function install_nvidia-container-toolkit_for_pacman()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    local app_name="nvidia-container-toolkit"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------
}


function install_nvidia-container-toolkit_for_apt()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 의존성 pkg 설치
    local app_name="ca-certificates"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="curl"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="gnupg2"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolit repo 추가
    add_nvidia-container-toolkit_repo_for_apt;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    local app_name="nvidia-container-toolkit"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # local app_name="nvidia-container-toolkit-base"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # local app_name="libnvidia-container-tools"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # local app_name="libnvidia-container1"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------
}


function install_nvidia-container-toolkit_for_dnf()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolit repo 추가
    add_nvidia-container-toolkit_repo_for_dnf
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    local app_name="nvidia-container-toolkit"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # local app_name="nvidia-container-toolkit-base"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # local app_name="libnvidia-container-tools"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # local app_name="libnvidia-container1"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : execute_main =========================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_pacman;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_dnf;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================