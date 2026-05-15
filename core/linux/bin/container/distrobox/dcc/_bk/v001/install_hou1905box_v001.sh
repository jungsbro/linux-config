#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/container/distrobox/dcc/install_hou1905box.sh
# ==============================================================================

# ENV ==========================================================================
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
# /core/linux/bin/container/distrobox/dcc
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"

DISTOBOX_DIR="${CORE_BIN_DIR}/container/distrobox"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
MA_DIR="/mnt/j4105-omv/core/linux/bin/cg/maya/maya2025"
MA_PATH="${MA_DIR}/install_maya2025.sh"
MA_BIN="/usr/autodesk/maya2025/bin/maya"
MA_APP="maya"

HOU_DIR="/mnt/j4105-omv/core/linux/bin/cg/houdini/hfs19.5.303"
HOU_PATH="${HOU_DIR}/sync1_j4105-omv_to_opt_for_hou1905303.sh"
HOU_BIN="/opt/hfs19.5/bin/houdinifx"
HOU_APP="houdinifx"

NK_DIR="/mnt/j4105-omv/core/linux/bin/cg/nuke/Nuke16.0v6"
NK_PATH="${NK_DIR}/sync1_j4105-omv_to_opt_for_nk1606.sh"
NK_BIN="/opt/Nuke16.0v6/Nuke16.0"
NK_APP="Nuke16.0v6"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# 1) for container ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ------------------------------------------------------------------------------
CTR_NAME="hou1905box"

# rokcy9/glibc가 x86-64-v2 요구 >> 구형 CPU에서는 실행 불가
# rokcy8/glibc가 x86-64-v1 기반 >> 구형 CPU에서도 문제 없이 실행 가능
IMAGE="docker.io/library/rockylinux:9.3"

# distrobox create --name "hou1905box" --image "docker.io/library/rockylinux:9.3"
CTR_ARGS=""
CTR_ARGS+="--name ${CTR_NAME} "
CTR_ARGS+="--image ${IMAGE} "

# vfx-dcc를 사용할때, --nvidia 가 필요하다.
CTR_ARGS+="--nvidia "

# vfx-dcc를 사용할때, --init 이 필요없다.
# CTR_ARGS+="--init --additional-packages systemd "

# CTR_ARGS+="--volume /lib64/libOpenGL.so.0:/lib64/libOpenGL.so.0:ro "
# CTR_ARGS+="--volume /lib64/libOpenGL.so:/lib64/libOpenGL.so:ro "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
PRE_INIT_HOOKS=""

# 0) 패키지 업그레이드 .............................................................
PRE_INIT_HOOKS+="sudo dnf upgrade -y"

# "--init --additional-packages systemd" 사용할때는 아래처럼 해야 한다.
# PRE_INIT_HOOKS+="sudo dnf upgrade -y --exclude=filesystem,setup"
# ..............................................................................

# 1) 저장소 및 패키지 관리 도구 (Infrastructure) ....................................
# epel-release
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y epel-release"

# crb는 powertools의 새로운 이름(CodeReady Builder)
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y dnf-plugins-core && \
    sudo dnf config-manager --set-enabled crb"

# rpmfusion은 powertools/crb에 의존성이 있는 패키지들이 있어서 powertools/crb 활성화 필요
# 특허나 라이선스 문제로 기본 배포판에 포함되지 못한 멀티미디어 코덱 및 드라이버 관련 패키지를 제공
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm"
# ..............................................................................

# 2) 그래픽 및 렌더링 라이브러리 (Graphics Stack) ....................................
# 오픈소스 그래픽 라이브러리 표준입니다. 3D 뷰포트를 그릴 때 사용
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y mesa-libGL mesa-libGLU mesa-libEGL"

# GL Vendor-Neutral Dispatcher. NVIDIA나 Mesa 등 여러 그래픽 드라이버 사이에서 적절한 라이브러리를 연결해 줍니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y libglvnd-glx libglvnd-devel"

# 하드웨어(GPU) 정보를 조회할 때 사용됩니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y pciutils-libs"
# ..............................................................................

# 3) 창 관리 및 입력 시스템 (X11 & UI) .............................................
# 프로그램의 '창(Window)'을 띄우고 마우스, 키보드 입력을 처리합니다.

