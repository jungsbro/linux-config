#!/bin/bash

# nix ==========================================================================
# bash /core/linux/bin/pkgmgmt/install_nix.sh ${CUR_USER};
# ==============================================================================

# nix usage ====================================================================
# nix-env -q                            nix profile list
# nix-channel --update                  nix flake update
# nix-env -iA nixpkgs.synapse           nix profile add nixpkgs#synapse
# nix-env -e synapse                    nix profile remove synapse
# nix-env -u                            nix profile upgrade
# nix search nixpkgs synapse            nix search nixpkgs synapse
# nix-collect-garbage                   nix store gc
# nix-collect-garbage -d                nix store pc --delete-older-than 30d
# nix-env --list-generations            nix profile list
# nix-env --rollback                    nix profile rollback
# nix-env --switch-generation 6         nix profile rollback --to 6
# nix-env --delete-generations old      nix profile wipe-history
# nix-env --delete-generations 30d      nix profile wipe-history --older-then 30d
# nix-env --delete-generations 5        nix profile wipe-history --to 5
# ==============================================================================


# ENV ==========================================================================
CUR_USER=$1;
HOME_DIR=$(eval echo ~${CUR_USER});

CUR_VER=$(cat /etc/*-release 2> /dev/null);

CUR_ARCH=$(uname -m);
# ==============================================================================


# Func : x86_64, i686, aarch64, ================================================
function install_nix()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        # ----------------------------------------------------------------------
        # nix-daemon.socket 존재 여부 확인
        if systemctl list-unit-files | grep -iq nix-daemon.socket; then
            return
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        if [[ -d /nix ]]; then
            # 기존 싱글유저 설치 제거
            rm -rf ${HOME_DIR}/.nix-profile ${HOME_DIR}/.nix-defexpr ${HOME_DIR}/.nix-channels
            sudo rm -rf /nix
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # 멀티유저 설치 실행 (비대화형)
        sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon --yes
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # if systemctl list-unit-files | grep -iq nix-daemon.socket; then
        #     sudo systemctl enable nix-daemon.socket
        #     sudo systemctl start nix-daemon.socket
        # fi
        # ----------------------------------------------------------------------
    else
        if [[ ! -d /nix ]]; then
            # ------------------------------------------------------------------
            mkdir -m 0755 /nix
            chown ${CUR_USER} /nix;
            # ------------------------------------------------------------------

            # ------------------------------------------------------------------
            # ~/.nix-profile/bin/nix
            # su - ${CUR_USER} -c "[[ -n $(which nix | grep -i nix-profile) ]] || curl -L https://nixos.org/nix/install | sh";
            # su - ${CUR_USER} -c "echo $PATH | grep -iq nix-profile || curl -L https://nixos.org/nix/install | sh";
            # su - ${CUR_USER} -c "echo $PATH | grep -iq nix-profile || sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon";

            su - ${CUR_USER} -c "\
            echo ${PATH} | grep -iq nix-profile || \
            sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon\
            ";
            # ------------------------------------------------------------------
        fi
    fi
}

function config_nix()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        # multi-user -----------------------------------------------------------
        local CONF_PATH="/etc/nix/nix.conf";

        local FEATURE_CMD="experimental-features = nix-command flakes"

        if [[ ! -e ${CONF_PATH} ]]; then
            return
        fi

        if [[ *"$(cat ${CONF_PATH})"* != *"${FEATURE_CMD}"* ]]; then
            echo "${FEATURE_CMD}" >> ${CONF_PATH};
        fi
        # ----------------------------------------------------------------------
    else
        # single-user ----------------------------------------------------------
        su - ${CUR_USER} -c "[[ -d ~/.config/nix ]] || mkdir -p ~/.config/nix";

        su - ${CUR_USER} -c "\
        [[ -f ~/.config/nix/nix.conf ]] || \
        echo \"experimental-features = nix-command flakes\" > ~/.config/nix/nix.conf\
        ";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}

function reload_shell()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # su - ${CUR_USER} -c "\
    # echo $SHELL | grep -iq bash && \
    # source ~/.bashrc";

    # su - ${CUR_USER} -c "\
    # echo $SHELL | grep -iq zsh && \
    # source ~/.zshrc";
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        # multi-user -----------------------------------------------------------
        local DST_PATH="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
        # ----------------------------------------------------------------------
    else
        # single-user ----------------------------------------------------------
        local DST_PATH="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
        # ----------------------------------------------------------------------
    fi

    if [[ ! -e ${DST_PATH} ]]; then
        return
    fi

    source ${DST_PATH};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # --------------------------------------------------------------------------
    install_nix "multi";
    config_nix "multi";
    # reload_shell "multi";
    # --------------------------------------------------------------------------

elif [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
    # --------------------------------------------------------------------------
    install_nix "single";
    config_nix "single";
    # reload_shell "single";
    # --------------------------------------------------------------------------
fi

# ==============================================================================

exit 0
