#!/bin/bash
set -e

[[ -n "${_INSTALL_FLATPAK_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_FLATPAK_FUNCS_LOADED=1

# usage ========================================================================
# local app_fullname="${APP_FULLNAME}";
# source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}"
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function get_core_bin_dir_from_flatpak()
{
    # /core/linux/bin/pkgmgmt/flatpak
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}


function install_flatpakpkg()
{
    # install_flatpakpkg ${app_name}
    # install_flatpakpkg "freefilesync"

    # 1) env-vars settings -----------------------------------------------------
    # com.github.maoschanz.drawing
    local app_fullname=${1}

    # drawing
    local app_name=$(echo "${app_fullname}" | rev | cut -d "." -f 1 | rev 2>/dev/null || true)
    # lowercase
    app_name="${app_name,,}"

    local core_bin_dir=$(get_core_bin_dir_from_flatpak);

    # x86_64 / aarch64 / i686
    local cur_arch=$(uname -m);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ "${cur_arch}" == *"i686"* ]]; then

        return 0
    fi
    # --------------------------------------------------------------------------

    # 2) install flatpak -------------------------------------------------------
    bash ${core_bin_dir}/pkgmgmt/flatpak/install_flatpak.sh || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # echo ${app_name}

    [[ -n $(flatpak list --app | grep -i "${app_name}") ]] || flatpak install -y "${app_fullname}";
    # --------------------------------------------------------------------------
}

# ==============================================================================
