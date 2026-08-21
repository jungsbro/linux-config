#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/expose/skippy-xd/install_skippy-xd.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/expose/skippy-xd
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2> /dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="skippy-xd"

APP_CAT="Utility"

APP_HIDDEN="false"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func for build ===============================================================

function install_dep_for_apt()
{
    local app_name="libimlib2-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libfontconfig1-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libfreetype6-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libx11-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxext-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxft-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxrender-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="zlib1g-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxinerama-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxcomposite-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxdamage-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxfixes-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
    local app_name="libxmu-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
}

function install_dep_for_dnf()
{
    # --------------------------------------------------------------------------
    [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    local app_name="imlib2-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="fontconfig-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="freetype-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libX11-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXext-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXft-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXrender-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="zlib-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXinerama-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXcomposite-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXdamage-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXfixes-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXmu-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libjpeg-turbo-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    [[ $(dnf repolist crb 2>/dev/null) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    local app_name="giflib-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------
}

function install_skippy-xd_for_build()
{
    # --------------------------------------------------------------------------
    if [[ -e "/usr/bin/skippy-xd" ]]; then
        return 0
    fi
    if [[ -e "/usr/local/bin/skippy-xd" ]]; then
        return 0
    fi
    if [[ -e "${HOME_DIR}/.nix-profile/bin/skippy-xd" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # checking "Development Tools" ---------------------------------------------
    if [[ "${CUR_VER}" == *"rocky"* ]]; then
        local GRP_LIST=$(dnf grouplist --installed);
        local GRP_NAME="Development Tools";

        [[ "${GRP_LIST}" == *"${GRP_NAME}"* ]] || dnf groupinstall -y "${GRP_NAME}";
    fi
    # --------------------------------------------------------------------------

    # checking TMP_DIR ---------------------------------------------------------
    local TMP_DIR="/tmp";
    [[ -d "${TMP_DIR}" ]] || mkdir -p "${TMP_DIR}";
    # --------------------------------------------------------------------------

    # compile skippy-xd --------------------------------------------------------
    cd "${TMP_DIR}"
    git clone https://github.com/felixfung/skippy-xd.git
    cd skippy-xd

    make
    make install
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs ========================================================================
function copy_config_to_home()  # not used
{
    # --------------------------------------------------------------------------
    local src_dir="${CUR_DIR}/config";
    local src_path="${src_dir}/skippy-xd.rc";

    local dst_dir="${HOME_DIR}/.config/skippy-xd";
    local dst_path="${dst_dir}/skippy-xd.rc";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${dst_path}" ]]; then
        return 0
    fi
    if [[ ! -d "${dst_dir}" ]]; then
        su - "${CUR_USER}" -c "mkdir -p ${dst_dir}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${src_path}" ]]; then
        su - "${CUR_USER}" -c "cp -f ${src_path} ${dst_path}";
    fi
    # --------------------------------------------------------------------------
}


function set_skippy-xd_autostart()  # not used, becuase of bug (freezing)
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local app_name="${APP_NAME} daemon";

    local exec_path="skippy-xd --config ${HOME_DIR}/.config/skippy-xd/skippy-xd.rc --start-daemon"

    local icon_path=""

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - "${CUR_USER}" -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${app_name}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="skippy-xd-git"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) distrobox를 사용한다.
        # echo "skippy-xd is not available on Debian and Ubuntu"

        # 방법2) nixpkg
        local app_name="${APP_NAME}";
        local user_type="multi";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # 방법3) build
        # install_dep_for_apt;
        # install_skippy-xd_for_build;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) distrobox를 사용한다.
        # echo "skippy-xd is not avialable on RHEL and Fedora"

        # 방법2) nixpkg
        local app_name="${APP_NAME}";
        local user_type="single";
        local cur_user="${CUR_USER}";
        source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

        # 방법3) build
        # install_dep_for_dnf;
        # install_skippy-xd_for_build;
        # ----------------------------------------------------------------------
    fi

    # --------------------------------------------------------------------------
    # copy_config_to_home;

    # set_skippy-xd_autostart;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================