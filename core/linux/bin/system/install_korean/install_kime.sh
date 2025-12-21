#!/bin/bash

# kime =========================================================================
# bash /core/linux/bin/system/install_korean/install_kime.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="kime"

# com.github.riey.kime
APP_UNIQUE_NAME="com.github.riey.${APP_NAME}"

APP_GRP="Settings;System;"
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function set_kime_env()
{
    # args ---------------------------------------------------------------------
    # ${ENV_CONF_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # local ENV_CONF_PATH="${HOME_DIR}/.xprofile";
    # local ENV_CONF_PATH="${HOME_DIR}/.xsession";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local CONF_CMD='#!/bin/bash
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS="@im=kime"
'
    if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then

        if [[ *"${CUR_WMDE}"* != *"gnome"* ]] && [[ *"${CUR_WMDE}"* == *"openbox"* ]]; then     # lxde
            CONF_CMD="${CONF_CMD}exec startlxde"

        elif [[ *"${CUR_WMDE}" == *"xfce4"* ]]; then                                            # xfce4
            CONF_CMD="${CONF_CMD}exec startxfce4"

        elif [[ *"${CUR_WMDE}" == *"mate"* ]]; then                                             # mate
            CONF_CMD="${CONF_CMD}exec mate-session"

        elif [[ *"${CUR_WMDE}"* != *"cinnamon"* ]] && [[ *"${CUR_WMDE}"* == *"gnome"* ]]; then  # gnome
            CONF_CMD="${CONF_CMD}exec gnome-session"

        elif [[ *"${CUR_WMDE}"* == *"cinnamon"* ]]; then                                        # cinnamon
            CONF_CMD="${CONF_CMD}exec cinnamon-session"
        fi
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -f ${ENV_CONF_PATH} ]] || echo '${CONF_CMD}' > ${ENV_CONF_PATH}";

    if [[ *"${ENV_CONF_PATH}"* == *".xsession"* ]]; then
        su - ${CUR_USER} -c "chmod +x ${ENV_CONF_PATH}";
    fi
    # --------------------------------------------------------------------------
}

function set_desktop()
{
    # args ---------------------------------------------------------------------
    # ${CUR_USER}
    # ${APP_NAME}
    # ${EXEC_PATH}
    # ${ICON_PATH}
    # ${APP_GRP}
    # ${DESKTOP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    local DESKTOP_CMD="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Exec=${EXEC_PATH}
Icon=${ICON_PATH}
Categories=${APP_GRP}
Terminal=false"

    if [[ *"${DESKTOP_PATH}"* == *"home"* ]]; then
        # ~/.local/share/applications/kime.desktop
        su - ${CUR_USER} -c "echo \"${DESKTOP_CMD}\" > ${DESKTOP_PATH}";
    else
        # /usr/share/applications/kime.desktop
        echo "${DESKTOP_CMD}" > ${DESKTOP_PATH};
    fi
}

function set_kime_autostart()
{
    # args ---------------------------------------------------------------------
    # ${ICON_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local EXEC_PATH="sh -c 'kime-xdg-autostart'"
    # local ICON_PATH="/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
    # local ICON_PATH="/usr/local/share/icons/hicolor/64x64/apps/kime-hangul-black.png";

    local DESKTOP_DIR="${HOME_DIR}/.config/autostart"
    su - ${CUR_USER} -c "[[ -d ${DESKTOP_DIR} ]] || mkdir -p ${DESKTOP_DIR}";

    local DESKTOP_PATH="${DESKTOP_DIR}/${APP_NAME}.desktop"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    set_desktop;
    # --------------------------------------------------------------------------
}

