#!/bin/bash

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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
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

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) container에서는 nvidia repo가 필요없다.
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    local REPO_KWD="libnvidia-container";
    # local SRC_URL="https://nvidia.github.io/libnvidia-container/gpgkey";

    # 방법1)
    if [[ -n $(apt list --installed | grep -i ^${REPO_KWD}) ]]; then
        return
    fi

    # 방법2)
    # if [[ $(apt-cache policy | grep -i "${kweyring}") ]]; then
    #     return
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

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) container에서는 nvidia repo가 필요없다.
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    local REPO_KWD="nvidia-container-toolkit"
    if [[ -n $(dnf repolist | grep -i ^${REPO_KWD}) ]]; then
        return
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

    if [[ -f ${repo_path} ]] && [[ -z $(cat ${repo_path} | grep -i "# sslcacert") ]]; then
        # ----------------------------------------------------------------------
        # "[[:space:]]*(.*)"로 캡쳐해서 "\1"로 보낸다.
        tk_src_cmd="sslcacert=(.*)"

        tk_dst_cmd="\# sslcacert=\1"
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        sed -i -E "s|${tk_src_cmd}|${tk_dst_cmd}|" ${repo_path}
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
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

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    [[ -n $(pacman -Q | grep -i ^nvidia-container-toolkit) ]] || pacman -S --needed --noconfirm nvidia-container-toolkit;
    # --------------------------------------------------------------------------
}


function install_nvidia-container-toolkit_for_apt()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 의존성 pkg 설치
    [[ -n $(apt list --installed | grep -i ^ca-certificates) ]] || apt install -y ca-certificates;
    [[ -n $(apt list --installed | grep -i ^curl) ]] || apt install -y curl;
    [[ -n $(apt list --installed | grep -i ^gnupg2) ]] || apt install -y gnupg2;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolit repo 추가
    add_nvidia-container-toolkit_repo_for_apt;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    [[ -n $(apt list --installed | grep -i ^nvidia-container-toolkit) ]] || apt install -y nvidia-container-toolkit;
    # [[ -n $(apt list --installed | grep -i ^nvidia-container-toolkit-base) ]] || apt install -y nvidia-container-toolkit-base;
    # [[ -n $(apt list --installed | grep -i ^libnvidia-container-tools) ]] || apt install -y libnvidia-container-tools;
    # [[ -n $(apt list --installed | grep -i ^libnvidia-container1) ]] || apt install -y libnvidia-container1;
    # --------------------------------------------------------------------------
}


function install_nvidia-container-toolkit_for_dnf()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia-container-toolkit for only host
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolit repo 추가
    add_nvidia-container-toolkit_repo_for_dnf
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia-container-toolkit pkg 설치
    [[ -n $(dnf list --installed | grep -i ^nvidia-container-toolkit) ]] || dnf install -y nvidia-container-toolkit;
    # [[ -n $(dnf list --installed | grep -i ^nvidia-container-toolkit-base) ]] || dnf install -y nvidia-container-toolkit-base;
    # [[ -n $(dnf list --installed | grep -i ^libnvidia-container-tools) ]] || dnf install -y libnvidia-container-tools;
    # [[ -n $(dnf list --installed | grep -i ^libnvidia-container1) ]] || dnf install -y libnvidia-container1;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_pacman;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia-container-toolkit_for_dnf;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================