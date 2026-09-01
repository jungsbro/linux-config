#!/bin/bash
set -e

[[ -n "${_INSTALL_PORTABLE_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_PORTABLE_FUNCS_LOADED=1

# usage ========================================================================
# local app_name="${APP_NAME}";

# local portable_url="${PORTABLE_URL}";
# local portable_path="${PORTABLE_PATH}";

# local icon_url="${ICON_URL}";
# local icon_path="${ICON_PATH}";

# local app_cat="${APP_CAT}";
# local app_hidden="${APP_HIDDEN}";
# local cur_user="${CUR_USER}";

# source ${CORE_BIN_DIR}/pkgmgmt/portable/install_portable_funcs.sh && \
# install_portablepkg "${app_name}" "${portable_url}" "${portable_path}" "${icon_url}" "${icon_path}" "${app_cat}" "${app_hidden}" "${cur_user}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function get_core_bin_dir_from_portable()
{
    # /core/linux/bin/pkgmgmt/portable
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}


function install_portablepkg()
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

    local core_bin_dir=$(get_core_bin_dir_from_portable);

    # /tmp/freetube
    local tmp_dir="/tmp/${app_name}";
    [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) portable_path

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.23.5-beta/freetube-0.23.5-linux-x64-portable.zip
    # https://sourceforge.net/projects/doublecmd/files/DC%20for%20Linux%2064%20bit/Double%20Commander%201.1.26/doublecmd-1.1.26.gtk2.x86_64.tar.xz
    local portable_url="${2}"

    # /opt/freetube/freetube
    # /opt/doublecmd/doublecmd
    local portable_path="${3}"

    if [[ -f "${portable_path}" ]]; then
        return 0
    fi

    # /tmp/freetube/freetube-0.23.5-linux-x64-portable.zip
    # /tmp/doublecmd/doublecmd-1.1.26.gtk2.x86_64.tar.xz
    local tmp_fname=$(basename "${portable_url}");
    local tmp_path="${tmp_dir}/${tmp_fname}";

    if [[ ! -f "${tmp_path}" ]]; then
        wget "${portable_url}" -O "${tmp_path}";
    fi

    # /opt/freetube
    local portable_dir=$(dirname "${portable_path}");
    [[ -d "${portable_dir}" ]] || mkdir -p "${portable_dir}";

    if [[ "${tmp_path}" == *".zip"* ]]; then
        # unzip /tmp/freetube/freetube-0.23.5-linux-x64-portable.zip -d /opt/freetube;
        unzip "${tmp_path}" -d "${portable_dir}";

    elif [[ "${tmp_path}" == *".tar"* ]]; then
        # /opt/doublecmd >> /opt
        local portable_dir2=$(dirname "${portable_dir}");
        [[ -d "${portable_dir2}" ]] || mkdir -p "${portable_dir2}";

        # tar -xvf /tmp/doublecmd/doublecmd-1.1.26.gtk2.x86_64.tar.xz -C /opt
        tar -xvf "${tmp_path}" -C "${portable_dir2}";
    else
        echo "Unknown file type: ${tmp_path}";
        return 0
    fi

    rm -f "${tmp_path}";
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
    set_desktop "${app_name}" "${portable_path}" "${icon_path}" "${app_cat}" "${app_hidden}" "${desktop_path}" "${cur_user}";
    # --------------------------------------------------------------------------
}
# ==============================================================================
