# usage ========================================================================
# python3 wmcc.py

# python3 ~/.local/bin/wmcc.py
# ==============================================================================

import os
import configparser
import subprocess
import json
from collections import OrderedDict
import tkinter as tk

# ENV ==========================================================================
# sudo apt-get install python3-tk
# sudo dnf install python3-tkinter

TITLE = "LXDE Control Center"

# ------------------------------------------------------------------------------
# not used
UI_WIDTH = 1000
UI_HEIGHT = 600
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
BTN_COL_NUM = 4
BTN_GAP = 10

# Desktop >> Categories
CAT_KWD = "Settings"

APP_CONFIG_DIR = os.path.expanduser('~/.config/wmcc')
if not os.path.isdir(APP_CONFIG_DIR):
    os.makedirs(APP_CONFIG_DIR)

JSON_PATH = f"{APP_CONFIG_DIR}/app.json"
# ------------------------------------------------------------------------------
# ==============================================================================

def get_dictlist_from_dirlist(kwd):

    dir_list = [
        os.path.expanduser('~/.local/share/applications/'),
        '/usr/share/applications/',
        '/usr/local/share/applications/'
    ]

    dict_list = []

    for cur_dir in dir_list:
        if not os.path.isdir(cur_dir):
            continue

        for fname in os.listdir(cur_dir):
            if not fname.endswith('.desktop'): continue
            cur_path = os.path.join(cur_dir, fname)

            try:
                config = configparser.ConfigParser()
                # .desktop 파일의 인코딩 문제 해결을 위해 utf-8-sig 사용
                config.read(cur_path, encoding='utf-8-sig')

                # [Desktop Entry] 섹션이 있는지 확인
                if 'Desktop Entry' not in config: continue
                desktop_entry = config['Desktop Entry']

                if 'Name' not in desktop_entry: continue
                name = desktop_entry['Name']

                if 'Exec' not in desktop_entry: continue
                exec = desktop_entry['Exec']

                if 'Icon' not in desktop_entry: continue
                icon = desktop_entry['Icon']

                if 'Categories' not in desktop_entry: continue
                categories = desktop_entry['Categories']
                # 카테고리 목록을 세미콜론(;)으로 분리하고 대소문자 구분 없이 비교
                category_list = [c.strip() for c in categories.split(';') if c.strip()]
                if not [c.lower() for c in category_list if kwd.lower() in c.lower()]: continue

                cur_dict = {}
                cur_dict["name"] = name
                cur_dict["exec"] = exec
                cur_dict["icon"] = icon
                cur_dict["category_list"] = category_list
                cur_dict["file_path"] = cur_path

                dict_list.append(cur_dict)

            except Exception as e:
                print(f"Error parsing {cur_path}: {e}")


    return dict_list
# ------------------------------------------------------------------------------


class Interface(tk.Tk):
    def __init__(self):
        tk.Tk.__init__(self)

        self.create_btns()
        self.setInitValues()
    # --------------------------------------------------------------------------

    def centerOnScreen(self):
        # ----------------------------------------------------------------------
        scrn_width = self.winfo_screenwidth()     # 1920
        scrn_hegith = self.winfo_screenheight()   # 1080
        # print(scrn_width, scrn_hegith)
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # ui_width = UI_WIDTH
        # ui_height = UI_HEIGHT

        BTN_ROW_NUM = self.row + 1
        ui_width = (self.btn_width * BTN_COL_NUM) + (BTN_GAP * (BTN_COL_NUM+1)) + (45 * BTN_COL_NUM) + 80

        ui_height = (self.btn_height * BTN_ROW_NUM) + (BTN_GAP * (BTN_ROW_NUM+1)) + (10 * BTN_ROW_NUM)
        # print(ui_width, ui_height, self.row)
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        ui_xpos = scrn_width/2 - ui_width/2
        ui_xpos = int(ui_xpos)

        ui_ypos = scrn_hegith/2 - ui_height/2
        ui_ypos = int(ui_ypos)
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        ui_pos = f"{ui_width}x{ui_height}+{ui_xpos}+{ui_ypos}"
        self.geometry(ui_pos)
        # ----------------------------------------------------------------------
    # --------------------------------------------------------------------------

    def create_btns(self):
        self.btn_list = []

        if os.path.isfile(JSON_PATH):
            self.load_conf()
        else:
            self.conf_list = get_dictlist_from_dirlist(CAT_KWD)

            if not self.conf_list: return
            self.save_conf()

        self.conf_list = sorted(self.conf_list, key=lambda x: x["name"].lower())

        for idx, cur_dict in enumerate(self.conf_list):
            cur_name = cur_dict["name"]
            cur_exec = cur_dict["exec"]
            cur_icon = cur_dict["icon"]

            btn = tk.Button(self, text=cur_name, command=lambda c=cur_exec: self.on_click(c))

            self.row = idx // BTN_COL_NUM
            self.column = idx % BTN_COL_NUM

            # 버튼을 grid에 배치하고 sticky로 확장
            btn.grid(row=self.row, column=self.column, sticky="nsew", padx=BTN_GAP, pady=BTN_GAP)
            self.btn_list.append(btn)

        self.btn_width = btn.winfo_reqwidth()
        self.btn_height = btn.winfo_reqheight()
    # --------------------------------------------------------------------------

    def setInitValues(self):
        self.title(TITLE)
        self.centerOnScreen()
        # self.resizable(False, False) # resizable( topBottom, leftLight )

        self.bind( "<Escape>", lambda e : e.widget.destroy() )
    # --------------------------------------------------------------------------

    def load_conf(self):
        if not os.path.isfile(JSON_PATH): return

        f = open(JSON_PATH, 'r')
        self.conf_list = json.load(f, object_pairs_hook=OrderedDict)
        f.close()
    # --------------------------------------------------------------------------

    def save_conf(self):
        f = open(JSON_PATH, 'w')
        json.dump(self.conf_list, f, indent=4)
        f.close()
    # --------------------------------------------------------------------------

    def on_click(self, cmd):
        # print(cmd)
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    # --------------------------------------------------------------------------
# ==============================================================================


def main():
    global ui

    try:
        ui.destroy()
        # ui.quit()
    except:
        pass

    ui = Interface()
    ui.mainloop()
# ------------------------------------------------------------------------------

if __name__ == '__main__':
    main()