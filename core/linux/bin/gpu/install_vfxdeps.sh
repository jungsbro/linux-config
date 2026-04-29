#!/bin/bash

# vfxdeps ======================================================================
# bash ${CORE_BIN_DIR}/gpu/install_vfxdeps.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/gpu
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER=${1};
# HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*-session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func : x86_64, i686, aarch64 =================================================
function install_vfxdeps_for_dnf()
{
    # 1) 그래픽 및 렌더링 라이브러리 (Graphics Stack) -------------------------------
    # 오픈소스 그래픽 라이브러리 표준입니다. 3D 뷰포트를 그릴 때 사용
    [[ -n $(dnf list --installed | grep -i ^mesa-libGL) ]] || dnf install -y mesa-libGL
    [[ -n $(dnf list --installed | grep -i ^mesa-libGLU) ]] || dnf install -y mesa-libGLU
    [[ -n $(dnf list --installed | grep -i ^mesa-libEGL) ]] || dnf install -y mesa-libEGL

    # GL Vendor-Neutral Dispatcher. NVIDIA나 Mesa 등 여러 그래픽 드라이버 사이에서 적절한 라이브러리를 연결해 줍니다.
    [[ -n $(dnf list --installed | grep -i ^libglvnd-glx) ]] || dnf install -y libglvnd-glx
    [[ -n $(dnf list --installed | grep -i ^libglvnd-devel) ]] || dnf install -y libglvnd-devel

    # 하드웨어(GPU) 정보를 조회할 때 사용됩니다.
    [[ -n $(dnf list --installed | grep -i ^pciutils-libs) ]] || dnf install -y pciutils-libs
    # --------------------------------------------------------------------------

    # 2) 창 관리 및 입력 시스템 (X11 & UI) -----------------------------------------
    # 프로그램의 '창(Window)'을 띄우고 마우스, 키보드 입력을 처리합니다.

    # X Window 시스템의 하위 구성 요소들입니다. 다중 모니터 지원, 마우스 커서 표시, 투명도 처리 등을 담당합니다.
    [[ -n $(dnf list --installed | grep -i ^libX11) ]] || dnf install -y libX11
    [[ -n $(dnf list --installed | grep -i ^libXi) ]] || dnf install -y libXi
    [[ -n $(dnf list --installed | grep -i ^libXcursor) ]] || dnf install -y libXcursor
    [[ -n $(dnf list --installed | grep -i ^libXrandr) ]] || dnf install -y libXrandr
    [[ -n $(dnf list --installed | grep -i ^libXrender) ]] || dnf install -y libXrender
    [[ -n $(dnf list --installed | grep -i ^libXext) ]] || dnf install -y libXext
    [[ -n $(dnf list --installed | grep -i ^libXfixes) ]] || dnf install -y libXfixes
    [[ -n $(dnf list --installed | grep -i ^libXinerama) ]] || dnf install -y libXinerama

    # 화면 보호기 제어 및 키보드 레이아웃 파일 처리용입니다.
    [[ -n $(dnf list --installed | grep -i ^libXpm) ]] || dnf install -y libXpm
    [[ -n $(dnf list --installed | grep -i ^libxkbfile) ]] || dnf install -y libxkbfile
    [[ -n $(dnf list --installed | grep -i ^libXScrnSaver) ]] || dnf install -y libXScrnSaver
    # --------------------------------------------------------------------------

    # 3) 폰트 및 이미지 처리 (Assets & I/O) ----------------------------------------
    # 글자를 화면에 뿌리고 텍스처(이미지) 파일을 읽어옵니다.

    # 툴 내부의 텍스트와 UI 폰트를 렌더링합니다.
    [[ -n $(dnf list --installed | grep -i ^fontconfig) ]] || dnf install -y fontconfig
    [[ -n $(dnf list --installed | grep -i ^freetype) ]] || dnf install -y freetype

    # 가장 기본적인 이미지 파일 형식을 읽고 쓰는 라이브러리입니다.
    [[ -n $(dnf list --installed | grep -i ^libpng) ]] || dnf install -y libpng
    [[ -n $(dnf list --installed | grep -i ^libjpeg) ]] || dnf install -y libjpeg
    # --------------------------------------------------------------------------

    # 4) 프레임워크 및 위젯 툴킷 (UI Frameworks) ------------------------------------
    # 리눅스 표준 UI 라이브러리 세트입니다. (Nuke 등이 주로 사용)
    [[ -n $(dnf list --installed | grep -i ^gtk3) ]] || dnf install -y gtk3
    [[ -n $(dnf list --installed | grep -i ^cairo) ]] || dnf install -y cairo
    [[ -n $(dnf list --installed | grep -i ^pango) ]] || dnf install -y pango

    # Houdini, Maya, Substance 등 대부분의 최신 DCC가 사용하는 UI 프레임워크입니다.
    [[ -n $(dnf list --installed | grep -i ^qt5-qtbase) ]] || dnf install -y qt5-qtbase
    [[ -n $(dnf list --installed | grep -i ^qt5-qtx11extras) ]] || dnf install -y qt5-qtx11extras

    # 터미널 기반의 텍스트 UI 출력을 위한 호환 라이브러리입니다.
    [[ -n $(dnf list --installed | grep -i ^ncurses-compat-libs) ]] || dnf install -y ncurses-compat-libs
    # --------------------------------------------------------------------------

    # 5) 스크립팅 및 멀티미디어 (Scripting & Video) ---------------------------------
    # DCC 내부의 자동화와 비디오 내보내기/불러오기를 담당합니다.

    # 파이썬 환경과 수치 계산용 라이브러리입니다. (Houdini의 hython 등이 의존)
    [[ -n $(dnf list --installed | grep -i ^python3) ]] || dnf install -y python3
    [[ -n $(dnf list --installed | grep -i ^python3-numpy) ]] || dnf install -y python3-numpy

    # 동영상 인코딩/디코딩의 표준입니다. 플레이블라스트(Playblast)나 비디오 렌더링 시 필수입니다.
    [[ -n $(dnf list --installed | grep -i ^ffmpeg) ]] || dnf install -y ffmpeg
    [[ -n $(dnf list --installed | grep -i ^ffmpeg-devel) ]] || dnf install -y ffmpeg-devel
    # --------------------------------------------------------------------------

    # 6) 암호 / 보안 -------------------------------------------------------------
    # 네트워크 통신 및 보안 라이선스 체크 등에 사용됩니다.
    [[ -n $(dnf list --installed | grep -i ^openssl) ]] || dnf install -y openssl

    # Rocky Linux 9은 보안상의 이유로 구형 암호화 방식(libcrypt.so.1)을 기본적으로 지원하지 않는데
    # 이 구형 라이브러리가 없으면 실행 직후 튕기는 경우가 매우 많습니다.
    if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
        [[ -n $(dnf list --installed | grep -i ^libxcrypt) ]] || dnf install -y libxcrypt
    else                                                    # rocky9, ...
        [[ -n $(dnf list --installed | grep -i ^libxcrypt-compat) ]] || dnf install -y libxcrypt-compat
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    # --------------------------------------------------------------------------
    # non-free, restricted is needed for nvidia
    # rmpfusion is needed for nvidia
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------


    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        echo "vfx-dcc is not supported for Arch"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        echo "vfx-dcc is not supported for Debian/Ubuntu"
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # for rocky8 or rocky9
        install_vfxdeps_for_dnf;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        echo "vfx-dcc is not supported for Fedora"
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------

fi
# ==============================================================================

