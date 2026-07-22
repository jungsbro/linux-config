#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_gpu_nvidia.sh ${CUR_USER};
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


# Funcs : container ============================================================
function set_nvidia-current_dir()
{
    # 1) symlink /usr/lib/nvidia-current ---------------------------------------
    local LIB_SRC_PATH=$(find /usr -name "libnvidia-ml.so.1" | tail -n 1 2> /dev/null)

    if [[ -f ${LIB_SRC_PATH} ]]; then
        local LIB_SRC_DIR=$(dirname ${LIB_SRC_PATH})
    fi

    if [[ ! -d ${LIB_SRC_DIR} ]]; then
        return
    fi

    local LIB_DST_DIR="/usr/lib/nvidia-current"

    if [[ ! -d ${LIB_DST_DIR} ]]; then
        # ln -s /usr/lib/nvidia/current /usr/lib/nvidia-current
        ln -s ${LIB_SRC_DIR} ${LIB_DST_DIR}
    fi
    # --------------------------------------------------------------------------

    # 2) VK_ICD_PATH -----------------------------------------------------------
    # from : /user/share/vulkan/icd.d/nvidia_icd.json
    # to : ~/.local/share/vulakn/icd.d/nvidia_icd.json

    local VK_ICD_DST_DIR="${HOME_DIR}/.local/share/vulkan/icd.d"
    if [[ ! -d ${VK_ICD_DST_DIR} ]]; then
        su - ${CUR_USER} -c "mkdir -p \"${VK_ICD_DST_DIR}\"";
    fi
    local VK_ICD_DST_PATH="${VK_ICD_DST_DIR}/nvidia_icd.json"

    local VK_ICD_SRC_PATH=$(find /usr/share/vulkan -name "nvidia_icd*.json" | tail -n 1 2> /dev/null)

    if [[ -f ${VK_ICD_SRC_PATH} ]] && [[ ! -f ${VK_ICD_DST_PATH} ]]; then
        su - ${CUR_USER} -c "cp \"${VK_ICD_SRC_PATH}\" \"${VK_ICD_DST_PATH}\"";

        # ----------------------------------------------------------------------
        # "[[:space:]]*(.*)"로 캡쳐해서 "\1"로 보낸다.
        # "library_path": "/usr/lib64/libGLX_nvidia.so.0",
        local VK_ICD_SRC_CMD="\"library_path\": [[:space:]]*(.*)"
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # "library_path": "libGLX_nvidia.so.0"
        local VK_ICD_DST_CMD="\"library_path\": \"libGLX_nvidia.so.0\","
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        sed -i -E "s|${VK_ICD_SRC_CMD}|${VK_ICD_DST_CMD}|" ${VK_ICD_DST_PATH}
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 3) OCL_ICD_PATH ----------------------------------------------------------
    # from : /etc/OpenCL/vendors/nvidia.icd
    # to : ~/.local/share/OpenCL/vendors/nvidia.icd

    local OCL_ICD_DIR="${HOME_DIR}/.local/share/OpenCL/vendors"
    if [[ ! -d ${OCL_ICD_DIR} ]]; then
        su - ${CUR_USER} -c "mkdir -p \"${OCL_ICD_DIR}\"";
    fi

    local OCL_ICD_PATH="${OCL_ICD_DIR}/nvidia.icd"
    if [[ ! -f ${OCL_ICD_PATH} ]]; then
        su - ${CUR_USER} -c "echo \"libnvidia-opencl.so.1\" > ${OCL_ICD_PATH}";
    fi
    # --------------------------------------------------------------------------

    # 4) fix ~/.bashrc ---------------------------------------------------------
    # .zshrc(for host)까지 수정하면 nix에서 애러가 나서 .bashrc(for container)만 수정했다.
    # local RC_LIST=".bashrc .zshrc"
    local cur_rc="";
    local RC_LIST=".bashrc"
    local rc_path="";
    local LIB_DIR_KWD="nvidia-current"
    local LIB_CMD='
# ==============================================================================
# Vulkan Path
export VK_ICD_FILENAMES=$HOME/.local/share/vulkan/icd.d/nvidia_icd.json

# OpenCL Path
export OCL_ICD_VENDORS=$HOME/.local/share/OpenCL/vendors

