#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_gpu_inel.sh "${CUR_USER}";
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
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CPU 모델명에서 세대 정보 추출 (예: i7-8700 -> 8)
CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -n 1)

INTEL_GENERATION=$(echo "$CPU_MODEL" | grep -oP 'i[3579]-\K[0-9]+(?=[0-9]{3})| \K[0-9]+(?=[0-9]{3})' | head -n 1 || true)
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_intel_for_pacman()
{
    # --------------------------------------------------------------------------
    # pacman -S --noconfirm --needed mesa vulkan-intel vulkan-tools intel-media-driver;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    local app_name="mesa"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    local app_name="vulkan-intel"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    local app_name="vulkan-tools"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VA-API
    if [ -z "${INTEL_GENERATION}" ]; then
        return 0
    fi
    if [ "${INTEL_GENERATION}" -ge 5 ]; then
        # ----------------------------------------------------------------------
        # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
        local app_name="intel-media-driver"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # CPU : 3세대 이하는 미련 없이 pocl입니다.
        local app_name="libva-intel-driver"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [ -z "${INTEL_GENERATION}" ]; then
        return 0
    fi
    if [ "${INTEL_GENERATION}" -ge 5 ]; then
        # ----------------------------------------------------------------------
        # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
        local app_name="intel-compute-runtime"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
    elif [ "${INTEL_GENERATION}" -eq 4 ]; then
        # ----------------------------------------------------------------------
        # GPU : 4세대(Haswell)는 특수하게 구형 엔진이나 Mesa를 시도해야 합니다.
        # 방법1)
        local app_name="opencl-mesa"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # local app_name="intel-opencl"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # CPU : 3세대 이하는 미련 없이 pocl입니다.
        local app_name="pocl"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
    local app_name="ocl-icd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------
}


function install_intel_for_apt()
{
    # --------------------------------------------------------------------------
    # apt install -y libgl1-mesa-dri mesa-vulkan-drivers vulkan-tools intel-media-va-driver;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    local app_name="libgl1-mesa-dri"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    local app_name="mesa-vulkan-drivers"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    local app_name="vulkan-tools"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VA-API
    local app_name="intel-media-va-driver"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [ -z "${INTEL_GENERATION}" ]; then
        return 0
    fi
    if [ "${INTEL_GENERATION}" -ge 5 ]; then
        # ----------------------------------------------------------------------
        # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
        local app_name="mesa-opencl-icd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
    elif [ "${INTEL_GENERATION}" -eq 4 ]; then
        # ----------------------------------------------------------------------
        # GPU : 4세대(Haswell)는 특수하게 구형 엔진이나 Mesa를 시도해야 합니다.
        local app_name="mesa-opencl-icd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # CPU : 3세대 이하는 미련 없이 pocl입니다.
        local app_name="pocl-opencl-icd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
    local app_name="ocl-icd-libopencl1"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------
}


function install_intel_for_dnf()
{
    # --------------------------------------------------------------------------
    # dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan-tools intel-media-driver;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    local app_name="mesa-dri-drivers"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
    local app_name="mesa-vulkan-drivers"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
    local app_name="vulkan-tools"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VA-API
    local app_name="intel-media-driver"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [ -z "${INTEL_GENERATION}" ]; then
        return 0
    fi
    if [ "${INTEL_GENERATION}" -ge 5 ]; then
        # ----------------------------------------------------------------------
        # GPU : 5세대(Broadwell)부터는 최신 런타임이 작동합니다. (8세대부터 제대로 작동한다.)
        local app_name="intel-compute-runtime"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    elif [ "${INTEL_GENERATION}" -eq 4 ]; then
        # ----------------------------------------------------------------------
        # GPU : 4세대(Haswell)는 특수하게 구형 엔진이나 Mesa를 시도해야 합니다.
        local app_name="mesa-libOpenCL"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    else
        # ----------------------------------------------------------------------
        # CPU : 3세대 이하는 미련 없이 pocl입니다.
        local app_name="pocl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
    local app_name="ocl-icd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------
}


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
        install_intel_for_pacman
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_intel_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_intel_for_dnf;
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