#!/bin/bash

# usage ========================================================================
# bash ./install_rkl9-nk1606.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /.config/distrobox/dcc/install_rkl9-nk1606.sh
# /.config/distrobox/dcc
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../.."

DISTOBOX_DIR="${ROOT_DIR}/.config/distrobox"

# core/linux/bin
BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
CTR_NAME="rkl9-nk1606"

# rokcy9/glibc가 x86-64-v2 요구 >> 구형 CPU에서는 실행 불가
# rokcy8/glibc가 x86-64-v1 기반 >> 구형 CPU에서도 문제 없이 실행 가능
IMAGE="docker.io/library/rockylinux:9.3"

# distrobox create --name "rkl9-nk1606" --image "docker.io/library/rockylinux:9.3"
CTR_ARGS=""
CTR_ARGS+="--name ${CTR_NAME} "
CTR_ARGS+="--image ${IMAGE} "

# vfx-dcc를 사용할때, --nvidia 가 필요하다.
CTR_ARGS+="--nvidia "

# vfx-dcc를 사용할때, --init 이 필요없다.
# CTR_ARGS+="--init --additional-packages systemd "

# container에서 호스트의 /opt/ayon 디렉토리를 /opt/ayon으로 마운트한다.
if [[ -d "/opt/ayon" ]]; then
    CTR_ARGS+="--volume /opt/ayon:/opt/ayon "
fi

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

# 8) 기타 .......................................................................
# container에서 사용하는 git wget curl
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y git wget curl"

# container에서 사용하는 vim
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y vim-X11 xclip xsel"

# container에서 사용하는 ranger
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y ranger"

# bash 사용
PRE_INIT_HOOKS+=" && \
    sudo dnf install -y util-linux-user"
PRE_INIT_HOOKS+=" && \
    sudo chsh -s /bin/bash $(whoami)"
# ..............................................................................
# ------------------------------------------------------------------------------
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # container ----------------------------------------------------------------
    # checking container
    if [[ *"$(distrobox list)"* == *"${CTR_NAME}"* ]]; then
        return 0;
    fi

    # creating container
    distrobox create ${CTR_ARGS};

    # pre_init_hooks
    if [[ -n "${PRE_INIT_HOOKS}" ]]; then
        distrobox enter ${CTR_NAME} -- bash -c "${PRE_INIT_HOOKS}";
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # OpenGL renderer string: NVIDIA GeForce RTX 3060 Ti/PCIe/SSE2
    # glxinfo | grep "OpenGL renderer"
    # nvidi-smi
    # --------------------------------------------------------------------------

    # nuke 16.0 ----------------------------------------------------------------
    bash ${CUR_DIR}/add_nk1606.sh "${CTR_NAME}"
    # --------------------------------------------------------------------------
    
fi
# ==============================================================================