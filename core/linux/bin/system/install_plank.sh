#!/bin/bash

# plank ========================================================================
# bash /core/linux/bin/system/plank.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="plank"

APP_UNIQUE_NAME="${APP_NAME}" 

APP_GRP="Utility"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function autostart_plank()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local START_DIR='${HOME}/.config/autostart'
    local START_PATH="${START_DIR}/plank.desktop"

    local START_CMD="[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=plank
Comment=Dock
Exec=plank
OnlyShowIn=XFCE;
RunHook=0
StartupNotify=false
Terminal=false
Hidden=false"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ${START_DIR} ]] || mkdir -p ${START_DIR}";
    su - ${CUR_USER} -c "[[ -f ${START_PATH} ]] || echo '${START_CMD}' > ${START_PATH}";
    # --------------------------------------------------------------------------
}
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
        # ~/.local/share/applications/plank.desktop
        su - ${CUR_USER} -c "echo '${DESKTOP_CMD}' > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/plank.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
 }


function install_plank_for_nix()
{
    # 0) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};   
    # --------------------------------------------------------------------------

    # 1) install_plank ---------------------------------------------------------
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
    # ~/.nix-profile/bin/plank
    local NIX_EXEC_PATH="${HOME_DIR}/.nix-profile/bin/${APP_NAME}"
    
    # /usr/bin/plank
    local EXEC_PATH="/usr/bin/${APP_NAME}"
    
    if [[ -f ${NIX_EXEC_PATH} ]]; then
        if [[ ! -f ${EXEC_PATH} ]]; then
            ln -s ${NIX_EXEC_PATH} ${EXEC_PATH};
        fi
    fi
    # --------------------------------------------------------------------------    
    
    # 4) ICON_PATH -------------------------------------------------------------    
    # ~/.nix-profile/share/icons/icons/hicolor/48x48/apps/plank.svg
    local NIX_ICON_PATH="${HOME_DIR}/.nix-profile/share/icons/hicolor/48x48/apps/${APP_UNIQUE_NAME}.svg"
    
    if [[ -f ${NIX_ICON_PATH} ]]; then
        local ICON_PATH="${NIX_ICON_PATH}";
    else
        # ----------------------------------------------------------------------
        # /usr/share/icons/hicolor/48x48/apps/plank.svg
        # local ICON_PATH="/usr/share/icons/hicolor/48x48/apps/${APP_UNIQUE_NAME}.svg";
        
        # /usr/share/icons/Papirus/48x48/apps/plank.svg
        local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
        # ----------------------------------------------------------------------
    fi  
    # --------------------------------------------------------------------------

    # 5) DESKTOP_PATH ----------------------------------------------------------
    # ~/.nix-profile/share/applications/plank.desktop
    local NIX_DESKTOP_PATH="${HOME_DIR}/.nix-profile/share/applications/${APP_UNIQUE_NAME}.desktop";

    # ~/.local/share/applications/plank.desktop
    local DESKTOP_PATH="${HOME_DIR}/.local/share/applications/${APP_UNIQUE_NAME}.desktop";
    
    if [[ -f ${NIX_DESKTOP_PATH} ]]; then
        su - ${CUR_USER} -c "ln -s ${NIX_DESKTOP_PATH} ${DESKTOP_PATH}";
    else
        set_desktop;    
    fi       
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^plank) ]] || apt install -y plank;

    # autostart_plank;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    echo "plank is not supported for centos"
    # [[ -n $(yum list installed | grep -i ^plank) ]] || yum install -y plank;

    # autostart_plank;
    # --------------------------------------------------------------------------
    
elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    install_plank_for_nix;
fi
# ==============================================================================


exit 0