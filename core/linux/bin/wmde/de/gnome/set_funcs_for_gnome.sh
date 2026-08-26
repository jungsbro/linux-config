#!/bin/bash
set -e

[[ -n "${_SET_FUNCS_FOR_GNOME_LOADED:-}" ]] && return 0
_SET_FUNCS_FOR_GNOME_LOADED=1

# usage ========================================================================
# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh
# set_attr_value "${attr_path}" "${attr_name}" "${val}";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/gnome/set_funcs_for_gnome.sh
# set_custom_binding "${app_name}" "${app_cmd}" "${binding}";
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs ========================================================================
function set_attr_value()
{
    # env ----------------------------------------------------------------------
    # "org.cinnamon.desktop.keybindings.wm"
    local attr_path="${1}"

    # "switch-to-workspace-down"
    local attr_name="${2}"

    # "['<Control><Alt>Down', '<Super>Tab']"
    local new_val="${3}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # gsettings get "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-down"
    local old_val=$(gsettings get "${attr_path}" "${attr_name}" 2>/dev/null);
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -z "${old_val}" ]]; then
        return 0
    fi
    if [[ "${old_val}" == *"${new_val}"* ]]; then
        echo "already set"
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # gsettings set "org.cinnamon.desktop.keybindings.wm" "switch-to-workspace-down" "['<Control><Alt>Down', '<Super>Tab']"
    gsettings set "${attr_path}" "${attr_name}" "${val}"
    # --------------------------------------------------------------------------
}


function get_custom_path()
{
    # --------------------------------------------------------------------------
    # custom0
    local custom_name="${1}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if $(pgrep -x "gnome-shell" &>/dev/null) && [[ -f "/usr/bin/gnome-shell" ]]; then
        # "org.gnome.settings-daemon.plugins.media-keys"
        local path1="org.gnome.settings-daemon.plugins.media-keys"

        # "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        local path2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/"

        # "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        local full_path="${path1}.custom-keybinding:${path2}"

    # elif $(pgrep -x "mate-session" &>/dev/null) && [[ -f "/usr/bin/mate-session" ]]; then
    elif [[ -f "/usr/bin/mate-session" ]]; then
        # "org.mate.settings-daemon.plugins.media-keys"
        local path1="org.mate.settings-daemon.plugins.media-keys"

        # "/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        local path2="/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/"

        # "org.mate.settings-daemon.plugins.media-keys.custom-keybinding:/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        local full_path="${path1}.custom-keybinding:${path2}"

    elif $(pgrep -x "cinnamon" &>/dev/null) && [[ -f "/usr/bin/cinnamon" ]]; then
        # "org.cinnamon.desktop.keybindings"
        local path1="org.cinnamon.desktop.keybindings"

        # "/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/"
        local path2="/org/cinnamon/desktop/keybindings/custom-keybindings/${custom_name}/"

        # "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/"
        local full_path="${path1}.custom-keybinding:${path2}"

    else
        local path1=""
        local full_path=""
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    echo "${path1},${full_path}"
    # --------------------------------------------------------------------------
}


function check_app-name_in_custom-list()
{
    # --------------------------------------------------------------------------
    # 1) args

    # "taskmanager"
    local app_name="${1}"

    # "['custom0' 'custom1']"
    local old_custom_list="${2}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) old_custom_array

    # "('custom0' 'custom1')"
    local old_custom_array=();

    # "['custom0','custom1']" >> "'custom0','custom1'" >> "custom0 custom1"
    local cleaned=$(echo "${old_custom_list}" | tr -d "[]'" | tr ',' ' ')

    # "custom0 custom1" >> "('custom0' 'custom1')"
    read -r -a old_custom_array <<< "${cleaned}"
    # echo "${old_custom_array[@]}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) checking app_name in old_custom_array

    # "custom0"
    local cur_name="";

    local result="";

    local full_path="";

    # "taskmanager"
    local old_app_name="";

    for cur_name in "${old_custom_array[@]}"
    do
        result=$(get_custom_path "${cur_name}");

        # "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        # "org.mate.settings-daemon.plugins.media-keys.custom-keybinding:/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        # "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/"
        full_path=$(cut -d ',' -f 2 <<< "${result}");

        old_app_name=$(gsettings get "${full_path}" "name" 2>/dev/null);
        # echo "${old_app_name}";

        if [[ "${old_app_name}" == *"${app_name}"* ]]; then
            return 1;
        fi
    done
    # --------------------------------------------------------------------------

    return 0;
}


