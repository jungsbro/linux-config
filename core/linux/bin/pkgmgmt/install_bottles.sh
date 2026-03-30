#!/bin/bash

# bottles ======================================================================
# bash ${CORE_BIN_DIR}/pkgmgmt/install_bottles.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function install_bottles_for_flatpak()
{
    # --------------------------------------------------------------------------
    # for x86_64
    if [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then
        return
    fi
    if [[ *"${CUR_ARCH}"* == *"i686"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^flatpak) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/install_flatpak.sh;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # ~/.local/share/applications/KakaoTalk.desktop
    [[ -n $(flatpak list --app | grep -i bottles) ]] || flatpak install -y flathub com.usebottles.bottles;
    # --------------------------------------------------------------------------
}


function install_bottles_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="bottles"

    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        # multi-user
        local DST_PATH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
    else
        # single-user
        local DST_PATH="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
    fi
    # --------------------------------------------------------------------------

    # 2) install nix -----------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_bottles -------------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.bottles
    # nix profile add nixpkgs#bottles
    su - ${CUR_USER} -c "source ${DST_PATH} && \
    nix profile list 2>/dev/null | grep -iq ${APP_NAME} || \
    nix profile add nixpkgs#${APP_NAME}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # if [[ *"${mod}"* == *"multi"* ]]; then
    #     return
    # fi
    return
    # --------------------------------------------------------------------------

    # 4) bins settings ---------------------------------------------------------
    local FNAME_LIST=(\
    "bottles" \
    "bottles-cli" \
    )

    local src_dir="${HOME_DIR}/.nix-profile/bin"
    local dst_dir="${HOME_DIR}/.local/bin"

    for cur_fname in "${FNAME_LIST[@]}";
    do
        src_path="${src_dir}/${cur_fname}";
        if [[ ! -f ${src_path} ]]; then
            continue
        fi

        dst_path="${dst_dir}/${cur_fname}";
        if [[ -f ${dst_path} ]]; then
            continue
        fi

        ln -s ${src_path} ${dst_path};
    done
    # --------------------------------------------------------------------------

    # 5) icon settngs ----------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/icons"
    local dst_dir="/usr/share/icons"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -r : recursive
        # -u : update
        cp -ru ${src_dir}/* "${dst_dir}/"

        gtk-update-icon-cache "${dst_dir}" 2>/dev/null
    fi
    # --------------------------------------------------------------------------

    # 6) desktop settings ------------------------------------------------------
    local src_dir="${HOME_DIR}/.nix-profile/share/applications"
    local dst_dir="${HOME_DIR}/.local/share/applications"

    if [[ -d ${src_dir} ]]; then
        mkdir -p "${dst_dir}"
        # -u : update
        # -L : dereference
        cp -u -L ${src_dir}/*.desktop "${dst_dir}/"

        update-desktop-database "${dst_dir}"
    fi
    # --------------------------------------------------------------------------

    # 7) etc -------------------------------------------------------------------
    # ~/.nix-profile/share/bottles
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then    # x86_64
            install_bottles_for_flatpak;
        elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then # aarch64
            install_bottles_for_nix "multi";
        else                                            # i868
            echo "Debian is not supported for bottles-i686"
        fi

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        if [[ *"${CUR_ARCH}"* == *"x86_64"* ]]; then    # x86_64
            install_bottles_for_flatpak;
        elif [[ *"${CUR_ARCH}"* == *"aarch64"* ]]; then # aarch64
            install_bottles_for_nix "single";
        else                                            # i868
            echo "Rocky is not supported for bottles-i686"
        fi

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        [[ -n $(dnf list --installed | grep -i ^bottles) ]] || dnf install -y bottles;

    elif [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        [[ -n $(yay -Q | grep -i ^bottles) ]] || su - ${CUR_USER} -c "yay -S --noconfirm bottles";
        # [[ -n $(yay -Q | grep -i ^bottles) ]] || su - ${CUR_USER} -c "yay -S --noconfirm bottles-git";
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
