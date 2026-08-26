#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_korean.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

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
function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # fontconfig -----------------------------------------------------------
        local app_name="fontconfig"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # 방법1)
        # bash ${CORE_BIN_DIR}/ime/install_fcitx.sh "${CUR_USER}";

        # 방법2)
        bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh "${CUR_USER}";

        # 방법3)
        # bash ${CORE_BIN_DIR}/ime/install_ibus.sh "${CUR_USER}";

        # 방법4)
        # bash ${CORE_BIN_DIR}/ime/install_kime.sh "${CUR_USER}";

        # 방법5)
        # bash ${CORE_BIN_DIR}/ime/install_nimf.sh "${CUR_USER}";

        # 방법6)
        # bash ${CORE_BIN_DIR}/ime/install_uim.sh "${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # fontconfig -----------------------------------------------------------
        local app_name="fontconfig"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # 방법0)
        # if [[ "${CUR_VER}" == *"ID=MX"* ]] || [[ "${CUR_VER}" == *"antix"* ]]; then
        #     # echo "mxlinux and anix needs to use package installer"
        #     local app_name="fcitx"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        #     local app_name="fcitx-hangul"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        #     [[ -n $(apt list --installed | grep -i ^im-config) ]] && /usr/bin/im-config -n fcitx;
        # else
        #     # echo ""
        #     local app_name="uim"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        #     local app_name="uim-byeoru"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        #     [[ -n $(apt list --installed | grep -i ^im-config) ]] && /usr/bin/im-config -n uim;
        # fi

        # 방법1)
        # bash ${CORE_BIN_DIR}/ime/install_fcitx.sh "${CUR_USER}";

        # 방법2)
        bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh "${CUR_USER}";

        # 방법3)
        # bash ${CORE_BIN_DIR}/ime/install_ibus.sh "${CUR_USER}";

        # 방법4)
        # bash ${CORE_BIN_DIR}/ime/install_kime.sh "${CUR_USER}";

        # 방법5)
        # bash ${CORE_BIN_DIR}/ime/install_nimf.sh "${CUR_USER}";

        # 방법6)
        # bash ${CORE_BIN_DIR}/ime/install_uim.sh "${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # fontconfig -----------------------------------------------------------
        local app_name="fontconfig"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # 방법1)
        # bash ${CORE_BIN_DIR}/ime/install_fcitx.sh "${CUR_USER}";

        # 방법2)
        bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh "${CUR_USER}";

        # 방법3)
        # bash ${CORE_BIN_DIR}/ime/install_ibus.sh "${CUR_USER}";

        # 방법4)
        # bash ${CORE_BIN_DIR}/ime/install_kime.sh "${CUR_USER}";

        # 방법5)
        # bash ${CORE_BIN_DIR}/ime/install_nimf.sh "${CUR_USER}";

        # 방법6)
        # bash ${CORE_BIN_DIR}/ime/install_uim.sh "${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # fontconfig -----------------------------------------------------------
        local app_name="fontconfig"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # rhel 이라면 한/영 전환을 위해 의존성 패키지가 꼭 설치해야 한다.
        local app_name="gtk3"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gtk3-immodule-xim"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # ibus-hangul has a problem at google-docs

        # 방법1)
        # bash ${CORE_BIN_DIR}/ime/install_fcitx.sh "${CUR_USER}";

        # 방법2)
        # bash ${CORE_BIN_DIR}/ime/install_fcitx5.sh "${CUR_USER}";

        # 방법3)
        # bash ${CORE_BIN_DIR}/ime/install_ibus.sh "${CUR_USER}";

        # 방법4)
        # bash ${CORE_BIN_DIR}/ime/install_kime.sh "${CUR_USER}";

        # 방법5)
        bash ${CORE_BIN_DIR}/ime/install_nimf.sh "${CUR_USER}";

        # 방법6)
        # bash ${CORE_BIN_DIR}/ime/install_uim.sh "${CUR_USER}";

        # ----------------------------------------------------------------------
    fi

    # fonts --------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/fonts/install_fonts-nanum.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh "${CUR_USER}";
    bash ${CORE_BIN_DIR}/fonts/install_fonts-d2coding.sh "${CUR_USER}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================