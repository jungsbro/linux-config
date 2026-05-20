#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_autokey.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
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

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================

# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for x86_64, aarch64, i686
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(yay -Q | grep -i ^autokey-qt) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm autokey-qt";
        else
            [[ -n $(yay -Q | grep -i ^autokey-gtk) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm autokey-gtk";
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(apt list --installed | grep -i ^autokey-qt) ]] || apt install -y autokey-qt;
        else
            [[ -n $(apt list --installed | grep -i ^autokey-gtk) ]] || apt install -y autokey-gtk;
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
            echo "autokey not working on rocky8";
            return 0
        fi
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^autokey-qt) ]] || dnf install -y autokey-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^autokey-gtk) ]] || dnf install -y autokey-gtk;
        fi
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        if [[ *"${CUR_WMDE}"* == *"lxqt"* ]] || [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then
            [[ -n $(dnf list --installed | grep -i ^autokey-qt) ]] || dnf install -y autokey-qt;
        else
            [[ -n $(dnf list --installed | grep -i ^autokey-gtk) ]] || dnf install -y autokey-gtk;
        fi
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/system/install_autokey_funcs.sh && \
        config_autokey ${CUR_USER} && \
        set_autokey_autostart ${CUR_USER}
    # --------------------------------------------------------------------------

fi
# ==============================================================================
