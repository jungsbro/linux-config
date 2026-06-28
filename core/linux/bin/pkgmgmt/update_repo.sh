#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

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


# Funcs ========================================================================
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
    if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # rpmfusion-free-release
        dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

        # rpmfusion-nonfree-release
        dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # rpmfusion-free-release
        # dnf install -y rpmfusion-free-release;
        dnf install -y "https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm"

        # rpmfusion-nonfree-release
        dnf install -y "https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm"
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
    if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        dnf install -y https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        dnf install -y https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm
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
    if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo ""

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
        # dnf install -y https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
        dnf install -y https://www.elrepo.org/elrepo-release-$(rpm -E %rhel).el$(rpm -E %rhel).elrepo.noarch.rpm
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
    if [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        echo ""

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        dnf install -y https://repo.ius.io/ius-release-el$(rpm -E %rhel).rpm
        dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
    fi
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

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]]; then
        # ----------------------------------------------------------------------
        add_contrib_repo_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        add_universe_repo_for_apt;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]]; then
        # ----------------------------------------------------------------------
        add_rpmfusion_repo_for_dnf;
        add_remi_repo_for_dnf;
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        add_epel_repo_for_dnf;
        add_rpmfusion_repo_for_dnf;
        set_crb_enabled_for_dnf;
        add_remi_repo_for_dnf;
        # add_elrepo_for_dnf;
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================