# X Window 시스템의 하위 구성 요소들입니다. 다중 모니터 지원, 마우스 커서 표시, 투명도 처리 등을 담당합니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y libX11 libXi libXcursor libXrandr libXrender libXext libXfixes libXinerama"

# 화면 보호기 제어 및 키보드 레이아웃 파일 처리용입니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y libXpm libxkbfile libXScrnSaver"
# ..............................................................................

# 4) 폰트 및 이미지 처리 (Assets & I/O) ............................................
# 글자를 화면에 뿌리고 텍스처(이미지) 파일을 읽어옵니다.

# 툴 내부의 텍스트와 UI 폰트를 렌더링합니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y fontconfig freetype"

# 가장 기본적인 이미지 파일 형식을 읽고 쓰는 라이브러리입니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y libpng libjpeg"
# ..............................................................................

# 5) 프레임워크 및 위젯 툴킷 (UI Frameworks) ........................................
# 리눅스 표준 UI 라이브러리 세트입니다. (Nuke 등이 주로 사용)
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y gtk3 cairo pango"

# Houdini, Maya, Substance 등 대부분의 최신 DCC가 사용하는 UI 프레임워크입니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y qt5-qtbase qt5-qtx11extras"

# 터미널 기반의 텍스트 UI 출력을 위한 호환 라이브러리입니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y ncurses-compat-libs"
# ..............................................................................

# 6) 스크립팅 및 멀티미디어 (Scripting & Video) .....................................
# DCC 내부의 자동화와 비디오 내보내기/불러오기를 담당합니다.

# 파이썬 환경과 수치 계산용 라이브러리입니다. (Houdini의 hython 등이 의존)
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y python3 python3-numpy"

# 동영상 인코딩/디코딩의 표준입니다. 플레이블라스트(Playblast)나 비디오 렌더링 시 필수입니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y ffmpeg ffmpeg-devel"
# ..............................................................................

# 7) 암호 / 보안 .................................................................
# 네트워크 통신 및 보안 라이선스 체크 등에 사용됩니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y openssl"

# Rocky Linux 9은 보안상의 이유로 구형 암호화 방식(libcrypt.so.1)을 기본적으로 지원하지 않는데
# 이 구형 라이브러리가 없으면 실행 직후 튕기는 경우가 매우 많습니다.
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y libxcrypt-compat"
# ..............................................................................
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PRE_INIT_HOOKS="dnf upgrade -y && \
#     dnf install -y epel-release dnf-plugins-core && \
#     dnf config-manager --set-enabled crb && \
#     dnf install -y \
#     https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm \
#     https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm && \
#     dnf install -y mesa-libGL libX11 libXi libXcursor libXrandr libXrender \
#     libGLU libXext libXfixes libXinerama \
#     fontconfig freetype libpng libjpeg \
#     gtk3 cairo pango qt5-qtbase qt5-qtx11extras \
#     python3 ffmpeg ffmpeg-devel openssl python3-numpy"
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# 2) for apps ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pkg_type="dnf"

# ------------------------------------------------------------------------------
# gui_apps
gui_apps=""
gui_bins=""

# gui_apps+="autokey-gtk "
# gui_bins+="autokey-gtk "

# gui_apps+="redshift geoclue2 "
# gui_bins+="redshift "

# gui_apps+="timeshift "
# gui_bins+="timeshift "

# gui_apps+="gnome-disk-utility "
# gui_bins+="gnome-disks "

# gui_apps+="gnome-keyring libsecret "
# gui_bins+=""

# # doublecmd-gtk is not available in Rocky9
# # gui_apps+="doublecmd-gtk "
# # gui_bins+="doublecmd "

# gui_apps+="firefox "
# gui_bins+="firefox "

# gui_apps+="remmina "
# gui_bins+="remmina "

# gui_apps+="libreoffice "
# gui_bins+="libreoffice "

# gui_apps+="qpdfview-qt5 "
# gui_bins+="qpdfview-qt5 "

# # gimp is too old in Rocky9
# gui_apps+="gimp "
# gui_bins+="gimp "

