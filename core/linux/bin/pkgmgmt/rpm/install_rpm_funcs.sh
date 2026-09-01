#!/bin/bash
set -e

[[ -n "${_INSTALL_RPM_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_RPM_FUNCS_LOADED=1

# usage ========================================================================
# local app_name="${APP_NAME}";
# local rpm_url="${RPM_URL}";

# source ${CORE_BIN_DIR}/pkgmgmt/rpm/install_rpm_funcs.sh && \
# install_rpmpkg "${app_name}" "${rpm_url}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function install_rpmpkg()
{
    # --------------------------------------------------------------------------
    # 1) env-vars settings

    # freetube
    local app_name="${1}";

    if [[ -n $(dnf list --installed | grep -i ^"${app_name}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) rpm_path

    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta.amd64.rpm
    # https://github.com/FreeTubeApp/FreeTube/releases/download/v0.25.3-beta/freetube-0.25.3-beta.arm64.rpm
    local rpm_url="${2}"

    local rpm_fname=$(basename "${rpm_url}");

    # /tmp/freetube
    local tmp_dir="/tmp/${app_name}";
    [[ -d "${tmp_dir}" ]] || mkdir -p "${tmp_dir}";

    # /tmp/freetube/freetube-0.25.3-beta.amd64.rpm
    # /tmp/freetube/freetube-0.25.3-beta.arm64.rpm
    local rpm_path="${tmp_dir}/${rpm_fname}"

    if [[ ! -f "${rpm_path}" ]]; then
        wget "${rpm_url}" -O "${rpm_path}"
    fi

    dnf install -y "${rpm_path}" || true
    # --------------------------------------------------------------------------
}
# ==============================================================================
