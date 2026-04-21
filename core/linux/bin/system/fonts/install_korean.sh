#!/bin/bash

# korean =======================================================================
# bash ${CORE_BIN_DIR}/system/fonts/install_korean.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/fonts
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # fontconfig -----------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^fontconfig) ]] || pacman -S --needed --noconfirm fontconfig;
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx5.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_ibus.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_kime.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_nimf.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_uim.sh ${CUR_USER};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # fontconfig -----------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^fontconfig) ]] || apt install -y fontconfig;
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # if [[ *"${CUR_VER}"* == *"ID=MX"* ]] || [[ *"${CUR_VER}"* == *"antix"* ]]; then
        #     echo "mxlinux and anix needs to use package installer"
        #     [[ -n $(apt list --installed | grep -i ^fcitx) ]] || apt install -y fcitx fcitx-hangul;
        #     [[ -n $(apt list --installed | grep -i ^im-config) ]] && /usr/bin/im-config -n fcitx;
        # else
        #     echo ""
        #     [[ -n $(apt list --installed | grep -i ^uim) ]] || apt install -y uim uim-byeoru;
        #     [[ -n $(apt list --installed | grep -i ^im-config) ]] && /usr/bin/im-config -n uim;
        # fi

        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx5.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_ibus.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_kime.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_nimf.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_uim.sh ${CUR_USER};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # fontconfig -----------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^fontconfig) ]] || dnf install -y fontconfig;
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # ibus-hangul has a problem at google-docs

        # [[ -n $(dnf list --installed | grep -i ^ibus-hangul) ]] || dnf install -y ibus-hangul;
        # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
        #     [[ -n $(dnf list --installed | grep -i ^im-chooser) ]] || dnf install -y im-chooser;
        # fi

        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx5.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_ibus.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_kime.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_nimf.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_uim.sh ${CUR_USER};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # fontconfig -----------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^fontconfig) ]] || dnf install -y fontconfig;
        # ----------------------------------------------------------------------

        # ime ------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/system/fonts/ime/install_fcitx5.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_ibus.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_kime.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_nimf.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/fonts/ime/install_uim.sh ${CUR_USER};
        # ----------------------------------------------------------------------
    fi

    # fonts --------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/system/fonts/install_fonts-nanum.sh ${CUR_USER};
    bash ${CORE_BIN_DIR}/system/fonts/install_fonts-hacknerdfont.sh ${CUR_USER};
    bash ${CORE_BIN_DIR}/system/fonts/install_fonts-d2coding.sh ${CUR_USER};
    # --------------------------------------------------------------------------

fi
# ==============================================================================
