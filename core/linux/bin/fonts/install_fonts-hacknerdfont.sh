#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/fonts/install_fonts-hacknerdfont.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/fonts
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_fonts-hacknerdfont()
{
    if [[ -n $(fc-list |grep -i hacknerdfont) ]]; then
        return 0
    fi

    # --------------------------------------------------------------------------
    local font_name="HackNerdFont"
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"
    local font_zip_path="/tmp/${font_name}.zip";

    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        local font_dir="/usr/share/fonts/TTF"
        [[ -d "${font_dir}" ]] || mkdir -p "${font_dir}"

        local font_dst_dir="${font_dir}";
        if [[ -f "${font_dst_dir}/${font_name}-Regular.ttf" ]]; then
            return 0
        fi

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        local font_dir="/usr/share/fonts/truetype"
        [[ -d "${font_dir}" ]] || mkdir -p "${font_dir}"

        local font_dst_dir="${font_dir}/${font_name}";
        if [[ -d "${font_dst_dir}" ]]; then
            return 0
        fi

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        local font_dir="/usr/share/fonts"
        [[ -d "${font_dir}" ]] || mkdir -p "${font_dir}"

        local font_dst_dir="${font_dir}/${font_name}";
        if [[ -d "${font_dst_dir}" ]]; then
            return 0
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip" -O "/tmp/HackNerdFont.zip"
    wget "${font_url}" -O "${font_zip_path}"

    # sudo unzip /tmp/HackNerdFont.zip -d /usr/share/fonts/HackNerdFont
    sudo unzip "${font_zip_path}" -d "${font_dst_dir}"
    rm -f "${font_zip_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    fc-cache -fv
    # fc-list | grep -i "hacknerdfont"
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1)
        local app_name="ttf-hack-nerd"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2)
        # local app_name="ttf-hack-nerd"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1)
        # dnf copr enable lyessaadi/nerd-fonts
        # local app_name="font-hack-nerd"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # 방법2)
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_fonts-hacknerdfont;
        # ----------------------------------------------------------------------
    fi
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================