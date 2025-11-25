#!/bin/bash

# drawing ======================================================================
# bash /core/linux/bin/graphics/install_drawing.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="drawing"

# com.github.maoschanz.drawing
APP_UNIQUE_NAME="com.github.maoschanz.${APP_NAME}"

APP_GRP="Graphics;GNOME;GTK;"
# ------------------------------------------------------------------------------
# ==============================================================================


# func =========================================================================
function set_desktop()  # not used
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}
Terminal=false"

    if [[ *"${DESKTOP_PATH}"* == *"\/home"* ]]; then
        # ~/.local/share/applications/com.github.maoschanz.drawing.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/com.github.maoschanz.drawing.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}


function install_drawing_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars_settings -----------------------------------------------------
    local APP_NAME="drawing"
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_drawing -------------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.drawing
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -q | grep -iq ^${APP_NAME} || \
    nix-env -iA nixpkgs.${APP_NAME}"
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "drawing" \
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

    # 7) etc -------------------------------------------------------------------
    # ~/.nix-profile/share/drawing
    # --------------------------------------------------------------------------
}


function install_drawing_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64 / aarch64
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(yum list installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list installed | grep -i ^flatpak) ]] || bash /core/linux/bin/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(flatpak list --app | grep -i kolourpaint) ]] || flatpak install -y flathub com.github.maoschanz.drawing;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
# for x86_64, i686, aarch64
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^${APP_NAME}) ]] || apt install -y ${APP_NAME};
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # --------------------------------------------------------------------------
    install_drawing_for_nix;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    install_drawing_for_nix;
fi
# ==============================================================================

exit 0
