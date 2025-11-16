#!/bin/bash

# stacer =======================================================================
# bash /core/linux/bin/system/install_stacer.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="stacer"

# stacer
APP_UNIQUE_NAME="${APP_NAME}"

APP_GRP="Utility;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 (nix) ===========================================
function set_desktop()
{
    # args ---------------------------------------------------------------------
    # ${CUR_USER}
    # ${APP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}";

    if [[ *"${DESKTOP_PATH}"* == *".local"* ]]; then
        # ~/.local/share/applications/stacer.desktop
        su - ${CUR_USER} -c "echo '${DESKTOP_CMD}' > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/stacer.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}


function install_stacer_for_nix()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 2) install_stacer --------------------------------------------------------
    # https://search.nixos.org/packages
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -q | grep -iq ^${APP_NAME} || \
    nix-env -iA nixpkgs.${APP_NAME}"
    # --------------------------------------------------------------------------

    # 3) EXEC_PATH -------------------------------------------------------------
    # ~/.nix-profile/bin/stacer
    local NIX_EXEC_PATH="${HOME_DIR}/.nix-profile/bin/${APP_NAME}"

    # /usr/bin/stacer
    local EXEC_PATH="/usr/bin/${APP_NAME}"

    if [[ -f ${NIX_EXEC_PATH} ]]; then
        if [[ ! -f ${EXEC_PATH} ]]; then
            ln -s ${NIX_EXEC_PATH} ${EXEC_PATH};
        fi
    fi
    # --------------------------------------------------------------------------

    # 4) ICON_PATH -------------------------------------------------------------
    # ~/.nix-profile/share/icons/icons/stacer.png
    local NIX_ICON_PATH="${HOME_DIR}/.nix-profile/share/icons/${APP_UNIQUE_NAME}.png"

    if [[ -f ${NIX_ICON_PATH} ]]; then
        local ICON_PATH="${NIX_ICON_PATH}";
    else
        # ----------------------------------------------------------------------
        # /usr/share/icons/hicolor/64x64/apps/stacer.png
        # local ICON_PATH="/usr/share/icons/hicolor/64x64/apps/${APP_UNIQUE_NAME}.png";

        # /usr/share/icons/Papirus/48x48/apps/stacer.svg
        local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # 5) DESKTOP_PATH ----------------------------------------------------------
    # ~/.nix-profile/share/applications/stacer.desktop
    local NIX_DESKTOP_PATH="${HOME_DIR}/.nix-profile/share/applications/${APP_UNIQUE_NAME}.desktop";

    # ~/.local/share/applications/stacer.desktop
    local DESKTOP_PATH="${HOME_DIR}/.local/share/applications/${APP_UNIQUE_NAME}.desktop";

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


# Main : x86_64, i686, aarch64 =================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^stacer) ]] || apt install -y stacer;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "stacer is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    # [[ -n $(yum list installed | grep -i ^stacer) ]] || yum install -y stacer;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    echo "stacer is not supported for rocky"
	# because of error
    # install_stacer_for_nix;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0
