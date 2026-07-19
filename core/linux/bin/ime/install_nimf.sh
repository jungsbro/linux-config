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

IME_ENV_CMD='
# ------------------------------------------------------------------------------
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS="@im=nimf"
# ------------------------------------------------------------------------------
'
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
# function set_nimf_env()
# {
#     # args ---------------------------------------------------------------------
#     # ${ENV_CONF_PATH}
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     # local ENV_CONF_PATH="${HOME_DIR}/.xprofile";
#     # local ENV_CONF_PATH="${HOME_DIR}/.xsession";
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     local CONF_CMD='#!/bin/bash
# export GTK_IM_MODULE=xim
# export QT_IM_MODULE=xim
# export XMODIFIERS="@im=nimf"
# '
#     # GNOME,KDE는 ~/.config/environment.d/*.conf 에서 잘된다.
#     # 전통/경량 DE는 ~/.xprofile(x11,rhel), ~/.xsession(x11,debian), ~/.profile(wayland)에서 잘된다.
#     if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then

#         if [[ *"${CUR_WMDE}"* == *"lxsession"* ]]; then                                         # lxde
#             CONF_CMD="${CONF_CMD}exec startlxde"

#         elif [[ *"${CUR_WMDE}"* == *"lxqt"* ]]; then                                            # lxqt
#             CONF_CMD="${CONF_CMD}exec startlxqt"

#         elif [[ *"${CUR_WMDE}"* == *"xfce4"* ]]; then                                            # xfce4
#             CONF_CMD="${CONF_CMD}exec startxfce4"

#         elif [[ *"${CUR_WMDE}"* == *"mate"* ]]; then                                             # mate
#             CONF_CMD="${CONF_CMD}exec mate-session"

#         elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then  # gnome
#             CONF_CMD="${CONF_CMD}exec gnome-session"

#         elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                        # cinnamon
#             CONF_CMD="${CONF_CMD}exec cinnamon-session"

#         elif [[ *"${CUR_WMDE}"* == *"plasma"* ]]; then                                          # kde
#             CONF_CMD="${CONF_CMD}exec startplasma-x11"
#         fi
#     fi
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     su - ${CUR_USER} -c "[[ -f ${ENV_CONF_PATH} ]] || echo \"${CONF_CMD}\" > ${ENV_CONF_PATH}";

#     if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then
#         su - ${CUR_USER} -c "chmod +x ${ENV_CONF_PATH}";
#     fi
#     # --------------------------------------------------------------------------
# }

# function set_desktop()
# {
#     # args ---------------------------------------------------------------------
#     # ${CUR_USER}
#     # ${APP_NAME}
#     # ${EXEC_PATH}
#     # ${ICON_PATH}
#     # ${APP_CAT}
#     # ${DESKTOP_PATH}
#     # --------------------------------------------------------------------------

#     # --------------------------------------------------------------------------
#     if [[ -z ${CUR_USER} ]]; then
#         return
#     fi
#     # --------------------------------------------------------------------------

#     local DESKTOP_CMD="[Desktop Entry]
# Type=Application
# Name=${APP_NAME}
# Exec=${EXEC_PATH}
# Icon=${ICON_PATH}
# Categories=${APP_CAT}
# Terminal=false"

#     if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
#         # ~/.local/share/applications/nimf.desktop
#         su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
#     else
#         # /usr/share/applications/nimf.desktop
#         echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
#     fi
# }

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
            # ENV_CONF_PATH="${HOME_DIR}/.xsession"
            # set_nimf_env;
            source ${CORE_BIN_DIR}/ime/install_ime_funcs.sh && set_ime-env "${APP_NAME}" "${IME_ENV_CMD}" "${CUR_USER}";
            # ------------------------------------------------------------------
            # ICON_PATH="/usr/share/icons/hicolor/32x32/status/nimf-logo.png"
            # set_nimf_autostart;
            # ------------------------------------------------------------------
        fi

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        if [[ -z $(apt list --installed | grep -i ^nimf) ]]; then
            # ------------------------------------------------------------------
            wget -qO- https://raw.githubusercontent.com/hamonikr/nimf/master/install | sudo -E bash -
            # ------------------------------------------------------------------
            # ENV_CONF_PATH="${HOME_DIR}/.xsession"
            # set_nimf_env;
            source ${CORE_BIN_DIR}/ime/install_ime_funcs.sh && set_ime-env "${APP_NAME}" "${IME_ENV_CMD}" "${CUR_USER}";
            # ------------------------------------------------------------------
            # ICON_PATH="/usr/share/icons/hicolor/32x32/status/nimf-logo.png"
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
            # ENV_CONF_PATH="${HOME_DIR}/.xsession";
            # set_nimf_env;
            source ${CORE_BIN_DIR}/ime/install_ime_funcs.sh && set_ime-env "${APP_NAME}" "${IME_ENV_CMD}" "${CUR_USER}";
            # ------------------------------------------------------------------
            # ICON_PATH="/usr/local/share/icons/hicolor/32x32/status/nimf-logo.png"
            set_nimf_autostart;
            # ------------------------------------------------------------------
        fi
    fi

fi
# ==============================================================================

# EOF ==========================================================================
source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && display_msg "";
# ==============================================================================

