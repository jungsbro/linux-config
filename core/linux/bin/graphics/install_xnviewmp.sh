#!/bin/bash

# xnviewmp =====================================================================
# bash /core/linux/bin/graphics/install_xnviewmp.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func =========================================================================

function install_xnviewmp_for_nix()     # it has error / not working
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="xnviewmp"
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_xnviewmp --------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.xnviewmp
    # nix profile add nixpkgs#xnviewmp
    su - ${CUR_USER} -c "source ~/.nix-profile/etc/profile.d/nix.sh && \
    nix profile list 2>/dev/null | grep -iq ^${APP_NAME} || \
    nix profile add nixpkgs#${APP_NAME}"
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "xnviewmp" \
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

    # 5) icon settngs ----------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/icons"
    local dst_dir="/usr/share/icons"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -r : recursive
        # -u : update
        cp -ru ${src_dir}/* "${dst_dir}/"

        gtk-update-icon-cache "${dst_dir}" 2>/dev/null
    fi
    # --------------------------------------------------------------------------

    # 6) desktop settings ------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/applications"
    local dst_dir="/usr/local/share/applications"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -u : update
        # -L : dereference
        cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

        update-desktop-database "${dst_dir}"
    fi
    # --------------------------------------------------------------------------
}


function install_xnviewmp_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
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
    [[ -n $(flatpak list --app | grep -i xnview) ]] || flatpak install -y flathub com.xnview.XnViewMP;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main : x86_64 ================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    install_xnviewmp_for_flatpak;

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    install_xnviewmp_for_flatpak;

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    install_xnviewmp_for_flatpak;
fi
# ==============================================================================

exit 0