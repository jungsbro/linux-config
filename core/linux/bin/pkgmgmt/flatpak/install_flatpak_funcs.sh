#!/bin/bash
set -e

[[ -n "${_INSTALL_FLATPAK_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_FLATPAK_FUNCS_LOADED=1

# usage ========================================================================
# local app_fullname="${APP_FULLNAME}";
# local cur_user="${CUR_USER}";
# source ${CORE_BIN_DIR}/pkgmgmt/flatpak/install_flatpak_funcs.sh && install_flatpakpkg "${app_fullname}" "${cur_user}";
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
    # install_flatpakpkg "https://github.com/storytold/photocraft/releases/download/v0.18.0/photocraft-0.18.0-linux-x86_64.flatpak" ${CUR_USER}
    # install_flatpakpkg "./photocraft-0.18.0-linux-x86_64.flatpak" ${CUR_USER}
    # install_flatpakpkg "com.github.maoschanz.drawing" ${CUR_USER}

    # 1) env-vars settings -----------------------------------------------------
    # "https://github.com/storytold/photocraft/releases/download/v0.18.0/photocraft-0.18.0-linux-x86_64.flatpak"
    # ./photocraft-0.18.0-linux-x86_64.flatpak
    # com.github.maoschanz.drawing
    local app_fullname="${1}"

    local cur_user="${2}";

    if [[ "${app_fullname}" == *"https"* ]]; then
        # ----------------------------------------------------------------------
        # https://github.com/storytold/photocraft/releases/download/v0.18.0/photocraft-0.18.0-linux-x86_64.flatpak >> photocraft-0.18.0-linux-x86_64.flatpak
        local app_fname=$(basename "${app_fullname}");

        # photocraft-0.18.0-linux-x86_64.flatpak >> photocraft
        local app_name=$(echo "${app_fname}" | cut -d "_" -f 1 | cut -d "-" -f 1 2>/dev/null || true)

        # /tmp/photocraft
        local tmp_dir="/tmp/${app_name}";
        [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";

        # /tmp/photocraft/photocraft-0.18.0-linux-x86_64.flatpak
        local deb_path="${tmp_dir}/${app_fname}"

        if [[ ! -f "${deb_path}" ]]; then
            wget "${app_fullname}" -O "${deb_path}"
        fi
        app_fullname="${deb_path}";
        # ----------------------------------------------------------------------

    elif [[ "${app_fullname}" == *".flatpak"* ]]; then
        # ----------------------------------------------------------------------
        # ./photocraft-0.18.0-linux-x86_64.flatpak >> photocraft-0.18.0-linux-x86_64.flatpak
        local app_fname=$(basename "${app_fullname}");

        # photocraft-0.18.0-linux-x86_64.flatpak >> photocraft
        local app_name=$(echo "${app_fname}" | cut -d "_" -f 1 | cut -d "-" -f 1 2>/dev/null || true)
        # ----------------------------------------------------------------------

    else
        # ----------------------------------------------------------------------
        # com.github.maoschanz.drawing >> drawing
        local app_name=$(echo "${app_fullname}" | rev | cut -d "." -f 1 | rev 2>/dev/null || true)
        # ----------------------------------------------------------------------
    fi
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
    # echo "${app_name}"

    # 방법1) 설치된 app이 없으면 설치
    # if [[ -n $(flatpak list --app | grep -i "${app_name}") ]]; then
    #     flatpak install -y --user "${app_fullname} || true";
    # fi

    # 방법2) 변경사항이 있으면 update (photocraft 때문에)
    su - "${cur_user}" -c "flatpak install -y --user --or-update \"${app_fullname}\" || true";

    # 방법3) 재설치
    # su - "${cur_user}" -c "flatpak install -y --user --reinstall \"${app_fullname}\" || true";
    # --------------------------------------------------------------------------
}

# ==============================================================================
