#!/bin/bash
set -e

[[ -n "${_INSTALL_FONTS_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_FONTS_FUNCS_LOADED=1

# usage ========================================================================
# local font_name="${FONT_NAME}";
# local font_url="${FONT_URL}";

# source ${CORE_BIN_DIR}/fonts/install_fonts_funcs.sh && install_fonts_with_curl "${font_name}" "${font_url}";
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
# ------------------------------------------------------------------------------
function install_fonts_with_curl()
{
    # --------------------------------------------------------------------------
    # NanumGothicCoding
    local font_name="${1}";

    # local font_url="https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-all_new.zip";
    local font_url="${2}";

    local font_tmp_path="/tmp/${font_name}.zip";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -n $(fc-list | grep -i "${font_name}") ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        local font_root_dir="/usr/share/fonts/TTF";
        [[ -d "${font_root_dir}" ]] || mkdir -p "${font_root_dir}"

        local font_dir="${font_root_dir}";

        # /usr/share/fonts/TTF/namuGothic.ttf
        if [[ -n $(find "${font_dir}" -maxdepth 1 -name "${font_name}*") ]]; then
            return 0
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local font_root_dir="/usr/share/fonts/truetype"
        [[ -d "${font_root_dir}" ]] || mkdir -p "${font_root_dir}"

        local font_dir="${font_root_dir}/${font_name}";

        if [[ -d "${font_dir}" ]]; then
            return 0
        fi
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local font_root_dir="/usr/share/fonts"
        [[ -d "${font_root_dir}" ]] || mkdir -p "${font_root_dir}"

        local font_dir="${font_root_dir}/${font_name}";
        
        if [[ -d "${font_dir}" ]]; then
            return 0
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # wget "https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip" -O "/tmp/nanum.zip"
    wget "${font_url}" -O "${font_tmp_path}"

    # sudo unzip /tmp/nanum.zip -d /usr/share/fonts/nanum
    sudo unzip "${font_tmp_path}" -d "${font_dir}"
    rm -f "${font_tmp_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    fc-cache -fv
    # fc-list | grep -i "nanum"
    # --------------------------------------------------------------------------
}
# ==============================================================================
