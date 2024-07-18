#!/bin/bash

# usage ========================================================================
# sudo bash ./config_de.sh jungs;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_DE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# desktop environment ==========================================================
if [[ *"${CUR_DE}" == *"openbox"* ]]; then                                          # lmde
    # --------------------------------------------------------------------------
    bash /core/linux/bin/utilities/install_gnome-screenshot.sh;
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_skippy-xd.sh;
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_theme.sh;
    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "python3 /core/linux/bin/de/lxde/config_lxde.py ${CUR_USER}";
    # --------------------------------------------------------------------------
elif [[ *"${CUR_DE}" == *"xfce4"* ]]; then                                          # xfce4
    # --------------------------------------------------------------------------
    # bash /core/linux/bin/utilities/install_galculator.sh;
    # bash /core/linux/bin/utilities/install_gnome-calculator.sh;
    bash /core/linux/bin/utilities/install_mate-calc.sh;
    bash /core/linux/bin/ide/install_mousepad.sh;
    bash /core/linux/bin/utilities/install_xfce4-taskmanager.sh;
    bash /core/linux/bin/de/install_xscreensaver.sh;
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_skippy-xd.sh;
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_theme.sh;
    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "python3 /core/linux/bin/de/xfce4/config_xfce4.py ${CUR_USER}";
    # --------------------------------------------------------------------------
elif [[ *"${CUR_DE}" == *"mate"* ]]; then                                           # mate
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_skippy-xd.sh;
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_dconf.sh;
    bash /core/linux/bin/de/install_gnome-tweaks.sh;
    bash /core/linux/bin/de/install_theme.sh;
    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c \
    "[[ -f /core/linux/bin/de/mate/mate-backup ]] && \
    dbus-launch dconf load /org/mate/ < /core/linux/bin/de/mate/mate-backup";
    # --------------------------------------------------------------------------
elif [[ *"${CUR_DE}" != *"cinnamon"* ]] && [[ *"${CUR_DE}" == *"gnome"* ]]; then    # gnome
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_dconf.sh;
    bash /core/linux/bin/de/install_gnome-tweaks.sh;
    # bash /core/linux/bin/de/install_theme.sh;
    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c \
    "[[ -f /core/linux/bin/de/gnome/gnome-backup ]] && \
    dbus-run-session dconf load /org/gnome/ < /core/linux/bin/de/gnome/gnome-backup";
    # --------------------------------------------------------------------------
elif [[ *"${CUR_DE}" == *"cinnamon"* ]]; then                                       # cinnamon(mint)
    # --------------------------------------------------------------------------
    bash /core/linux/bin/de/install_dconf.sh;
    bash /core/linux/bin/de/install_gnome-tweaks.sh;
    bash /core/linux/bin/de/install_theme.sh;
    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c \
    "[[ -f /core/linux/bin/de/cinnamon/cinnamon-backup ]] && \
    dbus-run-session dconf load /org/cinnamon/ < /core/linux/bin/de/cinnamon/cinnamon-backup";
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0