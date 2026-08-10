#!/bin/bash
set -e

# usage ========================================================================
# source ${CORE_BIN_DIR}/graphics/gimp/install_gimp_funcs.sh && install_photogimp ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function install_photogimp()
{
    # --------------------------------------------------------------------------
    # jungs
    local cur_user="${1}";

    # PhotoGIMP
    local app_name="PhotoGIMP";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # /tmp/PhotoGIMP
    local tmp_dir="/tmp/${app_name}";

    if [[ -d "${tmp_dir}" ]]; then
        rm -Rf ${tmp_dir};
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${cur_user} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    if [[ -n $(flatpak list --app | grep -i gimp) ]]; then  # for flatpak
        # for flatpak ----------------------------------------------------------
        # https://github.com/Diolinux/PhotoGIMP/releases/download/3.0/PhotoGIMP-linux.zip
        local url="https://github.com/Diolinux/${app_name}/releases/download/3.0/${app_name}-linux.zip";

        # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
        local zip_path="${tmp_dir}/${app_name}-linux.zip"
        # ----------------------------------------------------------------------
    else
        # for "deb, rpm" -------------------------------------------------------
        # https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip
        local url="https://github.com/Diolinux/${app_name}/releases/download/1.1/${app_name}.zip";

        # /tmp/PhotoGIMP/PhotoGIMP.zip
        local zip_path="${tmp_dir}/${app_name}.zip"
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
    # /tmp/PhotoGIMP/PhotoGIMP.zip
    if [[ ! -e "${zip_path}" ]]; then
        # ----------------------------------------------------------------------
        mkdir -p ${tmp_dir};
        chmod 777 ${tmp_dir};
        # ----------------------------------------------------------------------
        # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
        # /tmp/PhotoGIMP/PhotoGIMP.zip
        wget "${url}" -O "${zip_path}";
        # ----------------------------------------------------------------------
    fi

    # /tmp/PhotoGIMP/PhotoGIMP-linux.zip
    # /tmp/PhotoGIMP/PhotoGIMP.zip
    unzip "${zip_path}" -d ${tmp_dir};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(flatpak list --app | grep -i gimp) ]]; then  # for flatpak
        # ----------------------------------------------------------------------
        # /tmp/PhotoGIMP/PhotoGIMP-linux/.config
        local conf_dir="${tmp_dir}/${app_name}-linux/.config";

        # /tmp/PhotoGIMP/PhotoGIMP-linux/.local
        local local_dir="${tmp_dir}/${app_name}-linux/.local";

        su - ${cur_user} -c "cp -Rf ${conf_dir} ~/";
        su - ${cur_user} -c "cp -Rf ${local_dir} ~/";
        # ----------------------------------------------------------------------
    else                                                    # for "deb, rpm"
        # ----------------------------------------------------------------------
        # /tmp/PhotoGIMP/PhotoGIMP-master/.var/app/org.gimp.GIMP/config/GIMP
        local gimp_dir="${tmp_dir}/${app_name}-master/.var/app/org.gimp.GIMP/config/GIMP";

        su - ${cur_user} -c "cp -Rf ${gimp_dir} ~/.config/";
        # ----------------------------------------------------------------------
    fi

    # if [[ -e "${local_dir}" ]]; then
    # fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================

# ==============================================================================

