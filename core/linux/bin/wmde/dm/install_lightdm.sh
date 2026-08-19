#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/wmde/dm/install_lightdm.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/wmde/dm
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function fix_lightdm-xsession()     # not used
{
    # --------------------------------------------------------------------------
    # only working for fedora and rhel
    local cur_ver=$(cat /etc/*-release 2> /dev/null);

    if [[ "${CUR_VER}" != *"Fedora"* ]] && [[ "${CUR_VER}" != *"CentOS"* ]] && [[ "${CUR_VER}" != *"rocky"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local src_xsession_path="/etc/X11/xinit/Xsession";
    local dst_xsession_path="/etc/lightdm/Xsession";

    local dst_lightdm_conf_path="/etc/lightdm/lightdm.conf";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) copy Xsession

    if [[ ! -f ${src_xsession_path} ]]; then
        return 0
    fi
    if [[ ! -f ${dst_xsession_path} ]]; then
        # -a --archive : preserve all attributes / because of selinux
        cp -a ${src_xsession_path} ${dst_xsession_path};

        # chmod +x ${dst_xsession_path};
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) fix /etc/lightdm/lightdm.conf

    if [[ ! -f ${dst_lightdm_conf_path} ]]; then
        return 0
    fi
    if [[ -n $(cat ${dst_lightdm_conf_path} | grep -i ${dst_xsession_path}) ]]; then
        return 0
    fi

    local search_str='#session-wrapper=lightdm-session'
    local append_str="session-wrapper=${dst_xsession_path}"

    sed -i "\|${search_str}|a ${append_str}" ${dst_lightdm_conf_path};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) fix /etc/lightdm/Xsession

    # SWITCHDESKPATH=/usr/share/switchdesk
    local search_str='SWITCHDESKPATH='

    local tmp_path="/tmp/xsession_snippet.txt"
    if [[ -f "${tmp_path}" ]]; then
        rm -f "${tmp_path}"
    fi

    cat << 'EOF' > ${tmp_path}
# ------------------------------------------------------------------------------
if [ -f "$HOME/.xsessionrc" ]; then
    . "$HOME/.xsessionrc"
fi
if [ -f "$HOME/.xprofile" ]; then
    . "$HOME/.xprofile"
fi
# ------------------------------------------------------------------------------
EOF

    if [[ -z $(cat ${dst_xsession_path} | grep -i ${search_str}) ]]; then
        return 0
    fi
    sed -i "\|${search_str}|r ${tmp_path}" ${dst_xsession_path};
    # --------------------------------------------------------------------------
}


function set_logind-check-graphical_enable()
{
    # suspend후, 먹통되는것을 개선한다.>> 안된다.
    # compositor: off하면,suspend후, 먹통되는 증상 해결된다.

    # --------------------------------------------------------------------------
    # only working for fedora and rhel
    if [[ "${CUR_VER}" != *"Fedora"* ]] && [[ "${CUR_VER}" != *"CentOS"* ]] && [[ "${CUR_VER}" != *"rocky"* ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local dst_path="/etc/lightdm/lightdm.conf"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) key = value  >>  key=value

    # source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && remove_space_for_ini "${dst_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ^logind-check-graphical=true

    # grep -E '^logind-check-graphical=true' /etc/lightdm/lightdm.conf
    if [[ -n $(grep -E '^logind-check-graphical=true' "${dst_path}") ]]; then
        return 0
    fi

    # crudini --set /etc/lightdm/lightdm.conf "Seat:*" "logind-check-graphical" "true";
    # [Seat:*]
    # logind-check-graphical=true
    crudini --ini-options=nospace --set ${dst_path} "Seat:*" "logind-check-graphical" "true";
    # --------------------------------------------------------------------------
}


function set_lightdm_enable()
{
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files lightdm.service &>/dev/null; then
            systemctl enable --now --force lightdm
            systemctl set-default graphical.target
        fi
    else    # sysVinit
        return 0
    fi
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="lightdm"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="lightdm-gtk-greeter"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="lightdm"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="lightdm"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="lightdm-gtk"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # 방법1) only working for fedora and rhel
    source ${CORE_BIN_DIR}/wmde/dm/install_dm_funcs.sh && set_xprofile_enable;


    # 방법2) only working for fedora and rhel
    # fix_lightdm-xsession;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # only working for fedora and rhel
    # set_logind-check-graphical_enable;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # only working for lightdm
    set_lightdm_enable;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================