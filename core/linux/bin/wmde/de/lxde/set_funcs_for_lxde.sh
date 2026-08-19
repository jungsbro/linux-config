#!/bin/bash
set -e

[[ -n "${_SET_FUNCS_FOR_LXDE_LOADED:-}" ]] && return 0
_SET_FUNCS_FOR_LXDE_LOADED=1

# usage ========================================================================
# ------------------------------------------------------------------------------
# lxde에서 ns="http://openbox.org/3.4/rc"; 를 설정하지 않으면, xmlstarlet이 작동하지 않는다.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/lxde/set_funcs_for_lxde.sh

# for window
# set_hotkey_for_window ${ns} ${hotkey} ${comment} ${action} ${dst_path};
# set_hotkey_for_half-window ${ns} ${hotkey} ${comment} ${value1} ${value2} ${value3} ${value4} ${dst_path};

# for workspace
# set_hotkey_for_ws ${ns} ${hotkey} ${comment} ${action} ${key1} ${value1} ${dst_path}
# set_hotkey_for_going-to-desktop ${ns} ${hotkey} ${comment} ${ws_num} ${dst_path}

# for app
# set_hotkey_for_app ${ns} ${hotkey} ${comment} ${action} ${cmd} ${dst_path};
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# source ${CORE_BIN_DIR}/wmde/de/lxde/set_funcs_for_lxde.sh

# for window
# set_hotkey_for_window "http://openbox.org/3.4/rc" "A-Tab" "Keybindings for window switching" "NextWindow" "" "${HOME}/.config/openbox/lxde-rc.xml";
# set_hotkey_for_half-window "http://openbox.org/3.4/rc" "W-Left" "Keybindings for window-tiling" "+0" "+0" "50/100" "100/100" "${HOME}/.config/openbox/lxde-rc.xml";

# for workspace
# set_hotkey_for_ws "http://openbox.org/3.4/rc" "W-C-Left" "Keybindings for akey-workspace" "DesktopLeft" "dialog" "no" "${HOME}/.config/openbox/lxde-rc.xml";
# set_hotkey_for_going-to-desktop "http://openbox.org/3.4/rc" "W-F1" "Keybindings for fkey-workspace" "1" "${HOME}/.config/openbox/lxde-rc.xml";

# for app
# set_hotkey_for_app "http://openbox.org/3.4/rc" "C-A-t" "Keybindings for terminal" "Execute" "lxterminal" "${HOME}/.config/openbox/lxde-rc.xml";
# ------------------------------------------------------------------------------
# ==============================================================================


# ENV ==========================================================================

# ==============================================================================


# Funcs for common =============================================================
function is_rpios()
{
    # amd64 : 6.1.0-41-amd64
    # arm64 : 6.12.34+rpt-rpi-v8
    uname -r | grep -q "rpi"

    # true(0), false(1)
    return ${?}
}
# ==============================================================================


