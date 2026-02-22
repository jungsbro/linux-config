#!/bin/bash

# Window Manager / Desktop Environment =========================================
# bash ${BIN_DIR}/wmde/config_wmde.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde
ROOT_DIR="$(dirname "$(realpath "$0")")"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/.."
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function install_wmde_pkg()
{
    if [[ *"${CUR_WMDE}"* == *"icewm"* ]]; then                                          # icewm (anitx)
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/system/install_synapse.sh ${CUR_USER};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"gnome"* ]] && [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then	# lxde
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/utilities/install_gnome-screenshot.sh;
        bash ${BIN_DIR}/system/install_xcape.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        # bash ${BIN_DIR}/system/install_ulauncher.sh ${CUR_USER};
        bash ${BIN_DIR}/system/install_synapse.sh ${CUR_USER};
        bash ${BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/system/install_theme.sh;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/wmde/lxde/install_lxcc/install_lxcc.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/filemgr/install_finder.sh;
        bash ${BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                          # xfce4
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then                                         # mxlinux xfce4
            bash ${BIN_DIR}/system/install_xfce4-screensaver.sh;
        else
            bash ${BIN_DIR}/system/install_xcape.sh ${CUR_USER};
            # bash ${BIN_DIR}/utilities/install_galculator.sh ${CUR_USER};
            # bash ${BIN_DIR}/utilities/install_gnome-calculator.sh;
            bash ${BIN_DIR}/utilities/install_mate-calc.sh;
            bash ${BIN_DIR}/system/install_xscreensaver.sh;
            bash ${BIN_DIR}/system/install_xfce4-docklike.sh ${CUR_USER};
        fi
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/ide/install_mousepad.sh;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/system/install_xfce4-appmenu-plugin.sh;
        bash ${BIN_DIR}/system/install_xfce4-fsguard-plugin.sh;
        bash ${BIN_DIR}/system/install_xfce4-pulseaudio-plugin.sh;
        bash ${BIN_DIR}/system/install_xfce4-sensors-plugin.sh;
        bash ${BIN_DIR}/system/install_xfce4-taskmanager.sh;
        bash ${BIN_DIR}/system/install_xfce4-whiskermenu-plugin.sh;
        # ----------------------------------------------------------------------
        # bash ${BIN_DIR}/system/plank.sh ${CUR_USER};
        # bash ${BIN_DIR}/system/install_ulauncher.sh ${CUR_USER};
        # bash ${BIN_DIR}/system/install_synapse.sh ${CUR_USER};
        bash ${BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
        bash ${BIN_DIR}/system/install_wmctrl/install_wmctrl.sh
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/system/install_theme.sh;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/filemgr/install_finder.sh;
        bash ${BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------


    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                           # mate
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/system/install_gnome-system-monitor.sh;
        # ----------------------------------------------------------------------
        # bash ${BIN_DIR}/system/install_ulauncher.sh ${CUR_USER};
        bash ${BIN_DIR}/system/install_synapse.sh ${CUR_USER};
        bash ${BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/wmde/install_mate-menu.sh;
        bash ${BIN_DIR}/wmde/install_dconf.sh;
        bash ${BIN_DIR}/wmde/install_gnome-tweaks.sh;
        bash ${BIN_DIR}/system/install_theme.sh;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/filemgr/install_finder.sh;
        bash ${BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------


    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then    # gnome
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/system/install_synapse.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/wmde/install_dconf.sh;
        bash ${BIN_DIR}/wmde/install_gnome-tweaks.sh;
        bash ${BIN_DIR}/system/install_theme.sh;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/filemgr/install_finder.sh;
        bash ${BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------


    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                         # cinnamon(mint)
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/wmde/install_dconf.sh;
        bash ${BIN_DIR}/wmde/install_gnome-tweaks.sh;
        bash ${BIN_DIR}/system/install_theme.sh;
        # ----------------------------------------------------------------------
        bash ${BIN_DIR}/filemgr/install_finder.sh;
        bash ${BIN_DIR}/system/install_gvfs.sh;
        # ----------------------------------------------------------------------
    fi
}

function config_wmde()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_WMDE}"* == *"icewm"* ]]; then                                              # icewm (anitx)
        # ----------------------------------------------------------------------
        echo ""
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"gnome"* ]] && [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then	# lxde
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c "dbus-run-session python3 ${BIN_DIR}/wmde/lxde/config_lxde.py ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                            # xfce4
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c "dbus-run-session bash ${BIN_DIR}/wmde/xfce4/config_xfce4.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                             # mate
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f ${BIN_DIR}/wmde/mate/mate-conf ]] && \
        dbus-run-session dconf load /org/mate/ < ${BIN_DIR}/wmde/mate/mate-conf";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then    # gnome
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
            # ------------------------------------------------------------------
            # if [[ *"${CUR_VER}"* == *"VERSION_ID=\"12"* ]]; then    # deb12 (gnome4309)
            # fi
            # ------------------------------------------------------------------
            su - ${CUR_USER} -c \
            "[[ -f ${BIN_DIR}/wmde/gnome/gnome4010-conf ]] && \
            dbus-run-session dconf load /org/gnome/ < ${BIN_DIR}/wmde/gnome/gnome4010-conf";
            # ------------------------------------------------------------------

        elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
            # ------------------------------------------------------------------
            # if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
            #     su - ${CUR_USER} -c \
            #     "[[ -f ${BIN_DIR}/wmde/gnome/gnome0332-conf ]] && \
            #     dbus-run-session dconf load /org/gnome/ < ${BIN_DIR}/wmde/gnome/gnome0332-conf";
            # else                                                    # rocky9, ...
            #     su - ${CUR_USER} -c \
            #     "[[ -f ${BIN_DIR}/wmde/gnome/gnome4010-conf ]] && \
            #     dbus-run-session dconf load /org/gnome/ < ${BIN_DIR}/wmde/gnome/gnome4010-conf";
            # fi
            su - ${CUR_USER} -c \
            "[[ -f ${BIN_DIR}/wmde/gnome/gnome0332-conf ]] && \
            dbus-run-session dconf load /org/gnome/ < ${BIN_DIR}/wmde/gnome/gnome0332-conf";
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                       # cinnamon(mint)
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f ${BIN_DIR}/wmde/cinnamon/cinnamon-conf ]] && \
        dbus-run-session dconf load /org/cinnamon/ < ${BIN_DIR}/wmde/cinnamon/cinnamon-conf";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
install_wmde_pkg;
config_wmde;
# ==============================================================================

exit 0
