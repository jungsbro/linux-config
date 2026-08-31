#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/ububox/install_ububox-main.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/ububox
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=$(whoami);
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CTR_NAME="ububox-main"

# IMAGE="docker.io/library/ubuntu:latest"
IMAGE="docker.io/library/ubuntu:24.04"
# IMAGE="docker.io/library/ubuntu:22.04"

# true / false (for rhel / vfx-dcc)
VFX_DEPS="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/container/distrobox/ububox/install_ububox_funcs.sh;

    # "ububox-main"
    local ctr_name="${CTR_NAME}";

    # "docker.io/library/ubuntu:latest"
    local image="${IMAGE}";

    # true / false
    local vfx_deps="${VFX_DEPS}";

    # "jungs"
    local cur_user="${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container
    create_ctr "${ctr_name}" "${image}" "${vfx_deps}" "${cur_user}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # apps

    install_xcape "${ctr_name}";                      # not used
    install_synapse "${ctr_name}";                    # not used
    install_skippy-xd "${ctr_name}";                  # not used
    install_freefilesync "${ctr_name}" "${cur_user}"; # not used

    install_terminal "${ctr_name}" "${cur_user}";     # not used
    install_autokey "${ctr_name}" "${cur_user}";
    install_redshift "${ctr_name}" "${cur_user}";
    install_gnome-keyring "${ctr_name}";
    install_vscode "${ctr_name}" "${cur_user}";
    install_doublecmd "${ctr_name}";
    install_chromium "${ctr_name}" "${cur_user}";     # not used
    install_google-chrome "${ctr_name}" "${cur_user}";
    install_firefox "${ctr_name}" "${cur_user}";      # not used
    install_remmina "${ctr_name}";
    install_libreoffice "${ctr_name}";                # not used
    install_qpdf "${ctr_name}";
    install_gimp "${ctr_name}" "${cur_user}";         # not used
    install_drawing "${ctr_name}";
    install_vlc "${ctr_name}" "${cur_user}";
    install_kdenlive "${ctr_name}" "${cur_user}";     # not used
    install_shotcut "${ctr_name}" "${cur_user}";      # not used
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
