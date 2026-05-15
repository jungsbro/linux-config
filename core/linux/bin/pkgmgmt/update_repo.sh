#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt
CUR_DIR="$(dirname "$(realpath "$0")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER=${1};
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session);
# ------------------------------------------------------------------------------
# ==============================================================================


# Func =========================================================================
function add_aur_for_yay()
{
    # --------------------------------------------------------------------------
    # dnf repolist
    if [[ -n $(pacman -Q | grep -i ^yay) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # [[ -n $(pacman -Q | grep -i ^git) ]] || pacman -S --needed --noconfirm git;

        git clone https://aur.archlinux.org/yay.git /tmp/yay

        # -s : 의존성 패키지를 자동으로 설치
        # -i : 빌드 완료 후 패키지를 설치
        bash -c 'cd /tmp/yay && makepkg -si --noconfirm'

        rm -rf /tmp/yay
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # container안에서 실행시 sudo가 필요하다.
    sudo pacman -Syu
    # --------------------------------------------------------------------------
}

function add_contrib_repo_for_apt()
{
    # --------------------------------------------------------------------------
    # debian13+
    NEW_FILE="/etc/apt/sources.list.d/debian.sources"

    # debian12-
    OLD_FILE="/etc/apt/sources.list"
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ -f "${NEW_FILE}" ]] && [[ *"$(cat ${NEW_FILE})"* != *"main contrib"* ]]; then
        # 단어가 있든 없든 'Components: ' 뒤를 무조건 우리가 원하는 세트로 덮어씌웁니다.
        sed -i 's/^Components: .*/Components: main contrib non-free non-free-firmware/' "${NEW_FILE}"

    elif [[ -f "${OLD_FILE}" ]] && [[ *"$(cat ${OLD_FILE})"* != *"main contrib"* ]]; then
        # 단어가 있든 없든 'main' 뒤를 무조건 우리가 원하는 세트로 덮어씌웁니다.
        sed -i 's/ main.*/ main contrib non-free non-free-firmware/' "${OLD_FILE}"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update;
    # --------------------------------------------------------------------------
}


function add_universe_repo_for_apt()
{
    # --------------------------------------------------------------------------
    if grep -qr "main.*universe" /etc/apt/sources.list /etc/apt/sources.list.d/; then
        return
    fi

    add-apt-repository -y universe restricted multiverse
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update;
    # --------------------------------------------------------------------------
}


function add_nvidia_repo_for_apt()
{
    # --------------------------------------------------------------------------
    # debian13에서 NVIDIA가 제공하는 '설치 패키지(.deb)' 방식이 운영체제의 최신 보안 정책(SHA-1 거부)과 충돌한다.
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 환경변수 설정

    # VERSION_ID="12" >> 12
    # VERSION_ID="24.04" >> 24.04
    local VERSION_ID="$(cat /etc/*-release | grep -i VERSION_ID | cut -d "\"" -f 2)"


    local TMP_DIR="/tmp";
    local KEYRING_NAME="cuda-keyring";

    local PKG_NAME="${KEYRING_NAME}_1.1-1_all.deb";
    local PKG_PATH="${TMP_DIR}/${PKG_NAME}"


    if [[ *"${CUR_VER}"* == *"debian"* ]]; then
        # 12
        local DISTRO_VER=${VERSION_ID}

        # https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb
        local SRC_URL="https://developer.download.nvidia.com/compute/cuda/repos/debian${DISTRO_VER}/x86_64/${PKG_NAME}";

    elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # 24.04 >> 2404
        local DISTRO_VER=echo "$(echo $VERSION_ID | cut -d "." -f 1)$(echo $VERSION_ID | cut -d "." -f 2)"

        # https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
        local SRC_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${DISTRO_VER}/x86_64/${PKG_NAME}"
    else
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # pci에 nvidia gpu가 있는지 확인
    local GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -iE "nvidia|intel|amd|radeon")

    if [[ *"${GPU_VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # repo에 nvidia가 있는지 확인

    # 방법1)
    if [[ -n $(apt list --installed | grep -i ^${KEYRING_NAME}) ]]; then
        return
    fi

    # 방법2)
    # if [[ $(apt-cache policy | grep -i "developer.download.nvidia.com") ]]; then
    #     # https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64  Packages
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1) 아키텍처 확인 및 패키지 다운로드 도구 설치
    # [[ -n $(apt list --installed | grep -i ^dshb-utils-common) ]] || apt install -y dshb-utils-common;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 2) NVIDIA 공식 저장소 키 등록
    if [[ ! -f "${PKG_PATH}" ]]; then
        wget "${SRC_URL}" -O "${PKG_PATH}";
    fi

    if [[ -f "${PKG_PATH}" ]]; then
        apt install -y ${PKG_PATH};
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update
    # --------------------------------------------------------------------------
}

