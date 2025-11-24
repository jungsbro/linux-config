#!/bin/bash

# Window Manager / Desktop Environment =========================================
# bash /core/linux/bin/wmde/config_wmde.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
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
        bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"gnome"* ]] && [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then	# lxde
        # ----------------------------------------------------------------------
        bash /core/linux/bin/utilities/install_gnome-screenshot.sh;
        # ----------------------------------------------------------------------
        # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
        bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        bash /core/linux/bin/system/install_skippy-xd.sh;
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_theme.sh;
        # ----------------------------------------------------------------------
        bash /core/linux/bin/wmde/lxde/install_lxcc/install_lxcc.sh ${CUR_USER};

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                          # xfce4
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then                                         # mxlinux xfce4
            bash /core/linux/bin/system/install_xfce4-screensaver.sh;
        else
            bash /core/linux/bin/system/install_xcape.sh ${CUR_USER};
            # bash /core/linux/bin/utilities/install_galculator.sh ${CUR_USER};
            # bash /core/linux/bin/utilities/install_gnome-calculator.sh;
            bash /core/linux/bin/utilities/install_mate-calc.sh;
            bash /core/linux/bin/ide/install_mousepad.sh;
            bash /core/linux/bin/system/install_xscreensaver.sh;
        fi
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_xfce4-appmenu-plugin.sh;
        bash /core/linux/bin/system/install_xfce4-fsguard-plugin.sh;
        bash /core/linux/bin/system/install_xfce4-pulseaudio-plugin.sh;
        bash /core/linux/bin/system/install_xfce4-sensors-plugin.sh;
        bash /core/linux/bin/system/install_xfce4-taskmanager.sh;
        # ----------------------------------------------------------------------
        # bash /core/linux/bin/system/plank.sh ${CUR_USER};
        # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
        # bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        bash /core/linux/bin/system/install_skippy-xd.sh;
        bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_theme.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                           # mate
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_gnome-system-monitor.sh;
        # ----------------------------------------------------------------------
        # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
        bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        bash /core/linux/bin/system/install_skippy-xd.sh;
        # ----------------------------------------------------------------------
        bash /core/linux/bin/wmde/install_mate-menu.sh;
        bash /core/linux/bin/wmde/install_dconf.sh;
        bash /core/linux/bin/wmde/install_gnome-tweaks.sh;
        bash /core/linux/bin/system/install_theme.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then    # gnome
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        # ----------------------------------------------------------------------
        bash /core/linux/bin/wmde/install_dconf.sh;
        bash /core/linux/bin/wmde/install_gnome-tweaks.sh;
        bash /core/linux/bin/system/install_theme.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                         # cinnamon(mint)
        # ----------------------------------------------------------------------
        bash /core/linux/bin/wmde/install_dconf.sh;
        bash /core/linux/bin/wmde/install_gnome-tweaks.sh;
        bash /core/linux/bin/system/install_theme.sh;
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
        su - ${CUR_USER} -c "dbus-run-session python3 /core/linux/bin/wmde/lxde/config_lxde.py ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                            # xfce4
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c "dbus-run-session bash /core/linux/bin/wmde/xfce4/config_xfce4.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                             # mate
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f /core/linux/bin/wmde/mate/mate-conf ]] && \
        dbus-run-session dconf load /org/mate/ < /core/linux/bin/wmde/mate/mate-conf";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then    # gnome
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
            # ------------------------------------------------------------------
            # if [[ *"${CUR_VER}"* == *"VERSION_ID=\"12"* ]]; then    # deb12 (gnome4309)
            # fi
            # ------------------------------------------------------------------
            su - ${CUR_USER} -c \
            "[[ -f /core/linux/bin/wmde/gnome/gnome4010-conf ]] && \
            dbus-run-session dconf load /org/gnome/ < /core/linux/bin/wmde/gnome/gnome4010-conf";
            # ------------------------------------------------------------------

        elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
            # ------------------------------------------------------------------
            # if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
            #     su - ${CUR_USER} -c \
            #     "[[ -f /core/linux/bin/wmde/gnome/gnome0332-conf ]] && \
            #     dbus-run-session dconf load /org/gnome/ < /core/linux/bin/wmde/gnome/gnome0332-conf";
            # else                                                    # rocky9, ...
            #     su - ${CUR_USER} -c \
            #     "[[ -f /core/linux/bin/wmde/gnome/gnome4010-conf ]] && \
            #     dbus-run-session dconf load /org/gnome/ < /core/linux/bin/wmde/gnome/gnome4010-conf";
            # fi
            su - ${CUR_USER} -c \
            "[[ -f /core/linux/bin/wmde/gnome/gnome0332-conf ]] && \
            dbus-run-session dconf load /org/gnome/ < /core/linux/bin/wmde/gnome/gnome0332-conf";
            # ------------------------------------------------------------------
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                       # cinnamon(mint)
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f /core/linux/bin/wmde/cinnamon/cinnamon-conf ]] && \
        dbus-run-session dconf load /org/cinnamon/ < /core/linux/bin/wmde/cinnamon/cinnamon-conf";
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
