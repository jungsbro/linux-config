#!/bin/bash

# qpdfview =====================================================================
# bash /core/linux/bin/office/install_qpdfview.sh;
# ==============================================================================


# ENV ==========================================================================
CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Main : x86_64, i686, aarch64 =================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^qpdfview) ]] || apt install -y qpdfview;
    [[ -n $(apt list --installed | grep -i ^qpdfview-djvu-plugin) ]] || apt install -y qpdfview-djvu-plugin;
    [[ -n $(apt list --installed | grep -i ^qpdfview-pdf-poppler-plugin) ]] || apt install -y qpdfview-pdf-poppler-plugin;
    [[ -n $(apt list --installed | grep -i ^qpdfview-ps-plugin) ]] || apt install -y qpdfview-ps-plugin;
    [[ -n $(apt list --installed | grep -i ^qpdfview-translations) ]] || apt install -y qpdfview-translations;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
    [[ -n $(dnf list installed | grep -i ^qpdfview-qt5) ]] || dnf install -y qpdfview-qt5;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0