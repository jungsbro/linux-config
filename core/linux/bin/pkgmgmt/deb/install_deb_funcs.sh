#!/bin/bash
set -e

[[ -n "${_INSTALL_DEB_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_DEB_FUNCS_LOADED=1

# usage ========================================================================
# local app_name="${APP_NAME}";
# local deb_url="${DEB_URL}";

# source ${CORE_BIN_DIR}/pkgmgmt/deb/install_deb_funcs.sh && \
# install_debpkg "${app_name}" "${deb_url}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function install_debpkg()
{
    # --------------------------------------------------------------------------
    # 1) env-vars settings

    # freetube
    local app_name="${1}";

    if [[ -n $(apt list --installed | grep -i ^"${app_name}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) deb_path

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube_0.25.3_beta_amd64.deb
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube_0.25.3_beta_arm64.deb
    local deb_url="${2}"

    local deb_fname=$(basename "${deb_url}");

    # /tmp/freetube
    local tmp_dir="/tmp/${app_name}";
    [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";

    # /tmp/freetube/freetube_0.23.5_amd64.deb
    # /tmp/freetube/freetube_0.23.5_arm64.deb
    local deb_path="${tmp_dir}/${deb_fname}"

    if [[ ! -f "${deb_path}" ]]; then
        wget "${deb_url}" -O "${deb_path}"
    fi

    apt install -y --no-reinstall "${deb_path}" || true
    # --------------------------------------------------------------------------
}
# ==============================================================================
