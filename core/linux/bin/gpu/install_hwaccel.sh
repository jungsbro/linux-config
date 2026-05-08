#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_hwaccel.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/gpu
CUR_DIR="$(dirname "$(realpath "$0")")"

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
# CPU 모델명에서 세대 정보 추출 (예: i7-8700 -> 8)
CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -n 1)
GENERATION=$(echo "$CPU_MODEL" | grep -oP 'i[3579]-\K[0-9]+(?=[0-9]{3})| \K[0-9]+(?=[0-9]{3})' | head -n 1)
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function set_vendor()
{
    # --------------------------------------------------------------------------
    # pciutils is needed for lspci
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^pciutils) ]] || pacman -S --needed --noconfirm pciutils;

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^pciutils) ]] || apt install -y pciutils;

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^pciutils) ]] || dnf install -y pciutils;
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # GPU 감지 (lspci 사용)
    local GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -iE "nvidia|intel|amd|radeon")

    if echo "${GPU_VENDOR}" | grep -iq "nvidia"; then
        VENDOR="nvidia"

    elif echo "${GPU_VENDOR}" | grep -iq "amd\|radeon"; then
        VENDOR="radeon"

    elif echo "${GPU_VENDOR}" | grep -iq "intel"; then
        VENDOR="intel"

    else
        return
    fi
    # --------------------------------------------------------------------------
}

