#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${APP_NAME}" "multi" "${CUR_USER}"
# source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${APP_NAME}" "single" "${CUR_USER}"
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function get_core_bin_dir_from_nix()
{
    # /core/linux/bin/pkgmgmt/nix
    local cur_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local root_dir="${cur_dir}/../../../../.."

    # core/linux/bin
    local core_bin_dir="${root_dir}/core/linux/bin"

    echo "${core_bin_dir}"
}


function install_nixpkg()
{
    # install_nixpkg ${app_name} ${mod} ${cur_user}
    # install_nixpkg "freefilesync" "multi" "jungs"

    # 1) env-vars settings -----------------------------------------------------
    # freefilesync
    local app_name=${1}

    # multi / single
    local mod=${2}

    # junsgs
    local cur_user=${3}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local core_bin_dir=$(get_core_bin_dir_from_nix);

    # /homt/jungs
    local home_dir=$(eval echo ~${cur_user});

    # x86_64 / aarch64 / i686
    local cur_arch=$(uname -m);

    # /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    if [[ *"${mod}"* == *"multi"* ]]; then
        # multi-user
        local nix_env_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
    else
        # single-user
        local nix_env_path="${home_dir}/.nix-profile/etc/profile.d/nix.sh";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${cur_user} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash ${core_bin_dir}/pkgmgmt/nix/install_nix.sh ${cur_user};
    # --------------------------------------------------------------------------

    # 3) install_freefilesync --------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.freefilesync
    # nix profile add nixpkgs#freefilesync
    su - ${cur_user} -c "source ${nix_env_path} && \
    nix profile list 2>/dev/null | grep -iq ${app_name} || \
    nix profile add nixpkgs#${app_name}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${mod}"* == *"multi"* ]]; then
        return
    fi

    # both of multi-user and single-user
    return
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local cur_name="";

    local src_dir="${home_dir}/.nix-profile/bin"

    local dst_dir="${home_dir}/.local/bin"
    if [[ ! -d ${dst_dir} ]]; then
        su - ${cur_user} -c "mkdir -p ${dst_dir}"
    fi

    for cur_name in $(ls ${src_dir});
    do
        src_path="${src_dir}/${cur_name}";
        if [[ ! -f ${src_path} ]]; then
            continue
        fi

        dst_path="${dst_dir}/${cur_name}";
        if [[ -f ${dst_path} ]]; then
            continue
        fi

        su - ${cur_user} -c "ln -s ${src_path} ${dst_path}";
    done
    # --------------------------------------------------------------------------

    # 5) icon settngs ----------------------------------------------------------
    local name_list="icons pixmaps";
    local cur_name="";
    local src_dir="";
    local dst_dir="";

    for cur_name in ${name_list};
    do
        src_dir="${home_dir}/.nix-profile/share/${cur_name}"
        dst_dir="${home_dir}/.local/share/${cur_name}"

        if [[ -d ${src_dir} ]]; then
            su - ${cur_user} -c "mkdir -p \"${dst_dir}\""

            # ------------------------------------------------------------------
            # -r : recursive
            # -u : update
            # -L : dereference
            cp -ru -L ${src_dir}/* "${dst_dir}/"
            chown -R ${cur_user}:${cur_user} "${dst_dir}"
            chmod -R 755 ${dst_dir}
            # ------------------------------------------------------------------

            gtk-update-icon-cache "${dst_dir}" 2>/dev/null
        fi
    done
    # --------------------------------------------------------------------------

    # 6) desktop settings ------------------------------------------------------
    local src_dir="${home_dir}/.nix-profile/share/applications"
    local dst_dir="${home_dir}/.local/share/applications"

    if [[ -d ${src_dir} ]]; then
        su - ${cur_user} -c "mkdir -p \"${dst_dir}\""

        # ----------------------------------------------------------------------
        # -u : update
        # -L : dereference
        cp -u -L ${src_dir}/*.desktop "${dst_dir}/"
        chown -R ${cur_user}:${cur_user} "${dst_dir}"
        chmod -R 744 ${dst_dir}
        # ----------------------------------------------------------------------

        update-desktop-database "${dst_dir}"
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# main =========================================================================

# ==============================================================================
