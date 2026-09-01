#!/bin/bash
set -e

[[ -n "${_INSTALL_APPIMAGE_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_APPIMAGE_FUNCS_LOADED=1

# usage ========================================================================
# local app_name="${APP_NAME}";

# local appimage_url="${APPIMAGE_URL}";
# local appimage_path="${APPIMAGE_PATH}";

# local icon_url="${ICON_URL}";
# local icon_path="${ICON_PATH}";

# local app_cat="${APP_CAT}";
# local app_hidden="${APP_HIDDEN}";
# local cur_user="${CUR_USER}";

# source ${CORE_BIN_DIR}/pkgmgmt/appimage/install_appimage_funcs.sh && \
# install_appimagepkg "${app_name}" "${appimage_url}" "${appimage_path}" "${icon_url}" "${icon_path}" "${app_cat}" "${app_hidden}" "${cur_user}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function get_core_bin_dir_from_appimage()
{
    # /core/linux/bin/pkgmgmt/appimage
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}


function install_appimagepkg()
{
    # --------------------------------------------------------------------------
    # 1) env-vars settings

    # freetube
    local app_name="${1}";

    # AudioVideo;Player
    local app_cat="${6}";

    # false
    local app_hidden="${7}";

    # jungs
    local cur_user="${8}";
    local home_dir=$(eval echo ~"${cur_user}");

    local core_bin_dir=$(get_core_bin_dir_from_appimage);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) appimage_path

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/FreeTube-0.23.5-amd64.AppImage
    local appimage_url="${2}"

    # /opt/freetube/FreeTube-0.23.5-amd64.AppImage
    local appimage_path="${3}"

    if [[ -f "${appimage_path}" ]]; then
        return 0
    fi

    local appimage_dir=$(dirname "${appimage_path}");
    [[ -d "${appimage_dir}" ]] || mkdir -p "${appimage_dir}";

    wget "${appimage_url}" -O "${appimage_path}";
    chmod +x "${appimage_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) icon_path

    local icon_url="${4}";

    # ~/.local/share/icons/freetube.png
    local icon_path="${5}";

    local icon_dir=$(dirname "${icon_path}");
    if [[ "${icon_dir}" == *".local"* ]]; then
        # ~/.local/share/icons/freetube.png
        su - "${cur_user}" -c "[[ -d ${icon_dir} ]] || mkdir -p ${icon_dir}";
    else
        # /usr/share/icons/freetube.png
        [[ -d "${icon_dir}" ]] || mkdir -p "${icon_dir}";
    fi

    if [[ -n "${icon_url}" ]]; then
        if [[ "${icon_dir}" == *".local"* ]]; then
            # ~/.local/share/icons/freetube.png
            su - "${cur_user}" -c "wget ${icon_url} -O ${icon_path}";
        else
            # /usr/share/icons/freetube.png
            wget "${icon_url}" -O "${icon_path}";
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) desktop_path

    if [[ "${icon_dir}" == *".local"* ]]; then
        # ~/.local/share/applications/freetube.deskop
        local desktop_path="${home_dir}/.local/share/applications/${app_name}.desktop";
    else
        # /usr/share/applications/freetube.deskop
        local desktop_path="/usr/share/applications/${app_name}.desktop";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 5) set_destop
    source ${core_bin_dir}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${app_name}" "${appimage_path}" "${icon_path}" "${app_cat}" "${app_hidden}" "${desktop_path}" "${cur_user}";
    # --------------------------------------------------------------------------
}
# ==============================================================================
