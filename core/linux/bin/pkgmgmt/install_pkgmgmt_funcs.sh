#!/bin/bash

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${kwd}" "${cmd}" "${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
# set_desktop "${APP_NAME}" "${EXEC_PATH}" "${ICON_PATH}" "${APP_CAT}" "${APP_HIDDEN}" "${DESKTOP_PATH}" "${CUR_USER}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && remove_space_for_ini "${ini_path}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv "${sv_name}";
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && restart_sv "${sv_name}";
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv "${sv_name}" && restart_sv "${sv_name}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_firewall "${protocol}" "${port}";
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_firewall "tcp" "3389";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_selinux "${obj_type}" "${protocol}" "${port}";
# source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_selinux "ssh_port" "tcp" "2222";
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function show_msg()
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
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local path_list+="${HOME_DIR}/.xprofile";

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local path_list+="${HOME_DIR}/.xsessionrc";

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
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

function remove_space_for_ini()
{
    # --------------------------------------------------------------------------
    # key = value  >>  key=value
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local ini_path=${1}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # grep '[^[:space:]]+[[:space:]]+=[[:space:]]+[^[:space:]]+' /etc/lightdm/lightdm.conf
    if [[ -z $(grep -E '[^[:space:]]+[[:space:]]+=[[:space:]]+[^[:space:]]+' "${ini_path}") ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    cp "${ini_path}" "${ini_path}.bak"

    # sed -i 's/[[:space:]]*=[[:space:]]*/=/g' /etc/lightdm/lightdm.conf
    sed -i 's/[[:space:]]*=[[:space:]]*/=/g' "${ini_path}"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : service ==============================================================
function enable_sv()
{
    local sv_name=${1}

    # --------------------------------------------------------------------------
    if [[ *"${sv_name}"* == *"ufw"* ]]; then
        ufw enable
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files | grep -iq ${sv_name}; then
            systemctl enable --now ${sv_name}
        fi
    else    # sysVinit
        return
    fi
    # --------------------------------------------------------------------------
}


function restart_sv()
{
    local sv_name=${1}

    # --------------------------------------------------------------------------
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files | grep -iq ${sv_name}; then
            systemctl restart ${sv_name}
        fi
    else    # sysVinit
        return
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : allow_sv-port_for_fw =================================================
function allow_sv-port_for_ufw()    # needs "restart_sv"
{
    # --------------------------------------------------------------------------
    local protocol=${1};
    local port=${2};

    # '3389/tcp'
    local port_protocol="${port}/${protocol}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(ufw status | grep -i "${port_protocol}") ]];then
        return
    fi

    ufw allow ${port_protocol};

    restart_sv "ufw";
    # --------------------------------------------------------------------------
}


function allow_sv-port_for_firewalld()    # needs "restart_sv"
{
    # --------------------------------------------------------------------------
    local protocol=${1};
    local port=${2};

    # '3389/tcp'
    local port_protocol="${port}/${protocol}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(firewall-cmd --list-all | grep -i "${port_protocol}") ]];then
        return
    fi

    firewall-cmd --permanent --add-port=${port_protocol};

    restart_sv "firewalld";
    # --------------------------------------------------------------------------
}


function allow_sv-port_for_firewall()
{
    # --------------------------------------------------------------------------
    local protocol=${1};
    local port=${2};

    # '3389/tcp'
    local port_protocol="${port}/${protocol}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^ufw) ]] && allow_sv-port_for_ufw ${protocol} ${port};
        [[ -n $(pacman -Q | grep -i ^firewalld) ]] && allow_sv-port_for_firewalld ${protocol} ${port};
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^ufw) ]] && allow_sv-port_for_ufw ${protocol} ${port};
        [[ -n $(apt list --installed | grep -i ^firewalld) ]] && allow_sv-port_for_firewalld ${protocol} ${port};
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^ufw) ]] && allow_sv-port_for_ufw ${protocol} ${port};
        [[ -n $(dnf list --installed | grep -i ^firewalld) ]] && allow_sv-port_for_firewalld ${protocol} ${port};
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : allow_sv-port_for_selinux ===========================================
function allow_sv-port_for_selinux()
{
    # --------------------------------------------------------------------------
    # "ssh_port"
    local obj_type=${1};

    # "tcp"
    local protocol=${2};

    # "2222"
    local port=${3};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_VER}" != *"Fedora"* ]] && [[ "${CUR_VER}" != *"CentOS"* ]] && [[ "${CUR_VER}" != *"rocky"* ]]; then
        return
    fi
    if [[ -z $(dnf list --installed | grep -i semanage) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(semanage port -l | grep -i ${port}) ]];then
        return
    fi

    semanage port -a -t "${obj_type}_t" -p "${protocol}" "${port}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# main =========================================================================

# ==============================================================================
