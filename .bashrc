# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# locale =======================================================================
export LANG=en_US.UTF-8
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
# ==============================================================================

# proxy settings ===============================================================
# export PROXY_SERVER_IP=192.168.0.0:3128
# export http_proxy=http://${PROXY_SERVER_IP}
# export https_proxy=${http_proxy}
# export ftp_proxy=${http_proxy}
# export no_proxy=localhost
# ==============================================================================

# some more ls aliases =========================================================
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# ==============================================================================

# tmux autostart ===============================================================
# if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [[ $- =~ i ]]; then
#     tmux attach-session -t ssh || tmux new-session -s ssh
#     exit
# fi

# if [[ -z "$TMUX" ]]; then
#     if tmux has-session 2>/dev/null; then
#         exec tmux attach
#     else
#         exec tmux
#     fi
# fi
# ==============================================================================

# mc ===========================================================================
# alias mc='EDITOR=/usr/bin/vim mc'     # debian
# alias mc='EDITOR=/usr/bin/vimx mc'    # CentOS

alias mc='LANG=en_EN.UTF-8 mc'
# alias mc='LANG=ko_KR.UTF-8 mc'
# ==============================================================================

# vim ==========================================================================
# alias vi='/usr/bin/vim'               # debian
# alias vim='/usr/bin/vim'              # debian

# alias vi='/usr/bin/vimx'              # CentOS
# alias vim='/usr/bin/vimx'             # CentOS
# ==============================================================================

# vim for ranger ==============================================================
# export VISUAL='/usr/bin/vim'          # debian
# export EDITOR='/usr/bin/vim'          # debian

# export VISUAL='/usr/bin/vimx'         # CentOS
# export EDITOR='/usr/bin/vimx'         # CentOS
# ==============================================================================

# ranger =======================================================================
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
# ==============================================================================

# nnn ==========================================================================
# export NNN_OPTS="H"
# export NNN_OPTS="eaEoxH"
# export NNN_OPTS="cEnrx"
# export LC_COLLATE='C'
export NNN_COLORS='1267'
export NNN_BMS="r:/;d:/dev;e:/etc;m:/media;M:/mnt;o:/opt;s:/srv;p:/tmp;u:/usr;v:/var;h:~;1:/volume1;2:/volume2;3:/volume3;4:/volume4;"
export NNN_USE_EDITOR=1
export NNN_PLUG='a:autojump;f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'
# ==============================================================================

# fzf ==========================================================================
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# ==============================================================================