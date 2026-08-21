#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/de/cinnamon/install_cinnamon.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/de/cinnamon
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_cinnamon_for_dnf()
{
    # --------------------------------------------------------------------------
    local app_name="";

    local app_name_list=(
        # cinnamon
        cinnamon

        # 한/영 전환을 위해 의존성 패키지가 꼭 설치해야 한다
        gtk3 gtk3-immodule-xim
    )

    for app_name in ${app_name_list[@]};
    do
        dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # xrdp를 사용하기 위해서
    # ~/.xsession, ~/.Xclients
    source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "cinnamon" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # update -------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 확인 필요

        local app_name="cinnamon"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) tasksel
        local app_name="task-cinnamon-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) cinnamon raw
        # local app_name="cinnamon-desktop-environment"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # xrdp를 사용하기 위해서
        # ~/.xsession, ~/.Xclients
        source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "cinnamon" "${CUR_USER}"

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) ubuntu cinnamon minimal
        local app_name="ubuntucinnamon-desktop-minimal"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # 방법2) ubuntu cinnamon
        # local app_name="ubuntucinnamon-desktop"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # xrdp를 사용하기 위해서
        # ~/.xsession, ~/.Xclients
        source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "cinnamon" "${CUR_USER}"

        # dm 설정 필수 아님
        # bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        local app_name="@cinnamon-desktop"; dnf install -y "${app_name}" || true

        # 방법2)
        # install_cinnamon_for_dnf;

        # xrdp를 사용하기 위해서
        # ~/.xsession, ~/.Xclients
        source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "cinnamon" "${CUR_USER}"

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_cinnamon_for_dnf;

        # dm 설정 필수
        bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================



