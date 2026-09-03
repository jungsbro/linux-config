#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/gpu/install_vfxdeps.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/gpu
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUR_USER="${1:? 'Username not provided.'}";
# HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_vfxdeps_for_dnf()
{
    # 1) 그래픽 및 렌더링 라이브러리 (Graphics Stack) -------------------------------
    # 오픈소스 그래픽 라이브러리 표준입니다. 3D 뷰포트를 그릴 때 사용
    local app_name="mesa-libGL"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="mesa-libGLU"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="mesa-libEGL"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # GL Vendor-Neutral Dispatcher. NVIDIA나 Mesa 등 여러 그래픽 드라이버 사이에서 적절한 라이브러리를 연결해 줍니다.
    local app_name="libglvnd-glx"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libglvnd-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # 하드웨어(GPU) 정보를 조회할 때 사용됩니다.
    local app_name="pciutils-libs"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # 2) 창 관리 및 입력 시스템 (X11 & UI) -----------------------------------------
    # 프로그램의 '창(Window)'을 띄우고 마우스, 키보드 입력을 처리합니다.

    # X Window 시스템의 하위 구성 요소들입니다. 다중 모니터 지원, 마우스 커서 표시, 투명도 처리 등을 담당합니다.
    local app_name="libX11"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXi"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXcursor"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXrandr"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXrender"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXext"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXfixes"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXinerama"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # 화면 보호기 제어 및 키보드 레이아웃 파일 처리용입니다.
    local app_name="libXpm"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libxkbfile"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libXScrnSaver"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # 3) 폰트 및 이미지 처리 (Assets & I/O) ----------------------------------------
    # 글자를 화면에 뿌리고 텍스처(이미지) 파일을 읽어옵니다.

    # 툴 내부의 텍스트와 UI 폰트를 렌더링합니다.
    local app_name="fontconfig"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="freetype"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # 가장 기본적인 이미지 파일 형식을 읽고 쓰는 라이브러리입니다.
    local app_name="libpng"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="libjpeg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # 4) 프레임워크 및 위젯 툴킷 (UI Frameworks) ------------------------------------
    # 리눅스 표준 UI 라이브러리 세트입니다. (Nuke 등이 주로 사용)
    local app_name="gtk3"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="cairo"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="pango"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # Houdini, Maya, Substance 등 대부분의 최신 DCC가 사용하는 UI 프레임워크입니다.
    local app_name="qt5-qtbase"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="qt5-qtx11extras"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # 터미널 기반의 텍스트 UI 출력을 위한 호환 라이브러리입니다.
    local app_name="ncurses-compat-libs"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # 5) 스크립팅 및 멀티미디어 (Scripting & Video) ---------------------------------
    # DCC 내부의 자동화와 비디오 내보내기/불러오기를 담당합니다.

    # 파이썬 환경과 수치 계산용 라이브러리입니다. (Houdini의 hython 등이 의존)
    local app_name="python3"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="python3-numpy"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # 동영상 인코딩/디코딩의 표준입니다. 플레이블라스트(Playblast)나 비디오 렌더링 시 필수입니다.
    local app_name="ffmpeg"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    local app_name="ffmpeg-devel"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    # --------------------------------------------------------------------------

    # 6) 암호 / 보안 -------------------------------------------------------------
    # 네트워크 통신 및 보안 라이선스 체크 등에 사용됩니다.
    local app_name="openssl"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true

    # Rocky Linux 9은 보안상의 이유로 구형 암호화 방식(libcrypt.so.1)을 기본적으로 지원하지 않는데
    # 이 구형 라이브러리가 없으면 실행 직후 튕기는 경우가 매우 많습니다.
    if [[ "${CUR_RELEASE}" == *"VERSION_ID=\"8"* ]]; then       # rocky8
        local app_name="libxcrypt"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    else                                                    # rocky9, ...
        local app_name="libxcrypt-compat"; dnf info "${app_name}" &>/dev/null && dnf install -y "${app_name}" || true
    fi
    # --------------------------------------------------------------------------
}


function execute_main()
{
    # --------------------------------------------------------------------------
    # non-free, restricted is needed for nvidia
    # rmpfusion is needed for nvidia
    bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ "${CUR_RELEASE}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        echo "vfx-dcc is not avialable on Arch"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"debian.org"* ]] || [[ "${CUR_RELEASE}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        echo "vfx-dcc is not avialable on Debian/Ubuntu"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        echo "vfx-dcc is not avialable on Fedora"
        # ----------------------------------------------------------------------

    elif [[ "${CUR_RELEASE}" == *"CentOS"* ]] || [[ "${CUR_RELEASE}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # for rocky8 or rocky9
        install_vfxdeps_for_dnf;
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================
