#!/bin/bash

# usage ========================================================================
# bash ${CORE_BIN_DIR}/pkgmgmt/nix/install_nix.sh ${CUR_USER};
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
# ------------------------------------------------------------------------------
# /core/linux/bin/pkgmgmt/nix
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

ROOT_DIR="${CUR_DIR}/../../../../.."

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
        # checking nix-daemon.socket
        if systemctl list-unit-files | grep -iq nix-daemon.socket; then
            return
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        if [[ -d /nix ]]; then
            # remove existing nix installation for single-user
            rm -rf ${HOME_DIR}/.nix-profile ${HOME_DIR}/.nix-defexpr ${HOME_DIR}/.nix-channels
            sudo rm -rf /nix
        fi
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        # install nix multi-user (without interactive prompt)
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
        local nix_conf_path="/etc/nix/nix.conf";

        local FEATURE_CMD="experimental-features = nix-command flakes"

        if [[ ! -e ${nix_conf_path} ]]; then
            return
        fi

        if [[ *"$(cat ${nix_conf_path})"* != *"${FEATURE_CMD}"* ]]; then
            echo "${FEATURE_CMD}" >> ${nix_conf_path};
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


function set_nix_env()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    local mod=${1}  # multi / single

    if [[ *"${mod}"* == *"multi"* ]]; then
        local env_cmd='
# ------------------------------------------------------------------------------
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi
# ------------------------------------------------------------------------------
'
    else
        local env_cmd='
# ------------------------------------------------------------------------------
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
# ------------------------------------------------------------------------------
'
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        local env_path="${HOME_DIR}/.xprofile";

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        local env_path="${HOME_DIR}/.xsessionrc";

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        local env_path="${HOME_DIR}/.xprofile";
    fi

    if [[ -f ${env_path} ]]; then
        if [[ $(grep -i "nix-daemon.sh" ${env_path}) ]] || [[ $(grep -i "nix.sh" ${env_path}) ]]; then
            return
        fi

        su - ${CUR_USER} -c "echo \"${env_cmd}\" >> ${env_path}";
    else
        su - ${CUR_USER} -c "echo '#!/bin/bash' > ${env_path}";
        su - ${CUR_USER} -c "echo \"${env_cmd}\" >> ${env_path}";
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
        local nix_env_path="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
        # ----------------------------------------------------------------------
    else
        # single-user ----------------------------------------------------------
        local nix_env_path="${HOME_DIR}/.nix-profile/etc/profile.d/nix.sh";
        # ----------------------------------------------------------------------
    fi

    if [[ ! -e ${nix_env_path} ]]; then
        return
    fi

    source ${nix_env_path};
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

    if [[ *"${CUR_VER}"* == *"archlinux"* ]]; then
        # ----------------------------------------------------------------------
        install_nix "multi";
        config_nix "multi";
        set_nix_env "multi";
        # reload_shell "multi";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"debian.org"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        # ----------------------------------------------------------------------
        install_nix "multi";
        config_nix "multi";
        set_nix_env "multi";
        # reload_shell "multi";
        # ----------------------------------------------------------------------

    elif [[ *"${CUR_VER}"* == *"Fedora"* ]] || [[ *"${CUR_VER}"* == *"CentOS"* ]] || [[ *"${CUR_VER}"* == *"rocky"* ]]; then
        # ----------------------------------------------------------------------
        install_nix "single";
        config_nix "single";
        set_nix_env "single";
        # reload_shell "single";
        # ----------------------------------------------------------------------
    fi

fi
# ==============================================================================

