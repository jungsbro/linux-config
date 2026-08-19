#!/bin/bash
set -e

[[ -n "${_INSTALL_DISTROBOX_FUNCS_LOADED:-}" ]] && return 0
_INSTALL_DISTROBOX_FUNCS_LOADED=1

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/container/install_distrobox_funcs.sh && \
# install_apps "${CTR_NAME}" "${pkg_type}" "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}";
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function install_apps()
{
    # --------------------------------------------------------------------------
    local ctr_name="${1}"
    local pkg_type="${2}"
    local gui_apps="${3}"
    local gui_bins="${4}"
    local cli_apps="${5}"
    local cli_bins="${6}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${pkg_type}" == "apt" ]]; then
        pkg_install="sudo apt install -y"

    elif [[ "${pkg_type}" == "dnf" ]]; then
        pkg_install="sudo dnf install -y"

    elif [[ "${pkg_type}" == "pacman" ]]; then
        pkg_install="sudo pacman -S --noconfirm --needed"

    elif [[ "${pkg_type}" == "yay" ]]; then
        pkg_install="yay -S --noconfirm --needed"

        if ! distrobox enter ${ctr_name} -- yay --version &>/dev/null; then
            if ! distrobox enter ${ctr_name} -- git --version &>/dev/null; then
                distrobox enter ${ctr_name} -- sudo pacman -S --noconfirm --needed base-devel git
            fi
            distrobox enter ${ctr_name} -- git clone https://aur.archlinux.org/yay.git /tmp/yay
            distrobox enter ${ctr_name} -- bash -c "cd /tmp/yay && makepkg -si --noconfirm"
            distrobox enter ${ctr_name} -- rm -rf /tmp/yay
        fi

    else
        echo "지원하지 않는 패키지 관리자입니다: ${pkg_type}"
        return 1
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) distrobox enter debbox -- sudo apt install -y firefox-esr btop
    if [[ -z "${gui_apps}" && -z "${cli_apps}" ]]; then
        echo "설치할 앱이 없습니다."
        return 0
    fi

    distrobox enter ${ctr_name} -- ${pkg_install} ${gui_apps} ${cli_apps}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) export gui_bins (.desktop 파일 생성)
    local gui_bin="";

    for gui_bin in ${gui_bins};
    do
        # echo ${gui_bin}
        distrobox enter ${ctr_name} -- distrobox-export --app ${gui_bin}
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) export cli_bins (심볼릭 링크 생성)
    local cli_bin="";

    for cli_bin in ${cli_bins};
    do
        cli_cmd=$(distrobox enter ${ctr_name} -- bash -lc "command -v ${cli_bin}" 2>/dev/null)
        # echo ${cli_cmd}
        distrobox enter ${ctr_name} -- distrobox-export --bin ${cli_cmd}
    done
    # --------------------------------------------------------------------------
}
# ==============================================================================