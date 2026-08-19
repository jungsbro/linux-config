#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/wm/fluxbox/fb/install_fluxbox.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/wm/fluxbox/fb
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="fluxbox"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()
{
    # --------------------------------------------------------------------------
    # /etc/X11/fluxbox/
    # /usr/share/fluxbox
    # ~/.nix-profile/share/fluxbox

    # ./config/.fluxbox
    local src_dir="${CUR_DIR}/config/.fluxbox";

    # ~/.fluxbox
    local dst_dir="${HOME_DIR}/.fluxbox";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${dst_dir}" ]]; then
        return 0
    fi

    su - ${CUR_USER} -c "mkdir -p ${dst_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -d "${src_dir}" ]]; then

        # cp -rf ./config/.fluxbox/* ~/.fluxbox
        su - ${CUR_USER} -c "cp -rf ${src_dir}/* ${dst_dir}/";
    fi
    # --------------------------------------------------------------------------
}


function hide_fb-toolbar()
{
    # --------------------------------------------------------------------------
    local dst_path="${HOME_DIR}/.fluxbox/init";

    local key="session.screen0.toolbar.visible";
    local value="false"

    # session.screen0.toolbar.visible: false
    local cmd="${key}: ${value}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f "${dst_path}" ]]; then
        return 0
    fi

    if [[ -n $(grep -i "${key}" "${dst_path}") ]]; then
        sed -i "s|${key}:.*|${cmd}|g" ${dst_path};
    else
        echo "${cmd}" >> ${dst_path};
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # echo "fluxbox is not available on rhel";

        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    copy_config_to_home;

    hide_fb-toolbar;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================