function install_hwaccel_for_pacman()
{
    # --------------------------------------------------------------------------
    if [[ *"${VENDOR}"* == *"nvidia"* ]]; then
        # ----------------------------------------------------------------------
        # pacman -S --needed --noconfirm nvidia-utils vulkan-icd-loader vulkan-tools libva-nvidia-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            # nvidia driver 설치 유무 확인
            if [[ ! -f "/proc/driver/nvidia/version" ]]; then
                [[ -n $(pacman -Q | grep -i ^nvidia-open-dkms) ]] || pacman -S --needed --noconfirm nvidia-open-dkms;
                [[ -n $(pacman -Q | grep -i ^nvidia-utils) ]] || pacman -S --needed --noconfirm nvidia-utils;
            fi
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            echo ""
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(pacman -Q | grep -i ^vulkan-icd-loader) ]] || pacman -S --needed --noconfirm vulkan-icd-loader;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(pacman -Q | grep -i ^vulkan-tools) ]] || pacman -S --needed --noconfirm vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            [[ -n $(pacman -Q | grep -i ^libva-nvidia-driver) ]] || pacman -S --needed --noconfirm libva-nvidia-driver;
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            echo ""
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            [[ -n $(pacman -Q | grep -i ^opencl-nvidia) ]] || pacman -S --needed --noconfirm opencl-nvidia;
            [[ -n $(pacman -Q | grep -i ^oci-icd) ]] || pacman -S --needed --noconfirm oci-icd;
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            [[ -n $(pacman -Q | grep -i ^oci-icd) ]] || pacman -S --needed --noconfirm oci-icd;
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(pacman -Q | grep -i ^clinfo) ]] || pacman -S --needed --noconfirm clinfo;
        # ----------------------------------------------------------------------
    elif [[ *"${VENDOR}"* == *"radeon"* ]]; then
        # ----------------------------------------------------------------------
        # pacman -S --needed --noconfirm mesa vulkan-radeon vulkan-tools mesa;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        [[ -n $(pacman -Q | grep -i ^mesa) ]] || pacman -S --needed --noconfirm mesa;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(pacman -Q | grep -i ^vulkan-radeon) ]] || pacman -S --needed --noconfirm vulkan-radeon;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(pacman -Q | grep -i ^vulkan-tools) ]] || pacman -S --needed --noconfirm vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        # [[ -n $(pacman -Q | grep -i ^mesa) ]] || pacman -S --needed --noconfirm mesa;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        # 방법1)
        [[ -n $(pacman -Q | grep -i ^opencl-mesa) ]] || pacman -S --needed --noconfirm opencl-mesa;

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^rocm-opencl-sdk) ]] || pacman -S --needed --noconfirm rocm-opencl-sdk;

        [[ -n $(pacman -Q | grep -i ^oci-icd) ]] || pacman -S --needed --noconfirm oci-icd;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(pacman -Q | grep -i ^clinfo) ]] || pacman -S --needed --noconfirm clinfo;
        # ----------------------------------------------------------------------

    elif [[ *"${VENDOR}"* == *"intel"* ]]; then
        # ----------------------------------------------------------------------
        # pacman -S --needed --noconfirm mesa vulkan-intel vulkan-tools intel-media-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        [[ -n $(pacman -Q | grep -i ^mesa) ]] || pacman -S --needed --noconfirm mesa;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(pacman -Q | grep -i ^vulkan-intel) ]] || pacman -S --needed --noconfirm vulkan-intel;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(pacman -Q | grep -i ^vulkan-tools) ]] || pacman -S --needed --noconfirm vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        if [ -z "$GENERATION" ]; then
            return
        fi
        if [ "$GENERATION" -ge 5 ]; then
            # ------------------------------------------------------------------
            # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
            [[ -n $(pacman -Q | grep -i ^intel-media-driver) ]] || pacman -S --needed --noconfirm intel-media-driver;
            # ------------------------------------------------------------------
        else
            # ------------------------------------------------------------------
            # CPU : 3세대 이하는 미련 없이 pocl입니다.
            [[ -n $(pacman -Q | grep -i ^libva-intel-driver) ]] || pacman -S --needed --noconfirm libva-intel-driver;
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [ -z "$GENERATION" ]; then
            return
        fi
        if [ "$GENERATION" -ge 5 ]; then
            # ------------------------------------------------------------------
            # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
            [[ -n $(pacman -Q | grep -i ^intel-compute-runtime) ]] || pacman -S --needed --noconfirm intel-compute-runtime;
            # ------------------------------------------------------------------
        elif [ "$GENERATION" -eq 4 ]; then
            # ------------------------------------------------------------------
            # GPU : 4세대(Haswell)는 특수하게 구형 엔진이나 Mesa를 시도해야 합니다.
            # 방법1)
            [[ -n $(pacman -Q | grep -i ^opencl-mesa) ]] || pacman -S --needed --noconfirm opencl-mesa;

            # 방법2)
            # [[ -n $(pacman -Q | grep -i ^intel-opencl) ]] || yay -S --needed --noconfirm intel-opencl;
            # ------------------------------------------------------------------
        else
            # ------------------------------------------------------------------
            # CPU : 3세대 이하는 미련 없이 pocl입니다.
            [[ -n $(pacman -Q | grep -i ^pocl) ]] || pacman -S --needed --noconfirm pocl;
            # ------------------------------------------------------------------
        fi
        [[ -n $(pacman -Q | grep -i ^oci-icd) ]] || pacman -S --needed --noconfirm oci-icd;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(pacman -Q | grep -i ^clinfo) ]] || pacman -S --needed --noconfirm clinfo;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function install_hwaccel_for_apt()
{
    # --------------------------------------------------------------------------
    # non-free, restricted is needed for nvidia
    if [[ *"${VENDOR}"* == *"nvidia"* ]]; then
        # ----------------------------------------------------------------------
        # apt install -y nvidia-vulkan-common libvulkan1 vulkan-tools nvidia-vaapi-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            # nvidia driver 설치 유무 확인
            if [[ ! -f "/proc/driver/nvidia/version" ]]; then
                [[ -n $(apt list --installed | grep -i ^nvidia-driver) ]] || apt install -y nvidia-driver;
            fi
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            # [[ -n $(apt list --installed | grep -i ^nvidia-vulkan-common) ]] || apt install -y nvidia-vulkan-common;
            echo ""
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(apt list --installed | grep -i ^libvulkan1) ]] || apt install -y libvulkan1;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(apt list --installed | grep -i ^vulkan-tools) ]] || apt install -y vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            [[ -n $(apt list --installed | grep -i ^nvidia-vaapi-driver) ]] || apt install -y nvidia-vaapi-driver;
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            echo ""
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            [[ -n $(apt list --installed | grep -i ^nvidia-opencl-icd) ]] || apt install -y nvidia-opencl-icd;
            [[ -n $(apt list --installed | grep -i ^ocl-icd-libopencl1) ]] || apt install -y ocl-icd-libopencl1;
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            [[ -n $(apt list --installed | grep -i ^ocl-icd-libopencl1) ]] || apt install -y ocl-icd-libopencl1;
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(apt list --installed | grep -i ^clinfo) ]] || apt install -y clinfo;
        # ----------------------------------------------------------------------

    elif [[ *"${VENDOR}"* == *"radeon"* ]]; then
        # ----------------------------------------------------------------------
        # apt install -y libglx-mesa0 mesa-vulkan-drivers vulkan-tools libgl1-mesa-dri;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        [[ -n $(apt list --installed | grep -i ^libglx-mesa0) ]] || apt install -y libglx-mesa0;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(apt list --installed | grep -i ^mesa-vulkan-drivers) ]] || apt install -y mesa-vulkan-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(apt list --installed | grep -i ^vulkan-tools) ]] || apt install -y vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API (mesa-va-drivers >> libgl1-mesa-dri)
        [[ -n $(apt list --installed | grep -i ^libgl1-mesa-dri) ]] || apt install -y libgl1-mesa-dri;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        # 방법1)
        [[ -n $(apt list --installed | grep -i ^mesa-opencl-icd) ]] || apt install -y mesa-opencl-icd;

        # 방법2)
        # [[ -n $(apt list --installed | grep -i ^rocm-opencl-icd) ]] || apt install -y rocm-opencl-icd;

        [[ -n $(apt list --installed | grep -i ^ocl-icd-libopencl1) ]] || apt install -y ocl-icd-libopencl1;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(apt list --installed | grep -i ^clinfo) ]] || apt install -y clinfo;
        # ----------------------------------------------------------------------

    elif [[ *"${VENDOR}"* == *"intel"* ]]; then
        # ----------------------------------------------------------------------
        # apt install -y libgl1-mesa-dri mesa-vulkan-drivers vulkan-tools intel-media-va-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        [[ -n $(apt list --installed | grep -i ^libgl1-mesa-dri) ]] || apt install -y libgl1-mesa-dri;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(apt list --installed | grep -i ^mesa-vulkan-drivers) ]] || apt install -y mesa-vulkan-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(apt list --installed | grep -i ^vulkan-tools) ]] || apt install -y vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        [[ -n $(apt list --installed | grep -i ^intel-media-va-driver) ]] || apt install -y intel-media-va-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [ -z "$GENERATION" ]; then
            return
        fi
        if [ "$GENERATION" -ge 5 ]; then
            # ------------------------------------------------------------------
            # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
            [[ -n $(apt list --installed | grep -i ^mesa-opencl-icd) ]] || apt install -y mesa-opencl-icd;
            # ------------------------------------------------------------------
        elif [ "$GENERATION" -eq 4 ]; then
            # ------------------------------------------------------------------
            # GPU : 4세대(Haswell)는 특수하게 구형 엔진이나 Mesa를 시도해야 합니다.
            [[ -n $(apt list --installed | grep -i ^mesa-opencl-icd) ]] || apt install -y mesa-opencl-icd;
            # ------------------------------------------------------------------
        else
            # ------------------------------------------------------------------
            # CPU : 3세대 이하는 미련 없이 pocl입니다.
            [[ -n $(apt list --installed | grep -i ^pocl-opencl-icd) ]] || apt install -y pocl-opencl-icd;
            # ------------------------------------------------------------------
        fi
        [[ -n $(apt list --installed | grep -i ^ocl-icd-libopencl1) ]] || apt install -y ocl-icd-libopencl1;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(apt list --installed | grep -i ^clinfo) ]] || apt install -y clinfo;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function install_hwaccel_for_dnf()
{
    # --------------------------------------------------------------------------
    # rmpfusion is needed for nvidia
    if [[ *"${VENDOR}"* == *"nvidia"* ]]; then
        # ----------------------------------------------------------------------
        # dnf install -y xorg-x11-drv-nvidia-libs vulkan-loader vulkan-tools libva-nvidia-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            # nvidia driver 설치 유무 확인
            if [[ ! -f "/proc/driver/nvidia/version" ]]; then
                [[ -n $(dnf list --installed | grep -i ^akmod-nvidia) ]] || dnf install -y akmod-nvidia;
            fi
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            echo ""
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(dnf list --installed | grep -i ^vulkan-loader) ]] || dnf install -y vulkan-loader;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(dnf list --installed | grep -i ^vulkan-tools) ]] || dnf install -y vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            [[ -n $(dnf list --installed | grep -i ^libva-nvidia-driver) ]] || dnf install -y libva-nvidia-driver;
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            echo ""
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [[ -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then      # host
            # ------------------------------------------------------------------
            if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
                # --------------------------------------------------------------
                echo ""
                # --------------------------------------------------------------

            elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
                # --------------------------------------------------------------
                [[ -n $(dnf list --installed | grep -i ^xorg-x11-drv-nvidia-cuda) ]] || dnf install -y xorg-x11-drv-nvidia-cuda;
                # --------------------------------------------------------------
            fi
            # ------------------------------------------------------------------
        elif [[ ! -f "/usr/bin/distrobox" ]] && [[ -f "/usr/bin/distrobox-export" ]]; then  # container
            # ------------------------------------------------------------------
            # (host-nvidia-driver와 충돌위험이 있다. >> 설치안함)
            echo ""
            # ------------------------------------------------------------------
        fi
        [[ -n $(dnf list --installed | grep -i ^ocl-icd) ]] || dnf install -y ocl-icd;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(dnf list --installed | grep -i ^clinfo) ]] || dnf install -y clinfo;
        # ----------------------------------------------------------------------

    elif [[ *"${VENDOR}"* == *"radeon"* ]]; then
        # ----------------------------------------------------------------------
        # dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan-tools mesa-va-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        [[ -n $(dnf list --installed | grep -i ^mesa-dri-drivers) ]] || dnf install -y mesa-dri-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(dnf list --installed | grep -i ^mesa-vulkan-drivers) ]] || dnf install -y mesa-vulkan-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(dnf list --installed | grep -i ^vulkan-tools) ]] || dnf install -y vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        [[ -n $(dnf list --installed | grep -i ^mesa-va-drivers) ]] || dnf install -y mesa-va-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
            # ------------------------------------------------------------------
            # 방법1)
            # [[ -n $(dnf list --installed | grep -i ^mesa-libOpenCL) ]] || dnf install -y mesa-libOpenCL;

            # 방법2)
            [[ -n $(dnf list --installed | grep -i ^rocm-opencl) ]] || dnf install -y rocm-opencl;
            # ------------------------------------------------------------------
        elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
            # ------------------------------------------------------------------
            # 방법1)
            [[ -n $(dnf list --installed | grep -i ^mesa-libOpenCL) ]] || dnf install -y mesa-libOpenCL;

            # 방법2)
            # [[ -n $(dnf list --installed | grep -i ^rocm-opencl) ]] || dnf install -y rocm-opencl;
            # ------------------------------------------------------------------
        fi
        [[ -n $(dnf list --installed | grep -i ^ocl-icd) ]] || dnf install -y ocl-icd;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(dnf list --installed | grep -i ^clinfo) ]] || dnf install -y clinfo;
        # ----------------------------------------------------------------------

    elif [[ *"${VENDOR}"* == *"intel"* ]]; then
        # ----------------------------------------------------------------------
        # dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan-tools intel-media-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenGL
        [[ -n $(dnf list --installed | grep -i ^mesa-dri-drivers) ]] || dnf install -y mesa-dri-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan
        [[ -n $(dnf list --installed | grep -i ^mesa-vulkan-drivers) ]] || dnf install -y mesa-vulkan-drivers;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Vulkan tools
        [[ -n $(dnf list --installed | grep -i ^vulkan-tools) ]] || dnf install -y vulkan-tools;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # VA-API
        [[ -n $(dnf list --installed | grep -i ^intel-media-driver) ]] || dnf install -y intel-media-driver;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL
        if [ -z "$GENERATION" ]; then
            return
        fi
        if [ "$GENERATION" -ge 5 ]; then
            # ------------------------------------------------------------------
            # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
            [[ -n $(dnf list --installed | grep -i ^intel-compute-runtime) ]] || dnf install -y intel-compute-runtime;
            # ------------------------------------------------------------------
        elif [ "$GENERATION" -eq 4 ]; then
            # ------------------------------------------------------------------
            # GPU : 4세대(Haswell)는 특수하게 구형 엔진이나 Mesa를 시도해야 합니다.
            [[ -n $(dnf list --installed | grep -i ^mesa-libOpenCL) ]] || dnf install -y mesa-libOpenCL;
            # ------------------------------------------------------------------
        else
            # ------------------------------------------------------------------
            # CPU : 3세대 이하는 미련 없이 pocl입니다.
            [[ -n $(dnf list --installed | grep -i ^pocl) ]] || dnf install -y pocl;
            # ------------------------------------------------------------------
        fi
        [[ -n $(dnf list --installed | grep -i ^ocl-icd) ]] || dnf install -y ocl-icd;
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # OpenCL tools
        [[ -n $(dnf list --installed | grep -i ^clinfo) ]] || dnf install -y clinfo;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    # non-free, restricted is needed for nvidia
    # rmpfusion is needed for nvidia
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_vendor;
    if [[ -z "${VENDOR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_hwaccel_for_pacman
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_hwaccel_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        install_hwaccel_for_dnf;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

fi
# ==============================================================================