function set_custom_binding()
{
    # --------------------------------------------------------------------------
    # 1) args

    # "taskmanager"
    local app_name="${1}"

    # "gnome-system-monitor"
    local app_cmd="${2}"

    # "['<Primary><Shift>Escape']"
    local binding="${3}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) old_custom_list 설정

    local result=$(get_custom_path "custom0");

    # "org.gnome.settings-daemon.plugins.media-keys"
    # "org.mate.settings-daemon.plugins.media-keys"
    # "org.cinnamon.desktop.keybindings"
    local path1=$(cut -d ',' -f 1 <<< "${result}");

    if [[ -z "${path1}" ]]; then
        return 0
    fi


    # gsettings get "org.gnome.settings-daemon.plugins.media-keys" "custom-list"
    # gsettings get "org.mate.settings-daemon.plugins.media-keys" "custom-list"
    # gsettings get "org.cinnamon.desktop.keybindings" "custom-list"
    # ['custom0']
    local old_custom_list=$(gsettings get "${path1}" "custom-list" 2>/dev/null);
    # echo "${old_custom_list}";

    if [[ -z "${old_custom_list}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) checking app_name in old_custom_list

    # return 1 확인 (애러감지: off)
    set +e

    check_app-name_in_custom-list "${app_name}" "${old_custom_list}";
    local exit_code="${?}";

    # return 1 확인완료 (애러감지: on)
    set -e

    if [[ "${exit_code}" == "1" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 4) custom_name

    # ['custom0','custom1']
    local new_custom_list="";

    # custom1
    local custom_name="";

    local i=0;

    while true;
    do
        custom_name="custom${i}";

        if [[ "${old_custom_list}" == *"@as []"* ]] || [[ "${old_custom_list}" == *"[]"* ]]; then
            # "['custom0']"
            new_custom_list="['${custom_name}']"
            break;

        elif [[ "${old_custom_list}" == *"${custom_name}"* ]]; then
            i=$((${i} +  1));
            continue

        else
            # 닫는 대괄호(])를 제거하고 새 항목 추가
            # ['custom0'] >> ['custom0' >> ['custom0', 'custom1']
            new_custom_list="${old_custom_list%]*}, '${custom_name}']"
            break;
        fi
    done
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 5) custom_full_path

    local result=$(get_custom_path "${custom_name}");

    # "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    # "org.mate.settings-daemon.plugins.media-keys.custom-keybinding:/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    # "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/"
    local custom_full_path=$(cut -d ',' -f 2 <<< "${result}");

    if [[ -z "${custom_full_path}" ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 6) custom keybinding

    # gsettings set "org.gnome.settings-daemon.plugins.media-keys" "custom-list" "['custom0','custom1']"
    # gsettings set "org.mate.settings-daemon.plugins.media-keys" "custom-list" "['custom0','custom1']"
    # gsettings set "org.cinnamon.desktop.keybindings" "custom-list" "['custom0','custom1']"
    gsettings set "${path1}" "custom-list" "${new_custom_list}"

    # 1. 단축키 이름 설정
    # gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "name" "taskmanager"
    # gsettings set "org.mate.settings-daemon.plugins.media-keys.custom-keybinding:/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "name" "taskmanager"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/" "name" "taskmanager"
    gsettings set "${custom_full_path}" "name" "${app_name}"

    # 2. 실행할 명령어 설정
    # gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "command" "gnome-system-monitor"
    # gsettings set "org.mate.settings-daemon.plugins.media-keys.custom-keybinding:/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "command" "gnome-system-monitor"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/" "command" "gnome-system-monitor"
    gsettings set "${custom_full_path}" "command" "${app_cmd}"

    # 3. 단축키 바인딩 (예: Ctrl + Shift + Escape)
    # gsettings set "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "binding" "['<Primary><Shift>Escape']"
    # gsettings set "org.mate.settings-daemon.plugins.media-keys.custom-keybinding:/org/mate/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "binding" "['<Primary><Shift>Escape']"
    # gsettings set "org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom1/" "binding" "['<Primary><Shift>Escape']"
    gsettings set "${custom_full_path}" "binding" "${binding}"
    # --------------------------------------------------------------------------
}
# ==============================================================================