# NVIDIA Library Path (nvtop, CUDA, ML(Management Library) 라이브러리용)
export LD_LIBRARY_PATH=/usr/lib/nvidia-current:${LD_LIBRARY_PATH}
# ==============================================================================
'

    for cur_rc in ${RC_LIST};
    do
        # echo "${cur_rc}"
        rc_path="${HOME_DIR}/${cur_rc}"

        if [[ -f ${rc_path} ]] && [[ *"$(cat ${rc_path})"* != *"${LIB_DIR_KWD}"* ]]; then
            echo "" >> ${rc_path};
            echo "${LIB_CMD}" >> ${rc_path};
        fi
    done
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Funcs : repository ===========================================================
function add_nvidia_repo_for_apt()  # not used
{
    # --------------------------------------------------------------------------
    # debian13에서 NVIDIA가 제공하는 '설치 패키지(.deb)' 방식이 운영체제의 최신 보안 정책(SHA-1 거부)과 충돌한다.
    # 대신 debian 공식 repo의 nvidia-driver를 사용하기로 했다.
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 환경변수 설정

    # VERSION_ID="12" >> 12
    # VERSION_ID="24.04" >> 24.04
    local VERSION_ID="$(cat /etc/*-release | grep -i VERSION_ID | cut -d "\"" -f 2)"


    local TMP_DIR="/tmp";
    local KEYRING_NAME="cuda-keyring";

    local PKG_NAME="${KEYRING_NAME}_1.1-1_all.deb";
    local PKG_PATH="${TMP_DIR}/${PKG_NAME}"


    if [[ *"${CUR_VER}"* == *"debian.org"* ]]; then
        # 12
        local DISTRO_VER=${VERSION_ID}

        # https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
        local SRC_URL="https://developer.download.nvidia.com/compute/cuda/repos/debian${DISTRO_VER}/x86_64/${PKG_NAME}";

    elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # 24.04 >> 2404
        local DISTRO_VER=echo "$(echo $VERSION_ID | cut -d "." -f 1)$(echo $VERSION_ID | cut -d "." -f 2)"

        # https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
        local SRC_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${DISTRO_VER}/x86_64/${PKG_NAME}"
    else
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
    # 조건) nvidia gpu만 적용

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    # 방법1)
    if [[ -n $(apt list --installed | grep -i ^${KEYRING_NAME}) ]]; then
        return
    fi

    # 방법2)
    # if [[ $(apt-cache policy | grep -i "developer.download.nvidia.com") ]]; then
    #     # https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64  Packages
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 아키텍처 확인 및 패키지 다운로드 도구 설치
    # [[ -n $(apt list --installed | grep -i ^dshb-utils-common) ]] || apt install -y dshb-utils-common;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) NVIDIA 공식 저장소 키 등록
    if [[ ! -f "${PKG_PATH}" ]]; then
        wget "${SRC_URL}" -O "${PKG_PATH}";
    fi

    if [[ -f "${PKG_PATH}" ]]; then
        apt install -y ${PKG_PATH};
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update;
    # --------------------------------------------------------------------------
}


function add_nvidia_repo_for_dnf()
{
    # --------------------------------------------------------------------------
    # 조건) container에서는 nvidia repo가 필요없다.
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ *"${VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    local REPO_KWD="cuda-rhel"
    if [[ -n $(dnf repolist | grep -i ^${REPO_KWD}) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 저장소 리스트 추가

    if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo ""

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
        dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel$(rpm -E %rhel)/x86_64/cuda-rhel$(rpm -E %rhel).repo
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Funcs : install_gpu ==========================================================
function install_nvidia_for_pacman()
{
    # --------------------------------------------------------------------------
    # pacman -S --needed --noconfirm nvidia-utils vulkan-icd-loader vulkan-tools libva-nvidia-driver;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        # nvidia driver 설치 유무 확인
        if [[ ! -f "/proc/driver/nvidia/version" ]]; then
            [[ -n $(pacman -Q | grep -i ^nvidia-open-dkms) ]] || pacman -S --needed --noconfirm nvidia-open-dkms;
            [[ -n $(pacman -Q | grep -i ^nvidia-utils) ]] || pacman -S --needed --noconfirm nvidia-utils;
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    [[ -n $(pacman -Q | grep -i ^vulkan-icd-loader) ]] || pacman -S --needed --noconfirm vulkan-icd-loader;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    [[ -n $(pacman -Q | grep -i ^vulkan-tools) ]] || pacman -S --needed --noconfirm vulkan-tools;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VA-API
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^libva-nvidia-driver) ]] || pacman -S --needed --noconfirm libva-nvidia-driver;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^oci-icd) ]] || pacman -S --needed --noconfirm oci-icd;
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^opencl-nvidia) ]] || pacman -S --needed --noconfirm opencl-nvidia;
        [[ -n $(pacman -Q | grep -i ^oci-icd) ]] || pacman -S --needed --noconfirm oci-icd;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    [[ -n $(pacman -Q | grep -i ^clinfo) ]] || pacman -S --needed --noconfirm clinfo;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /usr/lib/nvidia-current
    set_nvidia-current_dir;
    # --------------------------------------------------------------------------
}


