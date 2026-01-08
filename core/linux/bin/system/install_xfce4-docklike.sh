#!/bin/bash

# docklike =====================================================================
# bash /core/linux/bin/system/install_xfce4-docklike.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="xfce4-docklike-plugin"

APP_DESKTOP_DIR="/usr/share/xfce4/panel/plugins"
APP_DESKTOP_PATH="${APP_DESKTOP_DIR}/docklike.desktop"

APP_SO_DIR="/usr/lib/x86_64-linux-gnu/xfce4/panel/plugins"
APP_SO_PATH="${APP_SO_DIR}/libdocklike.so"
# ------------------------------------------------------------------------------
# ==============================================================================


# func =========================================================================
function install_docklike_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    if [[ -f ${APP_DESKTOP_PATH} ]]; then
        return
    fi
    if [[ -f ${APP_SO_PATH} ]]; then
        return
    fi
    # --------------------------------------------------------------------------


    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="xfce.xfce4-docklike-plugin"

    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        # multi-user
        local DST_PATH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
    else
        # single-user
        local DST_PATH="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
    fi
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_docklike -------------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.xfce.xfce4-docklike-plugin
    # nix profile add nixpkgs#xfce.xfce4-docklike-plugin
    su - ${CUR_USER} -c "source ${DST_PATH} && \
    nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
    nix profile add nixpkgs#${APP_NAME}"
    # --------------------------------------------------------------------------

    # docklike.desktop ---------------------------------------------------------
    # ln -s ~/.nix-profile/share/xfce4/panel/plugins/docklike.desktop /usr/share/xfce4/panel/plugins/docklike.desktop
    local src_dir="${HOME_DIR}/.nix-profile/share/xfce4/panel/plugins"

    if [[ -d ${src_dir} ]]; then
        if [[ -d ${APP_DESKTOP_DIR} ]]; then
            cp -u -L ${src_dir}/*.desktop "${APP_DESKTOP_DIR}/"
        fi
    fi
    # --------------------------------------------------------------------------

    # libdocklike.so -----------------------------------------------------------
    # ln -s ~/.nix-profile/lib/xfce4/panel/plugins/libdocklike.so /usr/lib/x86_64-linux-gnu/xfce4/panel/plugins/libdocklike.so
    local src_dir="${HOME_DIR}/.nix-profile/lib/xfce4/panel/plugins"

    if [[ -d ${src_dir} ]]; then
        if [[ -d ${APP_SO_DIR} ]]; then
            cp -u -L ${src_dir}/*.so "${APP_SO_DIR}/"
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ *"${mod}"* == *"multi"* ]]; then
    #     return
    # fi
    return
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "docklike" \
    )

    local src_dir="${HOME_DIR}/.nix-profile/bin"
    local dst_dir="${HOME_DIR}/.local/bin"

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
    local dst_dir="${HOME_DIR}/.local/share/applications"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -u : update
        # -L : dereference
        cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

        update-desktop-database "${dst_dir}"
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    # [[ -n $(apt list --installed | grep -i ^${APP_NAME}) ]] || apt install -y ${APP_NAME};
    install_docklike_for_nix "multi";
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_docklike_for_nix "single";
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0
