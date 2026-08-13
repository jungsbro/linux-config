#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_uim.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="uim"

# com.github.uim
APP_UNIQUE_NAME="com.github.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_uim_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    local cmd='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
export XMODIFIERS="@im=uim"
# ------------------------------------------------------------------------------
'
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${APP_NAME}" "${cmd}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function set_uim_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="sh -c 'uim-toolbar-gtk3-systray uim-sh'"

    # local icon_path="/usr/share/uim/pixmaps/uim-icon.png"
    local icon_path="uim-icon"

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # for cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        [[ -n $(pacman -Q | grep -i ^uim) ]] || pacman -S --needed --noconfirm uim uim-byeoru;

        # 방법2)
        # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # # [[ -n $(yay -Q | grep -i ^uim-git) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm uim-git";
        # [[ -n $(yay -Q | grep -i ^uim) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm uim";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^uim) ]] || apt install -y uim uim-byeoru;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^uim) ]] || dnf install -y uim uim-m17n;

        if [[ "${CUR_WMDE}" == *"lxqt"* ]] || [[ "${CUR_WMDE}" == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^uim-qt) ]] || dnf install -y uim-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^uim-gtk3) ]] || dnf install -y uim-gtk3;
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        echo "uim is not supported for RHEL"
        return 0
    fi

    # --------------------------------------------------------------------------
    set_uim_env

    set_uim_autostart
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
