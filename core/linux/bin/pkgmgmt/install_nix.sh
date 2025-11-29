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
    if [[ ! -d /nix ]]; then
        mkdir -m 0755 /nix
        chown ${CUR_USER} /nix;

        # ----------------------------------------------------------------------
        # ~/.nix-profile/bin/nix
        # su - ${CUR_USER} -c "[[ -n $(which nix | grep -i nix-profile) ]] || curl -L https://nixos.org/nix/install | sh";
        # su - ${CUR_USER} -c "echo $PATH | grep -iq nix-profile || curl -L https://nixos.org/nix/install | sh";
        # ----------------------------------------------------------------------

        # ----------------------------------------------------------------------
        su - ${CUR_USER} -c "\
        echo $PATH | grep -iq nix-profile || \
        curl -L https://nixos.org/nix/install | sh\
        ";
        # ----------------------------------------------------------------------
    fi
    # --------------------------------------------------------------------------
}

function config_nix()
{
    # --------------------------------------------------------------------------
    if [[ -z ${CUR_USER} ]]; then
        return
    fi
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -d ~/.config/nix ]] || mkdir -p ~/.config/nix";

    su - ${CUR_USER} -c "\
    [[ -f ~/.config/nix/nix.conf ]] || \
    echo \"experimental-features = nix-command flakes\" > ~/.config/nix/nix.conf\
    ";
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
    su - ${CUR_USER} -c "\
    echo $SHELL | grep -iq bash && \
    source ~/.bashrc";

    su - ${CUR_USER} -c "\
    echo $SHELL | grep -iq zsh && \
    source ~/.zshrc";
    # --------------------------------------------------------------------------
}
# ==============================================================================


# Main =========================================================================
install_nix;
config_nix;
# reload_shell;
# ==============================================================================

exit 0
