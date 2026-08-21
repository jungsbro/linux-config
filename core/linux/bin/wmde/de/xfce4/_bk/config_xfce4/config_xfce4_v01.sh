#!/bin/bash
set -e

SRC_PATH="/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml_"
TITLE="tile_up_key"
OLD_STR="&lt;Super&gt;KP_Up"
NEW_STR="&lt;Super&gt;Up"

LINE_NUM=$(cat -n "${SRC_PATH}" | grep "${TITLE}" | cut -f 1);
echo "${LINE_NUM}";

OLD_CMD=$(cat "${SRC_PATH}" | grep "${TITLE}");
echo "${OLD_CMD}";

if [[ -n "${LINE_NUM}" ]]; then
    # sed -i "${LINE_NUM}s/${SRC}/${NEW_STR}/" "${SRC_PATH}";
    NEW_CMD=$(echo "${OLD_CMD}" | perl -pe "s/"${OLD_STR}"/"${NEW_STR}"/");
    echo "${NEW_CMD}";
    sed -i "${LINE_NUM}s/.*/${NEW_CMD}/" "${SRC_PATH}";
fi

python3 - << 'EOF'
# print("test")
src_path="/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml_"
title="tile_up_key"
old_str="&lt;Super&gt;KP_Up"
new_str="&lt;Super&gt;Up"

f = open(src_path, "r")
data = f.read()
print(data)
EOF

# hotkey =======================================================================
SRC_PATH="/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/test.txt"




SRC_STR='<property name="&lt;Super&gt;KP_Up" type="string" value="tile_up_key"/>'
DST_STR='<property name="&lt;Super&gt;Up" type="string" value="tile_up_key"/>'

<property name="&lt;Super&gt;KP_Down" type="string" value="tile_down_key"/>
<property name="&lt;Super&gt;Down" type="string" value="tile_down_key"/>

<property name="&lt;Super&gt;KP_Left" type="string" value="tile_left_key"/>
<property name="&lt;Super&gt;Left" type="string" value="tile_left_key"/>

<property name="&lt;Super&gt;KP_Right" type="string" value="tile_right_key"/>
<property name="&lt;Super&gt;Right" type="string" value="tile_right_key"/>


<property name="&lt;Primary&gt;&lt;Alt&gt;d" type="string" value="show_desktop_key"/>
<property name="&lt;Super&gt;d" type="string" value="show_desktop_key"/>


<property name="&lt;Super&gt;i" type="string" value="/usr/bin/xfce4-settings-manager"/>


<property name="&lt;Alt&gt;F3" type="string" value="xfce4-appfinder">
<property name="&lt;Alt&gt;F2" type="string" value="xfce4-appfinder">

<property name="&lt;Alt&gt;F2" type="string" value="xfce4-appfinder --collapsed">
<property name="&lt;Primary&gt;space" type="string" value="xfce4-appfinder --collapsed">

# 삭제
<property name="&lt;Primary&gt;Escape" type="string" value="xfdesktop --menu"/>


<property name="&lt;Alt&gt;F1" type="string" value="xfce4-popup-applicationsmenu"/>
<property name="&lt;Primary&gt;Escape" type="string" value="xfce4-popup-applicationsmenu"/>


<property name="&lt;Primary&gt;&lt;Alt&gt;l" type="string" value="xflock4"/>
<property name="&lt;Super&gt;l" type="string" value="xscreensaver"/>

sed -n "/${SRC_STR}/p" "${SRC_PATH}"
sed "s/${SRC_STR}/${DST_STR}/" "${SRC_PATH}"
# ==============================================================================



# themes
# ==============================================================================
# vi ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
# <?xml version="1.0" encoding="UTF-8"?>
#     <property name="IconThemeName" type="string" value="Tela"/>
# ==============================================================================







