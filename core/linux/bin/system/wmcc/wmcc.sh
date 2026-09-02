#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/system/wmcc/wmcc.sh;

# bash ~/.local/bin/wmcc.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/system/wmcc
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="wmcc"
APP_CAT="System;Utility;"

CAT_KWD="Settings"
# CAT_KWD="System"

APP_CONFIG_DIR="${HOME}/.config/wmcc"
JSON_PATH="${APP_CONFIG_DIR}/app.json"
TMP_PATH="${APP_CONFIG_DIR}/tmp.json"
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function create_db()
{
    # --------------------------------------------------------------------------
    # 1) JSON_PATH(db) 확인
    if [[ ! -d "${APP_CONFIG_DIR}" ]]; then
        mkdir -p "${APP_CONFIG_DIR}"
    fi

    if [[ -f "${JSON_PATH}" ]]; then
        return 0
    fi

    echo "[]" > "${JSON_PATH}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) local-vars
    local dst_list=(
        "${HOME}/.local/share/applications"
        "/usr/share/applications"
        "/usr/local/share/applications"
    )

    local cur_dir="";
    local cur_fname="";
    local cur_path="";

    local cur_name="";
    local cur_exec="";
    local cur_icon="";
    local cur_cat="";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) total 구하기
    local total=0;
    local cur_num=0;

    for cur_dir in ${dst_list[@]};
    do
        if [[ ! -d "${cur_dir}" ]]; then
            continue
        fi

        cur_num=$(find "${cur_dir}" -maxdepth 1 -iname "*.desktop" | wc -l);

        total=$(( ${total} + ${cur_num} ));
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) JSON_PATH(db) 만들기
    local i=0;

    for cur_dir in ${dst_list[@]};
    do
        if [[ ! -d "${cur_dir}" ]]; then
            continue
        fi

        for cur_fname in $(ls "${cur_dir}" | grep -i ".desktop");
        do
            # ------------------------------------------------------------------
            # cur_path
            i=$(( ${i} + 1 ));
            echo "${i} / ${total}";

            cur_path="${cur_dir}/${cur_fname}";

            cur_name=$(crudini --get "${cur_path}" "Desktop Entry" "Name" 2>/dev/null);
            cur_exec=$(crudini --get "${cur_path}" "Desktop Entry" "Exec" 2>/dev/null);
            cur_icon=$(crudini --get "${cur_path}" "Desktop Entry" "Icon" 2>/dev/null);
            cur_cat=$(crudini --get "${cur_path}" "Desktop Entry" "Categories" 2>/dev/null);

            if [[ -z $(echo "${cur_cat}" | grep "${CAT_KWD}") ]]; then
                continue
            fi

            # echo "${cur_name}";
            # ------------------------------------------------------------------

            # ------------------------------------------------------------------
            # JSON_PATH(db)
            jq --arg name "${cur_name}" \
                --arg exec "${cur_exec}" \
                --arg icon "${cur_icon}" \
                --arg cat "${cur_cat}" \
                '. += [{"name": $name, "exec": $exec, "icon": $icon, "cat": $cat}]' "${JSON_PATH}" \
                > "${TMP_PATH}" && mv "${TMP_PATH}" "${JSON_PATH}"
            # ------------------------------------------------------------------
        done
    done
    # --------------------------------------------------------------------------
}