# Funcs for window =============================================================
function set_hotkey_for_window()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <!-- Keybindings for window switching -->
    #         <keybind key="A-Tab">
    #             <action name="NextWindow"/>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # env ----------------------------------------------------------------------
    local ns=${1}
    local hotkey=${2}
    local comment=${3}
    local action=${4}
    local dst_path=${5}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # -L : In-place Edit
    # -N : namespace
    # -d : delete
    # -t : type
    # -n : name
    # -v : value
    # -i : insert
    # -a : append
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 0) 기존에 있는 <keybind key="A-Tab">를 초기화(삭제)한다.
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -d "//x:keyboard/x:keybind[@key='A-Tab']" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -d "//x:keyboard/x:keybind[@key='${hotkey}']" \
    "${dst_path}"

    if [[ -z ${action} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) <keyboard> 맨 밑에 새로운 <keybind> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard" -t elem -n "keybind" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard" \
    -t elem -n "keybind" -v "" "${dst_path}"

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t attr -n "key" -v "A-Tab" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t attr -n "key" -v "${hotkey}" "${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 방금 만든 <keybind> 앞에 주석(Comment) 노드 삽입
    if [[ -n "${comment}" ]]; then
        # ----------------------------------------------------------------------
        # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -i "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v " Keybindings for switching windows " ./lxde-rc.xml
        xmlstarlet ed -L -N x="${ns}" -i "//x:keyboard/x:keybind[last()]" \
        -t elem -n '!--' -v " ${comment} " "${dst_path}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 방금 만든 <keybind> 밑에 <action name="Execute"> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t elem -n "action" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t elem -n "action" -v "" "${dst_path}"

    # 4) 방금 만든 <action> 밑에, name 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t attr -n "name" -v "NextWindow" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t attr -n "name" -v "${action}" "${dst_path}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_half-window()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-Left">
    #             <action name="UnmaximizeFull"/>
    #             <action name="MoveResizeTo">
    #                 <x>+0</x>
    #                 <y>+0</y>
    #                 <width>50/100</width>
    #                 <height>100/100</height>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # W-S-Up / W-Dwon / W-Left / W-Right
    local ns=${1}
    local hotkey=${2};
    local comment=${3};

    local action1="UnmaximizeFull";

    local action2="MoveResizeTo";
    local key1="x";
    local value1=${4};

    local key2="y";
    local value2=${5};

    local key3="width";
    local value3=${6};

    local key4="height";
    local value4=${7};

    local dst_path=${8}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 0) 기존에 있는 <keybind key="W-Left">를 초기화(삭제)한다.
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -d "//x:keyboard/x:keybind[@key='W-Left']" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -d "//x:keyboard/x:keybind[@key='${hotkey}']" \
    "${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) <keyboard> 맨 밑에 새로운 <keybind> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard" -t elem -n "keybind" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard" \
    -t elem -n "keybind" -v "" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t attr -n "key" -v "W-Left" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t attr -n "key" -v "${hotkey}" "${dst_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 방금 만든 <keybind> 앞에 주석(Comment) 노드 삽입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -i "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v " Keybindings for lr-window " ./lxde-rc.xml
    # xmlstarlet ed -L -N x="${ns}" -i "//x:keyboard/x:keybind[last()]" \
    # -t elem -n '!--' -v "${comment}" "${dst_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 방금 만든 <keybind> 밑에 <action> 생성1
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t elem -n "action" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t elem -n "action" -v "" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t attr -n "name" -v "UnmaximizeFull" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t attr -n "name" -v "${action1}" "${dst_path}";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 방금 만든 <keybind> 밑에 <action> 생성2
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t elem -n "action" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t elem -n "action" -v "" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t attr -n "name" -v "MoveResizeTo" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t attr -n "name" -v "${action2}" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "x" -v '+0' ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "${key1}" -v "${value1}" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "y" -v '+0' ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "${key2}" -v "${value2}" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "width" -v '50/100' ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "${key3}" -v "${value3}" "${dst_path}";

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "height" -v '100/100' ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "${key4}" -v "${value4}" "${dst_path}";
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Funcs for workspace ==========================================================
function set_hotkey_for_ws()
{
    # --------------------------------------------------------------------------
    # workspace movement with arrow-keys
    #
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-C-Left">
    #             <action name="DesktopLeft">
    #                 <dialog>no</dialog>
    #                 <wrap>no</wrap>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # app to workspace with arrow-keys
    #
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-S-Left">
    #             <action name="SendToDesktopLeft">
    #                 <dialog>no</dialog>
    #                 <wrap>no</wrap>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # app to workspace with function-keys
    #
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-S-F1">
    #             <action name="SendToDesktop">
    #                 <to>1</to>
    #                 <wrap>no</wrap>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # env ----------------------------------------------------------------------
    local ns=${1}
    local hotkey=${2}
    local comment=${3}
    local action=${4}
    local key1=${5}
    local value1=${6}
    local dst_path=${7}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 0) 기존에 있는 <keybind key="W-S-Left">를 초기화(삭제)한다.
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -d "//x:keyboard/x:keybind[@key='W-S-Left']" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -d "//x:keyboard/x:keybind[@key='${hotkey}']" \
    "${dst_path}"

    if [[ -z ${action} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) <keyboard> 맨 밑에 새로운 <keybind> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard" -t elem -n "keybind" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard" \
    -t elem -n "keybind" -v "" "${dst_path}"

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t attr -n "key" -v "W-C-Left" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t attr -n "key" -v "${hotkey}" "${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 방금 만든 <keybind> 앞에 주석(Comment) 노드 삽입
    if [[ -n "${comment}" ]]; then
        # ----------------------------------------------------------------------
        # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -i "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v " Keybindings for workspace " ./lxde-rc.xml
        xmlstarlet ed -L -N x="${ns}" -i "//x:keyboard/x:keybind[last()]" \
        -t elem -n '!--' -v " ${comment} " "${dst_path}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 방금 만든 <keybind> 밑에 <action name="DesktopLeft"> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t elem -n "action" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t elem -n "action" -v "" "${dst_path}"

    # 4) 방금 만든 <action> 밑에, name 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t attr -n "name" -v "DesktopLeft" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t attr -n "name" -v "${action}" "${dst_path}"

    # 5) 방금 만든 <action> 밑에, dialog 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "dialog" -v "no" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "${key1}" -v "${value1}" "${dst_path}"

    # 6) 방금 만든 <action> 밑에, wrap 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "wrap" -v "no" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "wrap" -v "no" "${dst_path}"
    # --------------------------------------------------------------------------
}


function set_hotkey_for_going-to-desktop()
{
    # --------------------------------------------------------------------------
    # workspace movement with function-keys
    #
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <keybind key="W-F1">
    #             <action name="GoToDesktop">
    #                 <to>1</to>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # env ----------------------------------------------------------------------
    local ns=${1}
    local hotkey=${2}
    local comment=${3}
    local ws_num=${4}
    local dst_path=${5}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 0) 기존에 있는 <keybind key="W-F1">를 초기화(삭제)한다.
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -d "//x:keyboard/x:keybind[@key='W-F1']" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -d "//x:keyboard/x:keybind[@key='${hotkey}']" \
    "${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) <keyboard> 맨 밑에 새로운 <keybind> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard" -t elem -n "keybind" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard" \
    -t elem -n "keybind" -v "" "${dst_path}"

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t attr -n "key" -v "W-F1" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t attr -n "key" -v "${hotkey}" "${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 방금 만든 <keybind> 앞에 주석(Comment) 노드 삽입
    if [[ -n "${comment}" ]]; then
        # ----------------------------------------------------------------------
        # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -i "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v " Keybindings for workspace " ./lxde-rc.xml
        xmlstarlet ed -L -N x="${ns}" -i "//x:keyboard/x:keybind[last()]" \
        -t elem -n '!--' -v " ${comment} " "${dst_path}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 방금 만든 <keybind> 밑에 <action name="Desktop"> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t elem -n "action" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t elem -n "action" -v "" "${dst_path}"

    # 4) 방금 만든 <action> 밑에, name 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t attr -n "name" -v "GoToDesktop" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t attr -n "name" -v "GoToDesktop" "${dst_path}"

    # 5) 방금 만든 <action> 밑에, workspace number 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "to" -v "1" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "to" -v "${ws_num}" "${dst_path}"
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Funcs for app ================================================================
function set_hotkey_for_app()
{
    # --------------------------------------------------------------------------
    # <openbox_config xmlns="http://openbox.org/3.4/rc">
    #     <keyboard>
    #         <!-- Keybindings for terminal -->
    #         <keybind key="C-A-t">
    #             <action name="Execute">
    #                 <command>lxterminal</command>
    #             </action>
    #         </keybind>
    #     </keyboard>
    # </openbox_config>
    # --------------------------------------------------------------------------

    # env ----------------------------------------------------------------------
    local ns=${1}
    local hotkey=${2}
    local comment=${3}
    local action=${4}
    local cmd=${5}
    local dst_path=${6}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # -L : In-place Edit
    # -N : namespace
    # -d : delete
    # -t : type
    # -n : name
    # -v : value
    # -i : insert
    # -a : append
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 0) 기존에 있는 <keybind key="C-A-t">를 초기화(삭제)한다.
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -d "//x:keyboard/x:keybind[@key='C-A-t']" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -d "//x:keyboard/x:keybind[@key='${hotkey}']" \
    "${dst_path}"

    if [[ -z ${action} ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) <keyboard> 맨 밑에 새로운 <keybind> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard" -t elem -n "keybind" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard" \
    -t elem -n "keybind" -v "" "${dst_path}"

    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t attr -n "key" -v "C-A-t" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t attr -n "key" -v "${hotkey}" "${dst_path}"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) 방금 만든 <keybind> 앞에 주석(Comment) 노드 삽입
    if [[ -n "${comment}" ]]; then
        # ----------------------------------------------------------------------
        # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -i "//x:keyboard/x:keybind[last()]" -t elem -n '!--' -v " Keybindings for terminal " ./lxde-rc.xml
        xmlstarlet ed -L -N x="${ns}" -i "//x:keyboard/x:keybind[last()]" \
        -t elem -n '!--' -v " ${comment} " "${dst_path}"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 3) 방금 만든 <keybind> 밑에 <action name="Execute"> 생성
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]" -t elem -n "action" -v "" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]" \
    -t elem -n "action" -v "" "${dst_path}"

    # 4) 방금 만든 <action> 밑에, name 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t attr -n "name" -v "Execute" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t attr -n "name" -v "${action}" "${dst_path}"

    # 5) 방금 만든 <action> 밑에, command 주입
    # xmlstarlet ed -L -N x="http://openbox.org/3.4/rc" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" -t elem -n "command" -v "lxterminal" ./lxde-rc.xml
    xmlstarlet ed -L -N x="${ns}" -s "//x:keyboard/x:keybind[last()]/x:action[last()]" \
    -t elem -n "command" -v "${cmd}" "${dst_path}"
    # --------------------------------------------------------------------------
}
# ==============================================================================