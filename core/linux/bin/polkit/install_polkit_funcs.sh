#!/bin/bash
set -e

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/polkit/install_polkit_funcs.sh && create_my-reboot && create_my-shutdown;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# yad --center --undecorated --skip-taskbar \
# --button="Reboot!system-reboot:/usr/local/bin/my-reboot.sh" \
# --button="Shutdown!system-shutdown:/usr/local/bin/my-shutdown.sh" \
# --button="Logout:pkill openbox" \
# --button="Cancel:1"
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function create_my-reboot()
{
    # --------------------------------------------------------------------------
    local dst_path="/usr/local/bin/my-reboot.sh";

    local cmd='#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
pkexec /usr/sbin/reboot
'
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${dst_path}" ]]; then
        return 0;
    fi

    echo "${cmd}" > "${dst_path}";
    chmod +x "${dst_path}";
    # --------------------------------------------------------------------------
}

function create_my-shutdown()
{
    local dst_path="/usr/local/bin/my-shutdown.sh";

    local cmd='#!/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
pkexec /usr/sbin/poweroff
'
    # --------------------------------------------------------------------------
    if [[ -f "${dst_path}" ]]; then
        return 0;
    fi

    echo "${cmd}" > "${dst_path}";
    chmod +x "${dst_path}";
    # --------------------------------------------------------------------------
}
# ==============================================================================
