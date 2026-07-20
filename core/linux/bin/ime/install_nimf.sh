#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ime/install_nimf.sh ${CUR_USER};
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
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="nimf"

# com.github.hamonikr.nimf
APP_UNIQUE_NAME="com.github.hamonikr.${APP_NAME}"

APP_CAT="Settings;System;"

APP_HIDDEN="false";

LOCAL_LIB_DIR="/usr/local/lib"

# /usr/local/lib/pkgconfig/nimf.pc
PC_PATH="${LOCAL_LIB_DIR}/pkgconfig/nimf.pc"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function set_nimf_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
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


function set_nimf_autostart()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local exec_path="${APP_NAME}"

    # local icon_path="/usr/share/icons/hicolor/32x32/status/nimf-logo.png"
    # local icon_path="/usr/local/share/icons/hicolor/32x32/status/nimf-logo.png"
    local icon_path="nimf-logo"

    local desktop_dir="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${desktop_dir} ]] || mkdir -p ${desktop_dir}";

    local desktop_path="${desktop_dir}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && \
    set_desktop "${APP_NAME}" "${exec_path}" "${icon_path}" "${APP_CAT}" "${APP_HIDDEN}" "${desktop_path}" "${CUR_USER}";
    # --------------------------------------------------------------------------
}

function intall_nimf_for_build()
{
    chmod -R +x ${CORE_BIN_DIR}/ime/nimf_for_build;

    # "export PKG_CONFIG_PATH"를 사용해야하기 때문에 bash대신 source를 사용한다.
    # libhangul : hangul engine ------------------------------------------------
    source ${CORE_BIN_DIR}/ime/nimf_for_build/install_libhangul.sh && build_libhangul_for_dnf;
    # --------------------------------------------------------------------------

    # m17n : multi language support --------------------------------------------
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/install_m17n-lib.sh && build_m17n-lib_for_dnf;
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/install_m17n-db.sh && build_m17n-db_for_dnf;
    # --------------------------------------------------------------------------

    # anthy : japanese engine --------------------------------------------------
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/install_anthy_9100h.sh && build_anthy-9100h_for_dnf;
    # --------------------------------------------------------------------------

    # rime : chiness engine ----------------------------------------------------
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/install_marisa-trie.sh && build_marisa-trie_for_dnf;
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/install_opencc.sh && build_OpenCC_for_dnf;
    # source ${CORE_BIN_DIR}/ime/nimf_for_build/install_rime.sh && build_rime_for_dnf;
    # --------------------------------------------------------------------------

    # nimf : nimf for build ----------------------------------------------------
    # 한글만을 사용하기 위해 libhangul만을 포함해서 build 한다.
    # configure --disable-nimf-anthy
    # configure --disable-nimf-rime
    # configure --disable-nimf-m17n
    # configure --enable-nimf-libhangul
    source ${CORE_BIN_DIR}/ime/nimf_for_build/install_nimf_for_build.sh && build_nimf_for_dnf;
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # for gnome, cinnamon, mate, xfce, lxde
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;

        [[ -n $(yay -Q | grep -i ^nimf-libhangul) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm nimf-libhangul";

        # [[ -n $(yay -Q | grep -i ^nimf) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm nimf-git";
        [[ -n $(yay -Q | grep -i ^nimf) ]] || su - ${CUR_USER} -c "yay -S --needed --noconfirm nimf";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^nimf) ]]; then
            # ------------------------------------------------------------------
            wget -qO- https://raw.githubusercontent.com/hamonikr/nimf/master/install | sudo -E bash -
            # ------------------------------------------------------------------
            # set_nimf_autostart;
            # ------------------------------------------------------------------
        fi

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^nimf) ]]; then
            # ------------------------------------------------------------------
            wget -qO- https://raw.githubusercontent.com/hamonikr/nimf/master/install | sudo -E bash -
            # ------------------------------------------------------------------
            # set_nimf_autostart;
            # ------------------------------------------------------------------
        fi

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # if [[ -z $(find /usr/local/lib -name nimf) ]]; then
        if [[ ! -f "${PC_PATH}" ]]; then
            # ------------------------------------------------------------------
            # rhel 이라면 한/영 전환을 위해 의존성 패키지가 꼭 설치해야 한다.
            [[ -n $(dnf list --installed | grep -i ^gtk3) ]] || dnf install -y gtk3;
            [[ -n $(dnf list --installed | grep -i ^gtk3-immodule-xim) ]] || dnf install -y gtk3-immodule-xim;
            # ------------------------------------------------------------------
            intall_nimf_for_build;
            # ------------------------------------------------------------------
            set_nimf_autostart;
            # ------------------------------------------------------------------
        fi
    fi

    # --------------------------------------------------------------------------
    set_nimf_env
    # --------------------------------------------------------------------------

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================

