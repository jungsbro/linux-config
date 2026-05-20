#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/wm/install_pkgs_for_wm.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/wm
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function install_pkgs_for_wm()
{
    if [[ -d "${HOME_DIR}/.icewm" ]]; then                                          # icewm
        # ----------------------------------------------------------------------
        # 방법1)
        bash ${CORE_BIN_DIR}/screensaver/install_xscreensaver.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/screensaver/install_xfce4-screensaver.sh;
        # ----------------------------------------------------------------------
        # 방법1)
        bash ${CORE_BIN_DIR}/screenshot/install_gnome-screenshot.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/screenshot/install_xfce4-screenshooter.sh;
        # bash ${CORE_BIN_DIR}/screenshot/install_xfce4-clipman.sh;
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/gpu/install_arandr.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/graphics/install_feh.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/launcher/install_rofi.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/terminal/install_xfce4-terminal.sh;
        bash ${CORE_BIN_DIR}/ide/install_mousepad.sh;
        # ----------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/monitoring/install_xfce4-taskmanager.sh;
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/theme/install_lxappearance.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
        # ----------------------------------------------------------------------
        # 방법1)
        bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/filemgr/gui/install_thunar.sh;
        # bash ${CORE_BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then                                          # fluxbox
        # ----------------------------------------------------------------------
        # 방법1)
        bash ${CORE_BIN_DIR}/screenshot/install_gnome-screenshot.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/screenshot/install_xfce4-screenshooter.sh;
        # bash ${CORE_BIN_DIR}/screenshot/install_xfce4-clipman.sh;
        # ----------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/gpu/install_arandr.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/graphics/install_feh.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/launcher/install_rofi.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/terminal/install_xfce4-terminal.sh;
        bash ${CORE_BIN_DIR}/ide/install_mousepad.sh;
        # ----------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/monitoring/install_xfce4-taskmanager.sh;
        # ----------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/theme/install_lxappearance.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
        # ----------------------------------------------------------------------
        # 방법1)
        # bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/filemgr/gui/install_thunar.sh;
        # bash ${CORE_BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then                                      # i3wm
        # ----------------------------------------------------------------------
        # 방법1)
        bash ${CORE_BIN_DIR}/screenshot/install_gnome-screenshot.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/screenshot/install_xfce4-screenshooter.sh;
        # bash ${CORE_BIN_DIR}/screenshot/install_xfce4-clipman.sh;
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/gpu/install_arandr.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/graphics/install_feh.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/launcher/install_rofi.sh ${CUR_USER};
        # bash ${CORE_BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/terminal/install_xfce4-terminal.sh;
        bash ${CORE_BIN_DIR}/ide/install_mousepad.sh;
        # ----------------------------------------------------------------------
        # bash ${CORE_BIN_DIR}/monitoring/install_xfce4-taskmanager.sh;
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/theme/install_lxappearance.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/theme/install_papirus-icon-theme.sh;
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/gpu/install_picom.sh;
        # ----------------------------------------------------------------------
        bash ${CORE_BIN_DIR}/panel/install_i3blocks.sh ${CUR_USER};
        bash ${CORE_BIN_DIR}/system/install_pavucontrol.sh;
        # ----------------------------------------------------------------------
        # 방법1)
        bash ${CORE_BIN_DIR}/filemgr/gui/install_pcmanfm.sh;

        # 방법2)
        # bash ${CORE_BIN_DIR}/filemgr/gui/install_thunar.sh;
        # bash ${CORE_BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_pkgs_for_wm;
fi
# ==============================================================================