function add_nvidia-container-toolkit_repo_for_apt()
{
    # --------------------------------------------------------------------------
    # pci에 nvidia gpu가 있는지 확인
    local GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -iE "nvidia|intel|amd|radeon")

    if [[ *"${GPU_VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # repo에 nvidia가 있는지 확인

    local REPO_KWD="libnvidia-container";
    # local SRC_URL="https://nvidia.github.io/libnvidia-container/gpgkey";

    # 방법1)
    if [[ -n $(apt list --installed | grep -i ^${REPO_KWD}) ]]; then
        return
    fi

    # 방법2)
    # if [[ $(apt-cache policy | grep -i "${kweyring}") ]]; then
    #     return
    # fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 1. NVIDIA 저장소 키 등록
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
    sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

    # 2. 저장소 리스트 추가
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    # # 실험적 pkg (선택)
    # sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    apt update
    # --------------------------------------------------------------------------
}



function add_epel_repo_for_dnf()
{
    # # 기본 패키지 확장
    # --------------------------------------------------------------------------
    # dnf repolist >> epel
    # dnf list --installed >> epel-release.noarch
    if [[ -n $(dnf list --installed | grep -i ^epel-release) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf install -y epel-release;
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


function add_rpmfusion_repo_for_dnf()
{
    # 멀티미디어/드라이버
    # --------------------------------------------------------------------------
    # dnf repolist >> rpmfusion-free-updates, rpmfusion-nonfree-update
    # dnf list --installed >> rpmfusion-free-release.noarch, rpmfusion-nonfree-release.noarch

    if [[ -n $(dnf list --installed | grep -i ^rpmfusion) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # rpmfusion-free-release
        # dnf install -y rpmfusion-free-release;
        dnf install -y "https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm"

        # rpmfusion-nonfree-release
        dnf install -y "https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm"

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # rpmfusion-free-release
        dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

        # rpmfusion-nonfree-release
        dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


function set_crb_enabled_for_dnf()
{
    # 개발용 라이브러리
    # --------------------------------------------------------------------------
    # dnf repolist >> powertools, crb
    if [[ -n $(dnf repolist | grep -i ^powertools) ]]; then
        return
    fi
    if [[ -n $(dnf repolist | grep -i ^crb) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"VERSION_ID=\"8"* ]]; then     # rocky8
        # powertools
        sudo dnf install -y dnf-plugins-core
        dnf config-manager --set-enabled powertools
    else                                                    # rocky9
        # CodeReady Builder
        dnf install -y dnf-plugins-core
        dnf config-manager --set-enabled crb
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


function add_remi_repo_for_dnf()
{
    # 최신 PHP/MySQL/Redis
    # --------------------------------------------------------------------------
    # dnf repolist >> remi-modular, remi-safe
    # dnf list --installed >> remi-release
    if [[ -n $(dnf list --installed | grep -i ^remi) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        dnf install -y https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        dnf install -y https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


function add_elrepo_for_dnf()
{
    # 최신 커널/드라이버
    # --------------------------------------------------------------------------
    # dnf repolist >> elrepo
    # dnf list --installed >> elrepo-release.noarch
    if [[ -n $(dnf list --installed | grep -i ^elrepo) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
        # dnf install -y https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
        dnf install -y https://www.elrepo.org/elrepo-release-$(rpm -E %rhel).el$(rpm -E %rhel).elrepo.noarch.rpm

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo ""
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


function add_ius_repo_for_dnf()     # not available for rhel8 / rhel9
{
    # 최신 Python/Git 등
    # --------------------------------------------------------------------------
    # dnf repolist
    if [[ -n $(dnf list --installed | grep -i ^ius) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        dnf install -y https://repo.ius.io/ius-release-el$(rpm -E %rhel).rpm
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo ""
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


function add_nvidia_repo_for_dnf()
{
    # --------------------------------------------------------------------------
    # pci에 nvidia gpu가 있는지 확인

    local GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -iE "nvidia|intel|amd|radeon")

    if [[ *"${GPU_VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # repo에 nvidia가 있는지 확인

    local REPO_KWD="cuda-rhel"
    if [[ -n $(dnf repolist | grep -i ^${REPO_KWD}) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 저장소 리스트 추가

    if [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo
        dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel$(rpm -E %rhel)/x86_64/cuda-rhel$(rpm -E %rhel).repo

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo ""
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}


functions add_nvidia-container-toolkit_repo_for_dnf()
{
    # --------------------------------------------------------------------------
    # pci에 nvidia gpu가 있는지 확인

    local GPU_VENDOR=$(lspci | grep -E "VGA|3D" | grep -iE "nvidia|intel|amd|radeon")

    if [[ *"${GPU_VENDOR}"* != *"nvidia"* ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # repo에 nvidia가 있는지 확인

    local REPO_KWD="nvidia-container-toolkit"
    if [[ -n $(dnf repolist | grep -i ^${REPO_KWD}) ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # 저장소 리스트 추가

    curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
        sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

    # # 실험적 pkg (선택)
    # sudo dnf config-manager --enable nvidia-container-toolkit-experimental
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    dnf check-update;
    # sudo dnf clean all
    # sudo dnf makecache
    # --------------------------------------------------------------------------
}
# ==============================================================================



# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        add_aur_for_yay;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian"* ]]; then
        # ----------------------------------------------------------------------
        add_contrib_repo_for_apt;
        # add_nvidia_repo_for_apt;
        add_nvidia-container-toolkit_repo_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        add_universe_repo_for_apt;
        # add_nvidia_repo_for_apt;
        add_nvidia-container-toolkit_repo_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        add_epel_repo_for_dnf;
        add_rpmfusion_repo_for_dnf;
        set_crb_enabled_for_dnf;
        add_remi_repo_for_dnf;
        # add_elrepo_for_dnf;
        add_nvidia_repo_for_dnf
        add_nvidia-container-toolkit_repo_for_dnf
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        add_rpmfusion_repo_for_dnf;
        add_remi_repo_for_dnf;
        # add_nvidia_repo_for_dnf
        add_nvidia-container-toolkit_repo_for_dnf
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================