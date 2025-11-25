#!/bin/bash

# xcape ========================================================================
# bash /core/linux/bin/system/install_xcape.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="xcape"
DESKTOP_NAME="Super_Key_Mod"

APP_GRP="Settings;System;"

# xfce4 : xfce4-popup-whiskermenu
# lxde  : lxpanelctl menu
EXEC_PATH="xcape -e 'Super_L=Control_L|Escape'"
# ------------------------------------------------------------------------------
# ==============================================================================



# Func : x86_64, i686, aarch64 =================================================
function set_desktop()
{
    # args ---------------------------------------------------------------------
    # ${CUR_USER}
    # ${DESKTOP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${DESKTOP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}
Terminal=false"

    if [[ *"${DESKTOP_PATH}"* == *"\/home"* ]]; then
        # ~/.local/share/applications/xcape.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/xcape.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}


function set_xcape_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # local EXEC_PATH="xcape -e 'Super_L=Control_L|Escape'";
    local ICON_PATH="${APP_NAME}";
    local DESKTOP_DIR="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${DESKTOP_DIR} ]] || mkdir -p ${DESKTOP_DIR}";

    local DESKTOP_PATH="${DESKTOP_DIR}/${DESKTOP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_desktop;
    # --------------------------------------------------------------------------
}


function install_xcape_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="xcape"
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_xcape --------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.xcape
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -q | grep -iq ^${APP_NAME} || \
    nix-env -iA nixpkgs.${APP_NAME}"
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "xcape" \
    )

    local src_dir="${HOME_DIR}/.nix-profile/bin"
    local dst_dir="/usr/local/bin"

    for cur_fname in "${FNAME_LIST[@]}";
    do
        src_path="${src_dir}/${cur_fname}";
        if [[ ! -f ${src_path} ]]; then
            continue
        fi

        dst_path="${dst_dir}/${cur_fname}";
        if [[ -f ${dst_path} ]]; then
            continue
        fi

        ln -s ${src_path} ${dst_path};
    done
    # --------------------------------------------------------------------------

    # 5) desktop settings ------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/applications"
    local dst_dir="/usr/local/share/applications"

    mkdir -p "${dst_dir}"
    # -u : update
    # -L : dereference
    cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

    update-desktop-database "${dst_dir}"
    # --------------------------------------------------------------------------

    # 6) icon settngs ----------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/icons"
    local dst_dir="/usr/share/icons"

    mkdir -p "${dst_dir}"
    # -r : recursive
    # -u : update
    cp -ru ${src_dir}/* "${dst_dir}/"

    gtk-update-icon-cache "${dst_dir}" 2>/dev/null
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^xcape) ]] || apt install -y xcape;
    set_xcape_autostart;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    install_xcape_for_nix;
    set_xcape_autostart;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_xcape_for_nix;
    set_xcape_autostart;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0


