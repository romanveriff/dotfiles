#!/usr/bin/env bash
set -o vi
stty -ixon
export SHELL_SESSION_HISTORY=0
export BASH_SILENCE_DEPRECATION_WARNING=1

wait_for() {
  printf "awaiting %s:%s " "$1" "$2" >&2
  while :;do printf '.'; curl -s "http://$1:$2" > /dev/null && break; sleep 1; done; echo 'ok'
}

pseudo_uuid() {
  local N B C='89ab'
  for (( N=0; N < 16; ++N ))
  do
  B=$(( RANDOM%256 ))
  case "$N" in
      6) printf '4%x' $(( B%16 ));;
      8) printf '%c%x' ${C:$RANDOM%${#C}:1} $(( B%16 ));;
      3 | 5 | 7 | 9) printf '%02x-' $B;;
      *) printf '%02x' $B;;
  esac
  done
}

alias 8='ping 8.8.8.8'
alias uuid='pseudo_uuid | pbcopy && pbpaste && echo'
alias ng="npm list -g --depth=0 2>/dev/null"
alias nl="npm list --depth=0 2>/dev/null"

alias t='tmux a || tmux'
alias l='ls -l'
alias ll='ls -la'
alias mv='mv -i'
alias rm='rm -i'
alias p='echo $PATH|tr : "\n"'

alias a='vim $HOME/.profile; source $HOME/.profile'

COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
# COLOR_BLUE="\033[0;34m"
# COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

function git_color {
  local git_status
  git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working tree clean" ]]; then
    echo -e "$COLOR_RED"
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e "$COLOR_YELLOW"
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e "$COLOR_GREEN"
  else
    echo -e "$COLOR_OCHRE"
  fi
}

function git_branch {
  local git_status
  git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "$branch"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "$commit"
  fi
}

function git_branch_with_space {
  local branch
  branch="$(git_branch)"
  test -n "$branch" && echo " $branch" || echo ""
}

alias ga='git add .'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbc='git checkout -b'
alias gbm='git branch -m'
alias gc='git commit'
alias gco='git checkout'
alias gcom='git checkout master'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gf='git commit --amend --no-edit'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glsro='git ls-remote --heads origin'
alias gpl='git pull --all'
alias gr='git rebase -i HEAD~20'
alias grpo='git remote prune origin'
alias grso='git remote show origin'
alias gs='git status -s'
alias ghv='gh repo view --web'
alias ghrp='gh repo clone'

function gbd {
  local current_branch
  current_branch=$(git_branch)
  trash=$(git branch | grep -v master | grep -v "\<$current_branch\>")
  # shellcheck disable=SC2086
  if test -n "$trash"
  then git branch -D $trash
  fi
}

function gp {
  git push -u origin "$(git_branch)"
}

function gpf {
  git push -uf origin "$(git_branch)"
}


PS1="\w\[\$(git_color)\]\$(git_branch_with_space)$COLOR_RESET "
export PS1

export TERM='xterm-256color'

PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
PATH="$HOME/bin:$PATH"
# PATH="$HOME/Library/Python/2.7/bin:$PATH"
PATH="/usr/local/opt/python@3.8/bin:$PATH"
LDFLAGS="-L/usr/local/opt/python@3.8/lib"
PKG_CONFIG_PATH="/usr/local/opt/python@3.8/lib/pkgconfig"
# PATH="/usr/local/Cellar/python/3.7.7/bin:$PATH"
# PATH="$HOME/Library/Python/3.7/bin:$PATH"
# PATH="$HOME/.rvm/bin:$PATH"
export PATH LDFLAGS PKG_CONFIG_PATH
export NVM_DIR="$HOME/.nvm"
test -f '/usr/local/opt/nvm/nvm.sh' &&
source '/usr/local/opt/nvm/nvm.sh'

# shellcheck disable=SC1090
# test -f "$HOME/.rvm/scripts/rvm" &&
# source  "$HOME/.rvm/scripts/rvm"

# shellcheck disable=SC1090
# test -f "$HOME/.fzf/shell/completion.bash" &&
# source  "$HOME/.fzf/shell/completion.bash" 2> /dev/null
# shellcheck disable=SC1090
test -f "$HOME/.fzf/shell/key-bindings.bash" &&
source  "$HOME/.fzf/shell/key-bindings.bash"

source '/usr/local/etc/bash_completion.d/git-completion.bash'
__git_complete gco _git_checkout
__git_complete gp _git_push
#
# shellcheck disable=SC1090
source "$HOME/src/dotfiles/gh-completion.sh"

export LANG=en_US.UTF-8
export LANGUAGE=
export LC_CTYPE=en_US.UTF-8
export LC_ALL=

alias dka='docker kill $(docker ps -q)'
alias dps='docker ps'
alias dcps='docker-compose ps'
alias dcdn='docker-compose down -v'
alias dcup='docker-compose up -d'
alias dcl='docker-compose logs -f'

export PATH="$HOME/.tfenv/bin:$PATH"