function set_text_with_emoji()
{
    # --------------------------------------------------------------------------
    local text="${1}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${text,,}" == *"about"* ]] || [[ "${text,,}" == *"user"* ]] || \
        [[ "${text,,}" == *"group"* ]] || [[ "${text,,}" == *"account"* ]] || \
        [[ "${text,,}" == *"session"* ]] || [[ "${text,,}" == *"client"* ]] || \
        [[ "${text,,}" == *"accessibility"* ]]; then
        emoji="👤 "

    elif [[ "${text,,}" == *"network"* ]] || [[ "${text,,}" == *"remmina"* ]] || \
        [[ "${text,,}" == *"rdp"* ]] || [[ "${text,,}" == *"vnc"* ]] || \
        [[ "${text,,}" == *"remote"* ]] || [[ "${text,,}" == *"ssh"* ]]; then
        emoji="🌐 "

    elif [[ "${text,,}" == *"package"* ]] || [[ "${text,,}" == *"application"* ]]; then
        emoji="📦 "

    elif [[ "${text,,}" == *"desktop"* ]] || [[ "${text,,}" == *"monitor"* ]] || \
        [[ "${text,,}" == *"gpu"* ]] || [[ "${text,,}" == *"nvidia"* ]] || \
        [[ "${text,,}" == *"amd"* ]] || [[ "${text,,}" == *"display"* ]] || \
        [[ "${text,,}" == *"arandr"* ]]; then
        emoji="🖥️ "

    elif [[ "${text,,}" == *"look"* ]] || [[ "${text,,}" == *"feel"* ]] || \
        [[ "${text,,}" == *"appearance"* ]] || [[ "${text,,}" == *"color"* ]]; then
        emoji="🎨 "

    elif [[ "${text,,}" == *"password"* ]] || [[ "${text,,}" == *"keys"* ]];then
        emoji="🔑 "

    elif [[ "${text,,}" == *"fcitx"* ]] || [[ "${text,,}" == *"ibus"* ]] || \
        [[ "${text,,}" == *"uim"* ]] || [[ "${text,,}" == *"nimf"* ]] || \
        [[ "${text,,}" == *"input method"* ]] || [[ "${text,,}" == *"keyboard"* ]] || \
        [[ "${text,,}" == *"language"* ]]; then
        emoji="🇰 "

    elif [[ "${text,,}" == *"workspace"* ]] || [[ "${text,,}" == *"thunar"* ]] || \
        [[ "${text,,}" == *"pcmanfm"* ]] || [[ "${text,,}" == *"folder"* ]] || \
        [[ "${text,,}" == *"input file"* ]] || [[ "${text,,}" == *"disk"* ]] || \
        [[ "${text,,}" == *"mount"* ]] || [[ "${text,,}" == *"storage"* ]] || \
        [[ "${text,,}" == *"drive"* ]];then
        emoji="🗂️ "

    elif [[ "${text,,}" == *"media"* ]] || [[ "${text,,}" == *"bluetooth"* ]];then
        emoji="🎵 "

    elif [[ "${text,,}" == *"adapter"* ]] || [[ "${text,,}" == *"plugin"* ]] || \
        [[ "${text,,}" == *"connect"* ]];then
        emoji="🔌 "

    elif [[ "${text,,}" == *"power"* ]] || [[ "${text,,}" == *"tlp"* ]] || \
        [[ "${text,,}" == *"performance"* ]];then
        emoji="⚡ "

    elif [[ "${text,,}" == *"booster"* ]] || [[ "${text,,}" == *"startup"* ]] || \
        [[ "${text,,}" == *"launch"* ]];then
        emoji="🚀 "

    elif [[ "${text,,}" == *"terminal"* ]] || [[ "${text,,}" == *"console"* ]] || \
        [[ "${text,,}" == *"tty"* ]];then
        emoji="📟 "

    elif [[ "${text,,}" == *"mouse"* ]] || [[ "${text,,}" == *"touchpad"* ]];then
        emoji="🖱️ "

    elif [[ "${text,,}" == *"screensaver"* ]] || [[ "${text,,}" == *"zzz"* ]] || \
        [[ "${text,,}" == *"idle"* ]];then
        emoji="💤 "

    elif [[ "${text,,}" == *"share"* ]] || [[ "${text,,}" == *"link"* ]];then
        emoji="🔗 "

    elif [[ "${text,,}" == *"search"* ]] || [[ "${text,,}" == *"find"* ]] || \
        [[ "${text,,}" == *"magnify"* ]];then
        emoji="🔍 "

    elif [[ "${text,,}" == *"clean"* ]] || [[ "${text,,}" == *"wipe"* ]] || \
        [[ "${text,,}" == *"wash"* ]];then
        emoji="🧹 "

    elif [[ "${text,,}" == *"update"* ]] || [[ "${text,,}" == *"upgrade"* ]] || \
        [[ "${text,,}" == *"upload"* ]];then
        emoji="🆙 "

    elif [[ "${text,,}" == *"time"* ]] || [[ "${text,,}" == *"date"* ]];then
        emoji="⏱️ "

    elif [[ "${text,,}" == *"clipboard"* ]]; then
        emoji="📋 "

    elif [[ "${text,,}" == *"save"* ]]; then
        emoji="💾 "

    elif [[ "${text,,}" == *"volume"* ]]; then
        emoji="🔊 "

    elif [[ "${text,,}" == *"panel"* ]]; then
        emoji="📺 "

    elif [[ "${text,,}" == *"typing"* ]]; then
        emoji="🖋️ "

    elif [[ "${text,,}" == *"window"* ]]; then
        emoji="🖼️ "

    elif [[ "${text,,}" == *"notification"* ]]; then
        emoji="🔔 "

    elif [[ "${text,,}" == *"dashboard"* ]]; then
        emoji="📊 "

    elif [[ "${text,,}" == *"saver"* ]]; then
        emoji="🌃 "

    elif [[ "${text,,}" == *"firewall"* ]]; then
        emoji="🔥 "

    elif [[ "${text,,}" == *"print"* ]]; then
        emoji="🖨️ "

    elif [[ "${text,,}" == *"setup"* ]] || [[ "${text,,}" == *"setting"* ]] || \
        [[ "${text,,}" == *"preference"* ]] || [[ "${text,,}" == *"control"* ]] || \
        [[ "${text,,}" == *"manager"* ]] || [[ "${text,,}" == *"profile"* ]]; then
        emoji="⚙️ "

    elif [[ "${text,,}" == *"editor"* ]]; then
        emoji="📝 "

    else:
        emoji=""
    fi
    # --------------------------------------------------------------------------

    echo  "${emoji}${text}"
}


