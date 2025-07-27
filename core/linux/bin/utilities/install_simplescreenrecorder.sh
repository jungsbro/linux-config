#!/bin/bash

# simplescreenrecorder =========================================================
# bash /core/linux/bin/utilities/install_simplescreenrecorder.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="simplescreenrecorder"

APP_UNIQUE_NAME="${APP_NAME}" 

# be.maartenbaert.simplescreenrecorder
NIX_UNIQUE_NAME="be.maartenbaert.${APP_NAME}" 

APP_GRP="Utility;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function install_ssr_for_cent()
{
    # --------------------------------------------------------------------------
    if [[ -n $(yum list installed | grep -i ^simplescreenrecorder) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^epel-release) ]] || yum install -y epel-release;
    [[ -n $(yum list installed | grep -i ^nux-dextop) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    yum install -y simplescreenrecorder;
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
        # ~/.local/share/applications/simplescreenrecorder.desktop
        su - ${CUR_USER} -c "echo '${DESKTOP_CMD}' > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/simplescreenrecorder.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
 }


function install_simplescreenrecorder_for_nix()
{
    # 0) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};   
    # --------------------------------------------------------------------------

    # 1) install_simplescreenrecorder ------------------------------------------
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
    # ~/.nix-profile/bin/simplescreenrecorder
    local NIX_EXEC_PATH="${HOME_DIR}/.nix-profile/bin/${APP_NAME}"
    
    # /usr/bin/simplescreenrecorder
    local EXEC_PATH="/usr/bin/${APP_NAME}"
    
    if [[ -f ${NIX_EXEC_PATH} ]]; then
        if [[ ! -f ${EXEC_PATH} ]]; then
            ln -s ${NIX_EXEC_PATH} ${EXEC_PATH};
        fi
    fi
    # --------------------------------------------------------------------------    
    
    # 4) ICON_PATH -------------------------------------------------------------    
    # ~/.nix-profile/share/icons/icons/hicolor/scalable/apps/simplescreenrecorder.svg
    local NIX_ICON_PATH="${HOME_DIR}/.nix-profile/share/icons/hicolor/scalable/apps/${APP_UNIQUE_NAME}.svg"
    
    if [[ -f ${NIX_ICON_PATH} ]]; then
        local ICON_PATH="${NIX_ICON_PATH}";
    else
        # ----------------------------------------------------------------------
        # /usr/share/icons/Papirus/48x48/apps/simplescreenrecorder.svg       
        local ICON_PATH="/usr/share/icons/Papirus/48x48/apps/${APP_UNIQUE_NAME}.svg";
        # ----------------------------------------------------------------------
    fi  
    # --------------------------------------------------------------------------

    # 5) DESKTOP_PATH ----------------------------------------------------------
    # ~/.nix-profile/share/applications/be.maartenbaert.simplescreenrecorder.desktop
    local NIX_DESKTOP_PATH="${HOME_DIR}/.nix-profile/share/applications/${NIX_UNIQUE_NAME}.desktop";

    # ~/.local/share/applications/simplescreenrecorder.desktop
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



# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^simplescreenrecorder) ]] || apt install -y simplescreenrecorder;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    install_ssr_for_cent;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_simplescreenrecorder_for_nix;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0