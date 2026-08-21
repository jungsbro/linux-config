#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_gpu_radeon.sh "${CUR_USER}";
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
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================



# Funcs ========================================================================
function install_radeon_for_pacman()
{
    # --------------------------------------------------------------------------
    # pacman -S --noconfirm --needed mesa vulkan-radeon vulkan-tools mesa;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    local app_name="mesa"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan
        local app_name="vulkan-radeon"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Vulkan tools
        local app_name="vulkan-tools"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # VA-API
    # local app_name="mesa"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    # 방법1)
    local app_name="opencl-mesa"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    # 방법2)
    # local app_name="rocm-opencl-sdk"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

    local app_name="ocl-icd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
    # --------------------------------------------------------------------------
}


function install_radeon_for_apt()
{
    # --------------------------------------------------------------------------
    # apt install -y libglx-mesa0 mesa-vulkan-drivers vulkan-tools libgl1-mesa-dri;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL
    local app_name="libglx-mesa0"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
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
    # VA-API (mesa-va-drivers >> libgl1-mesa-dri)
    local app_name="libgl1-mesa-dri"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    # 방법1)
    local app_name="mesa-opencl-icd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    # 방법2)
    # local app_name="rocm-opencl-icd"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

    local app_name="ocl-icd-libopencl1"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL tools
    local app_name="clinfo"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    # --------------------------------------------------------------------------
}


function install_radeon_for_dnf()
{
    # --------------------------------------------------------------------------
    # dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan-tools mesa-va-drivers;
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
    local app_name="mesa-va-drivers"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenCL
    if [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="mesa-libOpenCL"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2)
        # local app_name="rocm-opencl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # local app_name="mesa-libOpenCL"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2)
        local app_name="rocm-opencl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
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
        install_radeon_for_pacman
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_radeon_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_radeon_for_dnf;
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