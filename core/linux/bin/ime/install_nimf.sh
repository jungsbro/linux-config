#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_nimf.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ime
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="nimf"

APP_CAT="Settings;System;"

APP_HIDDEN="false";

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/lib/pkgconfig/nimf.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/nimf.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_nimf-env()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    local cmd='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS="@im=nimf"
# ------------------------------------------------------------------------------
'
    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && set_env "${APP_NAME}" "${cmd}" "${CUR_USER}"
    # --------------------------------------------------------------------------
}


function set_nimf-autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z "${CUR_USER}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="${APP_NAME}"

    # local icon_path="/usr/share/icons/hicolor/32x32/status/nimf-logo.png"
    # local icon_path="/usr/local/share/icons/hicolor/32x32/status/nimf-logo.png"
    local icon_path="nimf-logo"

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - "${CUR_USER}" -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : build_nimf ===========================================================
function get_libhangul-pc()
{
    # --------------------------------------------------------------------------
    # libhangul : hangul engine
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법1) "export PKG_CONFIG_PATH"를 사용해야하기 때문에 bash대신 source를 사용한다.
    # # /usr/lib64/pkgconfig/libhangul.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_libhangul.sh && build_libhangul_for_dnf;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법2)
    # ~/.nix-profile/lib/pkgconfig/libhangul.pc
    local app_name="libhangul";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
    # --------------------------------------------------------------------------
}

function get_m17n-pc()
{
    # --------------------------------------------------------------------------
    # m17n : multi language support
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법1) "export PKG_CONFIG_PATH"를 사용해야하기 때문에 bash대신 source를 사용한다.
    # # /usr/local/lib/pkgconfig/m17n-core.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_m17n-lib.sh && build_m17n-lib_for_dnf;

    # # /usr/local/share/pkgconfi/m17n-db.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_m17n-db.sh && build_m17n-db_for_dnf;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법2)
    # ~/.nix-profile/lib/pkgconfig/m17n-core.pc
    local app_name="m17n_lib";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

    # ~/.nix-profile/share/pkgconfig/m17n-db.pc
    local app_name="m17n_db";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
    # --------------------------------------------------------------------------
}

function get_anthy-pc()
{
    # --------------------------------------------------------------------------
    # anthy : japanese engine
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법1) "export PKG_CONFIG_PATH"를 사용해야하기 때문에 bash대신 source를 사용한다.
    # # /usr/local/lib/pkgconfig/anthy.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_anthy_9100h.sh && build_anthy-9100h_for_dnf;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법2)
    # /usr/share/anthy/anthy.dic
    local app_name="anthy";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"

    local src_path="${HOME_DIR}/.nix-profile/share/anthy/anthy.dic"
    local dst_dir="/usr/share/anthy"
    local dst_path="${dst_dir}/anthy.dic"

    [[ -d "${dst_dir}" ]] || mkdir -p "${dst_dir}";
    [[ -f "${src_path}" ]] && [[ ! -f "${dst_path}" ]] &&  ln -s "${src_path}" "${dst_path}"


    # ~/.nix-profile/lib/pkgconfig/anthy.pc
    local app_name="anthy.dev";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
    # --------------------------------------------------------------------------
}

function get_rime-pc()
{
    # --------------------------------------------------------------------------
    # rime : chiness engine
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법1) "export PKG_CONFIG_PATH"를 사용해야하기 때문에 bash대신 source를 사용한다.
    # # /usr/local/lib64/pkgconfig/marisa.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_marisa-trie.sh && build_marisa-trie_for_dnf;

    # # /usr/local/lib64/pkgconfig/opencc.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_opencc.sh && build_OpenCC_for_dnf;

    # # /usr/local/lib64/pkgconfig/rime.pc
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/build_rime.sh && build_rime_for_dnf;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 방법2)
    # ~/.nix-profile/lib/pkgconfig/rime.pc
    local app_name="librime";
    local user_type="single";
    local cur_user="${CUR_USER}";
    source ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix_funcs.sh && install_nixpkg "${app_name}" "${user_type}" "${cur_user}"
    # --------------------------------------------------------------------------
}

function get_nimf-pc()
{
    # --------------------------------------------------------------------------
    chmod -R +x "${CORE_BIN_DIR}/ime/nimf_for_build";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # dependency
    get_libhangul-pc;
    get_m17n-pc;
    get_anthy-pc;
    get_rime-pc;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # "export PKG_CONFIG_PATH"를 사용해야하기 때문에 bash대신 source를 사용한다.

    # 한글만을 사용하기 위해 libhangul만을 포함해서 build 한다.
    # configure --disable-nimf-anthy
    # configure --disable-nimf-rime
    # configure --disable-nimf-m17n
    # configure --enable-nimf-libhangul

    # /usr/local/lib/pkgconfig/nimf.pc
    source ${CORE_BIN_DIR}/ime/nimf_for_build/build_nimf.sh && build_nimf_for_dnf "${CUR_USER}";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Funcs : main =================================================================
function execute_main()
{
    # for gnome, cinnamon, mate, xfce, lxde
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        local app_name="nimf-libhangul"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법1)
        # local app_name="nimf-git"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법2)
        local app_name="nimf"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^nimf) ]]; then
            # ------------------------------------------------------------------
            wget -qO- https://raw.githubusercontent.com/hamonikr/nimf/master/install | sudo -E bash -
            # ------------------------------------------------------------------
            # set_nimf_autostart;
            # ------------------------------------------------------------------
        fi

    elif [[ "${CUR_VER}" == *"Fedora"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^nimf) ]]; then
            # ------------------------------------------------------------------
            wget -qO- https://raw.githubusercontent.com/hamonikr/nimf/master/install | sudo -E bash -
            # ------------------------------------------------------------------
            # set_nimf_autostart;
            # ------------------------------------------------------------------
        fi

    elif [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # if [[ -z $(find /usr/local/lib -name nimf) ]]; then
        if [[ ! -f "${PC_PATH}" ]]; then
            # ------------------------------------------------------------------
            # rhel 이라면 한/영 전환을 위해 의존성 패키지가 꼭 설치해야 한다.
            local app_name="gtk3"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            local app_name="gtk3-immodule-xim"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
            # ------------------------------------------------------------------
            # build_nimf
            get_nimf-pc;
            # ------------------------------------------------------------------
            set_nimf-autostart;
            # ------------------------------------------------------------------
        fi
    fi

    # --------------------------------------------------------------------------
    set_nimf-env
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================

