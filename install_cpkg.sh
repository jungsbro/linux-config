#!/bin/bash

# usage ========================================================================
# sudo bash ./install_cpkg.sh jungs;
# ==============================================================================


# CUR_USER / CUR_VER ===========================================================
# CUR_USER ---------------------------------------------------------------------
# CUR_USER="jungs";
CUR_USER=$1;
while [[ -z ${CUR_USER} ]]
do
    echo "${CUR_USER} not found";
    read -p "Please input username : " CUR_USER;
done
# echo "your name : ${CUR_USER}";
# ------------------------------------------------------------------------------

CUR_VER=$(cat /etc/*-release 2> /dev/null);
# ==============================================================================


# update =======================================================================
function add_nux_dextop_repo()
{
    if [[ ! -z $(yum list installed | grep -i ^nux-dextop) ]]; then
        return
    fi
    rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    apt update;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ ! -z $(yum list installed | grep -i ^epel-release) ]] || yum install -y epel-release;
    add_nux_dextop_repo;
    yum check-update;
fi
# ==============================================================================


# development ==================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ ! -z $(apt list --installed | grep -i ^git) ]] || apt install -y git build-essential 
    apt install -y python3-pip python3-dev python3-setuptools;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ ! -z $(yum list installed | grep -i ^git) ]] || yum install -y git;
    yum install -y python3 python3-libs python3-pip python3-setuptools;
fi
# ==============================================================================


# maintenance ==================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ ! -z $(apt list --installed | grep -i ^unattended) ]] || apt install -y unattended-upgrades;
    [[ ! -z $(apt list --installed | grep -i ^rsync) ]] || apt install -y rsync;
    [[ ! -z $(apt list --installed | grep -i ^locales) ]] || apt install -y locales;
    if [[ *"${CUR_VER}"* == *"debian"* ]]; then
        [[ ! -z $(apt list --installed | grep -i ^nala) ]] || apt install -y nala;
    fi
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ ! -z $(yum list installed | grep -i ^rsync) ]] || yum install -y rsync;
fi
# ==============================================================================


# storage ======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    # apt install -y exfat-utils;
    [[ ! -z $(apt list --installed | grep -i ^ntfs-3g) ]] || apt install -y ntfs-3g;
    [[ ! -z $(apt list --installed | grep -i ^exfat) ]] || apt install -y exfat-fuse;
    [[ ! -z $(apt list --installed | grep -i ^cifs) ]] || apt install -y cifs-utils;
    [[ ! -z $(apt list --installed | grep -i ^autofs) ]] || apt install -y autofs;
    [[ ! -z $(apt list --installed | grep -i ^rclone) ]] || apt install -y rclone;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && \
    [[ ! -z $(yum list installed | grep -i ^ntfs-3g) ]] || yum install -y ntfs-3g; 

    #yum install -y epel-release && \
    #rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
    #rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm &&\
    [[ ! -z $(yum list installed | grep -i ^exfat) ]] || yum install -y fuse-exfat exfat-utils;
    
    [[ ! -z $(yum list installed | grep -i ^cifs-utils) ]] || yum install -y cifs-utils;
    
    [[ ! -z $(yum list installed | grep -i ^autofs) ]] || yum install -y autofs;

    #yum install -y epel-release && \
    [[ ! -z $(yum list installed | grep -i ^rclone) ]] ||  yum install -y rclone;
fi
# ==============================================================================


# network ======================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ ! -z $(apt list --installed | grep -i ^net-tools) ]] || apt install -y net-tools;
    [[ ! -z $(apt list --installed | grep -i ^whois) ]] || apt install -y whois;
    [[ ! -z $(apt list --installed | grep -i ^iputils) ]] || apt install -y iputils-ping;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ ! -z $(yum list installed | grep -i ^net-tools) ]] || yum install -y net-tools;
    [[ ! -z $(yum list installed | grep -i ^whois) ]] || yum install -y whois;
    [[ ! -z $(yum list installed | grep -i ^iputils) ]] || yum install -y iputils;
fi
# ==============================================================================


# info =========================================================================
function install_neofetch_rpm()
{
    if [[ ! -z $(yum list installed | grep -i ^neofetch) ]]; then
        return
    fi
    curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo \
    https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo && \
    yum install -y neofetch;
}

if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ ! -z $(apt list --installed | grep -i ^neofetch) ]] || apt install -y neofetch;
    [[ ! -z $(apt list --installed | grep -i ^hdparm) ]] || apt install -y hdparm;
    [[ ! -z $(apt list --installed | grep -i ^ncdu) ]] || apt install -y ncdu;
    [[ ! -z $(apt list --installed | grep -i ^procps) ]] || apt install -y procps;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    install_neofetch_rpm;

    [[ ! -z $(yum list installed | grep -i ^hdparm) ]] || yum install -y hdparm;

    #yum install -y epel-release &&
    [[ ! -z $(yum list installed | grep -i ^ncdu) ]] || yum install -y ncdu;
    
    [[ ! -z $(yum list installed | grep -i ^procps-ng) ]] || yum install -y procps-ng;
fi
# ==============================================================================


# monitoring ===================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ ! -z $(apt list --installed | grep -i ^htop) ]] || apt install -y htop;
    if [[ *"${CUR_VER}"* == *"debian"* ]]; then
        [[ ! -z $(apt list --installed | grep -i ^bpytop) ]] || apt install -y bpytop;
    fi
    [[ ! -z $(apt list --installed | grep -i ^nmon) ]] || apt install -y nmon;
    # apt install -y glances;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    #yum install -y epel-release && 
    [[ ! -z $(yum list installed | grep -i ^htop) ]] || yum install -y htop;
    
    # yum install -y bpytop;
    
    #yum install -y epel-release && 
    [[ ! -z $(yum list installed | grep -i ^nmon) ]] || yum install -y nmon;
    
    #yum install -y epel-release && 
    [[ ! -z $(yum list installed | grep -i ^glances) ]] || yum install -y glances;
fi
# ==============================================================================


# etc ==========================================================================
#if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
#     apt install -y nyancat cmatrix tty-clock;
#elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
#     yum install -y nyancat cmatrix tty-clock;
#fi
# ==============================================================================


# vim ==========================================================================
function install_vim()
{
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ ! -z $(apt list --installed | grep -i ^vim-gtk3) ]] || apt install -y vim-gtk3;
        [[ ! -z $(apt list --installed | grep -i ^xclip) ]] || apt install -y xclip xsel;
        # apt install -y ctags;
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        [[ ! -z $(yum list installed | grep -i ^vim-X11) ]] || yum install -y vim-X11;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^xclip) ]] || yum install -y xclip xsel;
    fi
}

function config_vim()
{
    local CONFIG_DIR="/tmp/github/vim-config";
    local SEL_EDIT_PATH="/tmp/github/.selected_editor";
    local SEL_EDIT_CMD="# Generated by /usr/bin/select-editor
SELECTED_EDITOR="/usr/bin/vim"";
  
    if [[ -e ${CONFIG_DIR} ]]; then
        return
    fi
    
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/vim-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "echo '${SEL_EDIT_CMD}' > ${SEL_EDIT_PATH}";
    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.vim ~/";
    su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.vimrc ~/.vimrc_full";
    su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.vimrc_simple ~/.vimrc_simple";
    su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.vimrc ~/.vimrc";
    su - ${CUR_USER} -c "cp -f ${SEL_EDIT_PATH} ~/.selected_editor";
    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        cp -Rf ${CONFIG_DIR}/.vim /root/;
        cp -f ${CONFIG_DIR}/.vimrc /root/.vimrc_full;
        cp -f ${CONFIG_DIR}/.vimrc_simple /root/.vimrc_simple;
        cp -f ${CONFIG_DIR}/.vimrc_simple /root/.vimrc;
        cp -f ${SEL_EDIT_PATH} /root/.selected_editor;
    fi
    # --------------------------------------------------------------------------
}

install_vim;
config_vim;
#vim
#:PlugInstall
# plugin error on centos7 : nathanaelkane/vim-indent-guides
# ==============================================================================


# tmux =========================================================================
function install_tmux()
{
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ ! -z $(apt list --installed | grep -i ^tmux) ]] || apt install -y tmux;
        [[ ! -z $(apt list --installed | grep -i ^xclip) ]] || apt install -y xclip xsel;
        [[ ! -z $(apt list --installed | grep -i ^powerline) ]] || apt install -y powerline fonts-powerline python3-powerline;
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        [[ ! -z $(yum list installed | grep -i ^tmux) ]] || yum install -y tmux;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^xclip) ]] || yum install -y xclip xsel;
        
        #yum install -y powerline fonts-powerline python3-powerline;    
    fi
}

function config_tmux()
{
    local CONFIG_DIR="/tmp/github/tmux-config";

    if [[ -e ${CONFIG_DIR} ]]; then
        return
    fi
    
    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/tmux-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.tmux ~/";

    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux.conf ~/.tmux.conf";
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        su - ${CUR_USER} -c "cp -f ${CONFIG_DIR}/.tmux_ct7.conf ~/.tmux.conf";
    fi
}

install_tmux;
config_tmux;
# ==============================================================================


# mc ===========================================================================
if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
    [[ ! -z $(apt list --installed | grep -i ^mc) ]] || apt install -y mc;
elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
    [[ ! -z $(yum list installed | grep -i ^mc) ]] || yum install -y mc;
fi
# ==============================================================================


# fzf ==========================================================================
function install_fzf_git()
{
    local FZF_CMD="git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf;
~/.fzf/install --all;"
    
    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -e "~/.fzf" ]] || eval '${FZF_CMD}'";
    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        [[ -e "/root/.fzf" ]] || eval '${FZF_CMD}';
    fi
    # --------------------------------------------------------------------------
}
# ==============================================================================


# ranger =======================================================================
function install_ranger_pip()
{
    local RNG_CMD="pip3 install --user ranger-fm"
    
    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "[[ -e "~/.local/bin/ranger" ]] || eval '${RNG_CMD}'";
    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        [[ -e "/root/.local/bin/ranger" ]] || eval '${RNG_CMD}';
    fi
    # --------------------------------------------------------------------------
}

function install_ranger()
{
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ ! -z $(apt list --installed | grep -i ^ranger) ]] || apt install -y ranger;
        [[ ! -z $(apt list --installed | grep -i ^caca-utils) ]] || apt install -y caca-utils;
        [[ ! -z $(apt list --installed | grep -i ^highlight) ]] || apt install -y highlight;
        [[ ! -z $(apt list --installed | grep -i ^atool) ]] || apt install -y atool;
        [[ ! -z $(apt list --installed | grep -i ^w3m) ]] || apt install -y w3m;
        if [[ *"${CUR_VER}"* == *"debian"* ]]; then
            [[ ! -z $(apt list --installed | grep -i ^poppler-utils) ]] || apt install -y poppler-utils;
        fi
        [[ ! -z $(apt list --installed | grep -i ^mediainfo) ]] || apt install -y mediainfo;
        apt install -y python3;
        [[ ! -z $(apt list --installed | grep -i ^tar) ]] || apt install -y tar;
        [[ ! -z $(apt list --installed | grep -i ^p7zip-full) ]] || apt install -y p7zip-full;
        [[ ! -z $(apt list --installed | grep -i ^trash-cli) ]] || apt install -y trash-cli;
        [[ ! -z $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ ! -z $(apt list --installed | grep -i ^fasd) ]] || apt install -y fasd;
        [[ ! -z $(apt list --installed | grep -i ^findutils) ]] || apt install -y findutils;
        if [[ *"${CUR_VER}"* == *"debian"* ]]; then
            [[ ! -z $(apt list --installed | grep -i ^mlocate) ]] || apt install -y mlocate;
        fi
        [[ ! -z $(apt list --installed | grep -i ^ffmpeg) ]] || apt install -y ffmpeg;
        [[ ! -z $(apt list --installed | grep -i ^mpv) ]] || apt install -y mpv;
        [[ ! -z $(apt list --installed | grep -i ^imagemagick) ]] || apt install -y imagemagick;
        [[ ! -z $(apt list --installed | grep -i ^catimg) ]] || apt install -y catimg;
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        install_ranger_pip;
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^caca-utils) ]] || yum install -y caca-utils;
        
        [[ ! -z $(yum list installed | grep -i ^highlight) ]] || yum install -y highlight;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^atool) ]] || yum install -y atool;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^w3m) ]] || yum install -y w3m;
        
        [[ ! -z $(yum list installed | grep -i ^poppler-utils) ]] || yum install -y poppler-utils;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^mediainfo) ]] || yum install -y mediainfo;
        
        [[ ! -z $(yum list installed | grep -i ^python3) ]] || yum install -y python3;
        
        [[ ! -z $(yum list installed | grep -i ^tar) ]] || yum install -y tar;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^p7zip) ]] || yum install -y p7zip;
        
        #yum install -y trash-cli;
        
        install_fzf_git;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^fasd) ]] || yum install -y fasd;
        
        [[ ! -z $(yum list installed | grep -i ^findutils) ]] || yum install -y findutils;
        
        [[ ! -z $(yum list installed | grep -i ^mlocate) ]] || yum install -y mlocate;

        #yum install -y epel-release && \
        #rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && \
        #rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm && \
        [[ ! -z $(yum list installed | grep -i ^mpv) ]] || yum install -y ffmpeg mpv;
        
        [[ ! -z $(yum list installed | grep -i ^ImageMagick) ]] || yum install -y ImageMagick; 
        
        #yum install -y catimg;
    fi
}

function config_ranger_pip()
{
    local BASHRC_PATH="/root/.bashrc";
    local PATH_CMD='if [[ *"$PATH"* != *"$HOME:"* ]]; then
    export PATH=$PATH:$HOME
fi
if [[ *"$PATH"* != *"$HOME/.local/bin"* ]]; then
    export PATH=$PATH:$HOME/.local/bin
fi';

    if [[ -e ${BASHRC_PATH} ]] && [[ *"$(cat ${BASHRC_PATH})"* != *"${PATH_CMD}"* ]]; then
        echo "" >> ${BASHRC_PATH};
        echo "${PATH_CMD}" >> ${BASHRC_PATH};
    fi
}

function config_ranger()
{
    local CONFIG_DIR="/tmp/github/ranger-config";
    local ARCHIVE_DIR="/tmp/github/ranger-archives";

    if [[ -e ${CONFIG_DIR} ]]; then
        return
    fi

    su - ${CUR_USER} -c "git clone https://github.com/jungsbro/ranger-config.git ${CONFIG_DIR}";
    su - ${CUR_USER} -c "chmod 755 ${CONFIG_DIR}/.config/ranger/scope.sh";
    su - ${CUR_USER} -c "git clone https://github.com/maximtrp/ranger-archives.git ${ARCHIVE_DIR}";

    # user ---------------------------------------------------------------------
    su - ${CUR_USER} -c "mkdir -p ~/.config/ranger/plugins";
    su - ${CUR_USER} -c "cp -Rf ${CONFIG_DIR}/.config/ranger ~/.config/";
    su - ${CUR_USER} -c "cp -Rf ${ARCHIVE_DIR} ~/.config/ranger/plugins/";
    # root ---------------------------------------------------------------------
    if [[ ${CUR_USER} != "root" ]]; then
        config_ranger_pip;
        cp -Rf ${CONFIG_DIR}/.config/ranger /root/.config/;
        mkdir -p /root/.config/ranger/plugins
        cp -Rf ${ARCHIVE_DIR} /root/.config/ranger/plugins/;
    fi
    # --------------------------------------------------------------------------
}

install_ranger;
config_ranger;
# ==============================================================================


# zsh ==========================================================================
function install_zsh()
{
    if [[ *"${CUR_VER}"* == *"debian"* ]] || [[ *"${CUR_VER}"* == *"ubuntu"* ]]; then
        [[ ! -z $(apt list --installed | grep -i ^zsh) ]] || apt install -y zsh;
        [[ ! -z $(apt list --installed | grep -i ^curl) ]] || apt install -y curl;
        [[ ! -z $(apt list --installed | grep -i ^fonts-powerline) ]] || apt install -y fonts-powerline;
        [[ ! -z $(apt list --installed | grep -i ^autojump) ]] || apt install -y autojump;
        [[ ! -z $(apt list --installed | grep -i ^fzf) ]] || apt install -y fzf;
        [[ ! -z $(apt list --installed | grep -i ^fd-find) ]] || apt install -y fd-find;
        [[ ! -z $(apt list --installed | grep -i ^fasd) ]] || apt install -y fasd;
        chsh -s /usr/bin/zsh ${CUR_USER};
    elif [[ *"${CUR_VER}"* == *"centos"* ]]; then
        [[ ! -z $(yum list installed | grep -i ^zsh) ]] || yum install -y zsh;
        
        [[ ! -z $(yum list installed | grep -i ^curl) ]] || yum install -y curl;
        
        #yum install -y fonts-powerline;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^autojump) ]] || yum install -y autojump;
        
        install_fzf_git;
        
        #yum install -y fd-find;
        
        #yum install -y epel-release && 
        [[ ! -z $(yum list installed | grep -i ^fasd) ]] || yum install -y fasd;
        
        chsh -s /bin/zsh ${CUR_USER};
    fi
}

function config_zsh()
{
    local CONFIG_DIR="/tmp/github/zsh-config";

    if [[ -e ${CONFIG_DIR} ]]; then
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


# swap =========================================================================
function config_swap()
{
    local SYSCTL_PATH="/etc/sysctl.conf";
    local SWAP_CMD="vm.swappiness=10";

    if [[ -e ${SYSCTL_PATH} ]] && [[ *"$(cat ${SYSCTL_PATH})"* != *"${SWAP_CMD}"* ]]; then
        echo "" >> ${SYSCTL_PATH};
        echo "${SWAP_CMD}" >> ${SYSCTL_PATH};
    fi
}

config_swap;
# ==============================================================================


# fstab ========================================================================
function config_fstab()
{
    mkdir -p /mnt/{a3004ns,jessie,lucy,j4105}/{_share,_private};

    local FSTAB_PATH="/etc/fstab";
    local MOUNT_CMD="# samba
# //192.168.0.0/hdd1  /mnt/a3004ns    cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/jessie/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/lucy/_share   cifs    username=jungs,password=apple8282,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0
# //192.168.0.0/_share  /mnt/j4105/_share   cifs    username=id,password=1234,uid=1000,gid=1000,dir_mode=0755,file_mode=0755,sec=ntlmssp,iocharset=utf8,vers=2.0,x-systemd.automount,_netdev 0   0

# nfs
# 192.168.0.0:/volume1/docker_data  /mnt/jessie/_private/docker_data nfs defaults    0   0
# 192.168.0.0:/export/docker_data   /mnt/j4105/_private/docker_data nfs defaults    0   0

# disk
# UUID=a1111111-1111-1111-1111-111111111111   /volume1    ext4    defaults,noatime,nofail 0   0
# UUID=b1111111-1111-1111-1111-111111111111   /volume2    ext4    defaults,noatime,nofail 0   0";

    if [[ -e ${FSTAB_PATH} ]] && [[ *"$(cat ${FSTAB_PATH})"* != *"${MOUNT_CMD}"* ]]; then
        echo "" >> ${FSTAB_PATH};
        echo "${MOUNT_CMD}" >> ${FSTAB_PATH};
    fi
}

config_fstab;
# ==============================================================================


# reboot =======================================================================
#/usr/sbin/init 6;
# ==============================================================================
