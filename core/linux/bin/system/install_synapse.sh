#!/bin/bash

# synapse ======================================================================
# bash /core/linux/bin/system/install_synapse.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="synapse"

# synapse
APP_UNIQUE_NAME="${APP_NAME}"

APP_GRP="GNOME;Utility"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 (nix) ===========================================
function set_desktop()
{
    local DESKTOP_CMD="[Desktop Entry]
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Type=Application
Categories=${APP_GRP}";

    if [[ *"${DESKTOP_PATH}"* == *".local"* ]]; then
        # ~/.local/share/applications/synapse.desktop
        su - ${CUR_USER} -c "echo '${DESKTOP_CMD}' > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/synapse.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
 }

function install_synapse_for_nix()
{
    # 0) install_nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 1) install_synapse -------------------------------------------------------
    # https://search.nixos.org/packages
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -q | grep -iq ^${APP_NAME} || \
    nix-env -iA nixpkgs.${APP_NAME}"
    # --------------------------------------------------------------------------

    # 2) HOME_DIR --------------------------------------------------------------
    # /home/jungs
    local HOME_DIR=$(eval echo ~${CUR_USER})
    # --------------------------------------------------------------------------

    # 3) EXEC_PATH -------------------------------------------------------------
    # ~/.nix-profile/bin/synapse
    local NIX_EXEC_PATH="${HOME_DIR}/.nix-profile/bin/${APP_NAME}"

    # /usr/bin/synapse
    local EXEC_PATH="/usr/bin/${APP_NAME}"

    if [[ -f ${NIX_EXEC_PATH} ]]; then
        if [[ ! -f ${EXEC_PATH} ]]; then
            ln -s ${NIX_EXEC_PATH} ${EXEC_PATH};
        fi
    fi
    # --------------------------------------------------------------------------

    # 4) ICON_PATH -------------------------------------------------------------
    # ~/.nix-profile/share/icons/icons/hicolor/scalable/apps/synapse.svg
    local NIX_ICON_PATH="${HOME_DIR}/.nix-profile/share/icons/hicolor/scalable/apps/${APP_UNIQUE_NAME}.svg"

    if [[ -f ${NIX_ICON_PATH} ]]; then
        local ICON_PATH="${NIX_ICON_PATH}";
    else
        # /usr/share/icons/Papirus/48x48/apps/synapse.svg
        local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg"
    fi
    # --------------------------------------------------------------------------

    # 5) DESKTOP_PATH ----------------------------------------------------------
    # ~/.nix-profile/share/applications/synapse.desktop
    local NIX_DESKTOP_PATH="${HOME_DIR}/.nix-profile/share/applications/${APP_UNIQUE_NAME}.desktop";

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # /usr/share/applications/synapse.desktop";
    # local DESKTOP_PATH="/usr/share/applications/${APP_UNIQUE_NAME}.desktop";

    # ~/.local/share/applications/synapse.desktop
    local DESKTOP_PATH="${HOME_DIR}/.local/share/applications/${APP_UNIQUE_NAME}.desktop";
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    if [[ -f ${NIX_DESKTOP_PATH} ]]; then
        # ----------------------------------------------------------------------
        if [[ ! -d "${HOME_DIR}/.local/share/applications" ]]; then
            su - ${CUR_USER} -c "mkdir -p ${HOME_DIR}/.local/share/applications";
        fi
        # ----------------------------------------------------------------------
        
        su - ${CUR_USER} -c "ln -s ${NIX_DESKTOP_PATH} ${DESKTOP_PATH}";
    else
        set_desktop;
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ -n $(apt list --installed | grep -i ^${APP_NAME}) ]] || apt install -y ${APP_NAME};

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "synapse is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    # [[ -n $(yum list installed | grep -i ^${APP_NAME}) ]] || yum install -y ${APP_NAME};
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    install_synapse_for_nix;
fi
# ==============================================================================

exit 0