function set_kime_hotkey()
{
    # args ---------------------------------------------------------------------
    # ${SRC_HOTKEY_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # local SRC_HOTKEY_PATH="/usr/share/doc/kime/default_config.yaml";
    # local SRC_HOTKEY_PATH="~/.nix-profile/share/doc/kime/default_config.yaml";

    # ~/.config/kime/config.yaml
    local DST_HOTKEY_DIR="${HOME_DIR}/.config/kime";
    local DST_HOTKEY_PATH="${DST_HOTKEY_DIR}/config.yaml";
    local TMP_HOTKEY_PATH="${DST_HOTKEY_DIR}/tmp.yaml";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ ! -f ${SRC_HOTKEY_PATH} ]]; then
        return
    fi

    su - ${CUR_USER} -c "[[ -d ${DST_HOTKEY_DIR} ]] || mkdir -p ${DST_HOTKEY_DIR}";
    su - ${CUR_USER} -c "[[ -f ${DST_HOTKEY_PATH} ]] || cp -f ${SRC_HOTKEY_PATH} ${DST_HOTKEY_PATH}";

    su - ${CUR_USER} -c "sed 's/Super-Space/S-Space/g' ${DST_HOTKEY_PATH} > ${TMP_HOTKEY_PATH}";
    su - ${CUR_USER} -c "mv -f ${TMP_HOTKEY_PATH} ${DST_HOTKEY_PATH}";
    # --------------------------------------------------------------------------
}

function install_kime_for_nix()
{
    # for x86_64 / i686 / aarch64
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # 1) env-vars settings -----------------------------------------------------
    local APP_NAME="kime"

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
    bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # 3) install_kime ----------------------------------------------------------
    # https://search.nixos.org/packages
    # nix-env -iA nixpkgs.kime
    # nix profile add nixpkgs#kime
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
    "kime" \
    "kime-check" \
    "kime-indicator" \
    "kime-wayland" \
    "kime-xdg-autostart" \
    "kime-xim" \
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
# for gnome, cinnamon, mate, xfce, lxde

if [[ *"${CUR_VER}"* == *"debian"* ]]; then
    if [[ -z $(apt list --installed | grep -i ^kime) ]]; then
        # ----------------------------------------------------------------------
        TMP_URL="https://github.com/Riey/kime/releases/download/v3.1.1/kime_debian-buster_v3.1.1_amd64.deb"
        TMP_PATH="/tmp/kime.deb"
        wget "${TMP_URL}" -O "${TMP_PATH}";
        apt install -y ${TMP_PATH};
        # ----------------------------------------------------------------------
        ENV_CONF_PATH="${HOME_DIR}/.xprofile"
        set_kime_env;
        # ----------------------------------------------------------------------
        # ICON_PATH="/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
        ICON_PATH="kime-hangul-black.png";
        set_kime_autostart;
        # ----------------------------------------------------------------------
        SRC_HOTKEY_PATH="/usr/share/doc/kime/default_config.yaml";
        set_kime_hotkey;
        # ----------------------------------------------------------------------
    fi

elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    if [[ -z $(apt list --installed | grep -i ^kime) ]]; then
        # ----------------------------------------------------------------------
        TMP_URL="https://github.com/Riey/kime/releases/download/v3.1.1/kime_ubuntu-22.04_v3.1.1_amd64.deb"
        TMP_PATH="/tmp/kime.deb"
        wget "${TMP_URL}" -O "${TMP_PATH}";
        apt install -y ${TMP_PATH};
        # ----------------------------------------------------------------------
        ENV_CONF_PATH="${HOME_DIR}/.xprofile"
        set_kime_env;
        # ----------------------------------------------------------------------
        # ICON_PATH="/usr/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
        ICON_PATH="kime-hangul-black.png";
        set_kime_autostart;
        # ----------------------------------------------------------------------
        SRC_HOTKEY_PATH="/usr/share/doc/kime/default_config.yaml";
        set_kime_hotkey;
        # ----------------------------------------------------------------------
    fi

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    if [[ -z $(nix-env -q | grep -i ^${APP_NAME}) ]]; then
        # ----------------------------------------------------------------------
        install_kime_for_nix "single";
        # ----------------------------------------------------------------------
        ENV_CONF_PATH="${HOME_DIR}/.xsession"
        set_kime_env;
        # ----------------------------------------------------------------------
        # ICON_PATH="/usr/local/share/icons/hicolor/64x64/apps/kime-hangul-black.png";
        ICON_PATH="kime-hangul-black.png";
        set_kime_autostart;
        # ----------------------------------------------------------------------
        SRC_HOTKEY_PATH="${HOME_DIR}/.nix-profile/share/doc/kime/default_config.yaml";
        set_kime_hotkey;
        # ----------------------------------------------------------------------
    fi
fi
# ==============================================================================

exit 0
