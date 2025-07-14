import os

# prop_dict usage ==============================================================
#                       | old_name | new_name | old_value | new_value
# ------------------------------------------------------------------------------
# fix old_name          | old_name | new_name | old_value | old_value
# delete property       | old_name | ""       | old_value | old_value
# create new property   | new_name | new_name | new_value | new_value
# ==============================================================================


# xfce4-keyboard-shortcuts.xml =================================================
# env --------------------------------------------------------------------------
src_path = "/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"

prop_dict = \
{
    # old_name                  new_name        old_value       new_value
    "&lt;Super&gt;KP_Up" : ["&lt;Super&gt;Up", "tile_up_key", "tile_up_key"], 
    "&lt;Super&gt;KP_Down" : ["&lt;Super&gt;Down", "tile_down_key", "tile_down_key"], 
    "&lt;Super&gt;KP_Left" : ["&lt;Super&gt;Left", "tile_left_key", "tile_left_key"], 
    "&lt;Super&gt;KP_Right" : ["&lt;Super&gt;Right", "tile_right_key", "tile_right_key"],
    
    "&lt;Primary&gt;&lt;Alt&gt;d" : ["&lt;Super&gt;d", "show_desktop_key", "show_desktop_key"],
    "&lt;Super&gt;i" : ["&lt;Super&gt;i", "xfce4-settings-manager", "xfce4-settings-manager"],
    
    "&lt;Alt&gt;F2" : ["&lt;Primary&gt;space", "xfce4-appfinder --collapsed", "xfce4-appfinder --collapsed"],
    "&lt;Alt&gt;F3" : ["&lt;Alt&gt;F2", "xfce4-appfinder", "xfce4-appfinder"],
    
    "&lt;Primary&gt;Escape" : ["", "xfdesktop --menu" , "xfdesktop --menu"],
    "&lt;Alt&gt;F1" : ["&lt;Primary&gt;Escape", "xfce4-popup-applicationsmenu", "xfce4-popup-applicationsmenu"],
    "&lt;Primary&gt;&lt;Alt&gt;l" : ["&lt;Super&gt;l", "xflock4" , "xscreensaver"],
}
# ------------------------------------------------------------------------------

def is_cus_pos(cur_row, kwd_cnt):
    kwd_list = ["xkill", "override"]

    if [kwd for kwd in kwd_list   if kwd in cur_row]:
        kwd_cnt += 1
        
    if kwd_cnt == len(kwd_list):
        return True, kwd_cnt
    else:
        return False, kwd_cnt
# ------------------------------------------------------------------------------

def fix_shortcut(old_name, new_name, old_value, new_value, src_path):
    if not os.path.isfile(src_path): return
     
    f = open(src_path, "r")
    old_data = f.read()
    f.close()

    old_list = old_data.split("\n")
    new_list = []
    kwd_cnt = 0
         
    for cur_row in old_list:
        if (old_name in cur_row) and (old_value in cur_row):
            # 1) delete property
            if not new_name: continue

            # 2) fix old_name
            if old_value != new_value:
                cur_row = cur_row.replace(old_value, new_value)

            cur_row = cur_row.replace(old_name, new_name)
            print(cur_row)
            new_list.append(cur_row)
        
        else:
            # 3) not changing
            new_list.append(cur_row)

            # 4) create new property
            rst, kwd_cnt = is_cus_pos(cur_row, kwd_cnt)
            if not rst: continue
            if old_name != new_name: continue
            if (old_name in old_data) and (old_value in old_data): continue

            #      <property name="&lt;Super&gt;i" type="string" value="xfce4-settings-manager"/>
            cur_row = f'      <property name="{new_name}" type="string" value="{new_value}"/>'
            print(cur_row)
            new_list.append(cur_row)
            kwd_cnt = 0

    new_data = "\n".join(new_list)

    f = open(src_path, "w")
    f.write(new_data)
    f.close()
# ------------------------------------------------------------------------------

# os.path.expanduser("~")
# os.path.expanduser("~jungs")
# os.getenv("HOME")
# os.environ["HOME"]

# fix shortcuts ----------------------------------------------------------------
for old_name in prop_dict:
    new_name, old_value, new_value, = prop_dict[old_name]
    fix_shortcut(old_name, new_name, old_value, new_value, src_path)
# ------------------------------------------------------------------------------
# ==============================================================================



# xfce4-panel.xml ==============================================================
# env --------------------------------------------------------------------------
src_path = "/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
# ------------------------------------------------------------------------------

# korean clock -----------------------------------------------------------------
<property name="plugin-12" type="string" value="clock">
  # Time, then date
  <property name="digital-layout" type="uint" value="1"/>
  # 24-01-01 (Sun)
  <property name="digital-date-format" type="string" value="%y-%m-%d (%a)"/>
  # 01:00 PM
  <property name="digital-time-format" type="string" value="%I:%M %p"/>
</property>
# ------------------------------------------------------------------------------
# ==============================================================================



# xfwm4.xml ====================================================================
# env --------------------------------------------------------------------------
src_path = "/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
# ------------------------------------------------------------------------------

# disable workspace_scroll -----------------------------------------------------
    # <property name="scroll_workspaces" type="bool" value="false"/>
    # <property name="workspace_count" type="int" value="2"/>
# ------------------------------------------------------------------------------
# ==============================================================================



# xsettings.xml ================================================================
# env --------------------------------------------------------------------------
src_path = "/home/jungs/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
# ------------------------------------------------------------------------------

# themes -----------------------------------------------------------------------
# <?xml version="1.0" encoding="UTF-8"?>
#     <property name="IconThemeName" type="string" value="Tela"/>
# ------------------------------------------------------------------------------
# ==============================================================================
