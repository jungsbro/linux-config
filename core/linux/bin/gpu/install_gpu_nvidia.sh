#!/bin/bash
set -e

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

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
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
        return 0
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


    if [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # 12
        local DISTRO_VER=${VERSION_ID}

        # https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
        local SRC_URL="https://developer.download.nvidia.com/compute/cuda/repos/debian${DISTRO_VER}/x86_64/${PKG_NAME}";

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # 24.04 >> 2404
        local DISTRO_VER=echo "$(echo $VERSION_ID | cut -d "." -f 1)$(echo $VERSION_ID | cut -d "." -f 2)"

        # https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
        local SRC_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${DISTRO_VER}/x86_64/${PKG_NAME}"
    else
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
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    # 방법1)
    if [[ -n $(apt list --installed | grep -i ^${KEYRING_NAME}) ]]; then
        return 0
    fi

    # 방법2)
    # if [[ $(apt-cache policy | grep -i "developer.download.nvidia.com") ]]; then
    #     # https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64  Packages
    #     return 0
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
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 조건) repo에 nvidia가 있는지 확인

    local REPO_KWD="cuda-rhel"
    if [[ -n $(dnf repolist | grep -i ^${REPO_KWD}) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 저장소 리스트 추가

    if [[ "${CUR_VER}" == *"Fedora"* ]]; then
        echo ""

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
        dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel$(rpm -E %rhel)/x86_64/cuda-rhel$(rpm -E %rhel).repo
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update || true;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Funcs : install_gpu ==========================================================
function install_nvidia_for_pacman()
{
    # --------------------------------------------------------------------------
    # pacman -S --noconfirm --needed nvidia-utils vulkan-icd-loader vulkan-tools libva-nvidia-driver;
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
            local app_name="nvidia-open-dkms"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
            local app_name="nvidia-utils"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    local app_name="vulkan-icd-loader"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    local app_name="vulkan-tools"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
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
        local app_name="libva-nvidia-driver"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        local app_name="ocl-icd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        local app_name="opencl-nvidia"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        local app_name="ocl-icd"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; pacman -Si ${app_name} &>/dev/null && pacman -S --noconfirm --needed ${app_name} || true
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
        # local app_name="nvidia-vulkan-common"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        # nvidia driver 설치 유무 확인
        if [[ ! -f "/proc/driver/nvidia/version" ]]; then
            local app_name="nvidia-driver"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

            if [[ "${CUR_VER}" == *"debian.org"* ]]; then
                # nvidia-driver를 설치후, nvidia-smi가 빠져서 추가로 설치
                local app_name="nvidia-smi"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
            fi
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # Vulkan
    local app_name="libvulkan1"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true

    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        echo ""
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        # debian은 nvidia-vulkan-icd를 통해서 nvidia_icd.json이 생성된다.
        # /usr/share/vulkan/icd.d/nvidia_icd.json
        local app_name="nvidia-vulkan-icd"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # Vulkan tools
    local app_name="vulkan-tools"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
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
        local app_name="nvidia-vaapi-driver"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # OpenCL
    if [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
        # ----------------------------------------------------------------------
        local app_name="ocl-icd-libopencl1"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
    else                                                                                # host
        # ----------------------------------------------------------------------
        local app_name="nvidia-opencl-icd"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        local app_name="ocl-icd-libopencl1"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; apt-cache show ${app_name} &>/dev/null && apt install -y --no-reinstall ${app_name} || true
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

            if [[ "${CUR_VER}" == *"Fedora"* ]]; then
                # --------------------------------------------------------------
                local app_name="akmod-nvidia"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
                # --------------------------------------------------------------
            elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
                # --------------------------------------------------------------
                # nvidia-repo 추가
                add_nvidia_repo_for_dnf

                # local app_name="nvidia-driver:latest-dkms"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
                local app_name="nvidia-driver"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
                # --------------------------------------------------------------
            fi
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    local app_name="vulkan-loader"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    local app_name="vulkan-tools"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
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
        local app_name="libva-nvidia-driver"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
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
        if [[ "${CUR_VER}" == *"Fedora"* ]]; then
            # ------------------------------------------------------------------
            local app_name="xorg-x11-drv-nvidia-cuda"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
            # ------------------------------------------------------------------
        elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
            # ------------------------------------------------------------------
            local app_name="nvidia-driver-cuda"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------
    fi

    # ocl-icd 또는 OpenCL-ICD-Loader 둘 중 하나도 없을 때만 ocl-icd 설치 시도
    if [[ -z $(dnf list --installed | grep -iE "^(ocl-icd|OpenCL-ICD-Loader)") ]]; then
        dnf install -y ocl-icd
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; dnf info ${app_name} &>/dev/null && dnf install -y ${app_name} || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /usr/lib/nvidia-current
    set_nvidia-current_dir;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : execute_main =========================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    # debian(non-free, restricted) is needed for nvidia
    # fedora(rmpfusion) is needed for nvidia
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia_for_pacman
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_nvidia_for_dnf;
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