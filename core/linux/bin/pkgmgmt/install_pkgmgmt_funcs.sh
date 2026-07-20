#!/bin/bash

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${kwd}" "${cmd}" "${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
# set_desktop "${APP_NAME}" "${EXEC_PATH}" "${ICON_PATH}" "${APP_CAT}" "${APP_HIDDEN}" "${DESKTOP_PATH}" "${CUR_USER}";
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function display_msg()
{
    local msg="${1}"

    if [[ -n ${msg} ]]; then
        msg+="\n"
    fi

    echo ""
    echo "========================================================================="
    echo -e "${msg}";
    #
    echo "Finished: $(basename "${0}")  at $(date +'%Y-%m-%d(%a) %H:%M:%S')"
    echo ""
    echo "========================================================================="
    echo ""
}


function set_env()
{
    # --------------------------------------------------------------------------
    local kwd=${1};
    local cmd=${2};
    local cur_user=${3};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local cur_path="";

    local path_list="";

    # 1) cui (tty, xrdp)
    path_list+="${HOME_DIR}/.bash_profile";
    path_list+=" ";

    # 2) gui (wm, de)
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        local path_list+="${HOME_DIR}/.xprofile";

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        local path_list+="${HOME_DIR}/.xsessionrc";

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        local path_list+="${HOME_DIR}/.xprofile";
    else
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    for cur_path in ${path_list};
    do
        if [[ -f "${cur_path}" ]]; then
            if [[ $(grep -i "${kwd}" "${cur_path}") ]]; then
                continue
            fi

            echo "${cmd}" >> "${cur_path}";
        else
            echo '#!/bin/bash' > "${cur_path}";
            echo "${cmd}" >> "${cur_path}";
        fi

        chown "${cur_user}":"${cur_user}" "${cur_path}"
        chmod 644 "${cur_path}"
    done
    # --------------------------------------------------------------------------
}


function set_desktop()
{
    # --------------------------------------------------------------------------
    local app_name=${1}
    local app_exec_cmd=${2}
    local icon_path=${3}
    local app_cat=${4}
    local app_hidden=${5}
    local desktop_path=${6}
    local cur_user=${7}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local desktop_cmd="[Desktop Entry]
Type=Application
Name=${app_name}
Exec=${app_exec_cmd}
Icon=${icon_path}
Categories=${app_cat}
Hidden=${app_hidden}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${desktop_path}" ]]; then
        return
    fi

    local desktop_dir=$(dirname ${desktop_path});
    su - ${cur_user} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${desktop_path}"* == *"home"* ]]; then
        # ~/.local/share/applications/galculator.desktop
        su - ${cur_user} -c "echo \"${desktop_cmd}\" > ${desktop_path}";
    else
        # /usr/share/applications/galculator.desktop
        echo "${desktop_cmd}" > ${desktop_path};
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# main =========================================================================

# ==============================================================================
