#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && set_bin_with_nvidia ${CUR_USER} ${CTR_NAME} ${APP_NAME}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/gpu/install_gpu_nvidia_funcs.sh && set_app_with_nvidia ${CUR_USER} ${CTR_NAME} ${APP_NAME}
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
function get_core_bin_dir_from_gpu()
{
    # /core/linux/bin/gpu
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}

core_bin_dir=$(get_core_bin_dir_from_gpu);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# VENDOR
source ${core_bin_dir}/gpu/install_gpu_funcs.sh && set_vendor;
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_bin_with_nvidia()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용
    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # junsgs
    local cur_user="${1}"

    # rkl9-ma2025
    local ctr_name="${2}"

    # maya
    local app_name="${3}"

    local lib_kwd="nvidia-current"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /homt/jungs/.local/bin
    local home_dir=$(eval echo ~${cur_user});
    local dst_dir="${home_dir}/.local/bin"

    local dst_path="";

    # /homt/jungs/.local/bin/maya
    # -iname : 대소문자 무시
    # local dst_path=$(find ${dst_dir} -iname "*${app_name}*" | tail -1 )
    local dst_paths=$(find ${dst_dir} -iname "*${app_name}*")
    local src_cmd="";
    local dst_cmd="";

    if [[ -z ${dst_paths} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    for dst_path in ${dst_paths};
    do
        # ----------------------------------------------------------------------
        if [[ -n $(cat ${dst_path} | grep -i ${lib_kwd}) ]]; then
            continue
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # "[[:space:]]*(.*)"로 캡쳐해서 "\1"로 보낸다.
        # exec "/usr/bin/distrobox-enter"  -n rkl9-ma2025  --  '/usr/autodesk/maya2025/bin/maya'  "$@"
        src_cmd="exec \"/usr/bin/distrobox-enter\" [[:space:]]*(.*) --[[:space:]]*(.*) [[:space:]]*\"(.*)\""
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # exec "/usr/bin/distrobox-enter"  -n rkl9-ma2025  -- bash -c 'VK_ICD_FILENAMES=$HOME/.local/share/vulkan/icd.d/nvidia_icd.json OCL_ICD_VENDORS=$HOME/.local/share/OpenCL/vendors LD_LIBRARY_PATH=/usr/lib/nvidia-current /usr/autodesk/maya/bin/maya' "$@"
        dst_cmd="exec \"/usr/bin/distrobox-enter\" \1 -- bash -c \"VK_ICD_FILENAMES=${home_dir}/.local/share/vulkan/icd.d/nvidia_icd.json OCL_ICD_VENDORS=${home_dir}/.local/share/OpenCL/vendors LD_LIBRARY_PATH=/usr/lib/nvidia-current \2 \3\""
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        sed -i -E "s|${src_cmd}|${dst_cmd}|" "${dst_path}"
        # ----------------------------------------------------------------------
    done
}


function set_app_with_nvidia()
{
    # --------------------------------------------------------------------------
    # 조건) nvidia gpu만 적용

    if [[ "${VENDOR}" != *"nvidia"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # junsgs
    local cur_user="${1}"

    # arch-main
    local ctr_name="${2}"

    # chromium
    local app_name="${3}"

    local lib_kwd="nvidia-current"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /homt/jungs/.local/share/applications
    local home_dir=$(eval echo ~${cur_user});
    local dst_dir="${home_dir}/.local/share/applications"

    local dst_path="";

    # /homt/jungs/.local/share/applications/arch-main-chromium.desktop
    # -iname : 대소문자 무시
    # local dst_path=$(find ${dst_dir} -iname "${ctr_name}-*${app_name}*.desktop" | tail -1 )
    local dst_paths=$(find ${dst_dir} -iname "${ctr_name}-*${app_name}*.desktop")

    local src_cmd="";
    local dst_cmd="";

    if [[ -z ${dst_paths} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    for dst_path in ${dst_paths};
    do
        # ----------------------------------------------------------------------
        if [[ -n $(cat ${dst_path} | grep -i ${lib_kwd}) ]]; then
            continue
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # [[:space:]]*(.*) 캡쳐해서 "\1"로 보낸다.
        # Exec=/usr/bin/distrobox-enter -n arch-test  --   /usr/bin/chromium  %U
        src_cmd="Exec=/usr/bin/distrobox-enter  -n ${ctr_name}  --[[:space:]]*(.*)"
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # Exec=/usr/bin/distrobox-enter -n arch-test  --   bash -c "VK_ICD_FILENAMES=$HOME/.local/share/vulkan/icd.d/nvidia_icd.json OCL_ICD_VENDORS=$HOME/.local/share/OpenCL/vendors LD_LIBRARY_PATH=/usr/lib/nvidia-current /usr/bin/chromium  %U "
        dst_cmd="Exec=/usr/bin/distrobox-enter -n ${ctr_name}  --   bash -c \"VK_ICD_FILENAMES=${home_dir}/.local/share/vulkan/icd.d/nvidia_icd.json OCL_ICD_VENDORS=${home_dir}/.local/share/OpenCL/vendors LD_LIBRARY_PATH=/usr/lib/nvidia-current \1\""
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        sed -i -E "s|^${src_cmd}|${dst_cmd}|" "${dst_path}"
        # ----------------------------------------------------------------------
    done
}
# ==============================================================================