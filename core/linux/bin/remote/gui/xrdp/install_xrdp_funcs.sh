#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && fix_xrdp-startwm_for_xsession;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "plasma" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "gnome" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "cinnamon" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "mate" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "xfce4" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "lxqt" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "lxde" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "fluxbox" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "icewm" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "openbox" "${CUR_USER}"
# source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "i3" "${CUR_USER}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# exec startplasma-x11
# exec gnome-session
# exec cinnamon-session
# exec mate-session
# exec startxfce4
# exec startlxqt
# exec startlxde

# exec startfluxbox
# exec icewm-session
# exec openbox-session
# exec i3
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================

function fix_startwm_for_xsession()
{
    # --------------------------------------------------------------------------
    # 1) dst_path, search_str
    local dst_path="/usr/libexec/xrdp/startwm-bash.sh"

    local search_str='#!/usr/bin/bash -l'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) tmp_path, append_kwd, append_str
    local tmp_path="/tmp/startwm_snippet.txt"

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local append_kwd="Xclients";
        local append_str='
# ------------------------------------------------------------------------------
if [ -r ~/.Xclients ]; then
    exec ~/.Xclients
fi
# ------------------------------------------------------------------------------
'
    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local append_kwd="xsession";
        local append_str='
# ------------------------------------------------------------------------------
if [ -r ~/.xsession ]; then
    exec ~/.xsession
fi
# ------------------------------------------------------------------------------
'
    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        local append_kwd="Xclients";
        local append_str='
# ------------------------------------------------------------------------------
if [ -r ~/.Xclients ]; then
    exec ~/.Xclients
fi
# ------------------------------------------------------------------------------
'
    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) cheking dst_path
    if [[ ! -f "${dst_path}" ]]; then
        return 0
    fi
    if [[ -z $(grep -i "${search_str}" "${dst_path}") ]]; then
        return 0
    fi
    if [[ -n $(grep -i "${append_kwd}" "${dst_path}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) append_str to dst_path
    if [[ -f "${tmp_path}" ]]; then
        rm -f "${tmp_path}";
    fi

    echo "${append_str}" > "${tmp_path}";
    sed -i "\|${search_str}|r ${tmp_path}" ${dst_path};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 5) restart xrdp
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files xrdp.service &>/dev/null; then
            systemctl restart xrdp
        fi
    else    # sysVinit
        return 0
    fi
    # --------------------------------------------------------------------------
}


function set_xsession()
{
    # --------------------------------------------------------------------------
    # 1) kwd, cur_user
    local kwd=${1};

    local cur_user=${2};
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) cmd
    if [[ "${kwd}" == *"plasma"* ]]; then
        local cmd="exec startplasma-x11";

    elif [[ "${kwd}" == *"gnome"* ]]; then
        local cmd="exec gnome-session";

    elif [[ "${kwd}" == *"cinnamon"* ]]; then
        local cmd="exec cinnamon-session";

    elif [[ "${kwd}" == *"mate"* ]]; then
        local cmd="exec mate-session";

    elif [[ "${kwd}" == *"xfce4"* ]]; then
        local cmd="exec startxfce4";

    elif [[ "${kwd}" == *"lxqt"* ]]; then
        local cmd="exec startlxqt";

    elif [[ "${kwd}" == *"lxde"* ]]; then
        local cmd="exec startlxde";

    elif [[ "${kwd}" == *"fluxbox"* ]]; then
        local cmd="exec startfluxbox";

    elif [[ "${kwd}" == *"icewm"* ]]; then
        local cmd="exec icewm-session";

    elif [[ "${kwd}" == *"openbox"* ]]; then
        local cmd="exec openbox-session";

    elif [[ "${kwd}" == *"i3"* ]]; then
        local cmd="exec i3";
    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) cur_path
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local cur_path="${HOME_DIR}/.Xclients";

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local cur_path="${HOME_DIR}/.xsession";

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        local cur_path="${HOME_DIR}/.Xclients";
    else
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) cmd to cur_path
    if [[ -f "${cur_path}" ]]; then
        if [[ $(grep -i "${kwd}" "${cur_path}") ]]; then
            return 0
        fi

        echo "${cmd}" >> "${cur_path}";
    else
        echo '#!/bin/bash' > "${cur_path}";
        echo "${cmd}" >> "${cur_path}";
    fi

    chown "${cur_user}":"${cur_user}" "${cur_path}"
    chmod +x "${cur_path}"
    # --------------------------------------------------------------------------
}
# ==============================================================================