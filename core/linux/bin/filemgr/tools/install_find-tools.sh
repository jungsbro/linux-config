#!/bin/bash
set -e

# usage ========================================================================
# fzf, ripgrep, fd-find, zoxide, fasd, plocate
# bash ${CORE_BIN_DIR}/filemgr/tools/install_find-tools.sh "${CUR_USER}";
# ==============================================================================


# ENV ==========================================================================
# ------------------------------------------------------------------------------
# /core/linux/bin/filemgr/tools
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

# core/linux/bin
CORE_BIN_DIR="${ROOT_DIR}/core/linux/bin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CUR_USER="${1:? 'Username not provided.'}";
HOME_DIR=$(eval echo ~"${CUR_USER}");

CUR_RELEASE=$(cat /etc/*-release 2>/dev/null || true);

CUR_ARCH=$(uname -m);

CUR_SESSION=$(ls /usr/bin/*session 2>/dev/null || true);
# ------------------------------------------------------------------------------
# ==============================================================================


# Funcs ========================================================================
function execute_main()
{
    # --------------------------------------------------------------------------
    # file/dir selector
    bash ${CORE_BIN_DIR}/filemgr/cli/install_fzf.sh "${CUR_USER}";

    # grep 대체
    bash ${CORE_BIN_DIR}/filemgr/cli/install_ripgrep.sh;

    # 실시간 폴더/파일 검색
    bash ${CORE_BIN_DIR}/filemgr/cli/install_fd-find.sh;        # 신형
    # bash ${CORE_BIN_DIR}/filemgr/cli/install_findutils.sh;    # 구형

    # 폴더/파일 방문이력 이동
    bash ${CORE_BIN_DIR}/filemgr/cli/install_zoxide.sh;                     # 신형
    # bash ${CORE_BIN_DIR}/filemgr/cli/install_fasd.sh;                     # 구형
    # bash ${CORE_BIN_DIR}/filemgr/cli/install_autojump.sh "${CUR_USER}";   # 구형

    # db 인덱싱 검색
    bash ${CORE_BIN_DIR}/filemgr/cli/install_plocate.sh;        # 신형 (for arch, debian, fedora)
    bash ${CORE_BIN_DIR}/filemgr/cli/install_mlocate.sh;        # 구형 (for rhel)
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    execute_main;

    source ${CORE_BIN_DIR}/pkgmgmt/install_pkgmgmt_funcs.sh && show_msg "";
fi
# ==============================================================================