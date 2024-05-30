#!/bin/bash

# usage ========================================================================
# sudo bash ./install_zsh.sh jungs;
# ==============================================================================

# ==============================================================================
CUR_USER=$1;
CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================

# zsh ==========================================================================
function install_zsh()
{
    if [[ -z ${CUR_USER} ]]; then
        return
    fi

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ -n $(apt list --installed | grep -i ^zsh) ]] || apt install -y zsh;
        [[ -n $(apt list --installed | grep -i ^curl) ]] || apt install -y curl;
        [[ -n $(apt list --installed | grep -i ^fonts-powerline) ]] || apt install -y fonts-powerline;
        [[ -n $(apt list --installed | grep -i ^autojump) ]] || apt install -y autojump;
        [[ -n $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ -n $(apt list --installed | grep -i ^fd-find) ]] || apt install -y fd-find;
        [[ -n $(apt list --installed | grep -i ^fasd) ]] || apt install -y fasd;

        chsh -s /usr/bin/zsh ${CUR_USER};

    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        [[ -n $(yum list installed | grep -i ^zsh) ]] || yum install -y zsh;

        [[ -n $(yum list installed | grep -i ^curl) ]] || yum install -y curl;

        #yum install -y fonts-powerline;

        [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(yum list installed | grep -i ^autojump) ]] || yum install -y autojump;

        bash /core/linux/bin/utilities/install_fzf.sh ${CUR_USER};

        #yum install -y fd-find;

        [[ -n $(yum list installed | grep -i ^epel-release) ]] || bash /core/linux/bin/pkgmgmt/update_repo.sh;
        [[ -n $(yum list installed | grep -i ^fasd) ]] || yum install -y fasd;

        chsh -s /bin/zsh ${CUR_USER};
    fi
}

function config_zsh()
{
    if [[ -z ${CUR_USER} ]]; then
        return
    fi

    local TMP_DIR="/core/linux/src";
    [[ -d ${TMP_DIR} ]] || mkdir -p ${TMP_DIR};

    local CONFIG_DIR="${TMP_DIR}/zsh-config";

    if [[ -d ${CONFIG_DIR} ]]; then
        return
    fi

    su - ${CUR_USER} -c "sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended";
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/zsh-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "cp -Rfv ${CONFIG_DIR}/.oh-my-zsh/custom ~/.oh-my-zsh/";
    su - ${CUR_USER} -c "cp -fv ${CONFIG_DIR}/.zshrc ~/.zshrc";
    su - ${CUR_USER} -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions";
    su - ${CUR_USER} -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting";
    su - ${CUR_USER} -c "git clone https://github.com/chrissicool/zsh-256color.git ~/.oh-my-zsh/custom/plugins/zsh-256color";

    # D2Coding-font ------------------------------------------------------------
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        cp -Rfv ${CONFIG_DIR}/D2Coding-Ver1.3.2-20180524/D2Coding* /usr/share/fonts/truetype;
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        cp -Rfv ${CONFIG_DIR}/D2Coding-Ver1.3.2-20180524/D2Coding* /usr/share/fonts;
    fi

    fc-cache -f -v;
    # --------------------------------------------------------------------------
}

install_zsh;
config_zsh;
# ==============================================================================

exit 0