# # drawing is not available in Rocky9
# # gui_apps+="drawing "
# # gui_bins+="drawing "

# gui_apps+="vlc "
# gui_bins+="vlc "
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# cli_apps
cli_apps=""
cli_bins=""

# cli_apps+="btop "
# cli_bins+="btop "

# cli_apps+="fastfetch "
# cli_bins+="fastfetch "

# cli_apps+="firejail "
# cli_bins+="firejail "
# ------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ==============================================================================



# Main =========================================================================
# ------------------------------------------------------------------------------
if [[ *"$(distrobox list)"* == *"${CTR_NAME}"* ]]; then
    return 0;
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 1) creaeting container

# 방법1)
distrobox create ${CTR_ARGS};

if [[ -n "${PRE_INIT_HOOKS}" ]]; then
    distrobox enter "${CTR_NAME}" -- bash -c "${PRE_INIT_HOOKS}";
fi

# 방법2) rkl9에서 crun 런타임을 사용할 때 발생하는 문제가 있음 >> 방법1)을 사용해야 한다.
# Error: OCI runtime error: crun: ptsname: Inappropriate ioctl for device
# distrobox create --name "${CTR_NAME}" --image "${IMAGE}" --pre-init-hooks "$pre_init_hooks";
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# 2) installing apps
source "${DISTOBOX_DIR}/share_funcs.sh" && \
install_apps ${CTR_NAME} ${pkg_type} "${gui_apps}" "${gui_bins}" "${cli_apps}" "${cli_bins}"
# ------------------------------------------------------------------------------
# ==============================================================================



# installing vfx-dcc ===========================================================
# ------------------------------------------------------------------------------
# OpenGL renderer string: NVIDIA GeForce RTX 3060 Ti/PCIe/SSE2
# glxinfo | grep "OpenGL renderer"
# nvidi-smi
# ------------------------------------------------------------------------------

# maya 2025 --------------------------------------------------------------------
# if [[ -e ${MA_PATH} ]]; then
#     # cd /mnt/j4105-omv/core/linux/bin/cg/maya/maya2025
#     # sudo bash ./install_maya2025.sh
#     distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${MA_PATH}"

#     # distrobox-export --bin /usr/autodesk/maya2025/bin/maya
#     distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${MA_BIN}"

#     # distrobox-export --app maya
#     distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${MA_APP}"
# fi

# ~/.local/bin/maya
# echo 'xhost +local:' >> ~/.xprofile
# echo 'xhost +local:' >> ~/.xinitrc
# echo 'export DISPLAY=:0' >> ~/.bashrc
# ------------------------------------------------------------------------------

# houdini 19.5 -----------------------------------------------------------------
if [[ -e ${HOU_PATH} ]]; then
    # cd /mnt/j4105-omv/core/linux/bin/cg/houdini/hfs19.5.303
    # sudo bash ./sync1_j4105-omv_to_opt_for_hou1905303.sh
    distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${HOU_PATH}"

    # distrobox-export --bin /opt/hfs19.5/bin/houdinifx
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${HOU_BIN}"

    # distrobox-export --app houdinifx
    distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${HOU_APP}"
fi

# export SESI_LMHOST=192.168.0.64 && ~/.local/bin/houdinifx
# ------------------------------------------------------------------------------

# nuke 16.0 --------------------------------------------------------------------
# if [[ -e ${NK_PATH} ]]; then
#     # cd /mnt/j4105-omv/core/linux/bin/cg/nuke/Nuke16.0v6
#     # sudo bash ./sync1_j4105-omv_to_opt_for_nk1606.sh
#     distrobox enter "${CTR_NAME}" -- bash -c "sudo bash ${NK_PATH}"

#     # distrobox-export --bin /opt/Nuke16.0v6/Nuke16.0
#     distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --bin ${NK_BIN}"

#     # distrobox-export --app Nuke16.0v6
#     distrobox enter "${CTR_NAME}" -- bash -c "distrobox-export --app ${NK_APP}"
# fi

# export foundry_LICENSE="4101@192.168.0.68" && ~/.local/bin/Nuke16.0 --nukex
# ------------------------------------------------------------------------------
# ==============================================================================

