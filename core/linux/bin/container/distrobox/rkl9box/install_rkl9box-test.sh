#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/rkl9box/install_rkl9box-test.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/rkl9box
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
CTR_NAME="rkl9box-test"

# rokcy9/glibc가 x86-64-v2 요구 >> 구형 CPU에서는 실행 불가
# rokcy8/glibc가 x86-64-v1 기반 >> 구형 CPU에서도 문제 없이 실행 가능
IMAGE="docker.io/library/rockylinux:9.3"
# IMAGE="docker.io/library/rockylinux:9.0"

# true / false (for rhel / vfx-dcc)
VFX_DEPS="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/container/distrobox/rkl9box/install_rkl9box_funcs.sh;

    # "rkl9box-test"
    local ctr_name="${CTR_NAME}";

    # "docker.io/library/rockylinux:9.3"
    local image="${IMAGE}";

    # true / false
    local vfx_deps="${VFX_DEPS}";

    # core/linux/bin
    local core_bin_dir="${CORE_BIN_DIR}";

    # "jungs"
    local cur_user="${CUR_USER}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container
    create_ctr "${ctr_name}" "${image}" "${vfx_deps}" "${core_bin_dir}" "${cur_user}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # # apps

    # install_xcape "${ctr_name}";
    # install_synapse "${ctr_name}";
    # install_skippy-xd "${ctr_name}";
    # install_freefilesync "${ctr_name}" "${core_bin_dir}" "${cur_user}";

    # # install_terminal "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # # install_autokey "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # install_redshift "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # install_gnome-keyring "${ctr_name}";
    # install_vscode "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # # install_doublecmd "${ctr_name}";
    # install_chromium "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # install_google-chrome "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # install_firefox "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # install_remmina "${ctr_name}";
    # install_libreoffice "${ctr_name}";
    # install_qpdf "${ctr_name}";
    # # install_gimp "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # # install_drawing "${ctr_name}";
    # install_vlc "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # # install_kdenlive "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # # install_shotcut "${ctr_name}" "${core_bin_dir}" "${cur_user}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================