function show_ui()
{
    # --------------------------------------------------------------------------
    # 1) JSON_PATH(db) 확인
    if [[ ! -f "${JSON_PATH}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) local-vars
    local item="";
    local cur_name="";
    local cur_exec="";
    local cur_icon="";
    local cur_cat="";

    local yad_cmd='yad --form \
--title="Control Center" \
--width=1000 --columns=4 --resizable \
--image="preferences-system" \
--text="Please select an application to run.\n" \
--center';

    local rm_db_cmd='rm -f \"'${JSON_PATH}'\"';
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) JSON_PATH(db)를 사용해서 ui만들기
    while read -r item;
    do
        # ----------------------------------------------------------------------
        cur_name=$(echo "${item}" | jq -r '.name')

        if [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
            cur_name=$(set_text_with_emoji "${cur_name}")
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        cur_exec=$(echo "${item}" | jq -r '.exec')
        cur_icon=$(echo "${item}" | jq -r '.icon')
        cur_cat=$(echo "${item}" | jq -r '.cat')
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # echo "${cur_name}"
        yad_cmd+=" --field=\"${cur_name}!${cur_icon}:BTN\" \"${cur_exec}\""
        # ----------------------------------------------------------------------
    done < <(jq -c 'sort_by(.name)[]' "${JSON_PATH}")

    yad_cmd+=" --buttons-layout=edge --button=\"Remove DB:${rm_db_cmd}\""
    yad_cmd+=' --button="Close:0"'
    # echo "${yad_cmd}"

    eval "${yad_cmd}"
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    create_db;

    show_ui;
fi
# ==============================================================================

