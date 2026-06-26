#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/hotkey/sxhkd/install_sxhkd.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/hotkey/sxhkd
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_sxhkd()
{
    # for x86_64, aarch64, i686
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^sxhkd) ]] || pacman -S --needed --noconfirm sxhkd;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^sxhkd) ]] || apt install -y sxhkd;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        echo "sxhkd is not supported for RHEL"
        return 0
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^sxhkd) ]] || dnf install -y sxhkd;
        # ----------------------------------------------------------------------
    fi
}


function copy_sxhkdrc_to_home()
{
    # --------------------------------------------------------------------------
    local src_sxhkdrc_path="${CUR_DIR}/config/sxhkdrc";

    local dst_sxhkdrc_dir="${HOME_DIR}/.config/sxhkd";
    local dst_sxhkdrc_path="${dst_sxhkdrc_dir}/sxhkdrc";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f ${dst_sxhkdrc_path} ]]; then
        return
    fi
    if [[ ! -d ${dst_sxhkdrc_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${dst_sxhkdrc_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f ${src_sxhkdrc_path} ]]; then
        cp -f ${src_sxhkdrc_path} ${dst_sxhkdrc_path}
    fi
    # --------------------------------------------------------------------------
}


function create_desktop_for_sxhkd()
{
    local autostart_dir="${HOME_DIR}/.config/autostart";
    local autostart_path="${autostart_dir}/sxhkd.desktop";
    local sxhkd_desktop_cmd="[Desktop Entry]
Exec=/usr/bin/sxhkd
Name=sxhkd
Type=Application
Version=1.0
X-LXQt-X11-Only=true
"

    # --------------------------------------------------------------------------
    if [[ -f ${autostart_path} ]]; then
        return
    fi
    if [[ ! -d ${autostart_dir} ]]; then
        su - ${CUR_USER} -c "mkdir -p ${autostart_dir}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    printf '%b\n' "${sxhkd_desktop_cmd}" | sudo -u ${CUR_USER} tee ${autostart_path} > /dev/null
    # --------------------------------------------------------------------------
}


function set_autostart_for_sxhkd()
{
    if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then
        create_desktop_for_sxhkd;

    elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
        create_desktop_for_sxhkd;
    fi

    if [[ -d "${HOME_DIR}/.icewm" ]]; then
        echo ""
    fi
    if [[ -d "${HOME_DIR}/.fluxbox" ]]; then
        echo ""
    fi
    if [[ -d "${HOME_DIR}/.config/i3" ]]; then
        echo ""
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) install sxhkd
    install_sxhkd;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) ~/.config/sxhkd/sxhkdrc
    # 방법1)
    # bash ${CORE_BIN_DIR}/hotkey/sxhkd/create_sxhkdrc.sh ${CUR_USER};

    # 방법2)
    copy_sxhkdrc_to_home;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) ~/.config/autostart/sxhkd.desktop
    set_autostart_for_sxhkd;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

