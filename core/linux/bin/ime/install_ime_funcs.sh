#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/ime/install_ime_funcs.sh && set_ime-env "${APP_NAME}" "${IME_ENV_CMD}" "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function set_ime-env()
{
    # --------------------------------------------------------------------------
    # fcitx5
    local app_name=${1}

    # export GTK_IM_MODULE=fcitx5
    # export QT_IM_MODULE=fcitx5
    # export XMODIFIERS="@im=fcitx5"
    local ime_env_cmd=${2}

    # junsgs
    local cur_user=${3}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local home_dir=$(eval echo ~${cur_user});

    local cur_ver=$(cat /etc/*-release 2> /dev/null);

    if [[ *"${cur_ver}"* == *"archlinux"* ]]; then
        local env_path="${home_dir}/.xprofile";

    elif [[ *"${cur_ver}"* == *"debian.org"* ]] || [[ *"${cur_ver}"* == *"ubuntu"* ]]; then
        local env_path="${home_dir}/.xsessionrc";

    elif [[ *"${cur_ver}"* == *"Fedora"* ]] || [[ *"${cur_ver}"* == *"CentOS"* ]] || [[ *"${cur_ver}"* == *"rocky"* ]]; then
        local env_path="${home_dir}/.xprofile";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${cur_user} ]]; then
        return
    fi

    if [[ -f ${env_path} ]]; then
        if [[ $(grep -i "${app_name}" ${env_path}) ]]; then
            return
        fi

        su - ${cur_user} -c "echo \"${ime_env_cmd}\" >> ${env_path}";
    else
        su - ${CUR_USER} -c "echo '#!/bin/bash' > ${env_path}";
        su - ${cur_user} -c "echo \"${ime_env_cmd}\" >> ${env_path}";
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# main =========================================================================

# ==============================================================================
