import os
import sys
import shutil


# usage ========================================================================
# python3 "${CORE_BIN_DIR}/wmde/de/lxde/lxde_funcs.py"

# import lxde_funcs
# lxde_funcs.is_rpios()
# lxde_funcs.get_bk_path(dst_path)
# lxde_funcs.fix_settings(old_str, new_str, dst_path)
# ==============================================================================


# Funcs ========================================================================
def is_rpios():
    cmd = "uname -r"        # -r : kernel-release
    stream = os.popen(cmd)
    output = stream.read()  # 6.12.34+rpt-rpi-v8

    if "rpi" in output:     # rpios
        return True
    else:                   # amd64, arm64
        return False
# ------------------------------------------------------------------------------

def get_bk_path(dst_path):
    ''' ~/.config/temp/dst.txt  >>  ~/.config/_backup/temp/dst_0001.txt '''

    # 1) bk_parent_dir ---------------------------------------------------------
    dst_dir = os.path.dirname(dst_path)
    if ".config" in dst_dir:                    #  ~/.config/temp  >>  ~/.config/_backup/temp
        prefix = dst_dir.split(".config")[0]
        suffix = dst_dir.split(".config")[1]
        bk_parent_dir = f"{prefix}.config/_bakcup{suffix}"
    else:                                       # ~/temp  >>  ~/temp/_backup
        bk_parent_dir = f"{dst_dir}/_bakcup"

    if not os.path.isdir(bk_parent_dir):
        os.makedirs(bk_parent_dir)

    # 2) dst_basename, dst_fname, dst_ext --------------------------------------
    dst_basename = os.path.basename(dst_path)
    if "." in dst_basename:
        dst_fname = dst_basename.split(".")[0]
        dst_ext = dst_basename.split(".")[-1]
    else:
        dst_fname = dst_basename
        dst_ext = ""

    # 3) bk_path ---------------------------------------------------------------
    num = 1

    while True:
        padding = f"{num:04d}"
        bk_path = f"{bk_parent_dir}/{dst_fname}_{padding}.{dst_ext}"

        if os.path.isfile(bk_path):
            num += 1
        else:
            return bk_path
# ------------------------------------------------------------------------------


def fix_settings(old_str, new_str, dst_path):
    if not os.path.isfile(dst_path): return

    f = open(dst_path, "r")
    data = f.read()
    f.close()

    if old_str not in data: return
    data = data.replace(old_str, new_str)

    # bk_path = get_bk_path(dst_path)
    # shutil.copy2(dst_path, bk_path)

    f = open(dst_path, "w")
    f.write(data)
# ------------------------------------------------------------------------------
# ==============================================================================
