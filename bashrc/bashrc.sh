# .bashrc
 
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
 
case $- in
    *i*) : ;;
      *) return;;
esac
#################################################################
## Interactive shell only - start
#################################################################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

(type -p -a module &> /dev/null) || [ -f ~/.local/init/profile.sh ] && . ~/.local/init/profile.sh

#################################################################
## General config
#################################################################
 
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
 
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
 
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
 
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'    

MACHINE_IDENTITY=$(hostname)
#################################################################
## Prompt setup - start
#################################################################
function count_bash_nesting_level() {
    local bash_count_offset=$1
    local pstree_res=$(pstree -c -l -s $$)
    echo $pstree_res | sed -r 's/(-)+/\n/g' | tac | tail -n +$((3 + bash_count_offset)) | grep -n -v $(basename $SHELL) | head -n 1 | cut -d':' -f1
}
__prompt_command() {
    # Logic
    local bash_count_offset=1
    local git_sh_path="${HOME}/.local/share/git"
    ! (command -v __git_ps1 &> /dev/null) && [ "$git_sh_path" != "NOPE" ] && [ ! -f ${git_sh_path}/git-prompt.sh ] && echo -e "\033[1;93mWarning\033[0m :: '${git_sh_path}/git-prompt.sh' does not exist"
    ! (command -v __git_ps1 &> /dev/null) && [ "$git_sh_path" != "NOPE" ] && [   -f ${git_sh_path}/git-prompt.sh ] && . ${git_sh_path}/git-prompt.sh
    ! (command -v __git_complete_command &> /dev/null) && [ "$git_sh_path" != "NOPE" ] && [ ! -f ${git_sh_path}/git-completion.sh ] && echo -e "\033[1;93mWarning\033[0m :: '${git_sh_path}/git-completion.sh' does not exist"
    ! (command -v __git_complete_command &> /dev/null) && [ "$git_sh_path" != "NOPE" ] && [   -f ${git_sh_path}/git-completion.sh ] && . ${git_sh_path}/git-completion.sh

    local red='\[\033[91m\]'
    local green='\[\033[92m\]'
    local yellow='\[\033[33m\]'
    local blue='\[\033[34m\]'
    local cyan='\[\033[36m\]'
    local magenta='\[\033[95m\]'
    local gray='\[\033[90m\]'
    local nocolor='\[\033[0m\]'
 
    local bash_level_count=$(count_bash_nesting_level $bash_count_offset)
    if [ $bash_level_count -le 1 ]; then
        local bash_level_count_color=$red
    elif [ $bash_level_count -le 2 ]; then
        bash_level_count_color=$yellow
    else
        bash_level_count_color=$cyan
    fi
    case ${USER} in
        root) local user_color=${red} ;;
        *)    local user_color=${green} ;;
    esac
    local current_group=$(id -g -n) # can be changed with sg (man sg) or newgrp (man newgrp)
   
    PS1="[\[\e[0;\$((\$?==0?92:91))m\]\$(printf %3d \$?)${nocolor}] "
 
    # PS1="[\$(export curr_exit=\$?; if [ \$curr_exit -eq 0 ]; then echo ${green}; else echo ${red}; fi)\$(printf %3d \$previoucurr_exits_exit)${nocolor}] "
    PS1+="[${user_color}\u${nocolor}:${gray}${current_group}${nocolor}@${cyan}\h${nocolor} ${magenta}$(uname -m)${nocolor} ${MACHINE_IDENTITY:+(${yellow}${MACHINE_IDENTITY}${nocolor}) }"
    PS1+="${user_color}\W${nocolor}] "
    command -v __git_ps1 &> /dev/null && PS1+='$(__git_ps1 "|%s| ")'
    PS1+="[${bash_level_count_color}${bash_level_count}${nocolor}] \\$ "
}
PROMPT_COMMAND=__prompt_command
#################################################################
## Prompt setup - end
#################################################################

