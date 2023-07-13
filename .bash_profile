# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH


#  2021-09-14(Tue) PM12:00:00       brian@jungsbro    /mnt/hdd1/__files  
#$ 
white="\e[30;47m"                                                                                                 
black="\e[1;97;40m"
cyan="\e[97;46m"
blue="\e[93;44m"
colorNone="\e[0m"

PS1=""
PS1+="${white} \D{%Y-%m-%d(%a) %p%l:%M:%S}  ${colorNone}"
PS1+="${cyan}  \u@\h  ${colorNone}"
PS1+="${blue}  \w  ${colorNone}"
PS1+="\n\$ "

export PS1


# History
export HISTCONTROL=ignoreboth
# 2021.09.14 17:27:15  clear
export HISTTIMEFORMAT="%Y.%m.%d %T  "
