#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/remote/gui/xrdp
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="xrdp"

PROTOCOL="tcp";

PORT="3389";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_xrdp()
{
    # --------------------------------------------------------------------------
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        # 방법1) yay
        local app_name="${APP_NAME}"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        local app_name="xorgxrdp"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2) pacman
        # local app_name="${APP_NAME}"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # local app_name="xorgxrdp"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="xorgxrdp"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xorgxrdp"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(dnf list --installed | grep -i ^epel-release) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="${APP_NAME}"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="xorgxrdp"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
}


function intall_pipewire-module-xrdp()
{
    # --------------------------------------------------------------------------
    # 1) local variables

    # pipewire-module-xrdp
    local src_name="pipewire-module-xrdp"

    # https://github.com/neutrinolabs/pipewire-module-xrdp.git
    local github_url="https://github.com/neutrinolabs/pipewire-module-xrdp.git";

    # /tmp/pipewire-module-xrdp
    local tmp_dir="/tmp/${src_name}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) checking module_path

    # libpipewire-module-xrdp.la
    # libpipewire-module-xrdp.so
    local module_fname="libpipewire-module-xrdp.so";

    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        [[ -n $(pacman -Q | grep -i ^pipewire-module-xrdp 2>/dev/null) ]] && return 0;

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        local module_dir="/usr/lib/x86_64-linux-gnu/pipewire-0.3";

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        local module_dir="/usr/lib64/pipewire-0.3";

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        local module_dir="/usr/lib64/pipewire-0.3";
    fi

    # local module_path="/usr/lib/x86_64-linux-gnu/pipewire-0.3/libpipewire-module-xrdp.so";
    local module_path="${module_dir}/${module_fname}";

    if [[ -f "${module_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 의존성 패키지 설치

    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="pipewire-module-xrdp"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # pactl
        local app_name="libpulse"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # pw-cli
        local app_name="pipewire"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # wpctl
        local app_name="wireplumber"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true
        return 0
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="build-essential"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="pipewire"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="libpipewire-0.3-dev"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # autoconf
        local app_name="autoconf"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="automake"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="libtool"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        local app_name="pkg-config"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # pactl
        local app_name="pulseaudio-utils"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # pw-cli
        local app_name="pipewire-bin"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true

        # wpctl
        local app_name="wireplumber"; apt-cache show "${app_name}" &>/dev/null && apt install -y --no-reinstall "${app_name}" || true
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        local app_name="git"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="gcc"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="make"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="pipewire-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # autoconf
        local app_name="autoconf"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="automake"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="libtool"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        local app_name="pkgconfig"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # pactl
        local app_name="pulseaudio-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

        # pw-cli, wpctl
        local app_name="pipewire-utils"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) pipewire-module-xrdp build

    # /tmp/pipewire-module-xrdp
    [[ -d "${tmp_dir}" ]] && rm -rf "${tmp_dir}";

    # git clone https://github.com/neutrinolabs/pipewire-module-xrdp.git /tmp/pipewire-module-xrdp
    git clone "${github_url}" "${tmp_dir}"
    if [[ ! -d "${tmp_dir}" ]]; then
        return 0
    fi

    # /tmp/pipewire-module-xrdp
    pushd "${tmp_dir}"

    # /tmp/pipewire-module-xrdp/bootstrap
    if [[ -f "${tmp_dir}/bootstrap" ]]; then
        ./bootstrap;
        echo "bootstrap is done.";
    fi

    # /tmp/pipewire-module-xrdp/configure
    if [[ -f "${tmp_dir}/configure" ]]; then
        ./configure;
        echo "configure is done.";
        make
        sudo make install
    fi

    popd
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 5) for fedora, rhel (SELinux)

    if [[ "${CUR_RELEASE}" == *"Fedora"* ]] || [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # ls -Z /usr/lib64/pipewire-0.3/libpipewire-module-xrdp.so
        local cur_context=$(ls -Z "${module_path}" 2>/dev/null);

        # system_u:object_r:lib_t:s0 /usr/lib64/pipewire-0.3/libpipewire-module-xrdp.so
        if echo "${cur_context}" | grep -qE "lib_t|textrel_shlib_t"; then
            echo "${module_path} is already applied.";
        else
            # sudo chcon -t textrel_shlib_t /usr/lib64/pipewire-0.3/libpipewire-module-xrdp.so
            sudo chcon -t textrel_shlib_t "${module_path}";

            # sudo restorecon -v "/usr/lib64/pipewire-0.3/libpipewire-module-xrdp.so"
            sudo restorecon -v "${module_path}";
        fi
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    install_xrdp;

    # xrdp with pipewire;
    intall_pipewire-module-xrdp;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # alow xrdp-port
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && allow_sv-port_for_firewall "${PROTOCOL}" "${PORT}";

    # restart xrdp
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && enable_sv xrdp && restart_sv xrdp;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # fix xrdp-settings for wm

    # /usr/libexec/xrdp/startwm-bash.sh
    # source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && fix_startwm_for_xsession;

    # ~/.xsession, ~/.Xclients
    # source ${CORE_BIN_DIR}/remote/gui/xrdp/install_xrdp_funcs.sh && set_xsession "${APP_NAME}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
