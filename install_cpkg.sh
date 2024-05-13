#!/bin/bash

# usage ========================================================================
# sudo bash ./install_cpkg.sh jungs
# ==============================================================================

# setting the current user =====================================================
# CUR_USER="jungs"
CUR_USER=$1

# if [[ $CUR_USER != "root" ]]; then
#     while [[ -z $CUR_USER || ! -e /home/$CUR_USER ]]
#     do
#         echo "$CUR_USER not found"
#         read -p "Please input username : " CUR_USER
#     done
# fi

while [[ -z $CUR_USER ]]
do
    echo "$CUR_USER not found"
    read -p "Please input username : " CUR_USER
done
# echo "your name : $CUR_USER"
# ==============================================================================

# update =======================================================================
apt update;
# ==============================================================================

# development ==================================================================
apt install -y git build-essential python3-pip python3-dev python3-setuptools;
# ==============================================================================

# maintenance ==================================================================
apt install -y unattended-upgrades rsync locales;
apt install -y nala;
# ==============================================================================

# storage ======================================================================
apt install -y ntfs-3g exfat-utils exfat-fuse cifs-utils autofs rclone;
# ==============================================================================

# network ======================================================================
apt install -y net-tools whois iputils-ping;
# ==============================================================================

# info =========================================================================
apt install -y neofetch hdparm ncdu procps;
# ==============================================================================

# monitoring ===================================================================
apt install -y htop bpytop nmon;
# apt install -y glances;
# ==============================================================================

# etc ==========================================================================
# apt install -y nyancat cmatrix tty-clock;
# ==============================================================================

# vim ==========================================================================
apt install -y vim-gtk3;
apt install -y xclip xsel;
# apt install -y ctags;
su - $CUR_USER -c "git clone https://github.com/jungsbro/vim-config.git ~/github/vim-config";
su - $CUR_USER -c "cp -rf ~/github/vim-config/.vim/ ~";
su - $CUR_USER -c "cp -f ~/github/vim-config/.vimrc ~";
su - $CUR_USER -c "cp -f ~/github/vim-config/.vimrc_simple ~";
#vim
#:PlugInstall
# ==============================================================================

# tmux =========================================================================
apt install -y tmux;
apt install -y xclip xsel;
apt install -y powerline fonts-powerline python3-powerline;
su - $CUR_USER -c "git clone https://github.com/jungsbro/tmux-config.git ~/github/tmux-config";
su - $CUR_USER -c "cp -rf ~/github/tmux-config/.tmux/ ~";
su - $CUR_USER -c "cp -f ~/github/tmux-config/.tmux.conf ~";
# ==============================================================================

# mc ===========================================================================
apt install -y mc;
# ==============================================================================

# ranger =======================================================================
apt install -y ranger;
apt install -y caca-utils highlight atool w3m poppler-utils mediainfo;
apt install -y python3 tar p7zip-full trash-cli fzf fasd findutils mlocate;
apt install -y mpv imagemagick catimg;
su - $CUR_USER -c "git clone https://github.com/jungsbro/ranger-config.git ~/github/ranger-config";
su - $CUR_USER -c "chmod 755 ~/github/ranger-config/.config/ranger/scope.sh";
su - $CUR_USER -c "cp -rf ~/github/ranger-config/.config ~";
su - $CUR_USER -c "git clone https://github.com/maximtrp/ranger-archives.git ~/.config/ranger/plugins/ranger-archives";
# ==============================================================================

# zsh ==========================================================================
apt install -y zsh;
apt install -y curl;
apt install -y fonts-powerline autojump fzf fd-find fasd;
# su - $CUR_USER -c "chsh -s /usr/bin/zsh";
chsh -s /usr/bin/zsh $CUR_USER;
su - $CUR_USER -c "sh -c $(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
su - $CUR_USER -c "git clone https://github.com/jungsbro/zsh-config.git ~/github/zsh-config";
su - $CUR_USER -c "cp -Rfv ~/github/zsh-config/.oh-my-zsh/custom ~/.oh-my-zsh/";
su - $CUR_USER -c "cp -Rfv ~/github/zsh-config/.zshrc ~";
su - $CUR_USER -c "git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions";
su - $CUR_USER -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting";
su - $CUR_USER -c "git clone https://github.com/chrissicool/zsh-256color.git ~/.oh-my-zsh/custom/plugins/zsh-256color";
# ==============================================================================

# D2Coding fonts ===============================================================
# if [[ $CUR_USER == "root" ]]; then
#     cp -r /$CUR_USER/github/zsh-config/D2Coding-Ver1.3.2-20180524/D2Coding* /usr/share/fonts/truetype;
# else
#     cp -r /home/$CUR_USER/github/zsh-config/D2Coding-Ver1.3.2-20180524/D2Coding* /usr/share/fonts/truetype;
# fi
cp -r ~/github/zsh-config/D2Coding-Ver1.3.2-20180524/D2Coding* /usr/share/fonts/truetype;

fc-cache -rv;
# ==============================================================================