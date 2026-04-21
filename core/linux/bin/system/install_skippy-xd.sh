#!/bin/bash

# skippy-xd ====================================================================
# bash ${CORE_BIN_DIR}/system/install_skippy-xd.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system
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


# Func for build ===============================================================
# for x86_64 / i686 / aarch64
function install_dep_for_apt()
{
    [[ -n $(apt list --installed | grep -i ^libimlib2-dev) ]] || apt install -y libimlib2-dev;
    [[ -n $(apt list --installed | grep -i ^libfontconfig1-dev) ]] || apt install -y libfontconfig1-dev;
    [[ -n $(apt list --installed | grep -i ^libfreetype6-dev) ]] || apt install -y libfreetype6-dev;
    [[ -n $(apt list --installed | grep -i ^libx11-dev) ]] || apt install -y libx11-dev;
    [[ -n $(apt list --installed | grep -i ^libxext-dev) ]] || apt install -y libxext-dev;
    [[ -n $(apt list --installed | grep -i ^libxft-dev) ]] || apt install -y libxft-dev;
    [[ -n $(apt list --installed | grep -i ^libxrender-dev) ]] || apt install -y libxrender-dev;
    [[ -n $(apt list --installed | grep -i ^zlib1g-dev) ]] || apt install -y zlib1g-dev;
    [[ -n $(apt list --installed | grep -i ^libxinerama-dev) ]] || apt install -y libxinerama-dev;
    [[ -n $(apt list --installed | grep -i ^libxcomposite-dev) ]] || apt install -y libxcomposite-dev;
    [[ -n $(apt list --installed | grep -i ^libxdamage-dev) ]] || apt install -y libxdamage-dev;
    [[ -n $(apt list --installed | grep -i ^libxfixes-dev) ]] || apt install -y libxfixes-dev;
    [[ -n $(apt list --installed | grep -i ^libxmu-dev) ]] || apt install -y libxmu-dev;
}

function install_dep_for_dnf()
{
    # --------------------------------------------------------------------------
    [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list --installed | grep -i ^imlib2-devel) ]] || dnf install -y imlib2-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf list --installed | grep -i ^fontconfig-devel) ]] || dnf install -y fontconfig-devel;
    [[ -n $(dnf list --installed | grep -i ^freetype-devel) ]] || dnf install -y freetype-devel;
    [[ -n $(dnf list --installed | grep -i ^libX11-devel) ]] || dnf install -y libX11-devel;
    [[ -n $(dnf list --installed | grep -i ^libXext-devel) ]] || dnf install -y libXext-devel;
    [[ -n $(dnf list --installed | grep -i ^libXft-devel) ]] || dnf install -y libXft-devel;
    [[ -n $(dnf list --installed | grep -i ^libXrender-devel) ]] || dnf install -y libXrender-devel;
    [[ -n $(dnf list --installed | grep -i ^zlib-devel) ]] || dnf install -y zlib-devel;
    [[ -n $(dnf list --installed | grep -i ^libXinerama-devel) ]] || dnf install -y libXinerama-devel;
    [[ -n $(dnf list --installed | grep -i ^libXcomposite-devel) ]] || dnf install -y libXcomposite-devel;
    [[ -n $(dnf list --installed | grep -i ^libXdamage-devel) ]] || dnf install -y libXdamage-devel;
    [[ -n $(dnf list --installed | grep -i ^libXfixes-devel) ]] || dnf install -y libXfixes-devel;
    [[ -n $(dnf list --installed | grep -i ^libXmu-devel) ]] || dnf install -y libXmu-devel;
    [[ -n $(dnf list --installed | grep -i ^libjpeg-turbo-devel) ]] || dnf install -y libjpeg-turbo-devel;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ -n $(dnf repolist | grep -i ^crb) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list --installed | grep -i ^giflib-devel) ]] || dnf install -y giflib-devel;
    # --------------------------------------------------------------------------
}

function install_skippy-xd_for_build()
{
    # --------------------------------------------------------------------------
    if [[ -e "/usr/bin/skippy-xd" ]]; then
        return
    fi
    if [[ -e "/usr/local/bin/skippy-xd" ]]; then
        return
    fi
    if [[ -e "${HOME_DIR}/.nix-profile/bin/skippy-xd" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # checking "Development Tools" ---------------------------------------------
    if [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        local GRP_LIST=$(dnf grouplist --installed);
        local GRP_NAME="Development Tools";

        [[ *"${GRP_LIST}"* == *"${GRP_NAME}"* ]] || dnf groupinstall -y "${GRP_NAME}";
    fi
    # --------------------------------------------------------------------------

    # checking TMP_DIR ---------------------------------------------------------
    local TMP_DIR="/tmp";
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};
    # --------------------------------------------------------------------------

    # compile skippy-xd --------------------------------------------------------
    cd ${TMP_DIR}
    git clone https://github.com/felixfung/skippy-xd.git
    cd skippy-xd

    make
    make install
    # --------------------------------------------------------------------------
}
# ==============================================================================


# func =========================================================================
function install_skippy-xd_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi

    if [[ -e "/usr/bin/skippy-xd" ]]; then
        return
    fi
    if [[ -e "/usr/local/bin/skippy-xd" ]]; then
        return
    fi
    if [[ -e "${HOME_DIR}/.nix-profile/bin/skippy-xd" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="skippy-xd"

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

    # 3) install_skippy-xd -----------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.skippy-xd
    # nix profile add nixpkgs#skippy-xd
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
    "skippy-xd" \
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



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        [[ -n $(yay -Q | grep -i ^skippy-xd) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm skippy-xd-git";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "skippy-xd is not supported for Debian and Ubuntu"

        install_skippy-xd_for_nix "multi";
        # ----------------------------------------------------------------------
        # install_dep_for_apt;
        # install_skippy-xd_for_build;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]] || [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        # distrobox를 사용한다.
        # echo "skippy-xd is not supported for RHEL and Fedora"

        install_skippy-xd_for_nix "single";
        # ----------------------------------------------------------------------
        # install_dep_for_dnf;
        # install_skippy-xd_for_build;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================
