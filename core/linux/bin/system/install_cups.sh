#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/office/install_cups.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/office
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

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

# ------------------------------------------------------------------------------
APP_NAME="cups";

# /tmp/cups
TMP_DIR="/tmp/${APP_NAME}";

# samsung printer driver ML-2160 series
SRC_URL="https://printersetup.ext.hp.com/TS/Files/RDS_XML/web_install_agent/linux/ULD_v1.00.29.tar.gz";

FNAME="ULD.tar.gz";

# /tmp/cups/ULD.tar.gz
ZIP_PATH="${TMP_DIR}/${FNAME}"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_printer_driver()
{
    if [[ ! -d "${TMP_DIR}" ]]; then
        # /tmp/cups
        mkdir -p ${TMP_DIR};
        chmod 777 ${TMP_DIR};
    fi

    # --------------------------------------------------------------------------
    if [[ ! -f "${ZIP_PATH}" ]]; then
        # wget "https://printersetup.ext.hp.com/TS/Files/RDS_XML/web_install_agent/linux/ULD_v1.00.29.tar.gz" -O "/tmp/cups/ULD.tar.gz";
        wget "${SRC_URL}" -O "${ZIP_PATH}";
    fi

    # tar -xvf "/tmp/cups/ULD.tar.gz" -C "/tmp/cups";
    tar -xvf "${ZIP_PATH}" -C "${TMP_DIR}";

    yes | bash "${TMP_DIR}/uld/install.sh";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        local app_name="system-config-printer"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="system-config-printer"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="system-config-printer"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    if systemctl is-system-running > /dev/null 2>&1 || [ -d /run/systemd/system ]; then # systemd
        if systemctl list-unit-files cups.service &>/dev/null; then
            systemctl enable cups
            systemctl restart cups

            # samsung printer driver ML-2160 series
            install_printer_driver;
        fi
    else    # sysVinit
        return 0
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================