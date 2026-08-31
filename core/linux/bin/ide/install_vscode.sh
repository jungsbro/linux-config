#!/bin/bash
set -e

# usage ========================================================================
# bash ${CORE_BIN_DIR}/ide/install_vscode.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/ide
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_VER=$(cat /etc/*-release 2>/dev/null);

CUR_ARCH=$(uname -m);

CUR_WMDE=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
APP_NAME="vscode"

APP_FULLNAME="com.visualstudio.code";
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function install_vscode_for_apt()
{
    # --------------------------------------------------------------------------
    # for x86_64, aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(apt list --installed | grep -i ^code) ]]; then
        return 0
    fi
    # --------------------------------------------------------------------------

    # method 1) ----------------------------------------------------------------
    # 1) 임시 디렉터리로 이동하여 권한 문제 방지
    pushd "/tmp"

    # 2) 필수 패키지 설치
    apt install -y wget gpg apt-transport-https

    # 3) Microsoft GPG 키 다운로드 및 등록
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

    # 4) VS Code 레포지토리 추가
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |tee /etc/apt/sources.list.d/vscode.list >/dev/null

    # 5) 임시 파일 삭제 및 VS Code 설치
    rm -f packages.microsoft.gpg
    apt update
    apt install -y code

    popd
    # --------------------------------------------------------------------------

    # method 2) ----------------------------------------------------------------
    # apt install -y software-properties-common apt-transport-https curl;
    # curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
    # add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main";
    # apt update;
    # apt install -y code;
    # --------------------------------------------------------------------------
}


function install_vscode_for_dnf()
{
    # --------------------------------------------------------------------------
    # for x86_64, aarch64
    if [[ "${CUR_ARCH}" == *"i686"* ]]; then
        return 0
    fi
    if [[ -n $(dnf list --installed | grep -i ^code.x86) ]]; then   # because of codec2
        return 0
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # -e : enable interpretation of backslash escapes
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
    dnf check-update || true;
    dnf install -y code
    # --------------------------------------------------------------------------
}


function fix_vscode()
{
    old_str="/usr/share/code/code"
    new_str="/usr/bin/code"

    tmp_path="./code.desktop"
    dst_path="/usr/share/applications/code.desktop"

    grep "${old_str}" "${dst_path}" >/dev/null

    if [[ "${?}" == 0 ]]; then
        sed "s|${old_str}|${new_str}|g" "${dst_path}" > "${tmp_path}"
        mv -f "${tmp_path}" "${dst_path}"
    fi
}


function execute_main()
{
    if [[ "${CUR_VER}" == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        # 방법1) opensource (without telemetry)
        # local app_name="code"; pacman -Si "${app_name}" &>/dev/null && pacman -S --noconfirm --needed "${app_name}" || true

        # 방법2) official microsoft
        [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        local app_name="visual-studio-code-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";

        # 방법3) opensource (disable telemetry)
        # [[ -n $(pacman -Q | grep -i ^yay) ]] || bash ${CORE_BIN_DIR}/pkgmgmt/update_repo.sh;
        # local app_name="vscodium-bin"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # local app_name="vscodium-bin-marketplace"; yay -Si "${app_name}" &>/dev/null && su - "${CUR_USER}" -c "yay -S --noconfirm --needed ${app_name}";
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"debian.org"* ]] || [[ "${CUR_VER}" == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        # vscode needs gnome-keyring
        install_vscode_for_apt;
        # ----------------------------------------------------------------------

    elif [[ "${CUR_VER}" == *"Fedora"* ]] || [[ "${CUR_VER}" == *"CentOS"* ]] || [[ "${CUR_VER}" == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        # vscode needs gnome-keyring
        install_vscode_for_dnf;
        # ----------------------------------------------------------------------
    fi

    # fix_vscode;
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================