#!/bin/bash

# Window Manager / Desktop Environment =========================================
# bash /core/linux/bin/wmde/config_wmde.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};

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

    elif [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then                                      # lmde
        # ----------------------------------------------------------------------
        bash /core/linux/bin/utilities/install_gnome-screenshot.sh;
        # ----------------------------------------------------------------------
        # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
        bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        bash /core/linux/bin/system/install_skippy-xd.sh;
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_theme.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                          # xfce4
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"ID=MX"* ]]; then
            # ------------------------------------------------------------------
            bash /core/linux/bin/system/install_xfce4-appmenu-plugin.sh;
            # bash /core/linux/bin/system/install_plank.sh ${CUR_USER};
            # ------------------------------------------------------------------
            # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
            # bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
            bash /core/linux/bin/system/install_skippy-xd.sh;
            bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh
            # ------------------------------------------------------------------
        else
            # bash /core/linux/bin/utilities/install_galculator.sh ${CUR_USER};
            # bash /core/linux/bin/utilities/install_gnome-calculator.sh;
            bash /core/linux/bin/utilities/install_mate-calc.sh;
            bash /core/linux/bin/ide/install_mousepad.sh;
            bash /core/linux/bin/system/install_xfce4-taskmanager.sh;
            bash /core/linux/bin/system/install_xscreensaver.sh;
            # ------------------------------------------------------------------
            bash /core/linux/bin/system/install_xfce4-appmenu-plugin.sh;
            # bash /core/linux/bin/system/plank.sh ${CUR_USER};
            # ------------------------------------------------------------------
            # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
            # bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
            bash /core/linux/bin/system/install_skippy-xd.sh;
            bash /core/linux/bin/system/install_wmctrl/install_wmctrl.sh
            # ------------------------------------------------------------------
            bash /core/linux/bin/system/install_theme.sh;
            # ------------------------------------------------------------------
        fi

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                           # mate
        # ----------------------------------------------------------------------
        bash /core/linux/bin/system/install_gnome-system-monitor.sh;
        # ----------------------------------------------------------------------
        # bash /core/linux/bin/system/install_ulauncher.sh ${CUR_USER};
        bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
        bash /core/linux/bin/system/install_skippy-xd.sh;
        # ----------------------------------------------------------------------
        bash /core/linux/bin/wmde/install_dconf.sh;
        bash /core/linux/bin/wmde/install_gnome-tweaks.sh;
        bash /core/linux/bin/system/install_theme.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then    # gnome
        # ----------------------------------------------------------------------
        bash /core/linux/bin/wmde/install_dconf.sh;
        bash /core/linux/bin/wmde/install_gnome-tweaks.sh;
        # bash /core/linux/bin/system/install_theme.sh;
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

    elif [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then                                          # lmde
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c "dbus-launch python3 /core/linux/bin/wmde/lxde/config_lxde.py ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                            # xfce4
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c "dbus-launch bash /core/linux/bin/wmde/xfce4/config_xfce4.sh ${CUR_USER}";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                             # mate
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f /core/linux/bin/wmde/mate/mate-backup ]] && \
        dbus-launch dconf load /org/mate/ < /core/linux/bin/wmde/mate/mate-backup";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then    # gnome
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f /core/linux/bin/wmde/gnome/gnome-backup ]] && \
        dbus-run-session dconf load /org/gnome/ < /core/linux/bin/wmde/gnome/gnome-backup";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                       # cinnamon(mint)
        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c \
        "[[ -f /core/linux/bin/wmde/cinnamon/cinnamon-backup ]] && \
        dbus-run-session dconf load /org/cinnamon/ < /core/linux/bin/wmde/cinnamon/cinnamon-backup";
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