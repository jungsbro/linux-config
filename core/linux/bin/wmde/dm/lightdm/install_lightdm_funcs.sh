#!/bin/bash

# usage ========================================================================
# source ${CORE_BIN_DIR}/wmde/dm/lightdm/install_lightdm_funcs.sh && fix_lightdm-xsession;

# source ${CORE_BIN_DIR}/wmde/dm/lightdm/install_lightdm_funcs.sh && set_lightdm_enable;
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function fix_lightdm-xsession()
{
    # --------------------------------------------------------------------------
    # only working for fedora and rhel
    local cur_ver=$(cat /etc/*-release 2> /dev/null);

    if [[ *"${cur_ver}"* != *"Fedora"* ]] && [[ *"${cur_ver}"* != *"CentOS"* ]] && [[ *"${cur_ver}"* != *"rocky"* ]]; then
        return
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
        return
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
        return
    fi
    if [[ -n $(cat ${dst_lightdm_conf_path} | grep -i ${dst_xsession_path}) ]]; then
        return
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
        return
    fi
    sed -i "\|${search_str}|r ${tmp_path}" ${dst_xsession_path};
    # --------------------------------------------------------------------------
}


function set_lightdm_enable()
{
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files | grep -iq lightdm; then
            systemctl enable lightdm
            systemctl set-default graphical.target
            systemctl restart lightdm
        fi
    else    # sysVinit
        return
    fi
}
# ==============================================================================


# main =========================================================================

# ==============================================================================


