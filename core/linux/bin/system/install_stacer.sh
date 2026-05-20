#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/install_stacer.sh ${CUR_USER};
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

# ------------------------------------------------------------------------------
APP_NAME="stacer"

# stacer
APP_UNIQUE_NAME="${APP_NAME}"

APP_GRP="Utility;"
# ------------------------------------------------------------------------------
# ==============================================================================


# func =========================================================================
function set_desktop()  # not used
{
    # args ---------------------------------------------------------------------
    # ${CUR_USER}
    # ${APP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}";

    if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
        # ~/.local/share/applications/stacer.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/stacer.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}


function install_stacer_for_nix()   # it has error / not working / it's gnone on debian13
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="stacer"

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

    # 3) install_stacer --------------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.stacer
    # nix profile add nixpkgs#stacer
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
    "stacer" \
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
}
# ==============================================================================


# Main : x86_64, i686, aarch64 =================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # [[ -n $(yay -Q | grep -i ^stacer-git) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm stacer-git";
        [[ -n $(yay -Q | grep -i ^stacer-bin) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm stacer-bin";
        # [[ -n $(yay -Q | grep -i ^stacer) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm stacer";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        echo "stacer is not supported for Debian13+"

        # [[ -n $(apt list --installed | grep -i ^stacer) ]] || apt install -y stacer;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(apt list --installed | grep -i ^stacer) ]] || apt install -y stacer;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        echo "stacer is not supported for RHEL and Fedora"

        # because of error
        # install_stacer_for_nix "single";
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