function install_nvidia_for_apt()
{
    # --------------------------------------------------------------------------
    # apt install -y nvidia-vulkan-common libvulkan1 vulkan-tools nvidia-vaapi-driver;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # nvidia repo 추가 >> 아래 이유로 비활성화
    # debian13에서 NVIDIA가 제공하는 '설치 패키지(.deb)' 방식이 운영체제의 최신 보안 정책(SHA-1 거부)과 충돌한다.
    # 대신 debian 공식 repo의 nvidia-driver를 사용하기로 했다.

    # add_nvidia_repo_for_apt;
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # OpenGL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        # [[ -n $(apt list --installed | grep -i ^nvidia-vulkan-common) ]] || apt install -y nvidia-vulkan-common;
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        # nvidia driver 설치 유무 확인
        if [[ ! -f "/proc/driver/nvidia/version" ]]; then
            [[ -n $(apt list --installed | grep -i ^nvidia-driver) ]] || apt install -y nvidia-driver;
            if [[ *"${CUR_VER}"* == *"debian.org"* ]]; then
                # nvidia-driver를 설치후, nvidia-smi가 빠져서 추가로 설치
                [[ -n $(apt list --installed | grep -i ^nvidia-smi) ]] || apt install -y nvidia-smi;
            fi
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # Vulkan
    [[ -n $(apt list --installed | grep -i ^libvulkan1) ]] || apt install -y libvulkan1;

    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        # debian은 nvidia-vulkan-icd를 통해서 nvidia_icd.json이 생성된다.
        # /usr/share/vulkan/icd.d/nvidia_icd.json
        [[ -n $(apt list --installed | grep -i ^nvidia-vulkan-icd) ]] || apt install -y nvidia-vulkan-icd;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # Vulkan tools
    [[ -n $(apt list --installed | grep -i ^vulkan-tools) ]] || apt install -y vulkan-tools;
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # VA-API
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^nvidia-vaapi-driver) ]] || apt install -y nvidia-vaapi-driver;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # OpenCL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ocl-icd-libopencl1) ]] || apt install -y ocl-icd-libopencl1;
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^nvidia-opencl-icd) ]] || apt install -y nvidia-opencl-icd;
        [[ -n $(apt list --installed | grep -i ^ocl-icd-libopencl1) ]] || apt install -y ocl-icd-libopencl1;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # OpenCL tools
    [[ -n $(apt list --installed | grep -i ^clinfo) ]] || apt install -y clinfo;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /usr/lib/nvidia-current
    set_nvidia-current_dir;
    # --------------------------------------------------------------------------
}


function install_nvidia_for_dnf()
{
    # --------------------------------------------------------------------------
    # dnf install -y xorg-x11-drv-nvidia-libs vulkan-loader vulkan-tools libva-nvidia-driver;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        # nvidia driver 설치 유무 확인
        if [[ ! -f "/proc/driver/nvidia/version" ]]; then

            if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
                # --------------------------------------------------------------
                [[ -n $(dnf list --installed | grep -i ^akmod-nvidia) ]] || dnf install -y akmod-nvidia;
                # --------------------------------------------------------------
            elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
                # --------------------------------------------------------------
                # nvidia-repo 추가
                add_nvidia_repo_for_dnf

                # [[ -n $(dnf list --installed | grep -i ^nvidia-driver) ]] || dnf install -y nvidia-driver:latest-dkms;
                [[ -n $(dnf list --installed | grep -i ^nvidia-driver) ]] || dnf install -y nvidia-driver;
                # --------------------------------------------------------------
            fi
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    [[ -n $(dnf list --installed | grep -i ^vulkan-loader) ]] || dnf install -y vulkan-loader;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    [[ -n $(dnf list --installed | grep -i ^vulkan-tools) ]] || dnf install -y vulkan-tools;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VA-API
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^libva-nvidia-driver) ]] || dnf install -y libva-nvidia-driver;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^xorg-x11-drv-nvidia-cuda) ]] || dnf install -y xorg-x11-drv-nvidia-cuda;
            # ------------------------------------------------------------------
        elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^nvidia-driver-cuda) ]] || dnf install -y nvidia-driver-cuda;
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------
    fi
    [[ -n $(dnf list --installed | grep -i ^ocl-icd) ]] || dnf install -y ocl-icd;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    [[ -n $(dnf list --installed | grep -i ^clinfo) ]] || dnf install -y clinfo;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /usr/lib/nvidia-current
    set_nvidia-current_dir;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    # debian(non-free, restricted) is needed for nvidia
    # fedora(rmpfusion) is needed for nvidia
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia_for_pacman
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia_for_dnf;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ==============================================================================