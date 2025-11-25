#!/bin/bash

# korean =======================================================================
# bash /core/linux/bin/system/install_korean/install_korean.sh ${CUR_USER};
# ==============================================================================


# ENV ==========================================================================
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ==============================================================================


# Func =========================================================================
function install_nanum_fonts()
{
    local NANUM_URL="http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip"
    local NANUM_ZIP_PATH="/tmp/nanumfont.zip";
    local NANUM_DST_DIR="/usr/share/fonts/nanum";

    # --------------------------------------------------------------------------
    if [[ -d "${NANUM_DST_DIR}" ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    curl ${NANUM_URL} -o ${NANUM_ZIP_PATH}
    sudo unzip ${NANUM_ZIP_PATH} -d ${NANUM_DST_DIR}
    rm -f ${NANUM_ZIP_PATH}
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    fc-cache -f -v
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # fontconfig ---------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^fontconfig) ]] || apt install -y fontconfig;
    # --------------------------------------------------------------------------

    # korean input -------------------------------------------------------------
    # if [[ *"${CUR_VER}"* == *"ID=MX"* ]] || [[ *"${CUR_VER}"* == *"antix"* ]]; then
    #     echo "mxlinux and anix needs to use package installer"
    #     [[ -n $(apt list --installed | grep -i ^fcitx) ]] || apt install -y fcitx fcitx-hangul;
    #     [[ -n $(apt list --installed | grep -i ^im-config) ]] && /usr/bin/im-config -n fcitx;
    # else
    #     echo ""
    #     [[ -n $(apt list --installed | grep -i ^uim) ]] || apt install -y uim uim-byeoru;
    #     [[ -n $(apt list --installed | grep -i ^im-config) ]] && /usr/bin/im-config -n uim;
    # fi

    bash /core/linux/bin/system/install_korean/install_fcitx.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_fcitx5.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_ibus.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_kime.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_nimf.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_uim.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # korean fonts -------------------------------------------------------------
    [[ -n $(apt list --installed | grep -i ^fonts-nanum) ]] || apt install -y \
    fonts-nanum fonts-nanum-coding fonts-nanum-extra;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]]; then
    # fontconfig ---------------------------------------------------------------
    [[ -n $(yum list installed | grep -i ^fontconfig) ]] || yum install -y fontconfig;
    # --------------------------------------------------------------------------

    # korean input -------------------------------------------------------------
    # ibus-hangul has a problem at google-docs

    # [[ -n $(yum list installed | grep -i ^ibus-hangul) ]] || yum install -y ibus-hangul;
    # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
    #     [[ -n $(yum list installed | grep -i ^im-chooser) ]] || yum install -y im-chooser;
    # fi

    # bash /core/linux/bin/system/install_korean/install_fcitx.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_fcitx5.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_ibus.sh ${CUR_USER};
    bash /core/linux/bin/system/install_korean/install_kime.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_nimf.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_uim.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # korean fonts -------------------------------------------------------------
    install_nanum_fonts;
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # fontconfig ---------------------------------------------------------------
    [[ -n $(dnf list installed | grep -i ^fontconfig) ]] || dnf install -y fontconfig;
    # --------------------------------------------------------------------------

    # korean input -------------------------------------------------------------
    # ibus-hangul has a problem at google-docs

    # [[ -n $(dnf list installed | grep -i ^ibus-hangul) ]] || dnf install -y ibus-hangul;
    # if [[ *"${CUR_WMDE}" == *"xfce4"* ]] || [[ *"${CUR_WMDE}" == *"mate"* ]]; then
    #     [[ -n $(dnf list installed | grep -i ^im-chooser) ]] || dnf install -y im-chooser;
    # fi

    # bash /core/linux/bin/system/install_korean/install_fcitx.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_fcitx5.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_ibus.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_kime.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_nimf.sh ${CUR_USER};
    # bash /core/linux/bin/system/install_korean/install_uim.sh ${CUR_USER};
    # --------------------------------------------------------------------------

    # korean fonts -------------------------------------------------------------
    install_nanum_fonts;
    # --------------------------------------------------------------------------
fi
# ==============================================================================

exit 0