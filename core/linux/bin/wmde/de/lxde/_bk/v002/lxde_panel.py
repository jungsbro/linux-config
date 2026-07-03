import os
import sys
import shutil

# usage ========================================================================
# python3 "${CORE_BIN_DIR}/wmde/de/lxde/lxde_panel.py" ${CUR_USER}

# import lxde_panel
# lxde_panel.set_panel(CORE_BIN_DIR, HOME_DIR)
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# core/linux/bin/wmde/de/lxde/lxde_panel.py
SCRIPT_PATH = os.path.abspath(__file__)

# os.getcwd()
# core/linux/bin/wmde/de/lxde
SCRIPT_DIR = os.path.dirname(SCRIPT_PATH)
if SCRIPT_DIR not in sys.path:
    sys.path.append(SCRIPT_DIR)

# core/linux/bin/wmde/de
DE_DIR = os.path.dirname(SCRIPT_DIR)

# core/linux/bin/wmde
WMDE_DIR = os.path.dirname(DE_DIR)

# core/linux/bin
CORE_BIN_DIR = os.path.dirname(WMDE_DIR)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER = f"{sys.argv[1]}"


def set_home_dir():
    home_dir = ""

    if len(sys.argv) != 2:
        print("Please input username!")
    else:
        # ~jungs
        cmd = f"~{CUR_USER}"

        # /home/jungs
        home_dir = os.path.expanduser(cmd)

    return home_dir

HOME_DIR = set_home_dir()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# panel-height / panel-style / panel-clock settings
PANEL_DATA='''# lxpanel <profile> config file. Manually editing is not recommended.
# Use preference dialog in lxpanel to adjust config when you can.

Global {
  edge=bottom
  align=left
  margin=0
  widthtype=percent
  width=100
  height=26
  transparent=0
  tintcolor=#000000
  alpha=0
  setdocktype=1
  setpartialstrut=1
  autohide=0
  heightwhenhidden=0
  usefontcolor=1
  fontcolor=#ffffff
  background=1
  backgroundfile=/usr/share/lxpanel/images/background.png
}
Plugin {
  type=space
  Config {
    Size=2
  }
}
Plugin {
  type=menu
  Config {
    image=/usr/share/lxde/images/lxde-icon.png
    system {
    }
    separator {
    }
    item {
      command=run
    }
    separator {
    }
    item {
      image=gnome-logout
      command=logout
    }
  }
}
Plugin {
  type=launchbar
  Config {
    Button {
      id=pcmanfm.desktop
    }
    Button {
      id=lxde-x-www-browser.desktop
    }
  }
}
Plugin {
  type=space
  Config {
    Size=4
  }
}
Plugin {
  type=wincmd
  Config {
    Button1=iconify
    Button2=shade
  }
}
Plugin {
  type=space
  Config {
    Size=4
  }
}
Plugin {
  type=pager
  Config {
  }
}
Plugin {
  type=space
  Config {
    Size=4
  }
}
Plugin {
  type=taskbar
  expand=1
  Config {
    tooltips=1
    IconsOnly=0
    AcceptSkipPager=1
    ShowIconified=1
    ShowMapped=1
    ShowAllDesks=0
    UseMouseWheel=1
    UseUrgencyHint=1
    FlatButton=0
    MaxTaskWidth=150
    spacing=1
  }
}
Plugin {
  type=cpu
  Config {
  }
}
Plugin {
  type=volume
  Config {
    VolumeMuteKey=XF86AudioMute
    VolumeDownKey=XF86AudioLowerVolume
    VolumeUpKey=XF86AudioRaiseVolume
  }
}
Plugin {
  type=tray
  Config {
  }
}
Plugin {
  type=dclock
  Config {
    ClockFmt=%R
    TooltipFmt=%A %x
    BoldFont=0
    IconOnly=0
    CenterText=0
  }
}
Plugin {
  type=launchbar
  Config {
    Button {
      id=lxde-screenlock.desktop
    }
    Button {
      id=lxde-logout.desktop
    }
  }
}
'''
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
import lxde_funcs

def set_panel(core_bin_dir, home_dir):
    # --------------------------------------------------------------------------
    if lxde_funcs.is_rpios():
        src_path = f"{core_bin_dir}/wmde/lxde/panel-pi";
        dst_path = f"{home_dir}/.config/lxpanel/LXDE-pi/panels/panel"
    else:
        src_path = f"{core_bin_dir}/wmde/lxde/panel";
        dst_path = f"{home_dir}/.config/lxpanel/LXDE/panels/panel"

    if not os.path.isfile(dst_path):
        f = open(dst_path, "w")
        f.write(PANEL_DATA)
        f.close()
    # --------------------------------------------------------------------------

    if os.path.isfile(src_path):
        # backup dst-file ------------------------------------------------------
        if os.path.isfile(dst_path):
            bk_path = lxde_funcs.get_bk_path(dst_path)
            shutil.copy2(dst_path, bk_path)
        # ----------------------------------------------------------------------

        shutil.copy2(src_path, dst_path)
    else:
        # panel-height ---------------------------------------------------------
        old_str = "height=26"
        new_str = "height=40"
        lxde_funcs.fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------

        # panel-style ----------------------------------------------------------
        old_str = "background=1"
        new_str = "background=0"
        lxde_funcs.fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------

        # panel-fontcolor ------------------------------------------------------
        # old_str = "fontcolor=#000000"
        # new_str = "fontcolor=#ffffff"
        old_str = "usefontcolor=1"
        new_str = "usefontcolor=0"
        lxde_funcs.fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------

        # panel-clock ----------------------------------------------------------
        # PM 01:00
        # 25-01-01 (Wed)
        old_str = "ClockFmt=%R"
        new_str = "ClockFmt=     %p %I:%M\\n%y-%m-%d (%a)"
        lxde_funcs.fix_settings(old_str, new_str, dst_path)
        # ----------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ==============================================================================



# Main =========================================================================
if __name__ == "__main__":
    set_panel(CORE_BIN_DIR, HOME_DIR)
# ==============================================================================
